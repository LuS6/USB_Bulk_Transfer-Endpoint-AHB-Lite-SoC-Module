// $Id: $
// File name:   timer.sv
// Created:     11/12/2019
// Author:      David Evans
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Timer for USB RX Design 
module timer(input wire clk,
             input wire n_rst,
             input wire enable_timer,
             input wire invalid_bit,
	     input wire eop_detected,
             output reg shift_enable,
             output reg shift_enable_const,
             output reg byte_complete);

//reg [3:0] track;
reg enable;
reg rollover_flag_1;
//reg rollover_flag_2;
reg [4:0] count_out_1;
reg [3:0] count_out_2;
//reg [1:0] cycles;
reg clear_1;
reg clear_2;
//reg clear_3;
//integer cnt = 0;

// to control 8 clk bit to be 1 bit
flex_counter #(5) fc1 (.clk(clk), .n_rst(n_rst), .clear(clear_1),
 .count_enable(enable), .rollover_val(5'd24), .count_out(count_out_1), .rollover_flag(rollover_flag_1));
//8 shift enable to be 1 byte complete
flex_counter #(4) fc2 (.clk(clk), .n_rst(n_rst), .clear(clear_2), 
.count_enable(shift_enable), .rollover_val(4'd8), .count_out(count_out_2), .rollover_flag(byte_complete));

/*flex_counter #(4) fc2 (.clk(clk), .n_rst(n_rst), .clear(clear_2), 
.count_enable(rollover_flag_1), .rollover_val(4'd8), .count_out(count_out_2), .rollover_flag(byte_complete));*/

always_comb
begin
  if(count_out_1 == 5'd7) begin
    shift_enable = 1'b1;
    //cnt = cnt + 1;
  end
  else if(count_out_1 == 5'd15) begin
    shift_enable = 1'b1;
    //cnt = cnt + 1;
  end
  else if(count_out_1 == 5'd23) begin
    shift_enable = 1'b1;
    //cnt = cnt + 1;
  end
  else begin
    shift_enable = 1'b0;
    //cnt = 0;
  end
  if(count_out_2 == 4'd8) begin
    clear_2 = 1'b1;
  end
  else begin
   clear_2 = 1'b0;
  end
end

/*always_comb 
begin
   if(cycles == 2'b01) begin
     track = 4'b1001;
     clear_3 = 1'b1;
   end
   else begin
    track = 4'b1000;
    clear_3 = 1'b0;
   end
end */

always_comb 
begin
   if (eop_detected) begin
	enable = 1'b0;
	shift_enable_const = 1'b0;
        clear_1 = 1'b1;
   end else begin
        enable = enable_timer;
	shift_enable_const = shift_enable; 
        clear_1 = 1'b0;
   end
   if(invalid_bit) begin
     enable = 1'b0;
     shift_enable_const = 1'b1;
   end
   else begin
     enable = enable_timer;
     shift_enable_const = shift_enable;
   end
end 
// flex_counter #(2) fc3 (.clk(clk), .n_rst(n_rst), .clear(clear_3), .count_enable(rollover_flag_1), .rollover_val(2'b11), .count_out(cycles), .rollover_flag());
// flex_counter #(7) nb1 (.clk(clk), .n_rst(n_rst), .clear(1'b0), .count_enable(byte_complete), .rollover_val(7'd69), .count_out(byte_count), .rollover_flag(rollover_flag_2));


endmodule
