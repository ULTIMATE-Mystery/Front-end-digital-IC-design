task run_test();
    reg [31:0]  task_rdata;
    reg         err;
    begin
  	    err = 0;
        $display("=====================================");	
  	    $display("=== Test Case: APB Protocol Test ====");
  	    $display("=====================================");	
        
        //normal APB 
        test_bench.apb_wr(ADDR_TDR0, 32'h3333_3333);

        test_bench.apb_rd( ADDR_TDR0, task_rdata);
        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h3333_3333, 32'hffff_ffff);

        //wrong protocol test
        $display("penable does not assert"); 
        test_bench.apb_err_penable = 1;
        test_bench.apb_wr(ADDR_TDR0, 32'h5555_5555); //error write
        test_bench.apb_err_penable = 0;

        test_bench.apb_rd( ADDR_TDR0, task_rdata);//read normal 
        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h3333_3333, 32'hffff_ffff);

        test_bench.apb_err_penable = 1;
        test_bench.apb_rd( ADDR_TDR0, task_rdata);//read error
        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h0, 32'hffff_ffff);
        test_bench.apb_err_penable = 0;

        $display("psel does not assert"); 
        test_bench.apb_err_psel = 1;
        test_bench.apb_wr(ADDR_TDR0, 32'h7777_7777); //error write
        test_bench.apb_err_psel = 0;

        test_bench.apb_rd( ADDR_TDR0, task_rdata);//read normal 
        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h3333_3333, 32'hffff_ffff);

        test_bench.apb_err_psel = 1;
        test_bench.apb_rd( ADDR_TDR0, task_rdata);//read error
        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h0, 32'hffff_ffff);
        test_bench.apb_err_psel = 0;
        
        test_bench.apb_wr(ADDR_TDR0, 32'h9999_9999); //write normal
        test_bench.apb_rd( ADDR_TDR0, task_rdata);//read normal
        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h9999_9999, 32'hffff_ffff);

        

        if( test_bench.err != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");

    end


endtask
