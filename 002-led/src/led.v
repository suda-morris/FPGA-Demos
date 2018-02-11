module led(clk,nrst,led_pin);

	input clk;//50M时钟输入
	input nrst;//复位按键
	output [9:0]led_pin;//LED输出
	
	reg [31:0]cnt;
	reg [9:0]pin;
	
	always@(posedge clk,negedge nrst)
	if(!nrst)
		cnt <= 32'd0;
	else if(cnt == 32'd24_999_999)
		cnt <= 32'd0;
	else
		cnt <= cnt + 1'b1;
		
	always@(posedge clk,negedge nrst)
	if(!nrst)
		pin <= 10'd1;
	else if(cnt == 32'd24_999_999)
		pin <= {pin[8:0],pin[9]};
		
	assign led_pin = pin;
	
endmodule
