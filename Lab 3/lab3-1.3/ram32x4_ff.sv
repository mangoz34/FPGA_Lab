module ram32x4_ff (
    input  logic        clk,       // KEY0
    input  logic [3:0]  data_in,   // SW3–SW0
    input  logic [4:0]  addr,      // SW8–SW4
    input  logic        we,        // SW9
    output logic [3:0]  data_out   // Data read out
);

    logic [3:0] memory_array [31:0]; // 32 words × 4 bits

    always_ff @(posedge clk) begin
        if (we)
            memory_array[addr] <= data_in; // Write on rising edge
        data_out <= memory_array[addr];    // Read on rising edge
    end

endmodule