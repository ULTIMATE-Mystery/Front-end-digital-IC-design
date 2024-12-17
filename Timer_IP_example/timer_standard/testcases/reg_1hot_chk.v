task run_test();
    reg [31:0]  task_rdata;
    begin
  	    
        $display("====================================");	
  	    $display("====== Test Case: check One hot ====");
  	    $display("====================================");	
        
        
        test_bench.apb_wr(ADDR_TISR, 32'h1111_1111);
        test_bench.apb_wr(ADDR_TCR, 32'h2222_2222);//timer_en need to be 0
        test_bench.apb_wr(ADDR_TDR0, 32'h3333_3333);
        test_bench.apb_wr(ADDR_TDR1, 32'h4444_4444);
        test_bench.apb_wr(ADDR_TCMP0, 32'h5555_5555);
        test_bench.apb_wr(ADDR_TCMP1, 32'h6666_6666);
        test_bench.apb_wr(ADDR_TIER, 32'h7777_7777);
        test_bench.apb_wr(ADDR_THCSR, 32'h8888_8888);
        
        test_bench.apb_rd( ADDR_TISR, task_rdata);
        test_bench.cmp_data( ADDR_TISR, task_rdata, 32'h0, 32'hffff_ffff);

        test_bench.apb_rd( ADDR_TCR, task_rdata);
        test_bench.cmp_data( ADDR_TCR, task_rdata, 32'h0000_0202, 32'hffff_ffff);

        test_bench.apb_rd( ADDR_TDR0, task_rdata);
        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h3333_3333, 32'hffff_ffff);

        test_bench.apb_rd( ADDR_TDR1, task_rdata);
        test_bench.cmp_data( ADDR_TDR1, task_rdata, 32'h4444_4444, 32'hffff_ffff);
        
        test_bench.apb_rd( ADDR_TCMP0, task_rdata);
        test_bench.cmp_data( ADDR_TCMP0, task_rdata, 32'h5555_5555, 32'hffff_ffff);
        
        test_bench.apb_rd( ADDR_TCMP1, task_rdata);
        test_bench.cmp_data( ADDR_TCMP1, task_rdata, 32'h6666_6666, 32'hffff_ffff);
        
        test_bench.apb_rd( ADDR_TIER, task_rdata);
        test_bench.cmp_data( ADDR_TIER, task_rdata, 32'h1, 32'hffff_ffff);
        
        test_bench.apb_rd( ADDR_THCSR, task_rdata);
        test_bench.cmp_data( ADDR_THCSR, task_rdata, 32'h0, 32'hffff_ffff);

        if( test_bench.err != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");

    end


endtask
