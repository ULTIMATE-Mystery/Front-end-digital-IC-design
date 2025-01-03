var g_data = {"name":"../rtl/apbif.v","src":"module apbif\n(\n    input  wire  clk     ,\n    input  wire  rst_n   ,\n    input  wire  psel    ,\n    input  wire  pwrite  ,\n    input  wire  penable ,\n    output wire  pready  ,\n    output wire  wr_en   ,\n    output wire  rd_en   \n);\n\n\n\n    reg wen    ;\n    reg ren    ;\n\n    always @(posedge clk or negedge rst_n) begin\n        if( !rst_n ) begin\n            wen <= 1'b0;\n            ren <= 1'b0;\n        end else begin\n            wen <= psel & pwrite  & penable & ~wen;\n            ren <= psel & ~pwrite & penable & ~ren;\n        end\n    end\n\n    assign wr_en = wen;\n    assign rd_en = ren;\n    assign pready = wen | ren;\n\nendmodule\n","lang":"verilog"};
processSrcData(g_data);