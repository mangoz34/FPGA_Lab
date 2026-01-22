module DE1_SoC(CLOCK_50, SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);
    input logic CLOCK_50;
    input logic [9:0] SW;
    input logic [3:0] KEY;
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    output logic [9:0] LEDR;
    logic rst;
    assign rst = KEY[0];

    logic s_sync;
    sync1bit sync(.clk(CLOCK_50), .d_async(SW[9]), .qsync(s_sync));

    logic load, shift, clear, inc;
    logic a_is_zero, a0;
    logic [3:0] result;
    logic done;

    register regs (
        .clk(CLOCK_50),
        .reset(rst),
        .load(load),
        .shift(shift),
        .clear(clear),
        .inc(inc),
        .sw(SW[7:0]),
        .a_is_zero(a_is_zero),
        .a0(a0),
        .result(result)
    );

    controller ctrl (
        .clk(CLOCK_50),
        .reset(rst),
        .s(s_sync),
        .a_is_zero(a_is_zero),
        .a0(a0),
        .load(load),
        .shift(shift),
        .clear(clear),
        .inc(inc),
        .done(done)
    );

    hex7seg hex(.num(result), .seg(HEX0));
    assign LEDR[9] = done;
    assign LEDR[8:0] = 9'b0;
    assign HEX1 = 7'b1111111;
    assign HEX2 = 7'b1111111;
    assign HEX3 = 7'b1111111;
    assign HEX4 = 7'b1111111;
    assign HEX5 = 7'b1111111;
endmodule


module DE1_SoC_testbench(); 
	logic CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	DE1_SoC dut (CLOCK_50, SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);
	
	// Set up a simulated clock. 
	parameter CLOCK_PERIOD=100; 
	initial begin
	CLOCK_50 <= 0;
	
	// Forever toggle the clock
	forever #(CLOCK_PERIOD/2) 
		CLOCK_50 <= ~CLOCK_50;
	end
	
	// Test the design. 
	initial begin
		// Always reset FSMs at start
		SW[9]=0;
		KEY[0]=1;
		repeat(3) @(posedge CLOCK_50)
		
		SW[0] = 1; SW[1] = 1; SW[2] = 1; SW[3] = 1; SW[4] = 1; SW[5] = 0; SW[6] = 0; SW[7] = 0;

		KEY[0] = 0;
		repeat (3) @(posedge CLOCK_50);
		KEY[0] = 1;
		repeat (3) @(posedge CLOCK_50);
		
		
		SW[9] = 1;
		repeat(20) @(posedge CLOCK_50);
		
		SW[9] = 0; @(posedge CLOCK_50);
		SW[9] = 1; @(posedge CLOCK_50);
		
		SW[0] = 1; SW[1] = 1; SW[2] = 1; SW[3] = 1; SW[4] = 1; SW[5] = 1; SW[6] = 1; SW[7] = 1;
		
		KEY[0] = 0;
		repeat (3) @(posedge CLOCK_50);
		KEY[0] = 1;
		repeat (3) @(posedge CLOCK_50);
		
		SW[9] = 1;
		repeat(20) @(posedge CLOCK_50);
		

		$stop; // End the simulation. 
	end

endmodule
