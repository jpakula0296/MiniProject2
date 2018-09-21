module RAW2GRAY(
	input iCLK, 		// clock
	input iRST, 		// reset
	input [11:0] iDATA,	// data
	input iDVAL,		// data valid input
	input [15:0] iX_Cont,	// row num?
	input [15:0] iY_Cont,	// col num?

	output[11:0]  oGray,	// gray output
	output oDVAL		// data valid output
);

endmodule

