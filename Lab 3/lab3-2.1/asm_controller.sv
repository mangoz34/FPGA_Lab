module asm_controller(clk, reset, s, a_is_zero, a0, load, shift, clear, inc, done);
    input  logic clk;
    input  logic reset;
    input  logic s;
    input  logic a_is_zero;
    input  logic a0;
    output logic load;
    output logic shift;
    output logic clear;
    output logic inc;
    output logic done;

    typedef enum logic [1:0] {S1, S2, S3} state_t;
    state_t state, nstate;

    // state register
    always_ff @(posedge clk) begin
        if (!reset) state <= S1;
        else          state <= nstate;
    end

    // next-state logic
    always_comb begin
        nstate = state;
        unique case (state)
            S1:    nstate = (s) ? S2 : S1;
            S2:    nstate = (a_is_zero) ? S3 : S2;
            S3:    nstate = (s == 1'b0) ? S1 : S3;
            default: nstate = S1;
        endcase
    end

    always_comb begin
        load  = 1'b0;
        shift = 1'b0;
        clear = 1'b0;
        inc   = 1'b0;
        done  = 1'b0;

        case (state)
            S1: begin
                load = 1'b1;
                clear = 1'b1;
            end
            S2: begin
                shift = 1'b1;
                inc = a0;
            end
            S3: begin
                done = 1'b1;
            end
        endcase
    end
endmodule
