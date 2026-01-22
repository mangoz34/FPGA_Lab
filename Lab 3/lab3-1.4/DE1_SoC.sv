module DE1_SoC (
    input  logic CLOCK_50,
    input  logic [3:0] KEY, 
    input  logic [9:0] SW,
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output logic [9:0] LEDR
);

    // --------------------------
    // Signal declarations
    // --------------------------
    logic [3:0] data_in, data_out;
    logic [4:0] addr, rd_addr;
    logic we;
    logic clean_key0;
    logic reset;

    // KEY3 reset is active-low on board
    assign reset = ~KEY[3];            // 按下 = 1 (active-high reset)
    assign LEDR[9] = reset;            // 亮燈表示正在 reset

    assign data_in = SW[3:0];
    assign addr    = SW[8:4];
    assign we      = SW[9];

    // --------------------------
    // Debounce KEY0 to clean pulse for counter
    // --------------------------
    button_input key0_clean (
        .clk   (CLOCK_50),
        .reset (reset),
        .key_raw(KEY[0]),
        .press_button(clean_key0)
    );

    // --------------------------
    // Counter for read address
    // --------------------------
    counter read_counter (
        .q     (rd_addr),
        .reset (reset),
        .clk   (clean_key0)
    );

    // --------------------------
    // Dual-port RAM (from IP Catalog)
    // --------------------------
    ram32x4port2 ram (
        .clock     (CLOCK_50),
        .data      (data_in),
        .wraddress (addr),
        .wren      (we),
        .rdaddress (rd_addr),
        .q         (data_out)
    );

    // --------------------------
    // Display Mapping
    // --------------------------
    logic [3:0] safe_data_out;
    logic [4:0] safe_rd_addr;

    always_comb begin
        if (reset) begin
            safe_data_out = 4'b0000;
            safe_rd_addr  = 5'b00000;
        end
        else begin
            safe_data_out = data_out;
            safe_rd_addr  = rd_addr;
        end
    end

    // Display sections
    hex7seg h_wr_lo   (.num(addr[3:0]),             .seg(HEX4));
    hex7seg h_wr_hi   (.num({3'b000, addr[4]}),     .seg(HEX5));
    hex7seg h_data_in (.num(data_in),               .seg(HEX1));

    hex7seg h_rd_lo   (.num(safe_rd_addr[3:0]),     .seg(HEX2));
    hex7seg h_rd_hi   (.num({3'b000, safe_rd_addr[4]}), .seg(HEX3));
    hex7seg h_data_out(.num(safe_data_out),         .seg(HEX0));

    assign LEDR[8:0] = 9'b0; // clean LEDs

endmodule