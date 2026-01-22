module counter (
    output logic [4:0] q,
    input  logic reset, clk
);
    always_ff @(posedge clk) begin
        if (reset)
            q <= 5'b00000;
        else
            q <= q + 1'b1;
    end
endmodule
