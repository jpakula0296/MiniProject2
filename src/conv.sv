module conv(
	input clk,
	input rst,
	input valid,
	input [11:0] row0_pixel,
	input [11:0] row1_pixel,
	input [11:0] row2_pixel,
	input row1_pixel_edge,
	input input_switch,
	output [11:0] conv_out,
	output reg conv_valid
);

reg [11:0] data_matrix [2:0][2:0];  // 3x3 array of pixels
wire [11:0] left_column;  // sum of left column from vertical convolution
wire [11:0] right_column;  // sum of right column from vertical convolution
wire [11:0] vert_conv;  // post-convolution value for vertical convolution
wire [11:0] top_row;  // sum of top row from horizonal convolution
wire [11:0] bottom_row;  // sum of bottom row from horizonal convolution
wire [11:0] horiz_conv;  // post-convolution value for horizontal convolution

// filters
int sobel1[3][3];
int sobel2[3][3];


// since the filter is either just using the two outside columns or
// the two outside rows, the math can simply be done on each column
// or row of pixels individually followed by finding the difference
assign sobel1 = {{-1, 0, 1},
		{-2, 0, 2},
		{-1, 0, 1}};

assign sobel2 = {{-1, -2, -1},
		{0, 0, 0},
		{1, 2, 1}};

// multiplying data_matrix[1][0] by 2 and summing the column
assign left_column = data_matrix[0][0] + {data_matrix[1][0], 1'b0} + data_matrix[2][0];

// multiplying data_matrix[1][2] by 2 and summing the column
assign right_column = data_matrix[0][2] + {data_matrix[1][2], 1'b0} + data_matrix[2][2];

// subtract, due to the negative values in the filter
// this simultaneously gets the absolute value
assign vert_conv = (right_column > left_column) ? right_column - left_column : left_column - right_column;

// multiplying data_matrix[0][1] by 2 and summing the row
assign top_row = data_matrix[0][0] + {data_matrix[0][1], 1'b0} + data_matrix[0][2];

// multiplying data_matrix[2][1] by 2 and summing the row
assign bottom_row = data_matrix[2][0] + {data_matrix[2][1], 1'b0} + data_matrix[2][2];
		 
// subtract, due to the negative values in the filter
// this simultaneously gets the absolute value
assign horiz_conv = (bottom_row > top_row) ? bottom_row - top_row : top_row - bottom_row;
	
	
// switch to select between horizontal and vertical edge detection	
assign conv_out = input_switch ? horiz_conv : vert_conv;	
	
	
// also need to deal with edges

	
int i;
int j; 
always@(posedge clk, negedge rst) begin
	if(!rst)
		begin
			conv_valid <= 1'b0;
			for (i = 0; i < 3; i = i + 1) begin
					for (j = 0; j < 3; j = j + 1) begin
						data_matrix[i][j] <= 0;
					end
			end
		end
	else
		// shift over a pixel every clock
		begin
			conv_valid <= valid;
			data_matrix[0][0] <= row0_pixel;
			data_matrix[1][0] <= row1_pixel;
			data_matrix[2][0] <= row2_pixel;
			
			for (i = 0; i < 3; i = i + 1) begin
				data_matrix[i][1] <= data_matrix[i][0];
				data_matrix[i][2] <= data_matrix[i][1];
			end
			
		end
end

endmodule