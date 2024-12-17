module apbif
(
    input  wire  clk     ,
    input  wire  rst_n   ,
    input  wire  psel    ,
    input  wire  pwrite  ,
    input  wire  penable ,
    output wire  pready  ,
    output wire  wr_en   ,
    output wire  rd_en   
);


    assign wr_en = psel & penable & pwrite;
    assign rd_en = psel & penable & ~pwrite;
    assign pready = 1'b1;


endmodule
