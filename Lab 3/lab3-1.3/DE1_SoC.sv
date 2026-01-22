module DE1_SoC (
    input  logic CLOCK_50,
    input  logic [3:0] KEY, 
    input  logic [9:0] SW,
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output logic [9:0] LEDR
);

    logic [3:0] data_in, data_out;
    logic [4:0] addr;
    logic we, clk;

    assign data_in = SW[3:0];
    assign addr    = SW[8:4];
    assign we      = SW[9];
    assign clk     = ~KEY[0]; // Active-low pushbutton

    ram32x4_ff ram (
        .clk(clk),
        .data_in(data_in),
        .addr(addr),
        .we(we),
        .data_out(data_out)
    );

    // Display
    hex7seg h_addr_lo (.num(addr[3:0]), .seg(HEX4));
    hex7seg h_addr_hi (.num({3'b000, addr[4]}), .seg(HEX5));
    hex7seg h_din (.num(data_in), .seg(HEX2));
    hex7seg h_dout (.num(data_out), .seg(HEX0));

    // Optional visual debug
	 assign HEX1 = 7'b1111111;
	 assign HEX3 = 7'b1111111;
    assign LEDR[3:0] = data_out;
    assign LEDR[9:4] = 0;

endmodule
