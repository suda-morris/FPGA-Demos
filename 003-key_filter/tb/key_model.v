`timescale 1ns/1ns

module key_model(press,key);
	input press;
	output reg key;
	
	initial key = 1'b1;
	
	reg [15:0]get_rand;
	
	task press_key;
		begin
			repeat(50)begin
				get_rand = {$random}%65536;
				#get_rand key = !key;
			end
			key = 1'b0;
			#25_000_000;
			repeat(50)begin
				get_rand = {$random}%65536;
				#get_rand key = !key;
			end
			key = 1'b1;
			#25_000_000;
		end
	endtask
	
	always@(posedge press)
		press_key;

endmodule
