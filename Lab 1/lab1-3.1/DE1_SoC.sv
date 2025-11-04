// Top-level module that defines the I/Os for the DE1 SoC board 
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW); 
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; 
	output logic [9:0] LEDR; 
	input logic [3:0] KEY; 
	input logic [9:0] SW; 
	
	seg7 digit0(.bcd(SW[3:0]), .leds(HEX0));
	seg7 digit1(.bcd(SW[7:4]), .leds(HEX1));
	
	assign LEDR[9:0] = 10'b0;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
endmodule 
