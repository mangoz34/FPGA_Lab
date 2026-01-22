module ram32x4_ff_testbench;

    // Declare signals matching the DUT's ports
    logic clk;
    logic [3:0] data_in;
    logic [4:0] addr;
    logic we;
    logic [3:0] data_out;

    // Instantiate the Device Under Test (DUT)
    ram32x4_ff dut (
        .clk(clk),
        .data_in(data_in),
        .addr(addr),
        .we(we),
        .data_out(data_out)
    );

    // Clock Generation
    parameter CLK_PERIOD = 20; // 50 MHz equivalent for simulation
    always #(CLK_PERIOD/2) clk = ~clk;

    // Test sequence
    initial begin
        // 1. Initialize
        clk = 0;
        data_in = 4'h0;
        addr = 5'h0;
        we = 0;
        #10; // Wait for initial stability

        // ------------------------------------------
        // 2. Write Operation: Write 0xC to Address 5
        // ------------------------------------------
        
        we = 1;              // Enable write
        addr = 5'd5;         // Set address
        data_in = 4'hC;      // Set data to write
        #5;                  
        
        @(posedge clk);      // Perform synchronous write 
        
        we = 0;              // Disable write
        data_in = 4'h0;      // Clear data_in 
        #10;

        // ------------------------------------------
        // 3. Read Operation: Read from Address 5
        // ------------------------------------------
        
        // addr is already 5'd5
        
        @(posedge clk);      // Perform synchronous read 
        
        #5; // Wait for data_out to settle after the clock edge
        
        // ------------------------------------------
        // 4. End Simulation
        // ------------------------------------------
        
        #50;
        $stop; 
    end

endmodule