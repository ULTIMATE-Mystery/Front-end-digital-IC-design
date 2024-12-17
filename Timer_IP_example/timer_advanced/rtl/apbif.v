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



    reg wen    ;
    reg ren    ;

    always @(posedge clk or negedge rst_n) begin
        if( !rst_n ) begin
            wen <= 1'b0;
            ren <= 1'b0;
        end else begin
            wen <= psel & pwrite  & penable & ~wen;
            ren <= psel & ~pwrite & penable & ~ren;
        end
    end

    assign wr_en = wen;
    assign rd_en = ren;
    assign pready = wen | ren;

endmodule
