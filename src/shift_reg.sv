module shift_reg(
	parameter DATA_WIDTH = 12,
	parameter SHIFT_LENGTH = 640,
	input clk,
	input rst,
	input en,
	input [DATA_WIDTH-1:0] in,
	output [DATA_WIDTH-1:0] out,
)

reg [DATA_WIDTH-1:0] shift[SHIFT_LENGTH-1:0];

assign out = shift[SHIFT_LENGTH-1];

integer i;
always @(posedge clk, negedge rst) begin
	if (!rst) begin
		for (i = 0; i < SHIFT_LENGTH; i = i+1) begin
			shift[i] <= 0;
		end
	end else begin
		if (en) begin
			for (i = 1; i < SHIFT_LENGTH; i = i+1) begin
				shift[i] <= shift[i-1];
			end
			shift[0] <= in;
		end else begin
			for (i = 0; i < SHIFT_LENGTH; i = i+1) begin
				shift[i] <= shift[i];
			end
		end
	end
end


endmodule
