task run_test();
    //reg [31:0]  task_rdata;
    begin
  	    
        $display("====================================");	
  	    $display("==== Pat name: check reset value ===");
  	    $display("====================================");	
        
        //call task in tb
        test_bench.reg_init_chk;

        //test_bench.apb_rd( ADDR_TCR, task_rdata);
        //test_bench.cmp_data( ADDR_TCR, task_rdata, 32'h0000_0100, 32'hffff_ffff);
        //
        //test_bench.apb_rd( ADDR_TDR0, task_rdata);
        //test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h0000_0000, 32'hffff_ffff);
        //
        //test_bench.apb_rd( ADDR_TDR1, task_rdata);
        //test_bench.cmp_data( ADDR_TDR1, task_rdata, 32'h0000_0000, 32'hffff_ffff);
        //
        //test_bench.apb_rd( ADDR_TCMP0, task_rdata);
        //test_bench.cmp_data( ADDR_TCMP0, task_rdata, 32'hffff_ffff, 32'hffff_ffff);
        //
        //test_bench.apb_rd( ADDR_TCMP1, task_rdata);
        //test_bench.cmp_data( ADDR_TCMP1, task_rdata, 32'hffff_ffff, 32'hffff_ffff);
        //
        //test_bench.apb_rd( ADDR_TIER, task_rdata);
        //test_bench.cmp_data( ADDR_TIER, task_rdata, 32'h0000_0000, 32'hffff_ffff);
        //
        //test_bench.apb_rd( ADDR_TISR, task_rdata);
        //test_bench.cmp_data( ADDR_TISR, task_rdata, 32'h0000_0000, 32'hffff_ffff);

        //test_bench.apb_rd( ADDR_THCSR, task_rdata);
        //test_bench.cmp_data( ADDR_THCSR, task_rdata, 32'h0000_0000, 32'hffff_ffff);

        if( test_bench.err != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");
    
    end


endtask
