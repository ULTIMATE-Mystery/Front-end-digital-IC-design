task run_test;
    begin
        $display("===================================");
        $display("Test Case: Counter Counting Check");
        $display("===================================");

        sys_reset();

        // Try to read counter value from non-TDR register
        apb_acc(`TCR_OFFSET, 1'b0, 32'h0, 4'h0, 32'h0, 1'b0, 1'b1, 64'h0);
        apb_acc(`TCMP0_OFFSET, 1'b0, 32'h0, 4'h0, 32'h0, 1'b0, 1'b1, 64'h0); 
        apb_acc(`TIER_OFFSET, 1'b0, 32'h0, 4'h0, 32'h0, 1'b0, 1'b1, 64'h0);
        
        // Initialize test environment
        sys_reset();
        dbg_mode = 1'b1;
        //----------------------------------------
        // Test ID 26: Check counting at boundary of TDR0/1
        //----------------------------------------
        $display("\n[Test ID 26] Check counting at boundary of TDR0 is correct");
        apb_wr(`TDR0_OFFSET, 32'hFFFF_FF00, 4'hF);
        // Set timer_en = 1
        apb_wr(`TCR_OFFSET, 32'h0000_0001, 4'hF);
        // Wait 256 cycles
        wait_cycles(252);
        // Halt the counter 
        apb_wr(`THCSR_OFFSET, 32'h0000_0001, 4'hF); // Set halt_req
        // Read TDR0 & TDR1
        chk_cnt_val(64'h0000_0001_0000_0000);
        // Clear halt 
        apb_wr(`THCSR_OFFSET, 32'h0000_0000, 4'hF); // Clear halt_req
        wait_cycles(77);
        chk_cnt_val(64'h0000_0001_0000_0053);

        //----------------------------------------
        // Test ID 27: Set TDR0/TDR1
        //----------------------------------------
        $display("\n[Test ID 27] Set TDR0/TDR1 then check counting");
        // Set timer_en = 0
        apb_wr(`TCR_OFFSET, 32'h0000_0000, 4'hF);
        // Set TDR0 = 0xffff_ff00
        apb_wr(`TDR0_OFFSET, 32'hFFFF_FF00, 4'hF);
        // Set TDR1 = 0xffff_ffff
        apb_wr(`TDR1_OFFSET, 32'hFFFF_FFFF, 4'hF);
        // Set timer_en = 1
        apb_wr(`TCR_OFFSET, 32'h0000_0001, 4'hF);
        // Wait 256 cycles
        wait_cycles(250);
        // Read TDR0 & TDR1
        chk_cnt_val(64'h0000_0000_0000_0000);
        wait_cycles(77);
        chk_cnt_val(64'h0000_0000_0000_0054);

        //----------------------------------------
        // Test ID 28: Counter's value can be read from TDR0/TDR1
        //----------------------------------------
        $display("\n[Test ID 28] Check counting at boundary of TDR0/1");
        // Set timer_en = 0
        apb_wr(`TCR_OFFSET, 32'h0000_0000, 4'hF);
        // Set TDR0 = 0xffff_ff00
        apb_wr(`TDR0_OFFSET, 32'hFFFF_FF00, 4'hF);
        // Set TDR1 = 0xffff_ffff
        apb_wr(`TDR1_OFFSET, 32'hFFFF_FFFF, 4'hF);
        // Set timer_en = 1
        apb_wr(`TCR_OFFSET, 32'h0000_0001, 4'hF);
        // Wait 256 cycles
        wait_cycles(252);
        // Halt the counter 
        apb_wr(`THCSR_OFFSET, 32'h0000_0001, 4'hF); // Set halt_req
        // Read TDR0 & TDR1
        chk_cnt_val(64'h0000_0000_0000_0000);
        // Clear halt 
        apb_wr(`THCSR_OFFSET, 32'h0000_0000, 4'hF); // Clear halt_req
        wait_cycles(77);
        chk_cnt_val(64'h0000_0000_0000_0053);

        //----------------------------------------
        // Test ID 29: Update TDR0/TDR1 when timer is working
        //----------------------------------------
        $display("\n[Test ID 29] Update TDR0/TDR1 during timer operation");
        // Set timer_en = 0
        apb_wr(`TCR_OFFSET, 32'h0000_0000, 4'hF);
        // Set timer_en = 1
        apb_wr(`TCR_OFFSET, 32'h0000_0001, 4'hF);
        wait_cycles(250);
        // Read TDR0 & TDR1
        chk_cnt_val(64'h0000_0000_0000_0100);
        wait_cycles(25);
        chk_cnt_val(64'h0000_0000_0000_0120);
        // Set TDR1 = 0x0
        apb_wr(`TDR1_OFFSET, 32'h0000_0000, 4'hF);
        // Set TDR0 = 0xffff_ff00
        apb_wr(`TDR0_OFFSET, 32'hFFFF_FF00, 4'hF);
        wait_cycles(251);
        chk_cnt_val(64'h0000_0001_0000_0000);
        wait_cycles(77);
        chk_cnt_val(64'h0000_0001_0000_0054);

        //----------------------------------------
        // Test ID 30: Timer to be reset and resumed
        //----------------------------------------
        $display("\n[Test ID 30] Timer reset and resume test");
        // Setting for counter normally
        wait_cycles(77);
        chk_cnt_val(64'h0000_0001_0000_00A8);
        // Set timer_en = 0
        apb_wr(`TCR_OFFSET, 32'h0000_0000, 4'hF);
        // Check counter is reset to 0
        chk_cnt_val(64'h0000_0000_0000_0000);

        //----------------------------------------
        // Test ID 31: Can set value to TDR0/1 while timer_en is 0
        //----------------------------------------
        $display("\n[Test ID 31] TDR0/1 write while timer disabled");
        // Setting for counter normally
        apb_wr(`TCR_OFFSET, 32'h0000_0001, 4'hF);
        wait_cycles(77);
        chk_cnt_val(64'h0000_0000_0000_0053);
        apb_wr(`TCR_OFFSET, 32'h0000_0000, 4'hF);
        // Write value to TDR0/1 and read back
        apb_wr(`TDR0_OFFSET, 32'hFFFF_FF00, 4'hF);
        apb_wr(`TDR1_OFFSET, 32'hFFFF_FFFF, 4'hF);
        chk_cnt_val(64'hFFFF_FFFF_FFFF_FF00);

        //----------------------------------------
        // Test ID 34: Counter behavior when overflow
        //----------------------------------------
        $display("\n[Test ID 34] Counter overflow behavior");
        // Setting for overflow occurs
        apb_wr(`TDR0_OFFSET, 32'hFFFF_FFF0, 4'hF);
        apb_wr(`TDR1_OFFSET, 32'hFFFF_FFFF, 4'hF);
        apb_wr(`TCR_OFFSET, 32'h0000_0001, 4'hF);
        // Wait for overflow
        wait_cycles(10);
        chk_cnt_val(64'h0000_0000_0000_0000);
        wait_cycles(20);
        // Read TDR0/1 to verify counter continues counting
        chk_cnt_val(64'h0000_0000_0000_001b);
    end
endtask