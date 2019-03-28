//LOOK INTO LINEAR FEEDBACK SHIFT REGISTER FOR RANDOM NUMBERS

module draw_card(in, card, clock, reset, turn);
	input in, clock, reset, turn;
	output reg [3:0] card;
	
	reg [5:0] high, low;
	always @(*)
	begin
		case(turn)
			1'b0: begin
						high <= 4'b1010;
						low <= 4'b0001;
					end
			1'b1: begin
						high <= 4'b1001;
						low <= 4'b0010;
					end
		endcase
	end
	
	always @(posedge clock)
	begin
		if(reset == 1'b1 || in == 1'b0)
			card <= 0;
		else
			card <= counterValue;
	end
	
	wire [3:0] counterValue;
	
	counterUp counter(.num(counterValue), .clock(clock), .high(high), .low(low));
	
endmodule	

module counterUp(num, clock, high, low);
	input [3:0] high, low;
	input clock;
	output reg [3:0] num;
	
	always @(posedge clock)
	begin
		if (num == high)
			num <= low;
		else
			num <= num + 1'b1;
	end
endmodule

module rateDivider(q, clock);
	input clock;
	output reg q;
	reg [27:0] counter;
	
	initial
	begin
		counter = 12499999;
		q = 1'b0;
	end
	
	always @(posedge clock)
	begin
		if(counter == 0)
		begin
			counter <= 12499999;
			q <= ~q;
		end
		else
			counter <= counter - 1;
	end
endmodule