module register(clk, reset, load, shift, clear, inc, sw, a_is_zero, a0, result);
    input logic clk;
    input logic reset;
    input logic load;
    input logic shift;
    input logic clear;
    input logic inc;
    input logic [7:0] sw;
    output logic a_is_zero;
    output logic a0;
    output logic [3:0] result;
    logic [7:0] A;
	 
	 assign a0 = A[0];
    assign a_is_zero = (A == 8'd0);

    always_ff @(posedge clk) begin
        if (!reset) begin
            A <= 8'b00000000;
            result <= 4'b0000;
        end else begin
				if(clear) result <= 4'b000;
            if(load) A <= sw;

            if(inc) result <= result + 4'd1;
            if(shift) A <= {1'b0, A[7:1]};
        end
    end
endmodule

