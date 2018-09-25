// 640X12 shift register used for buffering pixels in RAW2GRAY
module shift_reg(clk, rst, en, in, out);
parameter DATA_WIDTH = 12; // width and length of each pixel
parameter SHIFT_LENGTH = 640;

input clk, rst, en;
input wire [DATA_WIDTH-1:0] in;
output wire [DATA_WIDTH-1:0] out;

// actual shift register
reg [DATA_WIDTH-1:0] shift[SHIFT_LENGTH-1:0];

// output last value
assign out = shift[SHIFT_LENGTH-1];

integer i; // counter
always @(posedge clk, negedge rst) begin
	if (!rst) begin // clear register on rst
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
