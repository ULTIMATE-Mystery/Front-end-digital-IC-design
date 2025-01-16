task run_test;
    begin
        $display("===================================");
        $display("Test Case: Counter Halt Check");
        $display("===================================");
        
        // Initialize test environment
        sys_reset();

        //----------------------------------------
        // Test ID 46: Counter is halted when debug mode is High and can be resumed
        //----------------------------------------
        $display("\n[Test ID 46] Counter halt and resume in debug mode");
        
        // Set debug mode first
        dbg_mode = 1'b1;
        // Start counter
        apb_wr(`TCR_OFFSET, 32'h0000_0503, 4'hF);
        wait_cycles(100);
        
        // Request halt
        apb_wr(`THCSR_OFFSET, 32'h0000_0001, 4'hF);
        // Check halt ack is 1
        apb_rd_chk(`THCSR_OFFSET, 32'h0000_0003);
        chk_cnt_val(64'h0000_0000_0000_0003);

        // Check counter has stopped
        wait_cycles(70);
        chk_cnt_val(64'h0000_0000_0000_0003);
        
        // Clear halt and check counter resumes
        apb_wr(`THCSR_OFFSET, 32'h0000_0000, 4'hF);
        apb_rd_chk(`THCSR_OFFSET, 32'h0000_0000); // halt_ack is 0
        wait_cycles(32);
        chk_cnt_val(64'h0000_0000_0000_0004);

        //----------------------------------------
        // Test ID 47: Counter is not halted when debug mode is Low
        //----------------------------------------
        $display("\n[Test ID 47] Counter not halted in normal mode");
        
        // Reset and start with debug mode low
        sys_reset();
        dbg_mode = 1'b0;
        
        // Start counter
        apb_wr(`TCR_OFFSET, 32'h0000_0403, 4'hF);
        wait_cycles(100);
        
        // Request halt (should not halt since debug_mode is low)
        apb_wr(`THCSR_OFFSET, 32'h0000_0001, 4'hF);
        chk_cnt_val(64'h0000_0000_0000_0006);
        
        // Counter should continue counting
        wait_cycles(50);
        chk_cnt_val(64'h0000_0000_0000_000a);
        
        // Check halt_ack is 0 since we're not in debug mode
        apb_rd_chk(`THCSR_OFFSET, 32'h0000_0001);
    end
endtask