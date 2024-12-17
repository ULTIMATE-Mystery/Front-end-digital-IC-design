module timer_top 
(
    input  wire             sys_clk         ,
    input  wire             sys_rst_n       ,
    input  wire             tim_psel        ,
    input  wire             tim_pwrite      ,
    input  wire             tim_penable     ,
    input  wire [ 3:0]      tim_pstrb       ,
    output wire             tim_pready      ,
    output wire             tim_pslverr     ,
    input  wire [11:0]      tim_paddr       ,
    input  wire [31:0]      tim_pwdata      ,
    output wire [31:0]      tim_prdata      ,
    input  wire             dbg_mode        ,
    output wire             tim_int     
);
    wire        wr_en   ;
    wire        rd_en   ;
    wire        timer_en;
    wire        timer_en_neg;
    wire        div_en  ;
    wire        count_en;
    wire [ 3:0] div_val ;
    wire [63:0] cnt     ;
    wire        halt_req;

    apbif u_apbif(
        .clk        (   sys_clk     ),
        .rst_n      (   sys_rst_n   ),
        .psel       (   tim_psel    ),
        .pwrite     (   tim_pwrite  ),
        .penable    (   tim_penable ),
        .pready     (   tim_pready  ),
        .wr_en      (   wr_en       ),
        .rd_en      (   rd_en       )
    );

    regset u_regset (
            .clk        ( sys_clk       ),
            .rst_n      ( sys_rst_n     ),
            .wr_en      ( wr_en         ),
            .rd_en      ( rd_en         ),
            .addr       ( tim_paddr     ),
            .wdata      ( tim_pwdata    ),
            .rdata      ( tim_prdata    ),
            .pstrb      ( tim_pstrb     ),//(i)
            .pslverr    ( tim_pslverr   ),//(o)
            .cnt        ( cnt           ),//(i) 
            .dbg_mode   ( dbg_mode      ),//(i)
            .halt_req_out   ( halt_req  ),//(o)
            .div_en     ( div_en        ),//(o)
            .tdr0_wr_sel( tdr0_wr_sel   ),//(o)
            .tdr1_wr_sel( tdr1_wr_sel   ),//(o)
            .timer_en   ( timer_en      ),//(o)
            .timer_en_neg   ( timer_en_neg ),//(o)
            .div_val    ( div_val       ),//(o)
            .tim_int    ( tim_int       ) //(o)
        );

    counter u_cnt (
	    .clk        ( sys_clk       ), 
	    .reset_n    ( sys_rst_n     ), 
	    .count_en   ( count_en      ),//(i) 
        .tdr0_wr_sel( tdr0_wr_sel   ),//(i)
        .tdr1_wr_sel( tdr1_wr_sel   ),//(i)
        .pstrb      ( tim_pstrb         ),//(i)
        .wdata      ( tim_pwdata    ),//(i) 
        .timer_en_neg   ( timer_en_neg), //(i)
	    .count      ( cnt           )
    );

    cnt_ctrl u_cnt_ctrl(
        .clk        (   sys_clk     ),
        .rst_n      (   sys_rst_n   ),
        .timer_en   (   timer_en    ), //(i)
        .halt_req   (   halt_req    ),//(i)
        .div_en     (   div_en      ),
        .div_val    (   div_val     ),
        .count_en   (   count_en    )  //(o)
    );



endmodule
