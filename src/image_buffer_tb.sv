module image_buffer.tb()

parameter DATA_WIDTH = 12;
parameter SHIFT_LENGTH = 640;
parameter DATA_LENGTH = SHIFT_LENGTH * 3;

// inputs we want to manipulate
reg clk, rst, en, pixel_edge, pixel_valid;
reg [DATA_WIDTH-1:0] pixel_in;

wire [DATA_WIDTH-1:0] row0_pixel;
wire [DATA_WIDTH-1:0] row1_pixel;
wire [DATA_WIDTH-1:0] row2_pixel;
wire row2_pixel_edge, row2_pixel_valid;

// instantiate DUT
image_buffer imgbuff(
  .clk (clk),
  .rst (rst),
  .en(en),
  .pixel_en(pixel_en),
  .pixel_valid(pixel_valid),
  .row0_pixel(row0_pixel),
  .row1_pixel(row1_pixel),
  .row2_pixel,(row2_pixel),
  .row2_pixel_edge(row2_pixel_edge),
  .row2_pixel_valid(row2_pixel_valid)
  );
