/* wrapper for connecting RAW2GRAY, image_buffer, and conv buffers
 * take raw input from base DE1-SoC Camera project and output grayscale
 * image or edge detection image based on input_switch
*/
module imgproc(
	input iCLK, 		// clock
	input iRST, 		// reset
	input [11:0] iDATA,	// data
	input iDVAL,		// data valid input
	input [15:0] iX_Cont,	// col num
	input [15:0] iY_Cont,	// row num
	input iSW,		// switch 3 - controls ?

	output[11:0]  oRed,	// red output
	output[11:0]  oGreen,	// green output
	output[11:0]  oBlue,	// blue output
	output oDVAL		// data valid output
);
wire [11:0] gray_pixel, row0_pixel, row1_pixel, row2_pixel, conv_out;
wire gray_pixel_valid, gray_pixel_edge;
wire row1_pixel_valid, row1_pixel_edge;
wire [11:0] data_matrix [2:0][2:0];

// convert image to grayscale pixel by pixel
RAW2GRAY grayscale(
	.clk(iCLK), // clock
	.rst(iRST), // reset
	.pixel(iDATA), // pixel value input (updated every clock cycle)
	.pixel_valid(iDVAL), // pixel valid input
	.col_num(iX_Cont), // col num
	.row_num(iY_Cont), // row num

	.gray_pixel(gray_pixel), // pixel value output (gray)
	.gray_pixel_edge(gray_pixel_edge), // is pixel edge? 1: true / 0: false
	.gray_pixel_valid(gray_pixel_valid) // pixel value valid
);

//buffers three rows of grayscale pixels and outputs to convolution
image_buffer imgbuff(
	.clk(iCLK),
	.rst(iRST),
	.pixel_in(gray_pixel),		// input pixel
	.pixel_edge(gray_pixel_edge),	// input pixel is an edge 1: true / 0 false
	.pixel_valid(gray_pixel_valid),	// pixel is valid 	""
	.pixel_valid_out(oDVAL),
	.data_matrix(data_matrix),
	.row1_pixel_edge(row1_pixel_edge)
);

// 2d convolution of image w/ 3x3 filter
conv convolution(
	.clk(iCLK),
	.rst(iRST),
	.data_matrix(data_matrix), // passed in from image_buffer
	.input_switch(iSW), // chooses grayscale or edge detection
	.conv_out(conv_out) // our main output
);

// assign each color channel to our output, don't display edges
assign oRed = (~row1_pixel_edge) ? conv_out : 0;
assign oGreen = (~row1_pixel_edge) ? conv_out : 0;
assign oBlue = (~row1_pixel_edge) ? conv_out : 0;


endmodule
