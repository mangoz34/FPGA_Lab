module comparator(tens, units, match);
	parameter tens_ = 4'd3;
	parameter units_ = 4'd2;
	input logic [3:0] tens;
	input logic [3:0] units;
	output logic match;
	
	logic tens_match;
	logic units_match;
	assign tens_match = (tens == tens_);
	assign units_match = (units == units_);
	
	assign match = (tens_match & units_match);
	
endmodule

module comparator_testbench();
	logic [3:0] tens, units;
	logic match;
	
	comparator dut(.tens(tens), .units(units), .match(match));
	
	int i, j;
	
	initial begin
		for(int i = 0; i < 10; i++) begin
			for(int j = 0; j < 10; j++) begin
				tens = i; units = j; #10;
			end
		end
	end
endmodule

	