task run_test();
    reg [31:0]  task_rdata;
    reg [63:0]  cnt;
    reg [63:0]  cnt_save;
    begin
  	    
        $display("====================================");	
  	    $display("====== Test Case: check Interrupt===");
  	    $display("====================================");	
        
        test_bench.apb_wr(ADDR_TCMP0, 32'hff);//cmp = ff
        test_bench.apb_wr(ADDR_TCMP1, 32'h0);
        test_bench.apb_wr(ADDR_TIER, 32'h1);//enable interrupt
        test_bench.apb_wr(ADDR_TCR, 32'h1);//timer_en=1

        repeat(256+5) @(posedge test_bench.clk);

        if( test_bench.tim_int === 1 ) begin
			$display("--------------------------------------------------------");
			$display("t=%10d PASSED: interrupt is asserted",$time);
			$display("--------------------------------------------------------");

        end else begin
			$display("--------------------------------------------------------");
			$display("t=%10d FAILED: interrupt does not asserted",$time);
			$display("--------------------------------------------------------");
            err = 1;
        end
        
        $display("Check interrupt status is 1");
        test_bench.apb_rd( ADDR_TISR, task_rdata);
        test_bench.cmp_data( ADDR_TISR, task_rdata, 32'h1, 32'hffff_ffff);


        #100;
        $display("assert reset");

        test_bench.rst_n = 1'b0;
        #100;
        @(posedge test_bench.clk);
        #1;
        $display("release reset");
        rst_n = 1'b1;

        $display("config and assert interrupt again");
        
        //config for the counter model 
        test_bench.tsk_cfg_golden_cnt( 0 );
        test_bench.apb_wr(ADDR_TCMP0, 32'hff);//cmp = ff
        test_bench.apb_wr(ADDR_TCMP1, 32'h0);
        test_bench.apb_wr(ADDR_TIER, 32'h1);//enable interrupt
        test_bench.apb_wr(ADDR_TCR, 32'h1);//timer_en=1

        repeat(256+5) @(posedge test_bench.clk);

        if( test_bench.tim_int === 1 ) begin
			$display("--------------------------------------------------------");
			$display("t=%10d PASSED: interrupt is asserted",$time);
			$display("--------------------------------------------------------");

        end else begin
			$display("--------------------------------------------------------");
			$display("t=%10d FAILED: interrupt does not asserted",$time);
			$display("--------------------------------------------------------");
            err = 1;
        end
        //store cnt value
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        cnt_save[31:0] = task_rdata;
        test_bench.apb_rd(ADDR_TDR1, task_rdata);
        cnt_save[63:32] = task_rdata;
        
        $display("Check interrupt status is 1");
        test_bench.apb_rd( ADDR_TISR, task_rdata);
        test_bench.cmp_data( ADDR_TISR, task_rdata, 32'h1, 32'hffff_ffff);


        $display("Write 0 to interrupt status and check tim_int and int_st");
        test_bench.apb_wr(ADDR_TISR, 32'h0);
        
        if( test_bench.tim_int === 1 ) begin
			$display("--------------------------------------------------------");
			$display("t=%10d PASSED: interrupt is kept asserting",$time);
			$display("--------------------------------------------------------");

        end else begin
			$display("--------------------------------------------------------");
			$display("t=%10d FAILED: interrupt is negated",$time);
			$display("--------------------------------------------------------");
            err = 1;
        end
        test_bench.apb_rd( ADDR_TISR, task_rdata);
        test_bench.cmp_data( ADDR_TISR, task_rdata, 32'h1, 32'hffff_ffff);

        repeat(256) @(posedge test_bench.clk);
        
        $display("Check counter continue counting when interrupt asserts");
        test_bench.apb_rd(ADDR_TDR0, task_rdata);
        cnt[31:0] = task_rdata;
        test_bench.apb_rd(ADDR_TDR1, task_rdata);
        cnt[63:32] = task_rdata;


        if( cnt === cnt_save) begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: cnt does NOT continue counting when interrupt is asserted ",$time);
			$display("------------------------------------------------");
            err=1;
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d PASSED: cnt continue counting when interrupt is asserted ",$time);
			$display("------------------------------------------------");
        end

        $display("clear interrupt_en and check tim_int is masked");
        test_bench.apb_wr(ADDR_TIER, 32'h0);
        if( test_bench.tim_int === 1 ) begin
			$display("--------------------------------------------------------");
			$display("t=%10d FAILED: interrupt is NOT negated when disabled",$time);
			$display("--------------------------------------------------------");
            err = 1;
        end else begin
			$display("--------------------------------------------------------");
			$display("t=%10d PASSED: interrupt is negated when disabled",$time);
			$display("--------------------------------------------------------");
        end
        $display("int_st still keeps 1");
        test_bench.apb_rd( ADDR_TISR, task_rdata);
        test_bench.cmp_data( ADDR_TISR, task_rdata, 32'h1, 32'hffff_ffff);

        $display("set interrupt_en again and check tim_int is asserted");
        test_bench.apb_wr(ADDR_TIER, 32'h1);
        if( test_bench.tim_int === 1 ) begin
			$display("--------------------------------------------------------------------");
			$display("t=%10d PASSED: interrupt is asserted again when re-enable interrupt",$time);
			$display("--------------------------------------------------------------------");

        end else begin
			$display("-----------------------------------------------------------------------");
			$display("t=%10d FAILED: interrupt is not asserted again when re-enable interrupt",$time);
			$display("-----------------------------------------------------------------------");
            err = 1;
        end

        $display("write int_st=1 and check interrupt and int_st");
        test_bench.apb_wr(ADDR_TISR, 32'h1);

        repeat (5) @(posedge test_bench.clk);
        
        if( test_bench.tim_int === 1 ) begin
			$display("--------------------------------------------------------------");
			$display("t=%10d FAILED: interrupt is kept asserting when write int_st=1",$time);
			$display("--------------------------------------------------------------");
            err = 1;

        end else begin
			$display("--------------------------------------------------------");
			$display("t=%10d PASSED: interrupt is negated when write int_st=1 ",$time);
			$display("--------------------------------------------------------");
        end
        test_bench.apb_rd( ADDR_TISR, task_rdata);
        test_bench.cmp_data( ADDR_TISR, task_rdata, 32'h0, 32'hffff_ffff);
        


        $display("manual condition when generate interrupt by TDR0/1");
        //timer_en is 0
        test_bench.apb_wr(ADDR_TCR, 32'h0);
        //clear TDR0/1
        test_bench.apb_wr(ADDR_TDR0, 32'h0);
        test_bench.apb_wr(ADDR_TDR1, 32'h0);
        test_bench.apb_wr(ADDR_TIER, 32'h0);
        test_bench.apb_wr(ADDR_TDR0, 32'hff);
        repeat (5) @(posedge test_bench.clk);
        //interrupt is still 0
        if( test_bench.tim_int === 1 ) begin
			$display("--------------------------------------------------------------");
			$display("t=%10d FAILED: interrupt is asserted even if int_en is 0",$time);
			$display("--------------------------------------------------------------");
            err = 1;

        end else begin
			$display("--------------------------------------------------------");
			$display("t=%10d PASSED: interrupt is not asserted when int_en is 0",$time);
			$display("--------------------------------------------------------");
        end
        
        $display("Check interrupt status is 1");
        test_bench.apb_rd( ADDR_TISR, task_rdata);
        test_bench.cmp_data( ADDR_TISR, task_rdata, 32'h1, 32'hffff_ffff);
        //enable interrupt
        test_bench.apb_wr(ADDR_TIER, 32'h1);
        //interrupt now asserted
        if( test_bench.tim_int === 1 ) begin
			$display("--------------------------------------------------------");
			$display("t=%10d PASSED: interrupt is asserted",$time);
			$display("--------------------------------------------------------");

        end else begin
			$display("--------------------------------------------------------");
			$display("t=%10d FAILED: interrupt does not asserted",$time);
			$display("--------------------------------------------------------");
            err = 1;
        end


        $display("write int_st=1 and check interrupt and int_st, should be kept");
        test_bench.apb_wr(ADDR_TISR, 32'h1);

        repeat (5) @(posedge test_bench.clk);
        if( test_bench.tim_int === 1 ) begin
			$display("--------------------------------------------------------");
			$display("t=%10d PASSED: interrupt is asserted in muanal mode",$time);
			$display("--------------------------------------------------------");

        end else begin
			$display("--------------------------------------------------------");
			$display("t=%10d FAILED: interrupt does not asserted in manual mode",$time);
			$display("--------------------------------------------------------");
            err = 1;
        end
        
        $display("Check interrupt status is 1");
        test_bench.apb_rd( ADDR_TISR, task_rdata);
        test_bench.cmp_data( ADDR_TISR, task_rdata, 32'h1, 32'hffff_ffff);
        
        $display("change TDR0 1 unit and check again");
        test_bench.apb_wr(ADDR_TDR0, 32'hfe);
        
        test_bench.apb_wr(ADDR_TISR, 32'h1);

        repeat (5) @(posedge test_bench.clk);
        
        if( test_bench.tim_int === 1 ) begin
			$display("--------------------------------------------------------------");
			$display("t=%10d FAILED: interrupt is kept asserting when write int_st=1",$time);
			$display("--------------------------------------------------------------");
            err = 1;

        end else begin
			$display("--------------------------------------------------------");
			$display("t=%10d PASSED: interrupt is negated when write int_st=1 ",$time);
			$display("--------------------------------------------------------");
        end
        test_bench.apb_rd( ADDR_TISR, task_rdata);
        test_bench.cmp_data( ADDR_TISR, task_rdata, 32'h0, 32'hffff_ffff);
        

        if( test_bench.err != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");

    end


endtask
