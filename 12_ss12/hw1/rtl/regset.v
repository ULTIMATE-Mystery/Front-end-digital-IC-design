module regset (
    input  wire        clk,    // Clock input
    input  wire        rst_n,  // Active low asynchronous reset
    input  wire        wr_en,  // Write enable
    input  wire        rd_en,  // Read enable
    input  wire [9:0]  addr,   // Address bus
    input  wire [31:0] wdata,  // Write data bus
    output wire [31:0] rdata   // Read data bus
);

    // Address parameters - using localparam for synthesis optimization
    parameter DATA0_ADDR     = 10'h0;  // Data register 0
    parameter DATA0_SR_ADDR  = 10'h4;  // Status register 0 (mirrors DATA0)
    parameter DATA1_ADDR     = 10'h8;  // Data register 1
    parameter DATA1_SR_ADDR  = 10'hC;  // Status register 1 (mirrors DATA1)

    // Registers with their reset values
    reg [31:0] data0, data1;

    // Write decode logic
    wire data0_wr_en = wr_en && (addr == DATA0_ADDR);
    wire data1_wr_en = wr_en && (addr == DATA1_ADDR);

    // Sequential write logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data0 <= 32'h0000_0000;    // Reset value for DATA0
            data1 <= 32'hFFFF_FFFF;    // Reset value for DATA1
        end else begin
            if (data0_wr_en) data0 <= wdata;
            if (data1_wr_en) data1 <= wdata;
        end
    end

    // Combinational read logic - single always block
    reg [31:0] rd;
    always @(*) begin
        if (!rd_en) begin
            rd = 32'h0;
        end else begin
            case (addr)
                DATA0_ADDR,
                DATA0_SR_ADDR: rd = data0;
                DATA1_ADDR,
                DATA1_SR_ADDR: rd = data1;
                default:       rd = 32'h0;
            endcase
        end
    end

    assign rdata = rd;

endmodule