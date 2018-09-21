module imgproc(
	input iCLK, 		// clock
	input iRST, 		// reset
	input [11:0] iDATA,	// data
	input iDVAL,		// data valid input
	input [15:0] iX_Cont,	// row num?
	input [15:0] iY_Cont,	// col num?
	input iSW,		// switch 3 - controls ?

	output[11:0]  oRed,	// red output
	output[11:0]  oGreen,	// green output
	output[11:0]  oBlue,	// blue output
	output oDVAL		// data valid output
);

endmodule