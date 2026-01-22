`timescale 1ns/1ps
module DE1_SoC_testbench;

    // DUT Ports
    logic CLOCK_50;
    logic [3:0] KEY;
    logic [9:0] SW;
    logic [9:0] LEDR;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    // Instantiate the DUT
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

    // Clock Generation (50 MHz -> 20ns period)
    parameter CLOCK_PERIOD = 20;
    always #(CLOCK_PERIOD/2) CLOCK_50 = ~CLOCK_50;

    initial begin
        // Initialize Signals
        CLOCK_50 = 0;
        KEY = 4'b1111; // KEY[3] = 1 (No Reset); KEY[0] = 1 (No Press)
        SW  = 10'b0;
        #10;

        // ----------------------------------------------------
        // 1. Reset Verification (Active-high reset: KEY[3]=0 -> reset=1)
        // ----------------------------------------------------
        
        KEY[3] = 0; // Trigger Reset
        # (CLOCK_PERIOD * 2);
        
        KEY[3] = 1; // Release Reset
        # (CLOCK_PERIOD * 2);

        // ----------------------------------------------------
        // 2. Write Operations (Write Port: CLOCK_50)
        // ----------------------------------------------------
        
        // Write 0xAA to Address 1 (SW[8:4]=1, SW[3:0]=0xA, SW[9]=1)
        SW[9] = 1;         // we = 1 (Write Enable)
        SW[8:4] = 5'd1;    // addr = 1
        SW[3:0] = 4'hA;    // data_in = 0xA
        # (CLOCK_PERIOD / 2); // Wait for CLOCK_50 posedge (Write occurs here)
        
        SW[9] = 0;         // Disable write
        # (CLOCK_PERIOD);
        
        // Write 0xBB to Address 2 (SW[8:4]=2, SW[3:0]=0xB, SW[9]=1)
        SW[9] = 1;
        SW[8:4] = 5'd2;    // addr = 2
        SW[3:0] = 4'hB;    // data_in = 0xB
        # (CLOCK_PERIOD / 2); // Wait for CLOCK_50 posedge
        
        SW[9] = 0;         // Disable write
        SW[3:0] = 4'h0;    // Clear data_in
        # (CLOCK_PERIOD * 2);
        
        // ----------------------------------------------------
        // 3. Read Operations (Read Port: clean_key0 pulse)
        // ----------------------------------------------------
        
        // Read 1: Check initial state (Addr 0)
        # (CLOCK_PERIOD * 2);
        
        // Read 2: Press KEY[0] to increment rd_addr to 1. Expected data_out = 0xA.
        KEY[0] = 0; // Press the button
        # (CLOCK_PERIOD * 5); // Wait for Debouncer/Counter to process the press
        
        KEY[0] = 1; // Release the button
        # (CLOCK_PERIOD * 5);

        // Read 3: Press KEY[0] again to increment rd_addr to 2. Expected data_out = 0xB.
        KEY[0] = 0; // Press
        # (CLOCK_PERIOD * 5);
        
        KEY[0] = 1; // Release
        # (CLOCK_PERIOD * 5);
        
        // Read 4: Press KEY[0] again to increment rd_addr to 3. Expected data_out = 0x0 (assuming empty RAM location).
        KEY[0] = 0; // Press
        # (CLOCK_PERIOD * 5);
        
        KEY[0] = 1; // Release
        # (CLOCK_PERIOD * 5);

        // ----------------------------------------------------
        // 4. End Simulation
        // ----------------------------------------------------
        
        #100;
        $stop;
    end

endmodule
