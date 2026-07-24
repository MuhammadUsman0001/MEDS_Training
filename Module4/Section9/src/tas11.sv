module reset_synchronizer (
    input  logic clk,
    input  logic rst_n_async,   // asynchronous active‑low reset
    output logic rst_n_sync     // synchronised active‑low reset
);

    logic ff1_q, ff2_q;

    // Two flip‑flops with asynchronous reset
    always_ff @(posedge clk or negedge rst_n_async) begin
        if (!rst_n_async) begin
            ff1_q <= 1'b0;
            ff2_q <= 1'b0;
        end else begin
            ff1_q <= 1'b1;
            ff2_q <= ff1_q;
        end
    end

    assign rst_n_sync = ff2_q;

endmodule