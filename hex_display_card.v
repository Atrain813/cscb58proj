module hex_display_card(IN, tens, ones);
    input [5:0] IN;
	 output reg [6:0] tens, ones;
	 
	 always @(*)
	 begin
		case(IN[5:0])
			// 01
			6'b000000: begin
							tens = 7'b1000000; // 0
							ones = 7'b1000000; // 1
						end
			// 01
			6'b000001: begin
							tens = 7'b1000000; // 0
							ones = 7'b1111001; // 1
						end
			// 02
			6'b000010: begin
							tens = 7'b1000000; // 0
							ones = 7'b0100100; // 2
						end
			// 03
			6'b000011: begin
							tens = 7'b1000000; // 0
							ones = 7'b0110000; // 3
						end
			// 04
			6'b000100: begin
							tens = 7'b1000000; // 0
							ones = 7'b0011001; // 4
						end
			// 05
			6'b000101: begin
							tens = 7'b1000000; // 0
							ones = 7'b0010010; // 5
						end
			// 06
			6'b000110: begin
							tens = 7'b1000000; // 0
							ones = 7'b0000010; // 6
						end
			// 07
			6'b000111: begin
							tens = 7'b1000000; // 0
							ones = 7'b1111000; // 7
						end
			// 08
			6'b001000: begin
							tens = 7'b1000000; // 0
							ones = 7'b0000000; // 8
						end
			// 09
			6'b001001: begin
							tens = 7'b1000000; // 0
							ones = 7'b0011000; // 9
						end
			// 10
			6'b001010: begin
							tens = 7'b1111001; // 1
							ones = 7'b1000000; // 0
						end
			// 11
			6'b001011: begin
							tens = 7'b1111001; // 1
							ones = 7'b1111001; // 1
						end
			// 12
			6'b001100: begin
							tens = 7'b1111001; // 1
							ones = 7'b0100100; // 2
						end
			// 13
			6'b001101: begin
							tens = 7'b1111001; // 1
							ones = 7'b0110000; // 3
						end
			// 14
			6'b001110: begin
							tens = 7'b1111001; // 1
							ones = 7'b0011001; // 4
						end
			// 15
			6'b001111: begin
							tens = 7'b1111001; // 1
							ones = 7'b0010010; // 5
						end
			// 16
			6'b010000: begin
							tens = 7'b1111001; // 1
							ones = 7'b0000010; // 6
						end
			// 17
			6'b010001: begin
							tens = 7'b1111001; // 1
							ones = 7'b1111000; // 7
						end
			// 18
			6'b010010: begin
							tens = 7'b1111001; // 1
							ones = 7'b0000000; // 8
						end
			// 19
			6'b010011: begin
							tens = 7'b1111001; // 1
							ones = 7'b0011000; // 9
						end
			// 20
			6'b010100: begin
							tens = 7'b0100100; // 2
							ones = 7'b1000000; // 0
						end
			// 21
			6'b010101: begin
							tens = 7'b0100100; // 2
							ones = 7'b1111001; // 1
						end
			// 22
			6'b010110: begin
							tens = 7'b0100100; // 2
							ones = 7'b0100100; // 2
						end
			// 23
			6'b010111: begin
							tens = 7'b0100100; // 2
							ones = 7'b0110000; // 3
						end
			// 24
			6'b011000: begin
							tens = 7'b0100100; // 2
							ones = 7'b0011001; // 4
						end
			// 25
			6'b011001: begin
							tens = 7'b0100100; // 2
							ones = 7'b0010010; // 5
						end
			// 26
			6'b011010: begin
							tens = 7'b0100100; // 2
							ones = 7'b0000010; // 6
						end
			// 27
			6'b011011: begin
							tens = 7'b0100100; // 2
							ones = 7'b1111000; // 7
						end
			// 28
			6'b011100: begin
							tens = 7'b0100100; // 2
							ones = 7'b0000000; // 8
						end
			// 29
			6'b011101: begin
							tens = 7'b0100100; // 2
							ones = 7'b0011000; // 9
						end
			// 30
			6'b011110: begin
							tens = 7'b0110000; // 3
							ones = 7'b1000000; // 0
						end
			// 31
			6'b011111: begin
							tens = 7'b0110000; // 3
							ones = 7'b1111001; // 1
						end
			// 32
			6'b100000: begin
							tens = 7'b0110000; // 3
							ones = 7'b0100100; // 2
						end
			// 33
			6'b100001: begin
							tens = 7'b0110000; // 3
							ones = 7'b0110000; // 3
						end
			// 34
			6'b100010: begin
							tens = 7'b0110000; // 3
							ones = 7'b0011001; // 4
						end
			// 35
			6'b100011: begin
							tens = 7'b0110000; // 3
							ones = 7'b0010010; // 5
						end
			// 36
			6'b100100: begin
							tens = 7'b0110000; // 3
							ones = 7'b0000010; // 6
						end
			// 37
			6'b100101: begin
							tens = 7'b0110000; // 3
							ones = 7'b1111000; // 7
						end
			// 38
			6'b100110: begin
							tens = 7'b0110000; // 3
							ones = 7'b0000000; // 8
						end
			// 39
			6'b100111: begin
							tens = 7'b0110000; // 3
							ones = 7'b0011000; // 9
						end
			// 40
			6'b101000: begin
							tens = 7'b0011001; // 4
							ones = 7'b1000000; // 0
						end
			// 41
			6'b101001: begin
							tens = 7'b0011001; // 4
							ones = 7'b1111001; // 1
						end
			// 42
			6'b101010: begin
							tens = 7'b0011001; // 4
							ones = 7'b0100100; // 2
						end
			// 43
			6'b101011: begin
							tens = 7'b0011001; // 4
							ones = 7'b0110000; // 3
						end
			// 44
			6'b101100: begin
							tens = 7'b0011001; // 4
							ones = 7'b0011001; // 4
						end
			// 45
			6'b101101: begin
							tens = 7'b0011001; // 4
							ones = 7'b0010010; // 5
						end
			// 46
			6'b101110: begin
							tens = 7'b0011001; // 4
							ones = 7'b0000010; // 6
						end
			// 47
			6'b101111: begin
							tens = 7'b0011001; // 4
							ones = 7'b1111000; // 7
						end
			// 48
			6'b110000: begin
							tens = 7'b0011001; // 4
							ones = 7'b0000000; // 8
						end
			// 49
			6'b110001: begin
							tens = 7'b0011001; // 4
							ones = 7'b0011000; // 9
						end
			// 50
			6'b110010: begin
							tens = 7'b0010010; // 5
							ones = 7'b1000000; // 0
						end
			// 51
			6'b110011: begin
							tens = 7'b0010010; // 5
							ones = 7'b1111001; // 1
						end
			// 52
			6'b110100: begin
							tens = 7'b0010010; // 5
							ones = 7'b0100100; // 2
						end
			// 53
			6'b110101: begin
							tens = 7'b0010010; // 5
							ones = 7'b0110000; // 3
						end
			// 54
			6'b110110: begin
							tens = 7'b0010010; // 5
							ones = 7'b0011001; // 4
						end
			// 55
			6'b110111: begin
							tens = 7'b0010010; // 5
							ones = 7'b0010010; // 5
						end
			// 56
			6'b111000: begin
							tens = 7'b0010010; // 5
							ones = 7'b0000010; // 6
						end
			// 57
			6'b111001: begin
							tens = 7'b0010010; // 5
							ones = 7'b1111000; // 7
						end
			// 58
			6'b111010: begin
							tens = 7'b0010010; // 5
							ones = 7'b0000000; // 8
						end
			// 59
			6'b111011: begin
							tens = 7'b0010010; // 5
							ones = 7'b0011000; // 9
						end
			// 60
			6'b111100: begin
							tens = 7'b0000010; // 6
							ones = 7'b1000000; // 0
						end
			// 61
			6'b111101: begin
							tens = 7'b0000010; // 6
							ones = 7'b1111001; // 1
						end
			// 62
			6'b111110: begin
							tens = 7'b0000010; // 6
							ones = 7'b0100100; // 2
						end
			// 63
			6'b111111: begin
							tens = 7'b0000010; // 6
							ones = 7'b0110000; // 3
						end
			// Set default to --
			default: begin
							tens = 7'b0111111; // 0
							ones = 7'b0111111; // 0
						end
		endcase
	end
endmodule