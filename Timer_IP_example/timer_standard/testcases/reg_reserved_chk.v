task run_test();
    reg [31:0]  task_rdata;
    integer i;
    begin
  	    
        $display("====================================");	
  	    $display("==== Test Case: check Reserved =====");
  	    $display("====================================");	

        i=0;
        
        $display("write to 0x4000_1FFC");
        test_bench.apb_wr(32'h4000_1FFC, 32'hFFFF_FFFF);
        test_bench.apb_rd( 32'h4000_1FFC, task_rdata);
        test_bench.cmp_data( 32'h4000_1FFC, task_rdata, 32'h0, 32'hffff_ffff);
        
        $display("write to begin of reserved addr");
        test_bench.apb_wr(ADDR_THCSR+4, 32'hFFFF_FFFF);
        test_bench.apb_rd( ADDR_THCSR+4, task_rdata);
        test_bench.cmp_data( ADDR_THCSR+4, task_rdata, 32'h0, 32'hffff_ffff);

        //not check the below
        //i=0:0x1
        //i=1:0x2
        //i=2:0x4
        //i=3:0x8
        //i=4:0x10
        for( i = 5; i < 12; i=i+1) begin
            test_bench.apb_wr( 1<<i, 32'hFFFF_FFFF);
            test_bench.apb_rd( 1<<i, task_rdata);
            test_bench.cmp_data( 1<<i, task_rdata, 32'h0, 32'hffff_ffff);
        end

        if( test_bench.err != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");

    end


endtask
