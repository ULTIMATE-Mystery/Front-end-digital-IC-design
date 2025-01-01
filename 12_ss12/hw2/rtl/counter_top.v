module counter_top (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        wr_en,
    input  wire        rd_en,
    input  wire [9:0]  addr,
    input  wire [31:0] wdata,
    output wire [31:0] rdata,
    output wire        overflow
);

    wire        count_start;
    wire        count_clr;
    wire [7:0]  Cnt;

    regset u_regset (
        .clk          (clk),
        .rst_n        (rst_n),
        .wr_en        (wr_en),
        .rd_en        (rd_en),
        .addr         (addr),
        .wdata        (wdata),
        .rdata        (rdata),
        .count_start  (count_start),
        .count_clr    (count_clr),
        .Cnt          (Cnt)
    );

    counter u_counter (
        .clk          (clk),
        .rst_n        (rst_n),
        .count_en     (count_start),
        .count_clr    (count_clr),
        .count        (Cnt),
        .overflow     (overflow)
    );

endmodule