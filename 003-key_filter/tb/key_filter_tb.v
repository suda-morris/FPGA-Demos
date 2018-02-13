`timescale 1ns/1ns
`define clk_freq 20

module key_filter_tb();
	reg clk_tb;
	reg rst_n_tb;
	wire key_pin_tb;
	wire key_status_tb;
	wire key_event_tb;
	
	key_filter key_filter0(
		.clk(clk_tb),
		.rst_n(rst_n_tb),
		.key_pin(key_pin_tb),
		.key_status(key_status_tb),
		.key_event(key_event_tb)
	);
	
	reg press_tb;
	
	key_model key(
		.press(press_tb),
		.key(key_pin_tb)
	);
	
	initial clk_tb = 1'b1;
	always#(`clk_freq/2) clk_tb <= !clk_tb;
	
	initial begin
		press_tb = 0;
		rst_n_tb = 0;
		#(`clk_freq*10);
		rst_n_tb = 1;
		#(`clk_freq*10);
		
		press_tb = 1;
		#(`clk_freq*3);
		press_tb = 0;
		
		#80_000_000;
		
		$stop;
	end
	
endmodule
