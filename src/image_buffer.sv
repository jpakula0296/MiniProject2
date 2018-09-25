module image_buffer(clk, rst, pixel_in, pixel_edge, pixel_valid, pixel_valid_out, data_matrix);

parameter DATA_WIDTH = 12; // 12 bit width
parameter SHIFT_LENGTH = 640;
parameter DATA_LENGTH = SHIFT_LENGTH * 3; // need to hold 3 total

input clk, rst, pixel_edge, pixel_valid; // check if we have rgb pixel edge
input [DATA_WIDTH-1:0] pixel_in;
output reg [11:0] data_matrix [2:0][2:0];  // 3x3 array of pixels
output pixel_valid_out;







integer i, j, k;

// shift register operation
reg [DATA_WIDTH+1:0] shift[DATA_LENGTH-1:0];  // shift reg

always @(posedge clk, negedge rst) begin
	if (!rst) begin // clear entire register on reset
		for (i = 0; i < DATA_LENGTH; i = i+1) begin
			shift[i] <= 0;
		end
	end else begin // shift by SHIFT_LENGTH on enable
		if (pixel_valid) begin
			for (i = 1; i < DATA_LENGTH; i = i+1) begin
				shift[i] <= shift[i-1];
			end
			shift[0] <= {1'b1, pixel_edge, pixel_in};
		end else // latch data if no enable or reset
			shift <= shift;
	end
end


// assign incoming RGB signals to each part of shift register
wire row1_pixel_edge, row1_pixel_valid;
wire [DATA_WIDTH-1:0] row0_pixel;
wire [DATA_WIDTH-1:0] row1_pixel;
wire [DATA_WIDTH-1:0] row2_pixel;
assign row0_pixel = shift[SHIFT_LENGTH - 1][DATA_WIDTH - 1 : 0];
assign row1_pixel = shift[2 * SHIFT_LENGTH - 1][DATA_WIDTH - 1 : 0];
assign row2_pixel = shift[3 * SHIFT_LENGTH - 1][DATA_WIDTH - 1 : 0];

// edge and valid for row1 pixel passed as metadata in end of row1
assign row1_pixel_edge = shift[2 * SHIFT_LENGTH - 1][DATA_WIDTH];
assign row1_pixel_valid = shift[2 * SHIFT_LENGTH - 1][DATA_WIDTH + 1];


assign pixel_valid_out = pixel_valid & row1_pixel_valid;

// form data matrix to pass to convolution
always@(posedge clk, negedge rst) begin
	if(!rst) begin
		// conv_valid <= 1'b0;
		for (j = 0; j < 3; j = j + 1) begin
				for (k = 0; k < 3; k = k + 1) begin
					data_matrix[j][k] <= 0;
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
		data_matrix <= data_matrix;
end


endmodule
