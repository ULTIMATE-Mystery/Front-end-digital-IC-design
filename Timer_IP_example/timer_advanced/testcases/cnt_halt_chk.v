task run_test();
    reg [31:0]  task_rdata;
    reg [63:0]  cnt;
    reg [63:0]  cnt1;
    reg [63:0]  exp_value;
    reg [31:0]  test_cycle;
    integer     idx, loop;
    integer seed;
    reg [63:0] cnt_wdata;
    begin
  	    
        $display("====================================");	
  	    $display("====== Test Case: Cnt Halt Check ====");
  	    $display("====================================");	

        $display("Cnt is not halted when debug mode is Low");
        
        test_bench.apb_wr(ADDR_TCR, 32'h1);//timer_en is H 
        
        //store cnt value
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        cnt[31:0] = task_rdata;
        test_bench.apb_rd(ADDR_TDR1, task_rdata);
        cnt[63:32] = task_rdata;
        
        test_bench.apb_wr(ADDR_THCSR, 32'h1); //halt=1
        //read back to check if halt_ack=0
        test_bench.apb_rd( ADDR_THCSR, task_rdata);
        test_bench.cmp_data( ADDR_THCSR, task_rdata, 32'h1, 32'hffff_ffff);

        //store cnt value
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        cnt1[31:0] = task_rdata;
        test_bench.apb_rd(ADDR_TDR1, task_rdata);
        cnt1[63:32] = task_rdata;

        if( cnt !== cnt1) begin
			$display("------------------------------------------------");
			$display("t=%10d PASSED: cnt is counting normally when timer en is 1",$time);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: cnt does not count when timer en is 1 ",$time);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");
            err=1;
        end

        repeat(256) @(posedge test_bench.clk);

        //store cnt value after 256 cycle
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        cnt[31:0] = task_rdata;
        test_bench.apb_rd(ADDR_TDR1, task_rdata);
        cnt[63:32] = task_rdata;
        
        if( cnt !== cnt1) begin
			$display("------------------------------------------------");
			$display("t=%10d PASSED: cnt continue counting when halt is 1 in normal mode",$time);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: cnt does not count when halt is 1 in normal mode ",$time);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");
            err=1;
        end

        $display("Cnt is halted when debug mode is High");
        
        test_bench.apb_wr(ADDR_TCR, 32'h0);//timer_en is L 
        test_bench.apb_wr(ADDR_THCSR, 32'h0); //halt=0
        test_bench.tsk_set_dbg_mode(1); //dbg_mode=1
        test_bench.apb_wr(ADDR_TCR, 32'h1);//timer_en is H 

        //store cnt value
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        cnt[31:0] = task_rdata;
        test_bench.apb_rd(ADDR_TDR1, task_rdata);
        cnt[63:32] = task_rdata;
        
        test_bench.apb_wr(ADDR_THCSR, 32'h1); //halt=1
        //read back to check if halt_ack=1
        test_bench.apb_rd( ADDR_THCSR, task_rdata);
        test_bench.cmp_data( ADDR_THCSR, task_rdata, 32'h3, 32'hffff_ffff);

        //store cnt value
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        cnt1[31:0] = task_rdata;
        test_bench.apb_rd(ADDR_TDR1, task_rdata);
        cnt1[63:32] = task_rdata;

        if( cnt !== cnt1) begin
			$display("------------------------------------------------");
			$display("t=%10d PASSED: cnt is counting normally when timer en is 1",$time);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: cnt does not count when timer en is 1 ",$time);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");
            err=1;
        end

        repeat(256) @(posedge test_bench.clk);

        //store cnt value after 256 cycle
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        cnt[31:0] = task_rdata;
        test_bench.apb_rd(ADDR_TDR1, task_rdata);
        cnt[63:32] = task_rdata;
        
        if( cnt === cnt1) begin
			$display("------------------------------------------------");
			$display("t=%10d PASSED: cnt is stopped when halt is 1 in debug mode",$time);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: cnt does not count when halt is 1 in debug mode ",$time);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");
            err=1;
        end
        test_bench.apb_wr(ADDR_TCR, 32'h0);//timer_en = 0
        
        $display("============================================");
        $display("============ Halted and Resume =============");
        $display("============================================");
	    $display("t=%10d",$time);
        
        seed = $time + $realtime + $stime;
        cnt_wdata[31:0] = $urandom(seed); 
        cnt_wdata[63:32]= $urandom(seed>>1);
        test_bench.apb_wr(ADDR_TDR0, cnt_wdata[31:0]);
        test_bench.apb_wr(ADDR_TDR1, cnt_wdata[63:32]);

        $display("Test with system clock");

        //config golden cnt
        test_cycle = 100;
        test_bench.tsk_cfg_golden_cnt( cnt_wdata );
        test_bench.apb_wr(ADDR_TCR, 32'h0000_0001);//timer_en = 1, div_en = 0, div_val = 0;
        repeat (test_cycle) @(posedge test_bench.clk);
        //test_bench.apb_wr(ADDR_TCR, 32'h0000_0300);//timer_en = 0
        test_bench.apb_wr(ADDR_THCSR, 32'h1);//halt=1
        
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
        test_bench.apb_wr(ADDR_THCSR, 32'h0);//halt=0
        //test_bench.apb_wr(ADDR_TCR, 0);//timer_en = 0
        repeat (test_cycle) @(posedge test_bench.clk);
        test_bench.apb_wr(ADDR_THCSR, 32'h1);//halt=1
        //read out cnt again 
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        cnt[31:0] = task_rdata;
        test_bench.apb_rd(ADDR_TDR1, task_rdata);
        cnt[63:32] = task_rdata;

        if( cnt !== test_bench.golden_cnt) begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: cnt does not match expect value after halted ",$time);
            $display("Expect: %d", test_bench.golden_cnt);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");
            err=1;
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d PASSED: cnt matches expect value after halted ",$time);
            $display("Expect: %d", test_bench.golden_cnt);
            $display("Actual: %d", cnt);
			$display("------------------------------------------------");

        end
        test_bench.apb_wr(ADDR_TCR, 0);//timer_en = 0
        test_bench.apb_wr(ADDR_THCSR, 32'h0);//halt=0
        #10;
        //loop all 9 value of div_val when div_en is 1
        for(idx=0; idx < 9; idx=idx+1)begin
        //for(idx=0; idx < 2; idx=idx+1)begin
            //for( loop =0; loop < 1; loop=loop+1) begin 
            for( loop =0; loop < 2**idx; loop=loop+1) begin 
                seed = $time + $realtime + $stime + loop + idx;
                seed = $urandom(seed);
                //random cnt wdata
                cnt_wdata[31:0] = $urandom(seed); 
                cnt_wdata[63:32]= $urandom(seed>>1);
                test_bench.apb_wr(ADDR_TDR0, cnt_wdata[31:0]);
                test_bench.apb_wr(ADDR_TDR1, cnt_wdata[63:32]);
                //random test cycle
                test_cycle = $urandom(seed) % 1000;
                //test_cycle = 17;
                $display("t=%10d Test with div_val = %d, loop_idx=%d, test_cycle=%d",$time,idx,loop, test_cycle);
                test_bench.tsk_cfg_golden_cnt( cnt_wdata*(1<<idx) );
                //test_bench.tsk_cfg_golden_cnt( 0 );
                test_bench.apb_wr(ADDR_TCR, idx << 8 | 3);//timer_en = 1, div_en = 1, div_val = idx;
                repeat (test_cycle) @(posedge test_bench.clk);
                //test_bench.apb_wr(ADDR_TCR, idx <<8 | 2);//timer_en = 0
                test_bench.apb_wr(ADDR_THCSR, 32'h1);//halt=1
        
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
                    $display("Expect: %x", exp_value);
                    $display("Actual: %x", cnt);
		        	$display("------------------------------------------------");
                end
                test_bench.apb_wr(ADDR_THCSR, 32'h0);//halt=0
                repeat (test_cycle) @(posedge test_bench.clk);
                test_bench.apb_wr(ADDR_THCSR, 32'h1);//halt=1
                
                //store cnt value to another var
                test_bench.apb_rd(ADDR_TDR0, task_rdata);
                cnt1[31:0] = task_rdata;
                test_bench.apb_rd(ADDR_TDR1, task_rdata);
                cnt1[63:32] = task_rdata;
                
                //if( cnt[0] == 1 ) begin //odd
                //    exp_value = cnt + ((test_bench.golden_cnt + 1 - (cnt*(1<<idx))) >> idx);
                //end else begin
                    exp_value = cnt + ((test_bench.golden_cnt - (cnt*(1<<idx))) >> idx);

                //end
                if( cnt1 !== exp_value) begin
		        	$display("------------------------------------------------");
		        	$display("t=%10d FAIL: cnt does not match expect value after halted in div mode",$time);
                    $display("Expect: %d", exp_value);
                    $display("Actual: %d", cnt1);
		        	$display("------------------------------------------------");
                    err=1;
                end else begin
		        	$display("------------------------------------------------");
		        	$display("t=%10d PASSED: cnt matches expect value after halted in div mode ",$time);
                    $display("Expect: %d", exp_value);
                    $display("Actual: %d", cnt1);
		        	$display("------------------------------------------------");
                end

                #10;
                test_bench.apb_wr(ADDR_THCSR, 32'h0);//halt=0
                #100;
                //test_bench.apb_wr(ADDR_TCR, 0);//timer_en = 0
                test_bench.apb_wr(ADDR_TCR, idx << 8 | 2);//timer_en = 1, div_en = 1, div_val = idx;
            end
        end
        

        if( test_bench.err != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");

    end


endtask
