task run_test();
    reg [31:0]  task_rdata;
    begin
  	    
        $display("====================================");	
  	    $display("=== Test Case: check byte access ===");
  	    $display("====================================");	
        
        $display("*TCR*");
        test_bench.apb_wr_pstrb( ADDR_TCR, 32'hFFFF_F5FF, BYTE1);
        test_bench.apb_rd( ADDR_TCR, task_rdata);
        test_bench.cmp_data( ADDR_TCR, task_rdata, 32'h500, 32'hffff_ff00);
        
        //test_bench.apb_wr_pstrb( ADDR_TCR, 32'h0, BYTE1);
        test_bench.apb_wr_pstrb( ADDR_TCR, 32'hFFFF_FFFF, BYTE0);
        test_bench.apb_rd( ADDR_TCR, task_rdata);
        test_bench.cmp_data( ADDR_TCR, task_rdata, 32'h503, 32'hffff_ffff);


        test_bench.apb_wr_pstrb( ADDR_TCR, 32'hFFFF_FF00, BYTE2);
        test_bench.apb_rd( ADDR_TCR, task_rdata);
        test_bench.cmp_data( ADDR_TCR, task_rdata, 32'h503, 32'hffff_ffff);

        test_bench.apb_wr_pstrb( ADDR_TCR, 32'hFFFF_FF00, BYTE3);
        test_bench.apb_rd( ADDR_TCR, task_rdata);
        test_bench.cmp_data( ADDR_TCR, task_rdata, 32'h503, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TCR, 32'h2, BYTE0); //clear timer_en
        test_bench.apb_wr_pstrb( ADDR_TCR, 32'h0, BYTE0); //clear all 

        test_bench.apb_wr_pstrb( ADDR_TCR, 32'h5555_5555, HALF_WORD0);
        test_bench.apb_rd( ADDR_TCR, task_rdata);
        test_bench.cmp_data( ADDR_TCR, task_rdata, 32'h501, 32'hffff_ffff);

        test_bench.apb_wr_pstrb( ADDR_TCR, 32'hFFFF_FFFF, HALF_WORD1);
        test_bench.apb_rd( ADDR_TCR, task_rdata);
        test_bench.cmp_data( ADDR_TCR, task_rdata, 32'h501, 32'hffff_ffff);
        //clear
        test_bench.apb_wr_pstrb( ADDR_TCR, 32'h0, BYTE0);
        test_bench.apb_wr_pstrb( ADDR_TCR, 32'h0, BYTE1);
        
        $display("*TDR0*");
        test_bench.apb_wr_pstrb( ADDR_TDR0, 32'h1111_1111, BYTE0);
        test_bench.apb_rd( ADDR_TDR0, task_rdata);
        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h0000_0011, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TDR0, 32'h2222_2222, BYTE1);
        test_bench.apb_rd( ADDR_TDR0, task_rdata);
        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h0000_2211, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TDR0, 32'h3333_3333, BYTE2);
        test_bench.apb_rd( ADDR_TDR0, task_rdata);
        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h0033_2211, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TDR0, 32'h4444_4444, BYTE3);
        test_bench.apb_rd( ADDR_TDR0, task_rdata);
        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h4433_2211, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TDR0, 32'h5555_5555, HALF_WORD0);
        test_bench.apb_rd( ADDR_TDR0, task_rdata);
        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h4433_5555, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TDR0, 32'h6666_6666, HALF_WORD1);
        test_bench.apb_rd( ADDR_TDR0, task_rdata);
        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h6666_5555, 32'hffff_ffff);

        $display("*TDR1*");
        test_bench.apb_wr_pstrb( ADDR_TDR1, 32'h1111_1111, BYTE0);
        test_bench.apb_rd( ADDR_TDR1, task_rdata);
        test_bench.cmp_data( ADDR_TDR1, task_rdata, 32'h0000_0011, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TDR1, 32'h2222_2222, BYTE1);
        test_bench.apb_rd( ADDR_TDR1, task_rdata);
        test_bench.cmp_data( ADDR_TDR1, task_rdata, 32'h0000_2211, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TDR1, 32'h3333_3333, BYTE2);
        test_bench.apb_rd( ADDR_TDR1, task_rdata);
        test_bench.cmp_data( ADDR_TDR1, task_rdata, 32'h0033_2211, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TDR1, 32'h4444_4444, BYTE3);
        test_bench.apb_rd( ADDR_TDR1, task_rdata);
        test_bench.cmp_data( ADDR_TDR1, task_rdata, 32'h4433_2211, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TDR1, 32'h5555_5555, HALF_WORD0);
        test_bench.apb_rd( ADDR_TDR1, task_rdata);
        test_bench.cmp_data( ADDR_TDR1, task_rdata, 32'h4433_5555, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TDR1, 32'h6666_6666, HALF_WORD1);
        test_bench.apb_rd( ADDR_TDR1, task_rdata);
        test_bench.cmp_data( ADDR_TDR1, task_rdata, 32'h6666_5555, 32'hffff_ffff);

        $display("*TCMP0*");
        test_bench.apb_wr_pstrb( ADDR_TCMP0, 32'h1111_1111, BYTE0);
        test_bench.apb_rd( ADDR_TCMP0, task_rdata);
        test_bench.cmp_data( ADDR_TCMP0, task_rdata, 32'hFFFF_FF11, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TCMP0, 32'h2222_2222, BYTE1);
        test_bench.apb_rd( ADDR_TCMP0, task_rdata);
        test_bench.cmp_data( ADDR_TCMP0, task_rdata, 32'hFFFF_2211, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TCMP0, 32'h3333_3333, BYTE2);
        test_bench.apb_rd( ADDR_TCMP0, task_rdata);
        test_bench.cmp_data( ADDR_TCMP0, task_rdata, 32'hFF33_2211, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TCMP0, 32'h4444_4444, BYTE3);
        test_bench.apb_rd( ADDR_TCMP0, task_rdata);
        test_bench.cmp_data( ADDR_TCMP0, task_rdata, 32'h4433_2211, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TCMP0, 32'h5555_5555, HALF_WORD0);
        test_bench.apb_rd( ADDR_TCMP0, task_rdata);
        test_bench.cmp_data( ADDR_TCMP0, task_rdata, 32'h4433_5555, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TCMP0, 32'h6666_6666, HALF_WORD1);
        test_bench.apb_rd( ADDR_TCMP0, task_rdata);
        test_bench.cmp_data( ADDR_TCMP0, task_rdata, 32'h6666_5555, 32'hffff_ffff);

        $display("*TCMP1*");
        test_bench.apb_wr_pstrb( ADDR_TCMP1, 32'h1111_1111, BYTE0);
        test_bench.apb_rd( ADDR_TCMP1, task_rdata);
        test_bench.cmp_data( ADDR_TCMP1, task_rdata, 32'hFFFF_FF11, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TCMP1, 32'h2222_2222, BYTE1);
        test_bench.apb_rd( ADDR_TCMP1, task_rdata);
        test_bench.cmp_data( ADDR_TCMP1, task_rdata, 32'hFFFF_2211, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TCMP1, 32'h3333_3333, BYTE2);
        test_bench.apb_rd( ADDR_TCMP1, task_rdata);
        test_bench.cmp_data( ADDR_TCMP1, task_rdata, 32'hFF33_2211, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TCMP1, 32'h4444_4444, BYTE3);
        test_bench.apb_rd( ADDR_TCMP1, task_rdata);
        test_bench.cmp_data( ADDR_TCMP1, task_rdata, 32'h4433_2211, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TCMP1, 32'h5555_5555, HALF_WORD0);
        test_bench.apb_rd( ADDR_TCMP1, task_rdata);
        test_bench.cmp_data( ADDR_TCMP1, task_rdata, 32'h4433_5555, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TCMP1, 32'h6666_6666, HALF_WORD1);
        test_bench.apb_rd( ADDR_TCMP1, task_rdata);
        test_bench.cmp_data( ADDR_TCMP1, task_rdata, 32'h6666_5555, 32'hffff_ffff);

        $display("*TIER*");
        test_bench.apb_wr_pstrb( ADDR_TIER, 32'h1111_1111, BYTE0);
        test_bench.apb_rd( ADDR_TIER, task_rdata);
        test_bench.cmp_data( ADDR_TIER, task_rdata, 32'h1, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TIER, 32'h2222_2222, BYTE1);
        test_bench.apb_rd( ADDR_TIER, task_rdata);
        test_bench.cmp_data( ADDR_TIER, task_rdata, 32'h1, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TIER, 32'h3333_3333, BYTE2);
        test_bench.apb_rd( ADDR_TIER, task_rdata);
        test_bench.cmp_data( ADDR_TIER, task_rdata, 32'h1, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TIER, 32'h4444_4444, BYTE3);
        test_bench.apb_rd( ADDR_TIER, task_rdata);
        test_bench.cmp_data( ADDR_TIER, task_rdata, 32'h1, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TIER, 32'h6666_6666, HALF_WORD0);
        test_bench.apb_rd( ADDR_TIER, task_rdata);
        test_bench.cmp_data( ADDR_TIER, task_rdata, 32'h0, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TIER, 32'h7777_7777, HALF_WORD1);
        test_bench.apb_rd( ADDR_TIER, task_rdata);
        test_bench.cmp_data( ADDR_TIER, task_rdata, 32'h0, 32'hffff_ffff);

        $display("*TISR*");
        //assert interrupt
        test_bench.apb_wr( ADDR_TIER, 32'h1);
        test_bench.apb_wr( ADDR_TCMP0, 32'h0000_000A);
        test_bench.apb_wr( ADDR_TCMP1, 32'h0000_0000);

        test_bench.apb_wr( ADDR_TDR1, 32'h0000_0000);
        test_bench.apb_wr( ADDR_TDR0, 32'h0000_000A);
        
        //read interrupt status
        test_bench.apb_rd( ADDR_TISR, task_rdata);
        test_bench.cmp_data( ADDR_TISR, task_rdata, 32'h1, 32'hffff_ffff);
        
        
        test_bench.apb_wr_pstrb( ADDR_TISR, 32'hFFFF_FFFF, BYTE1);
        test_bench.apb_rd( ADDR_TISR, task_rdata);
        test_bench.cmp_data( ADDR_TISR, task_rdata, 32'h1, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TISR, 32'hFFFF_FFFF, BYTE2);
        test_bench.apb_rd( ADDR_TISR, task_rdata);
        test_bench.cmp_data( ADDR_TISR, task_rdata, 32'h1, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TISR, 32'hFFFF_FFFF, BYTE3);
        test_bench.apb_rd( ADDR_TISR, task_rdata);
        test_bench.cmp_data( ADDR_TISR, task_rdata, 32'h1, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_TISR, 32'hFFFF_FFFF, HALF_WORD1);
        test_bench.apb_rd( ADDR_TISR, task_rdata);
        test_bench.cmp_data( ADDR_TISR, task_rdata, 32'h1, 32'hffff_ffff);

        //change TDR0 then clear the interrupt
        test_bench.apb_wr( ADDR_TDR0, 32'h0000_000B);
        test_bench.apb_wr_pstrb( ADDR_TISR, 32'h1, BYTE0);
        test_bench.apb_rd( ADDR_TISR, task_rdata);
        test_bench.cmp_data( ADDR_TISR, task_rdata, 32'h0, 32'hffff_ffff);

        //assert the interrupt again
        test_bench.apb_wr( ADDR_TDR0, 32'h0000_000A);
        test_bench.apb_rd( ADDR_TISR, task_rdata);
        test_bench.cmp_data( ADDR_TISR, task_rdata, 32'h1, 32'hffff_ffff);


        //change TDR0 then clear the interrupt
        test_bench.apb_wr( ADDR_TDR0, 32'h0000_000B);
        test_bench.apb_wr_pstrb( ADDR_TISR, 32'h1, HALF_WORD0);
        test_bench.apb_rd( ADDR_TISR, task_rdata);
        test_bench.cmp_data( ADDR_TISR, task_rdata, 32'h0, 32'hffff_ffff);
        
        $display("*THCSR*");
        test_bench.apb_wr_pstrb( ADDR_THCSR, 32'h1111_1111, BYTE0);
        test_bench.apb_rd( ADDR_THCSR, task_rdata);
        test_bench.cmp_data( ADDR_THCSR, task_rdata, 32'h1, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_THCSR, 32'h2222_2222, BYTE1);
        test_bench.apb_rd( ADDR_THCSR, task_rdata);
        test_bench.cmp_data( ADDR_THCSR, task_rdata, 32'h1, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_THCSR, 32'h3333_3333, BYTE2);
        test_bench.apb_rd( ADDR_THCSR, task_rdata);
        test_bench.cmp_data( ADDR_THCSR, task_rdata, 32'h1, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_THCSR, 32'h4444_4444, BYTE3);
        test_bench.apb_rd( ADDR_THCSR, task_rdata);
        test_bench.cmp_data( ADDR_THCSR, task_rdata, 32'h1, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_THCSR, 32'h6666_6666, HALF_WORD0);
        test_bench.apb_rd( ADDR_THCSR, task_rdata);
        test_bench.cmp_data( ADDR_THCSR, task_rdata, 32'h0, 32'hffff_ffff);
        
        test_bench.apb_wr_pstrb( ADDR_THCSR, 32'h7777_7777, HALF_WORD1);
        test_bench.apb_rd( ADDR_THCSR, task_rdata);
        test_bench.cmp_data( ADDR_THCSR, task_rdata, 32'h0, 32'hffff_ffff);



        if( test_bench.err != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");

    end


endtask
