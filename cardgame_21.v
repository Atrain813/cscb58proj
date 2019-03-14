/* IDEA FOR PLAYER TURN INDICATOR: USE NUMBERS, AND LETTER D
	IE
	PLAYER 1 -> DISPLAY 1
	PLAYER 2 -> DISPLAY 2
	PLAYER 3 -> DISPLAY 3
	PLAYER 4 -> DISPLAY 4
	DEALER -> DISPLAY D

*/

module cardgame_21(SW, KEY, HEX0, HEX1, HEX4, HEX5, HEX6, CLOCK_50);
	input [2:0] SW;
	input [3:0] KEY;
	input CLOCK_50;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX4;
	output [6:0] HEX5;
	output [6:0] HEX6;
	
	wire [3:0] card;
	
	draw_card draw(.in(KEY[2]), .card(card), .clock(CLOCK_50));
	
	hex_display_card hex_card(.IN(card), .tens(HEX1), .ones(HEX0));
	
	hex_display_card player_score(.IN(score), .tens(HEX5), .ones(HEX4));
	
	wire [5:0] score;
	player_register test_reg(.in(card), .out(score), .clock(CLOCK_50), .reset(reset), .enable(KEY[2]));
	
	wire reset;
	assign reset = KEY[0];
	
endmodule

module control(
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
		
		case (current_turn)
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
	
	// current_turn registers
	always @(posedge clock)
	begin: State_FFs
		if(reset)
			current_turn <= PLAYER_1_TURN;
		else
			current_turn <= next_turn;
	end
		
endmodule

/*TRY TO SET IT SO THAT DRAWING A CARD MOVES TO A NEW STATE IN ORDER TO INCREMENT THE SCORE
*/
// Register to store the player score
module player_register(in, out, clock, reset, enable) ;
	input clock, reset, enable;
	input [3:0] in;
	// Use 6 bits in case someone has a score of 21 (5 bits) and draws a 13, resulting in 34 (6 bits)
	output reg [5:0] out;
	
	// Set initial score to 0
	initial
	begin
		out = 5'b00000;
	end
	
	// Add the value of in to out
	always @(posedge clock)
	begin
		if(reset == 1'b0)
			out <= 5'b00000;
		else if(enable == 1'b1)
			out <= out + {2'b00, in};
	end
endmodule
	