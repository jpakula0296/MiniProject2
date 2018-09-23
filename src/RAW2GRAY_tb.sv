module RAW2GRAY_tb();
reg clk, rst;

initial begin
	clk = 0;
	forever
		#5 clk = ~clk;
end

integer x, y;

reg valid;
reg [15:0] col, row;
wire [11:0] g_pix;
wire g_pix_valid, g_pix_edge;

initial begin
	rst = 0;
	col = 0;
	row = 0;
	valid = 0;
	#20
	rst = 1;
	for (y = 0; y < 960; y = y+1) begin
		for (x = 0; x < 1280; x = x+1) begin
			col = x;
			row = y;
			valid = 1;
			#10;
			valid = 0;
			#10;
		end
	end
	valid = 0;
	#50
	$stop();
end

RAW2GRAY r2g (
	.clk(clk),
	.rst(rst),
	.pixel({row[5:0], col[5:0]}),
	.pixel_valid(valid),
	.col_num(col),
	.row_num(row),
	.gray_pixel(g_pix),
	.gray_pixel_valid(g_pix_valid),
	.gray_pixel_edge(g_pix_edge)
);

endmodule
