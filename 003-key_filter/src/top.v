module top(clk,rst_n,key,led);
	input clk;
	input rst_n;
	input key;
	output reg [9:0]led;
	
	wire key_status;
	wire key_event;
	
	key_filter key_filter0(
		.clk(clk),
		.rst_n(rst_n),
		.key_pin(key),
		.key_status(key_status),
		.key_event(key_event)
	);
	
	always@(posedge clk, negedge rst_n)
	if(!rst_n)
		led <= 10'd0;
	else if(key_event && !key_status)
		led <= led + 1'b1;
	
endmodule
