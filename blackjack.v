module blackjack(SW, KEY, CLOCK_50, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
    input [17:0] SW;
    input [3:0] KEY;
    input CLOCK_50;
    output [17:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;

    wire resetn;
    wire draw;
    wire outcome;
    wire hold;
    wire hold_d;
    wire player_hold;
    wire dealer_hold;
    wire ld_card_dealer;
    wire ld_card_player;
    wire player_bust;
    wire dealer_bust;
    wire go;
    
    wire [7:0] money = 8'd50;

    wire [7:0] player_total;
    wire [7:0] dealer_total;
    //wire [3:0] card_in;
    assign resetn = SW[4];
    assign hold = SW[17];
    assign go = KEY[3];
    
    
    //draw_card draw( .in(draw),
	//	    .card(card_in),
	//	    .clock(CLOCK_50));

    hex_display H0(
        .IN(SW[16:13]), 
        .OUT(HEX0)
        );
        
    hex_display H1(
        .IN(SW[3:0]), 
        .OUT(HEX1)
        );
    hex_display H2(
        .IN(money[3:0]), 
        .OUT(HEX2)
        );
    hex_display H3(
        .IN(money[7:4]), 
        .OUT(HEX3)
        );
    hex_display H4(
        .IN(dealer_total[3:0]), 
        .OUT(HEX4)
        );
    hex_display H5(
        .IN(dealer_total[7:4]), 
        .OUT(HEX5)
        );
    hex_display H6(
        .IN(player_total[3:0]), 
        .OUT(HEX6)
        );
    hex_display H7(
        .IN(player_total[7:4]), 
        .OUT(HEX7)
        );
    control C0(
	.clk(CLOCK_50),
	.resetn(SW[4]),
	.hold(SW[17]),
	.hold_d(hold_d),
	.go(go),

	.outcome(outcome), 
	.player_hold(player_hold), 
	.dealer_hold(dealer_hold),
	.ld_card_dealer(ld_card_dealer),
	.ld_card_player(ld_card_player),
	.win(win),
	.lose(lose)
    );
    datapath D0(
	.clk(CLOCK_50),
	.resetn(SW[4]),
	.card_in(SW[16:13]),
	.money(money[7:0]),
	.bet(SW[3:0]),
	.player_hold(player_hold), 
	.dealer_hold(dealer_hold),
	.ld_card_dealer(ld_card_dealer),
	.ld_card_player(ld_card_player),
	.win(win),
	.lose(lose),
	.outcome(outcome),
	.dealer_total(dealer_total),
	.player_total(player_total),
	.hold_d(hold_d)
    );
endmodule
module control(
    input clk,
    input resetn,
    input hold,
    input hold_d,
    input outcome,
    input go,
    
    output reg ld_card_dealer,ld_card_player,win,lose,player_hold, dealer_hold
    //output draw
    );

    reg [5:0] current_state, next_state; 
    
    localparam  DEALER_DRAW_A   = 5'd0,
		DEALER_DRAW_B   = 5'd1,
		PLAYER_DRAW_A   = 5'd2,
		PLAYER_DRAW_B   = 5'd3,
		PLAYER_DRAW_B_WAIT = 5'd4,
                PLAYER_HOLD    = 5'd5,
		DEALER_DRAW_C   = 5'd6,
                DEALER_HOLD     =5'd7,
                WIN       = 5'd8,
                LOSE       = 5'd9;
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                DEALER_DRAW_A: next_state = DEALER_DRAW_B;
		DEALER_DRAW_B: next_state = PLAYER_DRAW_A;
		PLAYER_DRAW_A: next_state = PLAYER_DRAW_B;
		PLAYER_DRAW_B: next_state = PLAYER_DRAW_B_WAIT;
                PLAYER_DRAW_B_WAIT: next_state = hold ? PLAYER_HOLD : PLAYER_DRAW_B;
		PLAYER_HOLD: next_state = hold_d ? DEALER_HOLD : DEALER_DRAW_C;
		DEALER_DRAW_C: next_state = hold_d ? DEALER_HOLD : DEALER_DRAW_C;
                DEALER_HOLD: next_state =  outcome ? WIN : LOSE;
                WIN: next_state = DEALER_DRAW_A;
                LOSE: next_state = DEALER_DRAW_A;
            default:     next_state = DEALER_DRAW_A;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        ld_card_player = 1'b0;
        ld_card_dealer = 1'b0;
	win = 1'b0;
	lose = 1'b0;
	player_hold = 1'b0;
	dealer_hold = 1'b0;
	//draw = 1'b0;
        case (current_state)
            DEALER_DRAW_A: begin
                ld_card_dealer = 1'b1;
		//draw = 1'b1;
                end
	    DEALER_DRAW_B: begin
                ld_card_dealer = 1'b1;
		//draw = 1'b1;
                end
	    DEALER_DRAW_C: begin
                ld_card_dealer = 1'b1;
		//draw = 1'b1;
                end
            PLAYER_DRAW_A: begin
                ld_card_player = 1'b1;
		//draw = 1'b1;
                end
	    PLAYER_DRAW_B: begin
                ld_card_player = 1'b1;
		//draw = 1'b1;
                end
            PLAYER_HOLD: begin
                player_hold = 1'b1;
                end
            DEALER_HOLD: begin
                dealer_hold = 1'b1;
                end 
            WIN: begin
                win = 1'b1;
                end
            LOSE: begin
                lose = 1'b1;
                end
    
            
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= DEALER_DRAW_A;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

module datapath(
    input clk,
    input resetn,
    input [4:0] card_in,
    input [7:0] money,
    input [7:0] bet,
    input player_hold, dealer_hold,ld_card_dealer,ld_card_player,win,lose,
    output reg [7:0] dealer_total,
    output reg [7:0] player_total,
    output reg hold_d,
    output reg [7:0]money_out,
    output reg outcome
    );
	 
	//player_total <= 8'b0;
	//dealer_total <= 8'b0;
    reg [7:0]money_temp = 8'b0;
    reg [7:0]outcome_temp = 8'b0;

    always @(*)
    begin : Operations
	if(!resetn) 
		begin
		    player_total <= 8'b0;
		    dealer_total <= 8'b0;
		    outcome <= 1'b0;
		end
	else begin
		if(ld_card_player)
		begin
			if(card_in >= 8'd10)
				player_total <= player_total + 8'd10;
			else
				player_total <= player_total + card_in;
		end
		if(ld_card_dealer)
		begin
			if(card_in >= 8'd10)
				dealer_total <= dealer_total + 8'd10;
			else 
				dealer_total <= dealer_total + card_in;
	   end
		if(dealer_hold)
	   begin
		if(player_total > 21)
		    outcome <= 1'b0;
		else if(dealer_total > 21)
		    outcome <= 1'b1;
		else
		    outcome <= 1'b0;
	   end
		if(win)
	   begin
			money_temp <= money + bet;
			player_total <= 8'b0;
			dealer_total <= 8'b0;
			outcome <= 1'b0;
			money_out <= money_temp;
	   end
		if(lose)
		begin
			money_temp <= money + bet;
			player_total <= 8'b0;
			dealer_total <= 8'b0;
			outcome <= 1'b0;
			money_out <= money_temp;
	   end 
    end
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
			4'b1010: OUT = 7'b0001000;
			4'b1011: OUT = 7'b0000011;
			4'b1100: OUT = 7'b1000110;
			4'b1101: OUT = 7'b0100001;
			4'b1110: OUT = 7'b0000110;
			4'b1111: OUT = 7'b0001110;
			
			default: OUT = 7'b0111111;
		endcase

	end
endmodule