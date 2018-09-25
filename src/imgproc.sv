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

assign oRed = conv_out;
assign oGreen = conv_out;
assign oBlue = conv_out;

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
	.data_matrix(data_matrix)
);

// 2d convolution of image w/ 3x3 filter
conv convolution(
	.clk(iCLK),
	.rst(iRST),
	.data_matrix(data_matrix),
	.input_switch(iSW),
	.conv_out(conv_out)
);

assign oRed = conv_out;
assign oGreen = conv_out;
assign oBlue = conv_out;


endmodule
