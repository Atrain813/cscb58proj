module cardgame_21(SW, KEY, HEX0, HEX1, HEX4, HEX5, HEX6, CLOCK_50);
	input [2:0] SW;
	input [3:0] KEY;
	input CLOCK_50;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX4;
	output [6:0] HEX5;
	output [6:0] HEX6;
	
	wire reset;
	assign reset = ~KEY[0];
	
endmodule

module control(
	input enable,
	input next,
	//input skip,
	input reset,
	input clock,
	output reg [1:0] player);
	
	reg [4:0] current_turn, next_turn;
	
	localparam PLAYER_1_TURN = 5'd0,
				  PLAYER_1_WAIT = 5'd1,
				  PLAYER_2_TURN = 5'd2,
				  PLAYER_2_WAIT = 5'd3,
				  PLAYER_3_TURN = 5'd4,
				  PLAYER_3_WAIT = 5'd5,
				  PLAYER_4_TURN = 5'd6,
				  PLAYER_4_WAIT = 5'd7;
	
	// State table
	always @(*)
	begin: state_table
		case(current_turn)
			PLAYER_1_TURN: next_turn = next ? PLAYER_1_WAIT : PLAYER_1_TURN; // Loop in current state until value is input
			PLAYER_1_WAIT: next_turn = next ? PLAYER_1_WAIT : PLAYER_2_TURN; // Loop in current state until go signal goes low
			PLAYER_2_TURN: next_turn = next ? PLAYER_2_WAIT : PLAYER_2_TURN; // Loop in current state until value is input
			PLAYER_2_WAIT: next_turn = next ? PLAYER_2_WAIT : PLAYER_3_TURN; // Loop in current state until go signal goes low
			PLAYER_3_TURN: next_turn = next ? PLAYER_3_WAIT : PLAYER_3_TURN; // Loop in current state until value is input
			PLAYER_3_WAIT: next_turn = next ? PLAYER_3_WAIT : PLAYER_4_TURN; // Loop in current state until go signal goes low
			PLAYER_4_TURN: next_turn = next ? PLAYER_4_WAIT : PLAYER_4_TURN; // Loop in current state until value is input
			PLAYER_4_WAIT: next_turn = next ? PLAYER_4_WAIT : PLAYER_1_TURN; // Loop in current state until go signal goes low
			
			default: next_turn = PLAYER_1_TURN;
		endcase
	end
	
	// Output logic
	always @(*)
	begin: enable_signals
		// By default make output signals 0
		player = 2'b00;
		
		case (current_state)
			PLAYER_1_TURN: begin
				player = 2'b00;
				end
			PLAYER_2_TURN: begin
				player = 2'b01;
				end
			PLAYER_3_TURN: begin
				player = 2'b10;
				end
			PLAYER_4_TURN: begin
				player = 2'b11;
				end
				
		endcase
	end
	
	// current_state registers
	always @(posedge clock)
	begin: State_FFs
		if(reset)
			current_state <= PLAYER_1_TURN;
		else
			current_state <= next_state;
	end
		
endmodule

module hex_display(IN, OUT);
    input [3:0] IN;
	 output reg [6:0] OUT;
	 
	 always @(*)
	 begin
		case(IN[3:0])
			4'b0000: OUT = 7'b1000000;
			4'b0001: OUT = 7'b1111001;
			4'b0010: OUT = 7'b0100100;
			4'b0011: OUT = 7'b0110000;
			4'b0100: OUT = 7'b0011001;
			4'b0101: OUT = 7'b0010010;
			4'b0110: OUT = 7'b0000010;
			4'b0111: OUT = 7'b1111000;
			4'b1000: OUT = 7'b0000000;
			4'b1001: OUT = 7'b0011000;
			
			default: OUT = 7'b0111111;
		endcase

	end
endmodule