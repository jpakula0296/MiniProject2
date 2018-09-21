module conv(
	
);

int sobel1[3][3];
int sobel2[3][3];

assign sobel1 = {{-1, 0, 1},
		 {-2, 0, 2},
		 {-1, 0, 1}};

endmodule