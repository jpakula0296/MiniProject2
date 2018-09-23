module RAW2GRAY(
	input clk, 		// clock
	input rst, 		// reset
	input [11:0] pixel,	// pixel data
	input pixel_valid,		// valid input
	input [15:0] col_num,	// col num / x position
	input [15:0] row_num,	// row num / y position

	output[11:0]  gray_pixel,	// gray output
	output gray_pixel_valid,		// valid output 
	output gray_pixel_edge		// pixel is an edge
);

wire [11:0] shift_out;
wire [13:0] sum;
reg [13:0] flopped_sum;
wire [13:0] output_sum;

shift_reg #(.DATA_WIDTH(12), .SHIFT_LENGTH(1280)) sr (
	.clk(clk),
	.rst(rst),
	.en(pixel_valid),
	.in(pixel),
	.out(shift_out)
);

assign sum = pixel + shift_out;
assign output_sum = flopped_sum + sum;
assign gray_pixel = output_sum[13:2];	// divide by 4 to average the pixels

assign gray_pixel_valid = (pixel_valid && (row_num[0] == 1'b1)
			&& (col_num[0] == 1'b1)) ? 1'b1 : 1'b0;
assign gray_pixel_edge = ((row_num == 15'd1) || (row_num == 15'd959)
			|| (col_num == 15'd1) || (col_num == 15'd1279));

/* flop the sum for one cycle
*/
always @(posedge clk, negedge rst) begin
	if (!rst) begin
		flopped_sum <= 14'b0;
	end else begin
		flopped_sum <= sum;
	end
end

endmodule

