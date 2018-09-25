/* image_buffer takes pixel inputs from RAW2GRAY and shifts three of them into
 * register along with metadata to determine when the pixel will be valid
 * This is used to generate a 3x3 matrix for the filters to be applied convert
 */
module image_buffer(clk, rst, pixel_in, pixel_edge, pixel_valid, pixel_valid_out, data_matrix, row1_pixel_edge);

parameter DATA_WIDTH = 12; // 12 bit width
parameter PIXEL_LENGTH = 640;
parameter DATA_LENGTH = PIXEL_LENGTH * 3; // need to hold 3 total

input clk, rst, pixel_edge, pixel_valid; // check if we have rgb pixel edge
input [DATA_WIDTH-1:0] pixel_in;
output reg [11:0] data_matrix [2:0][2:0];  // 3x3 array of pixels
output pixel_valid_out;
output row1_pixel_edge;

integer i, j, k; // counters for shift reg and data matrix

reg [DATA_WIDTH+1:0] shift[DATA_LENGTH-1:0];  // shift reg

// shift register operation
always @(posedge clk, negedge rst) begin
	if (!rst) begin // clear entire register on reset
		for (i = 0; i < DATA_LENGTH; i = i+1) begin
			shift[i] <= 0;
		end
	end else begin // shift
		if (pixel_valid) begin
			// shift entire register on enable
			for (i = 1; i < DATA_LENGTH; i = i+1) begin
				shift[i] <= shift[i-1];
			end
			// shift in valid and edge signals with pixel
			shift[0] <= {1'b1, pixel_edge, pixel_in};
		end else // latch data if no enable or reset
			shift <= shift;
	end
end


// assign incoming RGB signals to each third of shift register
wire row1_pixel_valid;
wire [DATA_WIDTH-1:0] row0_pixel;
wire [DATA_WIDTH-1:0] row1_pixel;
wire [DATA_WIDTH-1:0] row2_pixel;
assign row0_pixel = shift[PIXEL_LENGTH - 1][DATA_WIDTH - 1 : 0];
assign row1_pixel = shift[2 * PIXEL_LENGTH - 1][DATA_WIDTH - 1 : 0];
assign row2_pixel = shift[3 * PIXEL_LENGTH - 1][DATA_WIDTH - 1 : 0];

// edge and valid for row1 pixel passed as metadata in end of row1
assign row1_pixel_edge = shift[2 * PIXEL_LENGTH - 1][DATA_WIDTH];
assign row1_pixel_valid = shift[2 * PIXEL_LENGTH - 1][DATA_WIDTH + 1];

assign pixel_valid_out = pixel_valid & row1_pixel_valid;

// form 3x3 data matrix based on each pixel to pass to convolution
always@(posedge clk, negedge rst) begin
	if(!rst) begin
		// conv_valid <= 1'b0;
		for (j = 0; j < 3; j = j + 1) begin
				for (k = 0; k < 3; k = k + 1) begin
					data_matrix[j][k] <= 0; // entire matrix 0 on reset
				end
		end
	end
	else if (pixel_valid) begin
		// shift over a pixel every clock
		// conv_valid <= valid;
		data_matrix[0][0] <= row0_pixel;
		data_matrix[1][0] <= row1_pixel;
		data_matrix[2][0] <= row2_pixel;

		for (j = 0; j < 3; j = j + 1) begin
			data_matrix[j][1] <= data_matrix[j][0];
			data_matrix[j][2] <= data_matrix[j][1];
		end
	end
	else
		data_matrix <= data_matrix; // intentional latch
end
endmodule
