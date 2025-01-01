module regset (
    input wire        clk,
    input wire        rst_n,
    input wire        wr_en,
    input wire        rd_en,
    input wire [9:0]  addr,
    input wire [31:0] wdata,
    output reg [31:0] rdata,
    output wire       count_start,
    output wire       count_clr,
    input wire [7:0]  Cnt
);

    // Register addresses
    parameter CTRL_ADDR   = 10'h0;   // Control register
    parameter STATUS_ADDR = 10'h4;   // Status register

    // Control register
    reg [1:0] ctrl_reg;

    // Write to control register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ctrl_reg <= 0;
        end else if (wr_en && addr == CTRL_ADDR) begin
            ctrl_reg <= wdata[1:0];
        end
    end

    // Read logic
    always @(*) begin
        if (rd_en) begin
            case (addr)
                CTRL_ADDR:   rdata = {30'b0, ctrl_reg};   // Control register
                STATUS_ADDR: rdata = {24'b0, Cnt};        // Status register with counter value
                default:     rdata = 32'h0;
            endcase
        end else begin
            rdata = 32'h0;
        end
    end

    assign count_start = ctrl_reg[0];
    assign count_clr   = ctrl_reg[1];

endmodule