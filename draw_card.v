module draw_card(in, out, clock);
	input in, clock;
	output reg [3:0] out;
	
	always @(posedge clock)
	begin
		if(in == 1b'1)
			out <= counterValue;
		else
			out <= 0;
	end
	
	wire rateDividerOut;
	
	rateDivider RateDivider(.out(rateDividerOut), .clock(clock));
	
	reg [3:0] counterValue;

	counterUp counter(.out(counterValue), .clock(rateDividerOut));
	
endmodule

module counterUp(out, clock);
	input clock;
	output reg [3:0] out;
	
	always @(posedge clock)
	begin
		if(out == 4b'1011)
			q <= 4b'0001;
		else
			q <= q + 1'b1;
	end
endmodule

module rateDivider(out, clock);
	input clock;
	output reg out;
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