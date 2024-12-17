task run_test();
    reg [31:0]  task_rdata;
    reg         err;
    begin
  	    err = 0;
        $display("=========================================");	
  	    $display("=== Test Case: APB Multi-access Test ====");
  	    $display("=========================================");	
        
        
        //multiple APB access 
        $display("multiple APB access");
        $display("write TDR0 & write TDR1");
        @(posedge clk);
        #1;
        test_bench.psel = 1 ;   //setup phase
        test_bench.pwrite = 1;
        test_bench.paddr = ADDR_TDR0;
        test_bench.pwdata = 32'h1111_1111; 
        @(posedge clk);
        #1;
        test_bench.penable = 1 ; //access phase
        wait( pready == 1); //wait accept
        @(posedge clk);
        #1;
        test_bench.penable = 0;
        test_bench.paddr = ADDR_TDR1;
        test_bench.pwdata = 32'h2222_2222; 
        @(posedge clk);
        #1;
        test_bench.penable = 1 ; //access phase
        wait( pready == 1); //wait accept
        @(posedge clk);
        #1;
        test_bench.pwrite = 0; //idle
        test_bench.psel = 0;
        test_bench.penable = 0;
        test_bench.paddr = 0;
        test_bench.pwdata = 0;

        //normal read
        $display("normal read");
        test_bench.apb_rd( ADDR_TDR0, task_rdata);//read normal 
        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h1111_1111, 32'hffff_ffff);
        test_bench.apb_rd( ADDR_TDR1, task_rdata);//read normal 
        test_bench.cmp_data( ADDR_TDR1, task_rdata, 32'h2222_2222, 32'hffff_ffff);
        
        //normal write
        $display("normal write");
        test_bench.apb_wr(ADDR_TDR0, 32'h3333_3333); 
        test_bench.apb_wr(ADDR_TDR1, 32'h4444_4444); 
        //multiple read
        $display("multiple read");
        @(posedge clk);
        #1;
        test_bench.psel = 1 ;   //setup phase
        test_bench.paddr = ADDR_TDR0;
        @(posedge clk);
        #1;
        test_bench.penable = 1 ; //access phase
        wait( pready == 1); //wait accept
        #1;
        test_bench.cmp_data( ADDR_TDR0, test_bench.prdata, 32'h3333_3333, 32'hffff_ffff);
        @(posedge clk);
        #1;
        test_bench.penable = 0;
        test_bench.paddr = ADDR_TDR1;
        @(posedge clk);
        #1;
        test_bench.penable = 1 ; //access phase
        wait( pready == 1); //wait accept
        #1
        test_bench.cmp_data( ADDR_TDR1, test_bench.prdata, 32'h4444_4444, 32'hffff_ffff);
        @(posedge clk);
        #1;
        test_bench.psel = 0;
        test_bench.penable = 0;
        test_bench.paddr = 0;
        
        $display("w-r(TDR0)-w-r(TDR1)");
        @(posedge clk);
        #1;
        test_bench.psel = 1 ;   //setup phase
        test_bench.pwrite = 1;
        test_bench.paddr = ADDR_TDR0;
        test_bench.pwdata = 32'h5555_5555; 
        @(posedge clk);
        #1;
        test_bench.penable = 1 ; //access phase
        wait( pready == 1); //wait accept
        @(posedge clk);
        #1;
        test_bench.penable = 0;
        test_bench.pwrite = 0;//change to read
        test_bench.pwdata = 0;
        @(posedge clk);
        #1;
        test_bench.penable = 1 ; //access phase
        wait( pready == 1); //wait accept
        #1;
        test_bench.cmp_data( ADDR_TDR0, test_bench.prdata, 32'h5555_5555, 32'hffff_ffff);
        @(posedge clk);
        #1;
        test_bench.penable = 0;
        test_bench.pwrite = 1;
        test_bench.paddr = ADDR_TDR1;
        test_bench.pwdata = 32'h6666_6666; 
        @(posedge clk);
        #1;
        test_bench.penable = 1 ; //access phase
        wait( pready == 1); //wait accept
        @(posedge clk);
        #1;
        test_bench.penable = 0;
        test_bench.pwrite = 0;//change to read
        test_bench.pwdata = 0;
        @(posedge clk);
        #1;
        test_bench.penable = 1 ; //access phase
        wait( pready == 1); //wait accept
        #1;
        test_bench.cmp_data( ADDR_TDR1, test_bench.prdata, 32'h6666_6666, 32'hffff_ffff);
        @(posedge clk);
        #1;
        test_bench.psel = 0;
        test_bench.penable = 0;
        test_bench.paddr = 0;

        if( test_bench.err != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");

    end


endtask
