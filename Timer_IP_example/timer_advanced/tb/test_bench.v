module test_bench;

    parameter   ADDR_TCR    =   12'h0;
    parameter   ADDR_TDR0   =   12'h4;
    parameter   ADDR_TDR1   =   12'h8;
    parameter   ADDR_TCMP0  =   12'hC;
    parameter   ADDR_TCMP1  =   12'h10;
    parameter   ADDR_TIER   =   12'h14;
    parameter   ADDR_TISR   =   12'h18;
    parameter   ADDR_THCSR  =   12'h1C;

    parameter   APB_CYCLE   =   1     ;

    parameter   BYTE0       =   4'b0001;
    parameter   BYTE1       =   4'b0010;
    parameter   BYTE2       =   4'b0100;
    parameter   BYTE3       =   4'b1000;
    parameter   HALF_WORD0  =   4'b0011;
    parameter   HALF_WORD1  =   4'b1100;
    
    reg  clk, rst_n;
    reg  psel, pwrite, penable,dbg_mode;
    reg  [11:0] paddr;
    reg  [31:0] pwdata;
    reg  [3:0 ] pstrb;
    wire [31:0] prdata;
    wire          pready;
    wire          tim_int;
    wire        pslverr;
    integer     err;

    reg cnt_chk_en;
    reg [31:0] cnt_chk_cycle;
    reg [3:0]  div_val;
    reg [63:0] exp_cnt;      

    reg golden_cnt_cfg_en   ;
    reg [63:0] golden_cnt_cfg;
    wire [63:0] golden_cnt;

    reg apb_err_psel;
    reg apb_err_penable;
    reg pslverr_chk_fail, pready_chk_fail;

    reg pslverr_exp;
    reg pslverr_high;

    
    //instance DUT
    timer_top u_timer 
    (
        .sys_clk    (   clk     ),
        .sys_rst_n  (   rst_n   ),
        .tim_psel   (   psel    ),
        .tim_pwrite (   pwrite  ),
        .tim_penable(   penable ),
        .tim_paddr   (  paddr    ),
        .tim_pwdata  (  pwdata   ),
        .tim_prdata  (  prdata   ),
        .tim_pready  (  pready   ),
        .tim_pstrb   (   pstrb    ),
        .tim_pslverr (  pslverr  ),
        .dbg_mode  ( dbg_mode ) ,
        .tim_int ( tim_int )

    );

    mod_golden_cnt u_tb_cnt
    (
        .cnt_cfg_en (   golden_cnt_cfg_en   ),
        .cnt_cfg    (   golden_cnt_cfg      ),
        .cnt        (   golden_cnt          ),
        .*
    );



    `include "run_test.v"
  	
    initial begin 
  	  clk = 0;
  	  forever #25 clk = ~clk;
  	end

  	initial begin
  	  rst_n = 1'b0;
  	  #25 rst_n = 1'b1;
  	end

    initial begin
        #100;
        run_test();
        #100;
        $finish;
    end


    initial begin
        paddr = 0;
        pwdata = 0;
        psel = 0;
        penable = 0;
        pwrite = 0;
        dbg_mode = 0;
        pstrb = 4'hf;
        err = 0;
        cnt_chk_cycle = 0;
        div_val = 0;
        golden_cnt_cfg_en = 0   ;
        golden_cnt_cfg      = 0  ;
        apb_err_psel = 0;
        apb_err_penable = 0;
        pslverr_chk_fail = 0;
        pready_chk_fail = 0;
        pslverr_exp = 0;
        
        #100;
    end

    //initial begin
    //    wait( rst_n == 1);
    //    wait( pslverr == 1 );
    //    pslverr_chk_fail = 1;
    //    $display("ERROR: PSLVERR is not 0");
    //    err = 1;
    //    
    //end
    //initial begin
    //    wait( rst_n == 1);
    //    wait( pready == 0 );
    //    pready_chk_fail = 1;
    //    $display("ERROR: PREADY is not 1");
    //    err = 1;
    //end

    task apb_wr;
        input   [31:0]  in_addr;
        input   [31:0]  in_data;

        begin
            pstrb = 4'b1111;
            pslverr_high = 0;
			$display("t=%10d [TB_WRITE]: addr=%x data=%x",$time,in_addr, in_data);
        
            @(posedge clk);
            #1;
            psel = 1 & !apb_err_psel;   //setup phase
            pwrite = 1;
            paddr = in_addr;
            pwdata = in_data; //cnt_en
            @(posedge clk);
            #1;
            penable = 1 & !apb_err_penable; //access phase
            if( apb_err_penable || apb_err_psel ) begin 
                //donothing
            end else begin
                #1;
                if( pready == 1) begin
			        $display("------------------------------------------------");
			        $display("t=%10d FAIL: pready asserts same time with penable", $time); 
			        $display("------------------------------------------------");
                    err=err+1;
                end
                wait( pready == 1); //wait accept
            end
            #1;
            if( pslverr ) begin
                if( pslverr_exp ) begin
                    pslverr_high = 1;
                end else begin
			        $display("------------------------------------------------");
			        $display("t=%10d FAIL: pslverr asserts unexpectedly", $time); 
			        $display("------------------------------------------------");
                    err=err+1;
                end

            end
            @(posedge clk);
            #1;
            pwrite = 0; //idle
            psel = 0;
            penable = 0;
            paddr = 0;
            pwdata = 0;
        end

    endtask
    
    task apb_rd;

        input   [31:0]  in_addr;
        output  [31:0]  out_rdata;
        
        begin
            pslverr_high = 0;
        
            @(posedge clk);
            #1;
            psel = 1 & !apb_err_psel;   //setup phase
            pwrite = 0;
            paddr = in_addr;
            @(posedge clk);
            #1;
            penable = 1 & !apb_err_penable; //access phase
            if( apb_err_penable || apb_err_psel ) begin 
                //donothing
            end else begin
                #1;
                if( pready == 1) begin
			        $display("------------------------------------------------");
			        $display("t=%10d FAIL: pready asserts same time with penable", $time); 
			        $display("------------------------------------------------");
                    err=err+1;
                end
                wait( pready == 1); //wait accept
            end
            #1;
            out_rdata = prdata; 
            if( pslverr && !pslverr_exp ) begin
                if( pslverr_exp ) begin
                    pslverr_high = 1;
                end else begin
			        $display("------------------------------------------------");
			        $display("t=%10d FAIL: pslverr asserts unexpectedly", $time); 
			        $display("------------------------------------------------");
                    err=err+1;

                end
            end

            @(posedge clk);
            
            pwrite = 0; //idle
            psel = 0;
            penable = 0;
            paddr = 0;
            pwdata = 0;
			
			$display("t=%10d [TB_READ]: addr=%x rdata=%x",$time,in_addr, out_rdata);
        end
    endtask
    
    task apb_wr_pstrb;
        input   [31:0]  in_addr;
        input   [31:0]  in_data;
        input   [3 :0]  in_pstrb;

        begin
            pstrb = in_pstrb;
            pslverr_high = 0;
			$display("t=%10d [TB_WRITE STRB]: addr=%x data=%x pstrb=%x ",$time,in_addr, in_data, in_pstrb);
        
            @(posedge clk);
            #1;
            psel = 1 & !apb_err_psel;   //setup phase
            pwrite = 1;
            paddr = in_addr;
            pwdata = in_data; //cnt_en
            @(posedge clk);
            #1;
            penable = 1 & !apb_err_penable; //access phase
            if( apb_err_penable || apb_err_psel ) begin 
                //donothing
            end else begin
                #1;
                if( pready == 1) begin
			        $display("------------------------------------------------");
			        $display("t=%10d FAIL: pready asserts same time with penable", $time); 
			        $display("------------------------------------------------");
                    err=err+1;
                end
                wait( pready == 1); //wait accept
            end
            #1;
            if( pslverr ) begin
                if( pslverr_exp ) begin
                    pslverr_high = 1;
                end else begin
			        $display("------------------------------------------------");
			        $display("t=%10d FAIL: pslverr asserts unexpectedly", $time); 
			        $display("------------------------------------------------");
                    err=err+1;
                end

            end
            @(posedge clk);
            #1;
            pwrite = 0; //idle
            psel = 0;
            penable = 0;
            paddr = 0;
            pwdata = 0;
            pstrb = 0;
        end

    endtask



    task cmp_data;
        input [31:0]  in_addr ;
        input [31:0]  in_data ;
        input [31:0]  exp_data;
        input [31:0]  mask;
  	    
		if( (in_data & mask) !== (exp_data & mask) ) begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: rdata at addr %x is not correct",$time, in_addr);
			$display("Exp: %x Actual:%x",exp_data & mask, in_data & mask);
			$display("------------------------------------------------");
            #100;
            err=err+1;
                    #100;
                    $finish;
		end else begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: rdata = %x at addr %x is correct",$time,in_data, in_addr);
			$display("------------------------------------------------");
		end
        
    endtask

    task reg_init_chk;
        reg [31:0]  task_rdata;
        begin
      	    
            apb_rd( ADDR_TCR, task_rdata);
            cmp_data( ADDR_TCR, task_rdata, 32'h0000_0100, 32'hffff_ffff);
            
            apb_rd( ADDR_TDR0, task_rdata);
            cmp_data( ADDR_TDR0, task_rdata, 32'h0000_0000, 32'hffff_ffff);
            
            apb_rd( ADDR_TDR1, task_rdata);
            cmp_data( ADDR_TDR1, task_rdata, 32'h0000_0000, 32'hffff_ffff);
            
            apb_rd( ADDR_TCMP0, task_rdata);
            cmp_data( ADDR_TCMP0, task_rdata, 32'hffff_ffff, 32'hffff_ffff);
            
            apb_rd( ADDR_TCMP1, task_rdata);
            cmp_data( ADDR_TCMP1, task_rdata, 32'hffff_ffff, 32'hffff_ffff);
            
            apb_rd( ADDR_TIER, task_rdata);
            cmp_data( ADDR_TIER, task_rdata, 32'h0000_0000, 32'hffff_ffff);
            
            apb_rd( ADDR_TISR, task_rdata);
            cmp_data( ADDR_TISR, task_rdata, 32'h0000_0000, 32'hffff_ffff);
    
            apb_rd( ADDR_THCSR, task_rdata);
            cmp_data( ADDR_THCSR, task_rdata, 32'h0000_0000, 32'hffff_ffff);
    
        end
    endtask

    task cnt_chk_no_halt;
        integer idx;
        begin
            for( idx =0; idx < cnt_chk_cycle; idx = idx+1) begin
                @(posedge clk); 
                #1;
                if( div_val == 0 || (div_val!=0 && (idx > 0) && (idx % (1 << div_val)) == 0)) 
                    exp_cnt = exp_cnt + 1;
            end
        end

    endtask

    task tsk_cfg_golden_cnt;
        input [63:0] val;

        begin
            @(posedge clk);
            #1;
            golden_cnt_cfg_en = 1;
            golden_cnt_cfg      = val;
            @(posedge clk);
            #1;
            golden_cnt_cfg_en = 0;
            golden_cnt_cfg      = 0;
            @(posedge clk);
        end

    endtask

    task tsk_set_pslverr_exp;
        input val;

        begin
            if( val )
                $display("Pslverr access is ON");
            else
                $display("Pslverr access is OFF");

            pslverr_exp = val;
        end

    endtask
    task tsk_set_dbg_mode;
        input val;

        begin
            if( val )
                $display("DBG MODE IS ON");
            else
                $display("DBG MODE IS OFF");

            dbg_mode = val;
        end

    endtask
    
    task tsk_rd_pslverr;
        output status;

        begin
            status = pslverr_high;
        end
    endtask


endmodule


module mod_golden_cnt (
    input wire clk       ,
    input wire rst_n     ,
    input wire psel      ,
    input wire penable   ,
    input wire pwrite    ,
    input wire [11:0] paddr,
    input wire [31:0] pwdata,
    input wire cnt_cfg_en   ,
    input wire [63:0] cnt_cfg,
    input wire      dbg_mode,
    output reg [63:0] cnt
);
    parameter   ADDR_TCR    =   12'h0;
    parameter   ADDR_THCSR  =   12'h1C;
    wire [63:0] cnt_next;
    wire tim_en_wr_set;
    wire tim_en_wr_clr;
    wire halt_wr_set;
    wire halt_wr_clr;
    reg  tim_en;
    reg  halt;
    reg  tim_en_1d;
    reg  halt_1d;
   
    assign tim_en_wr_set = psel & penable & pwrite & (paddr == ADDR_TCR ) & pwdata[0];
    assign tim_en_wr_clr = psel & penable & pwrite & (paddr == ADDR_TCR ) & ~pwdata[0];
    assign halt_wr_set   = psel & penable & pwrite & (paddr == ADDR_THCSR ) & pwdata[0] & dbg_mode;
    assign halt_wr_clr   = psel & penable & pwrite & (paddr == ADDR_THCSR ) & ~pwdata[0];

    assign cnt_next = cnt_cfg_en        ? cnt_cfg   : 
                      tim_en_1d & !halt_1d    ? cnt + 1'b1:
                      cnt        ;
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) 
            tim_en <= 1'b0;
        else if( tim_en_wr_clr )
            tim_en <= 1'b0;
        else if( tim_en_wr_set )
            tim_en <= 1'b1;
    end
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) 
            halt <= 1'b0;
        else if( halt_wr_clr )
            halt <= 1'b0;
        else if( halt_wr_set )
            halt <= 1'b1;
    end

    always @(posedge clk or negedge rst_n) begin
        if( !rst_n ) begin 
            cnt    <=  64'h0       ;
            tim_en_1d   <= 0      ;
            halt_1d     <= 0      ;    
        end else begin
            cnt    <=  cnt_next; 
            tim_en_1d   <= tim_en      ;
            halt_1d     <= halt         ;    
        end
    end

endmodule

