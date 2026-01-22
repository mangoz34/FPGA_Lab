module button_input (
    input  logic clk, reset, key_raw,
    output logic press_button
);

    logic dff1, dff2;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            dff1 <= 1'b1;
            dff2 <= 1'b1;
        end else begin
            dff1 <= key_raw;
            dff2 <= dff1;
        end
    end

    assign press_button = (dff2 && !dff1); // detect falling edge
endmodule
