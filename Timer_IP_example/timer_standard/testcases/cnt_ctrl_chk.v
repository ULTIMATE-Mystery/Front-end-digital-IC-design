task run_test();
    reg [31:0]  task_rdata;
    reg [63:0]  cnt;
    reg [63:0]  exp_value;
    reg [31:0]  test_cycle;
    reg         err;
    integer     idx, loop;
    integer seed;
    reg [63:0] cnt_wdata;
    begin
        err = 0;
        idx = 0;
        loop = 0;
  	    
        $display("======================================");	
  	    $display("====== Test Case: cnt control chk ====");
  	    $display("======================================");	
        
        $display("Check the period when start cnt combine with div_val");

        $display("Test with system clock");

        //config golden cnt
        test_cycle = 100;
        test_bench.tsk_cfg_golden_cnt( 0 );
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0001);//timer_en = 1, div_en = 0, div_val = 0;
        repeat (test_cycle) @(posedge test_bench.clk);
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0300);//timer_en = 0
        
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        cnt[31:0] = task_rdata;
        test_bench.apb_rd(ADDR_TDR1, task_rdata);
        cnt[63:32] = task_rdata;


        if( cnt !== test_bench.golden_cnt) begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: cnt does not match expect value ",$time);
            $display("Expect: %d", test_bench.golden_cnt);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");
            err=1;
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d PASSED: cnt matches expect value ",$time);
            $display("Expect: %d", test_bench.golden_cnt);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");

        end
        test_bench.apb_wr(ADDR_TDR0,0);
        test_bench.apb_wr(ADDR_TDR1,0);

        #10;
        for(idx=0; idx < 9; idx=idx+1)begin
            for( loop =0; loop < 2**idx; loop=loop+1) begin 
                seed = $time + $realtime + $stime;
                seed = $urandom(seed);
                test_cycle = $urandom(seed) % 1000;
                $display("Test with div_val = %d, loop_idx=%d, test_cycle=%d",idx,loop, test_cycle);
                test_bench.tsk_cfg_golden_cnt( 0 );
                test_bench.apb_wr(ADDR_TCR, idx << 8 | 3);//timer_en = 1, div_en = 0, div_val = 0;
                repeat (test_cycle) @(posedge test_bench.clk);
                test_bench.apb_wr(ADDR_TCR, idx <<8 | 2);//timer_en = 0
        
                test_bench.apb_rd(ADDR_TDR0, task_rdata);
                cnt[31:0] = task_rdata;
                test_bench.apb_rd(ADDR_TDR1, task_rdata);
                cnt[63:32] = task_rdata;
                
                if( cnt !== (test_bench.golden_cnt>> idx)) begin
		        	$display("------------------------------------------------");
		        	$display("t=%10d FAIL: cnt does not match expect value ",$time);
                    $display("Expect: %d", test_bench.golden_cnt >> idx);
                    $display("Actual: %d", cnt);
		        	$display("------------------------------------------------");
                    err=1;
                end else begin
		        	$display("------------------------------------------------");
		        	$display("t=%10d PASSED: cnt matches expect value ",$time);
                    $display("Expect: %d", test_bench.golden_cnt >> idx);
                    $display("Actual: %d", cnt);
		        	$display("------------------------------------------------");
                end

                test_bench.apb_wr(ADDR_TDR0,0);
                test_bench.apb_wr(ADDR_TDR1,0);
                #10;
            end
        end

        $display("============================================");
        $display("==== Test with random TDR0, and TDR1 =======");
        $display("============================================");
        
        cnt_wdata = $urandom(seed) + $urandom(seed);
        test_bench.apb_wr(ADDR_TDR0, cnt_wdata[31:0]);
        test_bench.apb_wr(ADDR_TDR1, cnt_wdata[63:32]);

        $display("Test with system clock");

        //config golden cnt
        test_cycle = 100;
        test_bench.tsk_cfg_golden_cnt( cnt_wdata );
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0001);//timer_en = 1, div_en = 0, div_val = 0;
        repeat (test_cycle) @(posedge test_bench.clk);
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0300);//timer_en = 0
        
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        cnt[31:0] = task_rdata;
        test_bench.apb_rd(ADDR_TDR1, task_rdata);
        cnt[63:32] = task_rdata;


        if( cnt !== test_bench.golden_cnt) begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: cnt does not match expect value ",$time);
            $display("Expect: %d", test_bench.golden_cnt);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");
            err=1;
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d PASSED: cnt matches expect value ",$time);
            $display("Expect: %d", test_bench.golden_cnt);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");

        end

        #10;
        //loop all 9 value of div_val when div_en is 1
        for(idx=0; idx < 9; idx=idx+1)begin
            for( loop =0; loop < 2**idx; loop=loop+1) begin 
                seed = $time + $realtime + $stime;
                seed = $urandom(seed);
                //random cnt wdata
                cnt_wdata = $urandom(seed) + $urandom(seed);
                test_bench.apb_wr(ADDR_TDR0, cnt_wdata[31:0]);
                test_bench.apb_wr(ADDR_TDR1, cnt_wdata[63:32]);
                //random test cycle
                test_cycle = $urandom(seed) % 1000;
                $display("Test with div_val = %d, loop_idx=%d, test_cycle=%d",idx,loop, test_cycle);
                //test_bench.tsk_cfg_golden_cnt( cnt_wdata );
                test_bench.tsk_cfg_golden_cnt( cnt_wdata*(1<<idx) );
                test_bench.apb_wr(ADDR_TCR, idx << 8 | 3);//timer_en = 1, div_en = 1, div_val = idx;
                repeat (test_cycle) @(posedge test_bench.clk);
                test_bench.apb_wr(ADDR_TCR, idx <<8 | 2);//timer_en = 0
        
                test_bench.apb_rd(ADDR_TDR0, task_rdata);
                cnt[31:0] = task_rdata;
                test_bench.apb_rd(ADDR_TDR1, task_rdata);
                cnt[63:32] = task_rdata;
                //generate exp value
                //exp_value = cnt_wdata + ((test_bench.golden_cnt - cnt_wdata) >> idx);
                exp_value = cnt_wdata + ((test_bench.golden_cnt - (cnt_wdata*(1<<idx))) >> idx);
                if( cnt !== exp_value) begin
		        	$display("------------------------------------------------");
		        	$display("t=%10d FAIL: cnt does not match expect value ",$time);
                    $display("Expect: %d", exp_value);
                    $display("Actual: %d", cnt);
		        	$display("------------------------------------------------");
                    err=1;
                end else begin
		        	$display("------------------------------------------------");
		        	$display("t=%10d PASSED: cnt matches expect value ",$time);
                    $display("Expect: %d", exp_value);
                    $display("Actual: %d", cnt);
		        	$display("------------------------------------------------");
                end

                #10;
            end
        end


        $display("additional check");
        $display("ensure that when div_en = 0, any setting of div_val is not affect to the counting speed");
        $display("");
        for(idx=0; idx < 9; idx=idx+1)begin
            for( loop =0; loop < 1; loop=loop+1) begin 
                seed = $time + $realtime + $stime;
                seed = $urandom(seed);
                //random cnt wdata
                cnt_wdata = $urandom(seed) + $urandom(seed);
                test_bench.apb_wr(ADDR_TDR0, cnt_wdata[31:0]);
                test_bench.apb_wr(ADDR_TDR1, cnt_wdata[63:32]);
                //random test cycle
                test_cycle = $urandom(seed) % 1000;
                $display("Test with div_val = %d, loop_idx=%d, test_cycle=%d",idx,loop, test_cycle);
                test_bench.tsk_cfg_golden_cnt( cnt_wdata );
                test_bench.apb_wr(ADDR_TCR, idx << 8 | 1);//timer_en = 1, div_en = 0, div_val = idx;
                repeat (test_cycle) @(posedge test_bench.clk);
                test_bench.apb_wr(ADDR_TCR, idx <<8 | 0);//timer_en = 0
        
                test_bench.apb_rd(ADDR_TDR0, task_rdata);
                cnt[31:0] = task_rdata;
                test_bench.apb_rd(ADDR_TDR1, task_rdata);
                cnt[63:32] = task_rdata;
                
                if( cnt !== test_bench.golden_cnt) begin
		        	$display("------------------------------------------------");
		        	$display("t=%10d FAIL: cnt does not match expect value ",$time);
                    $display("Expect: %d", test_bench.golden_cnt);
                    $display("Actual: %d", cnt);
		        	$display("------------------------------------------------");
                    err=1;
                end else begin
		        	$display("------------------------------------------------");
		        	$display("t=%10d PASSED: cnt matches expect value ",$time);
                    $display("Expect: %d", test_bench.golden_cnt);
                    $display("Actual: %d", cnt);
		        	$display("------------------------------------------------");

                end

                #10;
            end
        end



        if( err != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");

    end


endtask
