module sync1bit(clk, d_async, qsync);
    input logic clk;
    input logic d_async;
    output logic qsync;
    logic s1;
    
	always_ff @(posedge clk) begin
        s1 <= d_async;
        qsync <= s1;
    end
endmodule
