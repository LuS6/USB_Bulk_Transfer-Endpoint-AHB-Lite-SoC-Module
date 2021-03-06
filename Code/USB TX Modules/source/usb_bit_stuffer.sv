module usb_bit_stuffer(
input wire clk,
input wire n_rst,
input wire clk12,
input wire serial_in,	
output reg bit_stuff_en
);
reg nxt_bit_stuff_en;
reg [3:0]count_out;
flex_counter4 #(4) Y(.clk(clk),.n_rst(n_rst),
			.clear(!serial_in),
			.clk12(clk12),
			.count_enable(serial_in),
			.count_out(count_out),
			.halt(1'b0),
			.rollover_flag(bit_stuff_en),
			.rollover_value(4'b0110));

endmodule	
