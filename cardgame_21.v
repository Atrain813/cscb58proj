/*IDEA
STATE FOR THE DEALER TO DRAW
AFTER THE DEALER DRAWS AND CHANGES BACK TO DEALER STATE, CHECK THE SCORE

TRY MAKING THE MATH IN THE POSEDGE OF THE CLOCK

TRY MAKING SEPARATE STATES FOR PLAYER WIN/LOSS
*/

module cardgame_21(SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDR, CLOCK_50);
	input [2:0] SW;
	input [3:0] KEY;
	input CLOCK_50;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	output [6:0] HEX6;
	output [6:0] HEX7;
	output [16:0] LEDR;
	
	//wire [3:0] card;
	wire reset, next, draw, drawing;
	assign reset = ~KEY[0];
	assign next = ~KEY[3];
	assign draw = ~KEY[2] || ~KEY[1] || SW[0];
	
	wire [3:0] card_value;
	wire [2:0] outcome, turn;
	wire [5:0] player_score, dealer_score;
	
	assign LEDR[3:0] = turn;
	assign LEDR[16] = reset;
	assign LEDR[15] = next;
	assign LEDR[14] = draw;
	
//	draw_card draw(.in(~KEY[2]), .card(card), .clock(CLOCK_50), .reset(reset), .turn(SW[1]));
//	
//	hex_display_card hex_card(.IN(card), .tens(HEX1), .ones(HEX0));
//	
//	hex_display_card player_score(.IN(score), .tens(HEX5), .ones(HEX4));
//	
//	wire [5:0] score;
//	player_register test_reg(.in(card), .out(score), .clock(~KEY[2]), .reset(reset));

	// CONTROL MODULE
	control control_module(
						.next(next),
						.draw(draw),
						.reset(reset),
						.clock(CLOCK_50),
						.outcome(outcome),
						.drawing(drawing),
						.turn(turn));
	
	// DATAPATH MODULEdealer_score_cur
	datapath datapath_module(
						.clock(CLOCK_50),
						.reset(reset),
						.turn(turn),
						.draw(draw),
						.card_value(card_value),
						.outcome(outcome),
						.player_score(player_score),
						.dealer_score(dealer_score));
						
	// HEX DISPLAY FOR THE PLAYER SCORE
	hex_display_card player_score_display(.IN(player_score), .tens(HEX1), .ones(HEX0));
	
	// HEX DISPLAY FOR THE DEALER SCORE
	hex_display_card dealer_score_display(.IN(dealer_score), .tens(HEX3), .ones(HEX2));
	
	// HEX DISPLAY FOR THE CARD VALUE
	hex_display_card card_value_display(.IN(card_value), .tens(HEX5), .ones(HEX4));
	
	// HEX DISPLAY FOR THE TURN COUNTER
	reg [3:0] turn_hex;
	always @(*)
	begin
		case(turn)
			3'b000: turn_hex <= 4'b1010;
			3'b010: turn_hex <= 4'b1101;
			3'b100: turn_hex <= 4'b1110;
			
		endcase
	end
	
	hex_display turn_display(.IN(turn_hex), .OUT(HEX6));
	// HEX DISPLAY FOR THE OUTCOME
	reg [3:0] outcome_hex;
	always @(*)
	begin
		case(outcome)
			2'b01: outcome_hex <= 4'b1010;
			2'b10: outcome_hex <= 4'b1101;
			2'b00: outcome_hex <= 4'b0000;
			
		endcase
	end
	
	hex_display outcome_display(.IN(outcome_hex), .OUT(HEX7));
	
endmodule

module control(
	input next,
	input draw,
	input reset,
	input clock,
	input [1:0] outcome,
	output reg drawing,
	output reg [2:0] turn);
	
	reg [4:0] current_state, next_state;

	localparam PLAYER_HOLD = 5'd0,
				  PLAYER_HOLD_WAIT = 5'd1,
				  PLAYER_DRAW = 5'd2,
				  PLAYER_DRAW_WAIT = 5'd3,
				  DEALER_TURN = 5'd4,
				  DEALER_DRAW = 5'd5,
				  ENDGAME = 5'd6,
//				  WIN = 5'd7
//				  LOSE = 5'd8
				  ENDGAME_WAIT = 5'd7;
				  
	initial
	begin
		current_state = PLAYER_HOLD;
	end
	
	// State table
	always @(*)
	begin: state_table
		case(current_state)
			PLAYER_HOLD: begin
								if(next)
									next_state = PLAYER_HOLD_WAIT;
								else if(draw)
									next_state = PLAYER_DRAW;
								else if(outcome == 2'b10)
									next_state = ENDGAME;
								else
									next_state = PLAYER_HOLD;
							end
			PLAYER_HOLD_WAIT: next_state = next ? PLAYER_HOLD_WAIT: DEALER_TURN;
			PLAYER_DRAW: next_state = PLAYER_HOLD; //PLAYER_DRAW_WAIT;
//			PLAYER_DRAW_WAIT: next_state = drawing ? PLAYER_DRAW_WAIT : PLAYER_HOLD;
			DEALER_TURN: begin
								if(outcome != 2'b00)
									next_state = DEALER_DRAW;
								else
									next_state = ENDGAME;
							end
			DEALER_DRAW: next_state = DEALER_TURN;
			ENDGAME: next_state =  reset ? ENDGAME_WAIT : ENDGAME;
			ENDGAME_WAIT: next_state = reset ? ENDGAME_WAIT : PLAYER_HOLD;
			
			default: next_state = PLAYER_HOLD;
		endcase
	end
	
	// Output logic
	always @(*)
	begin: enable_signals
		drawing = 1'b0;
		turn = 3'b000;
					
		case (current_state)
			PLAYER_HOLD: begin
					turn = 3'b000;
					drawing = 1'b0;
					end
			PLAYER_HOLD_WAIT: begin
					turn = 3'b000;
					drawing = 1'b0;
					end
			PLAYER_DRAW: begin
					turn = 3'b001;
					drawing = 1'b1;
					end
//			PLAYER_DRAW_WAIT: begin
//					turn = 3'b001;
//					drawing = 1'b0;
//					end
			DEALER_TURN: begin
					turn = 3'b010;
					drawing = 1'b0;
					end
			DEALER_DRAW: begin
					turn = 3'b011;
					drawing = 1'b1;
					end
			ENDGAME: begin
					turn = 3'b100;
					drawing = 1'b0;
					end
			ENDGAME_WAIT: begin
					turn = 3'b100;
					drawing = 1'b0;
					end

		endcase
	end
	
	// current_turn registers
	always @(posedge clock)
	begin: State_FFs
		if(reset)
			current_state <= PLAYER_HOLD;
		else
			current_state <= next_state;
	end
		
endmodule

module datapath(
	input clock,
	input reset,
	input [2:0] turn,
	input draw,
	output reg [3:0] card_value,
	output reg [1:0] outcome,
	output reg [5:0] player_score,
	output reg [5:0] dealer_score);

	wire [3:0] card;
	wire [3:0] dealer_count;
	
	reg [5:0] player_score_cur, dealer_score_cur;
	
	integer dealer_card_counter = 0;
	
	initial
	begin
		player_score <= 6'b000000;
		dealer_score <= 6'b000000;
		player_score_cur <= 6'b000000;
		dealer_score_cur <= 6'b000000;
		outcome <= 2'b00;
		card_value <= 4'b000;
	end
	
	draw_card Draw_Card(.in(draw), .card(card), .clock(clock), .reset(reset), .turn(1'b0));
	
	draw_card turn_counter(.in(draw), .card(dealer_count), .clock(clock), .reset(reset), .turn(1'b1));
//	// Operations to keep track of player scores
//	always @(posedge draw)
//	begin: operations
////		if(reset)
////		begin
////			player_score_cur <= 6'b000000;
////			dealer_score_cur <= 6'b000000;
////		end
////		else
////				player_score_cur <= player_score_cur + card;
//				card_value <= card;
//			end
//			else if(turn == 3'b011)
//				dealer_score_cur <= dealer_score_cur + card;
////		end
//	
//			if(turn == 3'b001 && !reset)
//			begin
//				player_sccard_value <= card;ore_cur <= player_score_cur + card;
//				card_value <= card;
//			end
//			else if(turn == 3'b011)
//				dealer_score_cur <= dealer_score_cur + card;
////		end
//	end
	
	// Output result
	always @(posedge clock)
	begin
		if(reset)
		begin
			outcome <= 2'b00;
			player_score <= 6'b0;
			dealer_score <= 6'b0;
			player_score_cur <= 6'b0;
			dealer_score_cur <= 6'b0;
			card_value <= 3'b0000;
		end
		else
		begin
			if(turn == 3'b001)
				player_score_cur <= player_score_cur + card;
			else if(turn == 3'b011)
				dealer_score_cur <= dealer_score_cur + card;
			
			player_score <= player_score_cur;
			dealer_score <= dealer_score_cur;
			
			if(turn == 3'b001)
				card_value <= card;
				
			if(player_score > 6'b10101  && turn == 3'b000)
				outcome <= 2'b10;
			else if (dealer_score > player_score && dealer_score <= 5'b10101)
				outcome <= 2'b10;
			else if(dealer_score > 5'b10101)
				outcome <= 2'b01;
			else
				outcome <= 2'b00;
		end
	end
endmodule
	

//// Register to store the player score
//module player_register(in, out, clock, reset) ;
//	input clock, reset;
//	input [3:0] in;
//	// Use 6 bits in case someone has a score of 21 (5 bits) and draws a 13, resulting in 34 (6 bits)
//	output reg [5:0] out;
//	
//	// Set initial score to 0
//	initial
//	begin
//		out = 5'b00000;
//	end
//	
//	// Add the value of in to out
//	always @(negedge clock)
//	begin
//		if(reset == 1'b1)
//			out <= 5'b00000;
//		else
//			out <= out + in;
//	end
//endmodule
	