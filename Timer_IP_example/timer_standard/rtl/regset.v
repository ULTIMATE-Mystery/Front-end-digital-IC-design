module regset 
(
    input  wire         clk         ,
    input  wire         rst_n       ,
    input  wire         wr_en       ,
    input  wire         rd_en       ,
    input  wire [3:0]   pstrb       ,
    input  wire [11:0]  addr        ,
    input  wire [31:0]  wdata       ,
    input  wire [63:0]  cnt         , //from cnt
    output wire         pslverr     ,
    output wire         tdr0_wr_sel , //to cnt
    output wire         tdr1_wr_sel , //to cnt
    output reg          div_en      ,
    output reg  [3:0]   div_val     ,
    output reg          timer_en    ,
    output wire         tim_int     ,
    output wire [31:0]  rdata   
);
    parameter   ADDR_TCR    =   12'h0;
    parameter   ADDR_TDR0   =   12'h4;
    parameter   ADDR_TDR1   =   12'h8;
    parameter   ADDR_TCMP0  =   12'hC;
    parameter   ADDR_TCMP1  =   12'h10;
    parameter   ADDR_TIER   =   12'h14;
    parameter   ADDR_TISR   =   12'h18;
    parameter   ADDR_THCSR  =   12'h1C;



    reg [31:0]  rd;
    reg [31:0]  tcmp0    ;   //reg
    reg [31:0]  tcmp1    ;   //reg
    reg         hw_int_en;   //reg
    reg         sw_int_en;   //reg
    reg         hw_int   ;   //reg
    reg         halt_req ;   //reg

    wire        cr_wr_sel;
    wire        tcmp0_wr_sel;
    wire        tcmp1_wr_sel;
    wire        tier_wr_sel;
    wire        tisr_wr_sel;
    wire        thcsr_wr_sel ;

    wire        div_val_wr_en;
    wire        div_val_wr_sel;
    wire [3:0]  div_val_pre;
    wire        div_en_pre;
    wire        timer_en_pre;
    wire [31:0] tcmp0_pre    ;  
    wire [31:0] tcmp1_pre    ;  
    wire        hw_int_en_pre;  
    wire        hw_int_pre   ;  
    wire        int_sig      ;
    wire        halt_req_pre ;

    //CR sel
    assign cr_wr_sel        =   wr_en & (addr == ADDR_TCR);
    
    
    assign  div_val_wr_en   = (wdata[11:8] <= 4'h8);
    assign  div_val_wr_sel  = div_val_wr_en & cr_wr_sel;

    assign  div_val_pre     = div_val_wr_sel ? wdata[11:8] : div_val;
    assign  div_en_pre      = cr_wr_sel      ? wdata[1]    : div_en ;
    assign  timer_en_pre    = cr_wr_sel      ? wdata[0]    : timer_en;

    //CR : 0x00
    always @(posedge clk or negedge rst_n) begin
        if( !rst_n ) begin 
            div_val     <=  4'b0001;
            div_en      <=  1'b0;
            timer_en    <=  1'b0;
        end else begin
            div_val     <= div_val_pre  ;
            div_en      <= div_en_pre   ;
            timer_en    <= timer_en_pre ;
        end
    end

    assign  tdr0_wr_sel = wr_en & (addr == ADDR_TDR0); 

    assign  tdr1_wr_sel = wr_en & (addr == ADDR_TDR1); 


    assign  tcmp0_wr_sel = wr_en & (addr == ADDR_TCMP0); 
    assign  tcmp0_pre    = tcmp0_wr_sel ? wdata : tcmp0;
    //TCMP0 : 0x0C
    always @(posedge clk or negedge rst_n) begin
        if( !rst_n ) begin 
            tcmp0    <=  32'hFFFF_FFFF       ;
        end else begin
            tcmp0    <=  tcmp0_pre    ;
        end
    end
    
    assign  tcmp1_wr_sel = wr_en & (addr == ADDR_TCMP1); 
    assign  tcmp1_pre    = tcmp1_wr_sel ? wdata : tcmp1;
    //TCMP1 : 0x10
    always @(posedge clk or negedge rst_n) begin
        if( !rst_n ) begin 
            tcmp1    <=  32'hFFFF_FFFF       ;
        end else begin
            tcmp1    <=  tcmp1_pre    ;
        end
    end


    assign  tier_wr_sel = wr_en & (addr == ADDR_TIER); 
    assign  hw_int_en_pre  = tier_wr_sel ? wdata[0] : hw_int_en;
    //TIER : 0x14
    always @(posedge clk or negedge rst_n) begin
        if( !rst_n ) begin 
            hw_int_en   <= 1'b0;
        end else begin
            hw_int_en   <= hw_int_en_pre;
        end
    end

    //interrupt
    assign  int_sig     = cnt == {tcmp1, tcmp0}; 
    
    assign  tisr_wr_sel = wr_en & (addr == ADDR_TISR); 
    assign  hw_int_clr  = tisr_wr_sel & (wdata[0] == 1'b1) & (hw_int == 1'b1); 
    assign  hw_int_set  = int_sig;
    assign  hw_int_pre  = hw_int_clr ? 1'b0 : 
                          hw_int_set ? 1'b1 : 
                          hw_int     ;
    //TISR  : 0x18
    always @(posedge clk or negedge rst_n) begin
        if( !rst_n ) begin 
            hw_int   <= 1'b0;
        end else begin
            hw_int   <= hw_int_pre;
        end
    end

    assign tim_int      = hw_int & hw_int_en;
    
    assign  thcsr_wr_sel = wr_en & (addr == ADDR_THCSR); 
    assign  halt_req_pre = thcsr_wr_sel ? wdata[0] : halt_req;
    //TCMP1 : 0x1C
    always @(posedge clk or negedge rst_n) begin
        if( !rst_n ) begin 
            halt_req    <=  1'b0        ;
        end else begin
            halt_req    <=  halt_req_pre;
        end
    end

    //read logic
    always @* begin
        if( rd_en == 1'b1 ) begin
            case (addr) 
                ADDR_TCR    :   rd = { 20'h0, div_val[3:0], 6'h0, div_en, timer_en }  ;
                ADDR_TDR0   :   rd = cnt[31:0]              ;
                ADDR_TDR1   :   rd = cnt[63:32]             ;
                ADDR_TCMP0  :   rd = tcmp0                  ;
                ADDR_TCMP1  :   rd = tcmp1                  ;
                ADDR_TIER   :   rd = { 31'h0, hw_int_en }   ;
                ADDR_TISR   :   rd = { 31'h0, hw_int    }   ;
                ADDR_THCSR  :   rd = { 31'h0, halt_req  }   ;
                default     :   rd = 32'h0                  ;
            endcase
        end else begin
            rd = 32'h0; 
        end
    end

    assign rdata   = rd     ;
    assign pslverr = 1'b0   ;

endmodule
