// Write policy : write-allocate. On any write, the addressed line's data,
//                tag, and valid bit are updated unconditionally (a write
//                always "installs" that address into its mapped line).
// Read policy  : combinational hit detection; data is registered out on
//                a hit. On a miss, rdata is not meaningful and hit is low.

module cache_controller #(
    parameter int ADDR_WIDTH  = 16,   // address bus width
    parameter int DATA_WIDTH  = 32,   // word width
    parameter int INDEX_WIDTH = 4     // log2(number of lines); 4 -> 16 lines
) (
    input  logic                    clk,
    input  logic                    rst_n,      // active-low async reset

    // CPU request interface
    input  logic                    req_valid,  // 1 = CPU is issuing a request this cycle
    input  logic                    req_we,     // 1 = write, 0 = read
    input  logic [ADDR_WIDTH-1:0]   addr,
    input  logic [DATA_WIDTH-1:0]   wdata,

    // CPU response interface
    output logic [DATA_WIDTH-1:0]   rdata,       // valid on a read hit, one cycle after req_valid
    output logic                    hit,         // combinational: 1 = current addr is a hit
    output logic                    ready        // registered: 1 = response for the previous request is valid this cycle
);

    // Derived (localparam) sizing :
    // One line holds exactly one DATA_WIDTH-bit word, so:
    // OFFSET_WIDTH = log2(bytes per word) = log2(DATA_WIDTH/8)
    // TAG_WIDTH    = ADDR_WIDTH - INDEX_WIDTH - OFFSET_WIDTH

    localparam int OFFSET_WIDTH = $clog2(DATA_WIDTH/8);
    localparam int TAG_WIDTH    = ADDR_WIDTH - INDEX_WIDTH - OFFSET_WIDTH;
    localparam int NUM_LINES    = 1 << INDEX_WIDTH;

    // Sanity check on parameters at elaboration time
    initial begin
        if (TAG_WIDTH <= 0) begin
            $error("cache_controller: ADDR_WIDTH too small for the given INDEX_WIDTH/DATA_WIDTH (TAG_WIDTH=%0d)", TAG_WIDTH);
        end
    end

    // Storage arrays
    logic [DATA_WIDTH-1:0] data_array  [0:NUM_LINES-1];
    logic [TAG_WIDTH-1:0]  tag_array   [0:NUM_LINES-1];
    logic                  valid_array [0:NUM_LINES-1];

    // Address decoding
    logic [TAG_WIDTH-1:0]    addr_tag;
    logic [INDEX_WIDTH-1:0]  addr_index;
    logic [OFFSET_WIDTH-1:0] addr_offset;

    assign addr_tag    = addr[ADDR_WIDTH-1 -: TAG_WIDTH];
    assign addr_index  = addr[OFFSET_WIDTH +: INDEX_WIDTH];
    assign addr_offset = addr[OFFSET_WIDTH-1:0];

    // Hit detection (combinational)
    assign hit = req_valid && valid_array[addr_index] &&
                 (tag_array[addr_index] == addr_tag);

    // Sequential read/write behavior
    integer i;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < NUM_LINES; i++) begin
                valid_array[i] <= 1'b0;
                tag_array[i]   <= '0;
                data_array[i]  <= '0;
            end
            rdata <= '0;
            ready <= 1'b0;
        end 
        else begin
            ready <= 1'b0; // default; asserted below when a request completes

            if (req_valid) begin
                if (req_we) begin
                    // Write-allocate: always install this address into its line
                    data_array[addr_index]  <= wdata;
                    tag_array[addr_index]   <= addr_tag;
                    valid_array[addr_index] <= 1'b1;
                    ready <= 1'b1;
                end 
                else begin
                    // Read
                    if (hit) begin
                        rdata <= data_array[addr_index];
                    end
                    // On a miss, rdata is left unchanged / don't-care;
                    // 'hit' is the signal the testbench should check.
                    ready <= 1'b1;
                end
            end
        end
    end

endmodule
