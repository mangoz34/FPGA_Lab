`timescale 1ns/1ps
module BinarySearch_ctrl(
    input  logic clk, reset,
    input  logic start,
    input  logic eq, gt, l_gt_r,
    output logic ld_init, ld_mid, upd_left, upd_right,
    output logic latch_loc, set_found
);
    typedef enum logic [2:0] { S_IDLE, S_INIT, S_SETMID, S_READ, S_READ2, S_CMP, S_DONE } st_t;
    st_t st, nst;

    always_comb begin
        ld_init=0; ld_mid=0; upd_left=0; upd_right=0;
        latch_loc=0; set_found=0;
        nst = st;

        unique case(st)
            S_IDLE:   if(start) nst = S_INIT;
            S_INIT:   begin ld_init = 1; nst = S_SETMID; end
            S_SETMID: begin ld_mid  = 1; nst = S_READ;   end
            S_READ:   nst = S_READ2;
				S_READ2:  nst = S_CMP;
            S_CMP: begin
                if(eq) begin latch_loc=1; set_found=1; nst = S_DONE; end
                else if(l_gt_r) nst = S_DONE;
                else if(gt) begin upd_right=1; nst = S_SETMID; end
                else begin upd_left =1; nst = S_SETMID; end
            end
            S_DONE: if(!start) nst = S_IDLE;
            default: nst = S_IDLE;
        endcase
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) st <= S_IDLE; else st <= nst;
    end
endmodule



