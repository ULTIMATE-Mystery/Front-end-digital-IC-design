module regset (
    input  wire        clk,    // Clock input
    input  wire        rst_n,  // Active low asynchronous reset
    input  wire        wr_en,  // Write enable
    input  wire        rd_en,  // Read enable
    input  wire [9:0]  addr,   // Address bus (1KB space = 10 bits)
    input  wire [31:0] wdata,  // Write data bus
    output wire [31:0] rdata   // Read data bus
);

    // Address parameters - using localparam for synthesis optimization
    localparam DATA0_ADDR    = 10'h0;  // Data register 0
    localparam DATA0_SR_ADDR = 10'h4;  // Status register 0 (mirrors DATA0)

    // Register
    reg [31:0] data0;

    // Write decode and control
    wire data0_wr_en = wr_en && (addr == DATA0_ADDR);

    // Sequential write logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data0 <= 32'h0000_0000;    // Reset value for DATA0
        end else if (data0_wr_en) begin
            data0 <= wdata;
        end
    end

    // Combinational read logic
    reg [31:0] rd;
    always @(*) begin
        if (!rd_en) begin
            rd = 32'h0;
        end else begin
            case (addr)
                DATA0_ADDR,
                DATA0_SR_ADDR: rd = data0;
                default:       rd = 32'h0;
            endcase
        end
    end

    assign rdata = rd;

endmodule