module counter (
	input 	wire 		clk		        , 
	input 	wire 		reset_n	        , 
    input   wire        tdr0_wr_sel     , //from regset
    input   wire        tdr1_wr_sel     , //from regset
    input   wire [3:0]  pstrb           ,
    input   wire [31:0] wdata           , //from regset
	input 	wire		count_en        , //from divisor   
    input   wire        timer_en_neg    , //from regset
	output 	wire [63:0]	count	 
);

  	reg		[31:0] tdr0		;   //reg
    reg     [31:0] tdr1     ;   //reg 
    wire	[31:0] tdr0_pre	;
    wire	[31:0] tdr1_pre	;
    wire    [63:0] cnt_plus1;



    assign 	tdr0_pre[ 7: 0]	=	tdr0_wr_sel & pstrb[0]  ?	wdata[7:0]      ://write from apb 
                                timer_en_neg            ?   8'h0            ://timer_en negation
                                count_en                ?   cnt_plus1[7:0]  ://counter control
                                tdr0[7:0]               ;  
    assign 	tdr0_pre[15: 8]	=	tdr0_wr_sel & pstrb[1]  ?	wdata[15:8]     : 
                                timer_en_neg            ?   8'h0            :
                                count_en                ?   cnt_plus1[15:8] : 
                                tdr0[15:8]              ;  
    assign 	tdr0_pre[23:16]	=	tdr0_wr_sel & pstrb[2]  ?	wdata[23:16]    : 
                                timer_en_neg            ?   8'h0            :
                                count_en                ?   cnt_plus1[23:16]: 
                                tdr0[23:16]             ;  
    assign 	tdr0_pre[31:24]	=	tdr0_wr_sel & pstrb[3]  ?	wdata[31:24]    : 
                                timer_en_neg            ?   8'h0            :
                                count_en                ?   cnt_plus1[31:24]: 
                                tdr0[31:24]             ;  
    
    assign 	tdr1_pre[ 7: 0]	=	tdr1_wr_sel & pstrb[0]  ?	wdata[7:0]      : 
                                timer_en_neg            ?   8'h0            :
                                count_en                ?   cnt_plus1[39:32]: 
                                tdr1[7:0]               ;  
    assign 	tdr1_pre[15: 8]	=	tdr1_wr_sel & pstrb[1]  ?	wdata[15:8]     : 
                                timer_en_neg            ?   8'h0            :
                                count_en                ?   cnt_plus1[47:40]: 
                                tdr1[15:8]              ;  
    assign 	tdr1_pre[23:16]	=	tdr1_wr_sel & pstrb[2]  ?	wdata[23:16]    : 
                                timer_en_neg            ?   8'h0            :
                                count_en                ?   cnt_plus1[55:48]: 
                                tdr1[23:16]             ;  
    assign 	tdr1_pre[31:24]	=	tdr1_wr_sel & pstrb[3]  ?	wdata[31:24]    : 
                                timer_en_neg            ?   8'h0            :
                                count_en                ?   cnt_plus1[63:56]: 
                                tdr1[31:24]             ;  
    

  	always @(posedge clk or negedge reset_n) begin
  	  	if(!reset_n) begin
            tdr0    <= 32'h0;
            tdr1    <= 32'h0;
  	 	end else begin
            tdr0    <= tdr0_pre;
            tdr1    <= tdr1_pre;
        end
	end

	assign count[63:0]	=  {tdr1[31:0], tdr0[31:0]}	;
    assign  cnt_plus1[63:0]   = count + 1'b1;
endmodule
