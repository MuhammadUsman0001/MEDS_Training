module fifo_controller #(
    parameter int ADDR_WIDTH = 3,   // depth = 2^ADDR_WIDTH (default depth 8)
    parameter int DATA_WIDTH = 8
) (
    input  logic                  clk,
    input  logic                  rst_n,      // asynchronous active-low reset

    // Write port
    input  logic                  wr_en,
    input  logic [DATA_WIDTH-1:0] wr_data,
    output logic                  wr_ready,

    // Read port
    input  logic                  rd_en,
    output logic [DATA_WIDTH-1:0] rd_data,
    output logic                  rd_valid,

    // Status
    output logic                  full,
    output logic                  empty,
    output logic [ADDR_WIDTH:0]   count,

    // Task 18 extension: early-warning flags
    output logic                  almost_full,   // asserts when 1 write away from full
    output logic                  almost_empty   // asserts when 1 read away from empty
);

    localparam int DEPTH = 1 << ADDR_WIDTH;

    // Storage + pointers
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    logic [ADDR_WIDTH:0] wr_ptr, rd_ptr;  // extra MSB = wrap/parity bit

    // Combinational status logic (Section 6 style)
    assign empty = (wr_ptr == rd_ptr);
    assign full  = (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]) &&
                   (wr_ptr[ADDR_WIDTH]     != rd_ptr[ADDR_WIDTH]);

    assign count = wr_ptr - rd_ptr;   // ADDR_WIDTH+1-bit modular subtraction
                                      // -> correct 0..DEPTH count as long as
                                      //    writes are always blocked while full

    assign wr_ready = ~full;
    assign rd_valid = ~empty;

    assign almost_full  = (count == DEPTH - 1);
    assign almost_empty = (count == 1);

    // Show-ahead read: head of queue is always visible combinationally
    assign rd_data = mem[rd_ptr[ADDR_WIDTH-1:0]];

    // Sequential pointer + memory update
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= '0;
            rd_ptr <= '0;
        end else begin
            // Write: blocked automatically by wr_ready when full, so a
            // write attempted on a full FIFO never touches mem[] or wr_ptr.
            if (wr_en && wr_ready) begin
                mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data;
                wr_ptr <= wr_ptr + 1'b1;
            end

            // Read: blocked automatically by rd_valid when empty, so a read
            // attempted on an empty FIFO never advances rd_ptr (and never
            // touches mem[], since this is a pointer-only pop).
            if (rd_en && rd_valid) begin
                rd_ptr <= rd_ptr + 1'b1;
            end
        end
    end

endmodule
