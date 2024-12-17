
task run_test();
    reg [31:0]  task_rdata;
    reg [63:0]  cnt;
    reg [63:0]  cnt1;
    begin
  	    
        $display("===============================================================");	
  	    $display("====== Test Case: check counter couting check =================");
  	    $display("===============================================================");	
        
        $display("check at boundary of TDR0");        
        test_bench.apb_wr(ADDR_TDR0, 32'hffff_ff00);
        test_bench.apb_wr(ADDR_TDR1, 32'h0);
        test_bench.apb_wr(ADDR_TCR, 32'h1); //timer_en = 1;
        repeat(256) @(posedge test_bench.clk);


        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        cnt[31:0] = task_rdata;
        test_bench.apb_rd(ADDR_TDR1, task_rdata);
        cnt[63:32] = task_rdata;

        //check the counter increment is correct 

        if( cnt[63:32] == 1 && cnt[31:0] < 10) begin
			$display("------------------------------------------------");
			$display("t=%10d PASSED: cnt matches expect value ",$time);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: cnt does not match expect value ",$time);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");
            err=1;
        end
        
        test_bench.apb_wr(ADDR_TCR, 32'h0); //timer_en = 0;

        $display("check at boundary of TDR1");        
        test_bench.apb_wr(ADDR_TDR0, 32'hffff_ff00);
        test_bench.apb_wr(ADDR_TDR1, 32'hffff_ffff);
        test_bench.apb_wr(ADDR_TCR, 32'h1); //timer_en = 1;
        
        repeat(256) @(posedge test_bench.clk);
        
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        cnt[31:0] = task_rdata;
        test_bench.apb_rd(ADDR_TDR1, task_rdata);
        cnt[63:32] = task_rdata;

        //check the counter increment is correct 

        if( cnt[63:32] == 0 && cnt[31:0] < 10) begin
			$display("------------------------------------------------");
			$display("t=%10d PASSED: cnt matches expect value ",$time);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: cnt does not match expect value ",$time);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");
            err=1;
        end


        test_bench.apb_wr(ADDR_TCR, 32'h0); //timer_en = 0;


        
        $display("check writing to counter when counting");        
        test_bench.apb_wr(ADDR_TDR0, 32'h0);
        test_bench.apb_wr(ADDR_TDR1, 32'h0);
        test_bench.apb_wr(ADDR_TCR, 32'h1); //timer_en = 1;
        repeat(256) @(posedge test_bench.clk);
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        cnt[31:0] = task_rdata;
        test_bench.apb_rd(ADDR_TDR1, task_rdata);
        cnt[63:32] = task_rdata;
        
        if( cnt[63:0] < 250 || cnt[63:0] > 270 ) begin
            err = 1;
			$display("------------------------------------------------");
			$display("t=%10d FAIL: cnt does not match expect value ",$time);
            $display("Expect: between 250..270");
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");
            err=1;
        end


        test_bench.apb_wr(ADDR_TDR0, 32'hffff_ff00);
        
        repeat(256) @(posedge test_bench.clk);
        
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        cnt[31:0] = task_rdata;
        test_bench.apb_rd(ADDR_TDR1, task_rdata);
        cnt[63:32] = task_rdata;
        
        //check the counter increment is correct 

        if( cnt[63:32] == 1 && cnt[31:0] < 10) begin
			$display("------------------------------------------------");
			$display("t=%10d PASSED: cnt matches expect value ",$time);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: cnt does not match expect value ",$time);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");
            err=1;
        end
        
        test_bench.apb_wr(ADDR_TCR, 32'h0); //timer_en = 0;

        $display("check timer_en = 0, cnt is 0");
        //read current value
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        cnt[31:0] = task_rdata;
        test_bench.apb_rd(ADDR_TDR1, task_rdata);
        cnt[63:32] = task_rdata;

        
        //repeat(256) @(posedge test_bench.clk);
        //test_bench.apb_rd(ADDR_TDR0, task_rdata);
        //cnt1[31:0] = task_rdata;
        //test_bench.apb_rd(ADDR_TDR1, task_rdata);
        //cnt1[63:32] = task_rdata;
        

        if( cnt === 0) begin
			$display("--------------------------------------------------------");
			$display("t=%10d PASSED: cnt is 0 when timer_en is 0 ",$time);
			$display("--------------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: cnt is NOT 0 when timer_en is 0 ",$time);
            $display("Expect: %d", cnt);
            $display("Actual: %d", cnt1);
			$display("------------------------------------------------");
            err=1;
        end

        test_bench.apb_wr(ADDR_TCR, 32'h1); //timer_en = 1;
        repeat(256) @(posedge test_bench.clk);
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        cnt[31:0] = task_rdata;
        test_bench.apb_rd(ADDR_TDR1, task_rdata);
        cnt[63:32] = task_rdata;
        
        if( cnt[63:0] < 250 || cnt[63:0] > 270 ) begin
            err = 1;
			$display("------------------------------------------------");
			$display("t=%10d FAIL: cnt does not match expect value ",$time);
            $display("Expect: between 250..270");
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");
            err=1;
        end





        if( test_bench.err != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");

    end


endtask
