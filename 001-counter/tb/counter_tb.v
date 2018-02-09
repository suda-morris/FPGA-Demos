`timescale 1ns/1ns
`define clk_period 10

module counter_tb();

	reg clk_t;
	reg en_t;
	reg nclr_t;
	wire [3:0]counterv_t;
	
	counter counter_t0(
		.clk(clk_t),
		.en(en_t),
		.nclr(nclr_t),
		.countv(counterv_t)
	);

	initial clk_t = 1;
	always #(`clk_period/2) clk_t = ~clk_t;
	
	initial begin
		en_t = 0;
		nclr_t = 1;
		#(`clk_period*20);
		nclr_t = 0;
		#(`clk_period*10);
		nclr_t = 1;
		en_t = 1;
		#(`clk_period*200);
		en_t = 0;
		#(`clk_period*50);
		nclr_t = 0;
		#(`clk_period*50);
		nclr_t = 1;
		$stop;
	end

endmodule
