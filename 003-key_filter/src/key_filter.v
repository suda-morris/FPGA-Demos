module key_filter(clk,rst_n,key_pin,key_status,key_event);
	input clk;
	input rst_n;
	input key_pin;
	output reg key_status;
	output reg key_event;
	
	/* 按键输入，避免亚稳态传播，边沿检测 */
	reg [2:0]key_former;
	wire key_posedge;
	wire key_negedge;
	
	always@(posedge clk, negedge rst_n)
	if(!rst_n)
		key_former <= 3'd0;
	else
		key_former <= {key_former[1:0],key_pin};
	
	assign key_posedge = (!key_former[2])&&key_former[1];
	assign key_negedge = key_former[2]&&(!key_former[1]);
	
	/* 状态机，独热码编码 */
	reg [3:0]state;
	localparam KEY_IDLE = 4'b0001;
	localparam KEY_PRESS = 4'b0010;
	localparam KEY_STEADY = 4'b0100;
	localparam KEY_RELEASE = 4'b1000;
	
	/* 内部计数器 */
	reg [19:0]cnt;
	reg en_cnt;
	
	always@(posedge clk, negedge rst_n)
	if(!rst_n)begin
		cnt <= 20'd0;
	end
	else if(en_cnt)
		cnt <= cnt + 1'b1;
	else
		cnt <= 20'd0;
	
	/* 状态机跳转逻辑 */
	always@(posedge clk, negedge rst_n)
	if(!rst_n)begin
		key_status <= 1'b1;
		key_event <= 1'b0;
		state <= KEY_IDLE;
		en_cnt <= 1'b0;
	end
	else begin
		case(state)
		KEY_IDLE:
			begin
				key_event <= 1'b0;
				if(key_negedge)begin
					state <= KEY_PRESS;
					en_cnt <= 1'b1;
				end
			end
		KEY_PRESS:
			if(cnt >= 999_999)begin
				state <= KEY_STEADY;
				en_cnt <= 1'b0;
				key_status <= 1'b0;
				key_event <= 1'b1;
			end
			else if(key_posedge)begin
				state <= KEY_IDLE;
				en_cnt <= 1'b0;
			end
		KEY_STEADY:
			begin
				key_event <= 1'b0;
				if(key_posedge)begin
					state <= KEY_RELEASE;
					en_cnt <= 1'b1;
				end
			end				
		KEY_RELEASE:
			if(cnt >= 999_999)begin
				state <= KEY_IDLE;
				en_cnt <= 1'b0;
				key_status <= 1'b1;
				key_event <= 1'b1;
			end
			else if(key_negedge)begin
				state <= KEY_STEADY;
				en_cnt <= 1'b0;
			end
		default:
			begin
				key_status <= 1'b1;
				key_event <= 1'b0;
				state <= KEY_IDLE;
				en_cnt <= 1'b0;
			end
		endcase
	end
endmodule
