`timescale 1ns/1ps
module DE1_SoC(CLOCK_50, SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);
    input  logic CLOCK_50;
    input  logic [9:0] SW;
    input  logic [0:0] KEY;
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    output logic [9:0] LEDR;
	 
    logic start, reset, found;
	 logic [4:0] loc;
	 logic [7:0] A;
    assign reset = ~KEY[0];
	 assign start = SW[9];
	 assign LEDR[7:0] = SW[7:0];
	 assign A = SW[7:0];
	 
    logic s_init, s_setmid, s_wait, s_cmp, s_done;
    logic ld_init, ld_mid, upd_left, upd_right, latch_loc, set_found;
    logic eq, gt, l_gt_r;
    logic [4:0] mid_for_loc;

    logic [4:0] mem_addr;
    logic [7:0] mem_q;

    BinarySearch_ctrl bs_ctrl (
        .clk(CLOCK_50),
        .reset(reset),
        .start(start),
        .eq(eq),
        .gt(gt),
        .l_gt_r(l_gt_r),
        .ld_init(ld_init),
        .ld_mid(ld_mid),
        .upd_left(upd_left),
        .upd_right(upd_right),
        .latch_loc(latch_loc),
        .set_found(set_found)
    );

	 
    BinarySearch_datapath bs_dp (
        .clk       (CLOCK_50),
        .reset     (reset),
        .A         (A),
        .ld_init   (ld_init),
        .ld_mid    (ld_mid),
        .upd_left  (upd_left),
        .upd_right (upd_right),
        .latch_loc (latch_loc),
        .set_found (set_found),
        .mem_q     (mem_q),
        .mem_addr  (mem_addr),
        .eq        (eq),
        .gt        (gt),
        .l_gt_r    (l_gt_r),
        .loc       (loc),
        .found     (found)
    );

	 
	sorted_array_rom mem(.address(mem_addr), .clken(1'b1), .clock(CLOCK_50),
									.data(8'b0), .wren(1'b0), .q(mem_q));

	 
    hex7seg hex0 (.num(loc[3:0]), .seg(HEX0));
    hex7seg hex1 (.num({3'b000, loc[4]}), .seg(HEX1));
    assign LEDR[9] = found;
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
		SW[9] = 0;
		KEY[0] = 1;
		repeat(3) @(posedge CLOCK_50)
		
		SW[0] = 1; SW[1] = 1; SW[2] = 0; SW[3] = 0; SW[4] = 0; SW[5] = 0; SW[6] = 0; SW[7] = 0;

		KEY[0] = 0; @(posedge CLOCK_50);
		KEY[0] = 1; @(posedge CLOCK_50);
		
		SW[9] = 0; @(posedge CLOCK_50);
		
		SW[9] = 1; @(posedge CLOCK_50);
		repeat(20) @(posedge CLOCK_50);
		
		
		SW[0] = 0; SW[1] = 1; SW[2] = 0; SW[3] = 0; SW[4] = 0; SW[5] = 0; SW[6] = 0; SW[7] = 0;
		
		KEY[0] = 0; @(posedge CLOCK_50);
		KEY[0] = 1; @(posedge CLOCK_50);
		
		SW[9] = 0; @(posedge CLOCK_50);
		
		SW[9] = 1; @(posedge CLOCK_50);
		repeat(20) @(posedge CLOCK_50);
		

		$stop; // End the simulation. 
	end

endmodule
