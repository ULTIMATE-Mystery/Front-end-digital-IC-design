var g_data = {"name":"../rtl/apbif.v","src":"module apbif\n(\n    input  wire  clk     ,\n    input  wire  rst_n   ,\n    input  wire  psel    ,\n    input  wire  pwrite  ,\n    input  wire  penable ,\n    output wire  pready  ,\n    output wire  wr_en   ,\n    output wire  rd_en   \n);\n\n\n    assign wr_en = psel & penable & pwrite;\n    assign rd_en = psel & penable & ~pwrite;\n    assign pready = 1'b1;\n\n\nendmodule\n","lang":"verilog"};
processSrcData(g_data);