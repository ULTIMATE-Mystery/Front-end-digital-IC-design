module counter (
	input 	wire 		clk		        , 
	input 	wire 		reset_n	        , 
    input   wire        tdr0_wr_sel     , //from regset
    input   wire        tdr1_wr_sel     , //from regset
    input   wire [31:0] wdata           , //from regset
	input 	wire		count_en        , //from divisor   
	output 	wire [63:0]	count	 
);

  	reg		[31:0] tdr0		;   //reg
    reg     [31:0] tdr1     ;   //reg 
    wire	[31:0] tdr0_pre	;
    wire	[31:0] tdr1_pre	;
    wire    [63:0] cnt_plus1;

    assign  cnt_plus1[63:0]   = count + 1'b1;


    assign 	tdr0_pre[31:0]	=	tdr0_wr_sel ?	wdata[31:0]    : 
                                count_en    ?   cnt_plus1[31:0]: 
                                tdr0        ;  
    
    assign 	tdr1_pre[31:0]	=	tdr1_wr_sel ?	wdata[31:0]     :
                                count_en    ?   cnt_plus1[63:32]: 
                                tdr1        ; 
                                    

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
endmodule
