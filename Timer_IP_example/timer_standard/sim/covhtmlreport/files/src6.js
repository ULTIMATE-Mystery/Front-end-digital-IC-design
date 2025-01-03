var g_data = {"name":"../rtl/counter.v","src":"module counter (\n	input 	wire 		clk		        , \n	input 	wire 		reset_n	        , \n    input   wire        tdr0_wr_sel     , //from regset\n    input   wire        tdr1_wr_sel     , //from regset\n    input   wire [31:0] wdata           , //from regset\n	input 	wire		count_en        , //from divisor   \n	output 	wire [63:0]	count	 \n);\n\n  	reg		[31:0] tdr0		;   //reg\n    reg     [31:0] tdr1     ;   //reg \n    wire	[31:0] tdr0_pre	;\n    wire	[31:0] tdr1_pre	;\n    wire    [63:0] cnt_plus1;\n\n    assign  cnt_plus1[63:0]   = count + 1'b1;\n\n\n    assign 	tdr0_pre[31:0]	=	tdr0_wr_sel ?	wdata[31:0]    : \n                                count_en    ?   cnt_plus1[31:0]: \n                                tdr0        ;  \n    \n    assign 	tdr1_pre[31:0]	=	tdr1_wr_sel ?	wdata[31:0]     :\n                                count_en    ?   cnt_plus1[63:32]: \n                                tdr1        ; \n                                    \n\n  	always @(posedge clk or negedge reset_n) begin\n  	  	if(!reset_n) begin\n            tdr0    <= 32'h0;\n            tdr1    <= 32'h0;\n  	 	end else begin\n            tdr0    <= tdr0_pre;\n            tdr1    <= tdr1_pre;\n        end\n	end\n\n	assign count[63:0]	=  {tdr1[31:0], tdr0[31:0]}	;\nendmodule\n","lang":"verilog"};
processSrcData(g_data);