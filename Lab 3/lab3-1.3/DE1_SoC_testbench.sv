module DE1_SoC_testbench;

    logic CLOCK_50;
    logic [3:0] KEY;
    logic [9:0] SW;
    logic [9:0] LEDR;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    // safer instantiation
    DE1_SoC dut (
        .CLOCK_50(CLOCK_50),
        .KEY(KEY),
        .SW(SW),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5),
        .LEDR(LEDR)
    );

    parameter CLOCK_PERIOD = 100;
    always #(CLOCK_PERIOD/2) CLOCK_50 = ~CLOCK_50;

    initial begin
        CLOCK_50 = 0;
        KEY = 4'b1111;
        SW  = 10'b0;
        #20;

        // Write 0xA to address 1
        SW[9] = 1;         // we = 1
        SW[8:4] = 5'd1;    // addr = 1
        SW[3:0] = 4'hA;    // data = A
		  #10;
        // generate write clk edge
		  KEY[0] = 0;
        #10
		  KEY[0] = 1;

        // disable write
        SW[9] = 0;
        #20;
		  KEY[0] = 0; 
        #10;
        KEY[0] = 1; 
        
        #20;

        $display("READ OUT = %h", dut.data_out);

        $stop;
    end

endmodule

