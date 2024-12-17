task run_test();
    reg [31:0]  task_rdata;
    reg         err;
    reg         status;
    integer     idx;
    begin
  	    err = 0;
        status = 0;
        $display("=====================================");	
  	    $display("=== Test Case: Pslverr check === ====");
  	    $display("=====================================");	
        
        test_bench.tsk_set_pslverr_exp(1);
        
        for(idx = 9; idx <16; idx=idx+1) begin
            test_bench.apb_wr(ADDR_TCR, idx << 8);
            test_bench.tsk_rd_pslverr(status);
            if( status == 0 ) begin
                $display("FAIL: pslverr does not assert");
                err = 1;
            end
            #1 status = 0;
            test_bench.apb_rd( ADDR_TCR, task_rdata);
            test_bench.cmp_data( ADDR_TCR, task_rdata, 32'h100, 32'hffff_ffff);
        end
        
        test_bench.tsk_set_pslverr_exp(0);
        
        test_bench.apb_wr(ADDR_TCR, 8 << 8);
        test_bench.apb_rd( ADDR_TCR, task_rdata);
        test_bench.cmp_data( ADDR_TCR, task_rdata, 32'h800, 32'hffff_ffff);

        //timer_en=1;
        test_bench.apb_wr(ADDR_TCR, 1);

        test_bench.tsk_set_pslverr_exp(1);

        test_bench.apb_wr(ADDR_TCR, 32'h103);
        test_bench.tsk_rd_pslverr(status);
        if( status == 0 ) begin
            $display("FAIL: pslverr does not assert");
            err = 1;
        end
        #1 status = 0;
        test_bench.apb_rd( ADDR_TCR, task_rdata);
        test_bench.cmp_data( ADDR_TCR, task_rdata, 32'h1, 32'hffff_ffff);


        test_bench.apb_wr(ADDR_TCR, 32'h100);
        test_bench.tsk_rd_pslverr(status);
        if( status == 0 ) begin
            $display("FAIL: pslverr does not assert");
            err = 1;
        end
        #1 status = 0;
        test_bench.apb_rd( ADDR_TCR, task_rdata);
        test_bench.cmp_data( ADDR_TCR, task_rdata, 32'h1, 32'hffff_ffff);

        test_bench.apb_wr(ADDR_TCR, 32'h002);
        test_bench.tsk_rd_pslverr(status);
        if( status == 0 ) begin
            $display("FAIL: pslverr does not assert");
            err = 1;
        end
        #1 status = 0;
        test_bench.tsk_set_pslverr_exp(0);
        
        test_bench.apb_rd( ADDR_TCR, task_rdata);
        test_bench.cmp_data( ADDR_TCR, task_rdata, 32'h1, 32'hffff_ffff);
        

        $display("clear timer_en");
        test_bench.apb_wr(ADDR_TCR, 32'h0);
        test_bench.apb_wr(ADDR_TCR, 32'h102);
        test_bench.apb_rd( ADDR_TCR, task_rdata);
        test_bench.cmp_data( ADDR_TCR, task_rdata, 32'h102, 32'hffff_ffff);


        
        

        if( test_bench.err!=0 || err != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");

    end


endtask
