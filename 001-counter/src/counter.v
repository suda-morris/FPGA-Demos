module counter(clk,en,nclr,countv);
	input clk;//时钟
	input en;//同步使能
	input nclr;//异步清零
	output [3:0]countv;//当前计数值
	
	reg [3:0]cnt;
	
	always@(posedge clk,negedge nclr)
	if (!nclr)
		cnt <= 4'd0;
	else if(en)
		cnt <= cnt + 4'd1;
	
	assign countv = cnt;

endmodule
