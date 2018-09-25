module imgproc_tb();

// inputs we want to manipulate
reg clk, rst, sw;
reg [11:0] data_in;
reg data_valid_in;
reg [15:0] x_cont_in, y_cont_in;

// outputs
wire [11:0] oRed, oGreen, oBlue;
wire data_valid_out;

parameter WIDTH = 960;
parameter HEIGHT = 1280;

// loop variables
integer x, y;

// instantiate DUT
imgproc iDUT(
	.iCLK(clk),
	.iRST(rst),
	.iDATA(data_in),
	.iDVAL(data_valid_in),
	.oRed(oRed),
	.oGreen(oGreen),
	.oBlue(oBlue),
	.oDVAL(data_valid_out),
	.iX_Cont(x_cont_in),
	.iY_Cont(y_cont_in),
	.iSW(sw)
);

always
	#5 clk = !clk;

initial begin
	clk = 0;
	rst = 0;
	x_cont_in = 0; // start w/ col = 0
	y_cont_in = 0; // start w/ row = 0
	data_valid_in = 1; // set data as always valid
	sw = 1;
	#20
	
	// start
	rst = 1;

	// iterate through each row and column
	for (y = 0; y < WIDTH; y = y+1) begin
		for (x = 0; x < HEIGHT; x = x+1) begin
			// update the input on each clock cycle
			@(posedge clk) begin
				x_cont_in = x;
				y_cont_in = y;
				// arbitrary data, we just need to see that it's being passed through the module correctly
				data_in = {y_cont_in[5:0], x_cont_in[5:0]};
			end
		end
	end
	data_valid_in = 0;
	#50
	$stop();
	
end

endmodule
