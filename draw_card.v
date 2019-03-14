module draw_card(in, card, clock);
	input in, clock;
	output reg [3:0] card;
	
	always @(posedge in)
	begin
		card <= counterValue;
	end
	
	wire rateDividerOut;
	
	rateDivider RateDivider(.q(rateDividerOut), .clock(clock));
	
	wire [3:0] counterValue;
	
	counterUp counter(.num(counterValue), .clock(clock));
	//counterUp counter(.num(counterValue), .clock(rateDividerOut));
	
endmodule

module counterUp(num, clock);
	input clock;
	output reg [3:0] num;
	
	always @(posedge clock)
	begin
		if (num == 4'b1101)
			num <= 4'b0001;
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