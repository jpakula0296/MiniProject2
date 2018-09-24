module image_buffer(clk, rst, pixel_in, pixel_edge, pixel_valid, row0_pixel, row1_pixel,
	row2_pixel, row1_pixel_edge, row1_pixel_valid);

parameter DATA_WIDTH = 12; // 12 bit width
parameter SHIFT_LENGTH = 640;
parameter DATA_LENGTH = SHIFT_LENGTH * 3; // need to hold 3 total

input clk, rst, pixel_edge, pixel_valid; // check if we have rgb pixel edge

input wire [DATA_WIDTH-1:0] pixel_in;
output wire [DATA_WIDTH-1:0] row0_pixel;
output wire [DATA_WIDTH-1:0] row1_pixel;
output wire [DATA_WIDTH-1:0] row2_pixel;
output wire row1_pixel_edge, row1_pixel_valid;

reg [DATA_WIDTH-1:0] shift[DATA_LENGTH+1:0];  // shift reg

// assign incoming RGB signals to each part of shift register
assign row0_pixel = shift[SHIFT_LENGTH - 1][DATA_WIDTH - 1 : 0];
assign row1_pixel = shift[2 * SHIFT_LENGTH - 1][DATA_WIDTH - 1 : 0];
assign row2_pixel = shift[3 * SHIFT_LENGTH - 1][DATA_WIDTH - 1 : 0];

// pixel edge is last value in buffer
assign row1_pixel_edge = shift[DATA_LENGTH*2 - 1][DATA_WIDTH];

// valid signal
assign row1_pixel_valid = shift[DATA_LENGTH*2- 1][DATA_WIDTH + 1];

// shift register operation
integer i;
always @(posedge clk, negedge rst) begin
	if (!rst) begin // clear entire register on reset
		for (i = 0; i < DATA_LENGTH; i = i+1) begin
			shift[i] <= 0;
		end
	end else begin // shift by SHIFT_LENGTH on enable
		if (pixel_valid) begin
			for (i = 1; i < SHIFT_LENGTH; i = i+1) begin
				shift[i] <= shift[i-1];
			end
			shift[0] <= {1'b1, pixel_edge, pixel_in};
		end else // latch data if no enable or reset
			shift <= shift;
	end
end
endmodule
