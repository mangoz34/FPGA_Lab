`timescale 1ns/1ps
module BinarySearch_datapath (
    input  logic clk, reset,
    input  logic [7:0] A,
    input  logic ld_init, ld_mid, upd_left, upd_right, latch_loc, set_found,
    input  logic [7:0] mem_q,
    output logic [4:0] mem_addr,
    output logic eq, gt, l_gt_r,
    output logic [4:0] loc,
    output logic found
);
    logic [4:0] left, right, mid;
	 logic [5:0] sum;

    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            left <= '0; right <= 5'd31;
        end else begin
            if (ld_init) begin
                left <= 5'd0; 
					 right <= 5'd31;
            end else begin
                if(upd_left) left <= mid + 1;
                if(upd_right) begin
						if(mid == 0) begin
							left <= 5'd1;
							right <= 5'd0;
						end else begin
							right <= mid - 1;
                  end
                end
            end
			end
	 end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            mid <= '0;
				mem_addr <= '0;
        end else if (ld_mid) begin
            sum = {1'b0,left} + {1'b0,right};
            mid      <= sum[5:1];
            mem_addr <= sum[5:1];
        end
    end

    always_comb begin
        eq = (mem_q == A);
        gt = (mem_q > A);
        l_gt_r = (left > right);
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            loc <= '0; found <= 1'b0;
        end else begin
            if (latch_loc) loc <= mid;
            if (set_found) found <= 1'b1;
        end
    end
endmodule


