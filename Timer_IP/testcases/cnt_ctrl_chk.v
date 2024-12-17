task run_test;
    begin
        $display("===================================");
        $display("Test Case: Counter Control Check");
        $display("===================================");
        
        // Initialize test environment
        sys_reset();
        
        //----------------------------------------
        // Test ID 32: Check counter works normally after timer_en changed from 1->0->1
        //----------------------------------------
        $display("\n[Test ID 32] Counter works normally after timer_en toggle");
        // Enable timer
        apb_wr(`TCR_OFFSET, 32'h0000_0003, 4'b0001); // timer_en = 1, div_val = 1, div_en = 1
        wait_cycles(100);
        chk_cnt_val(64'h0000_0000_0000_0035);
        
        // Disable timer
        apb_wr(`TCR_OFFSET, 32'h0000_0102, 4'hF); // timer_en = 0
        chk_cnt_val(64'h0000_0000_0000_0000);

        //Change div_en/div_val
        apb_wr(`TCR_OFFSET, 32'h0000_0202, 4'hF);
        
        // Re-enable timer and verify counting
        apb_wr(`TCR_OFFSET, 32'h0000_0203, 4'hF); // timer_en = 1
        wait_cycles(2);
        chk_cnt_val(64'h0000_0000_0000_0002);

        //----------------------------------------
        // Test ID 35: Default mode (div_en = 0)
        //----------------------------------------
        $display("\n[Test ID 35] Counter default mode");
        apb_wr(`TCR_OFFSET, 32'h0000_0202, 4'hF); // Reset timer
        apb_wr(`TCR_OFFSET, 32'h0000_0001, 4'hF); // timer_en=1, div_en=0
        wait_cycles(20);
        chk_cnt_val(64'h0000_0000_0000_001a); // Count same as system clock freq

        // Test case 36: Counter control - control mode
        $display("\n[Test ID 36] Counter control mode div_val = 0");
        apb_wr(`TCR_OFFSET, 32'h0000_0000, 4'hF); // Reset timer
        apb_wr(`TCR_OFFSET, 32'h0000_0003, 4'hF); // timer_en=1, div_en=1, div_val=0
        wait_cycles(20);
        chk_cnt_val(64'h0000_0000_0000_001a); // Count same as system clock freq

        // Test case 37: div_en = 1, div_val = 1
        $display("\n[Test ID 37] Counter control mode div_val = 1");
        apb_wr(`TCR_OFFSET, 32'h0000_0002, 4'hF); // Reset timer
        apb_wr(`TCR_OFFSET, 32'h0000_0103, 4'hF); // timer_en=1, div_en=1, div_val=1
        wait_cycles(40);
        chk_cnt_val(64'h0000_0000_0000_0017); // Count freq = count/2

        // Test case 38: div_en = 1, div_val = 2
        $display("\n[Test ID 38] Counter control mode div_val = 2");
        apb_wr(`TCR_OFFSET, 32'h0000_0102, 4'hF); // Reset timer
        apb_wr(`TCR_OFFSET, 32'h0000_0203, 4'hF); // timer_en=1, div_en=1, div_val=2
        wait_cycles(80);
        chk_cnt_val(64'h0000_0000_0000_0015); // Count freq = count/4

        // Test case 39: div_en = 1, div_val = 3
        $display("\n[Test ID 39] Counter control mode div_val = 3");
        apb_wr(`TCR_OFFSET, 32'h0000_0202, 4'hF); // Reset timer
        apb_wr(`TCR_OFFSET, 32'h0000_0303, 4'hF); // timer_en=1, div_en=1, div_val=3
        wait_cycles(160);
        chk_cnt_val(64'h0000_0000_0000_0014); // Count freq = count/8

        // Test case 40: div_en = 1, div_val = 4
        $display("\n[Test ID 40] Counter control mode div_val = 4");
        apb_wr(`TCR_OFFSET, 32'h0000_0302, 4'hF); // Reset timer
        apb_wr(`TCR_OFFSET, 32'h0000_0403, 4'hF); // timer_en=1, div_en=1, div_val=4
        wait_cycles(320);
        chk_cnt_val(64'h0000_0000_0000_0014); // Count freq = count/16

        // Test case 41: div_en = 1, div_val = 5
        $display("\n[Test ID 41] Counter control mode div_val = 5");
        apb_wr(`TCR_OFFSET, 32'h0000_0402, 4'hF); // Reset timer
        apb_wr(`TCR_OFFSET, 32'h0000_0503, 4'hF); // timer_en=1, div_en=1, div_val=5
        wait_cycles(640);
        chk_cnt_val(64'h0000_0000_0000_0014); // Count freq = count/32

        // Test case 42: div_en = 1, div_val = 6
        $display("\n[Test ID 42] Counter control mode div_val = 6");
        apb_wr(`TCR_OFFSET, 32'h0000_0502, 4'hF); // Reset timer
        apb_wr(`TCR_OFFSET, 32'h0000_0603, 4'hF); // timer_en=1, div_en=1, div_val=6
        wait_cycles(1280);
        chk_cnt_val(64'h0000_0000_0000_0014); // Count freq = count/64

        // Test case 43: div_en = 1, div_val = 7
        $display("\n[Test ID 43] Counter control mode div_val = 7");
        apb_wr(`TCR_OFFSET, 32'h0000_0602, 4'hF); // Reset timer
        apb_wr(`TCR_OFFSET, 32'h0000_0703, 4'hF); // timer_en=1, div_en=1, div_val=7
        wait_cycles(2560);
        chk_cnt_val(64'h0000_0000_0000_0014); // Count freq = count/128

        // Test case 44: div_en = 1, div_val = 8
        $display("\n[Test ID 44] Counter control mode div_val = 8");
        apb_wr(`TCR_OFFSET, 32'h0000_0702, 4'hF); // Reset timer
        apb_wr(`TCR_OFFSET, 32'h0000_0803, 4'hF); // timer_en=1, div_en=1, div_val=8
        wait_cycles(5120);
        chk_cnt_val(64'h0000_0000_0000_0014); // Count freq = count/256

        // Test case 45: div_val but does not set div_en
        $display("\n[Test ID 45] Counter control mode invalid div_val");
        apb_wr(`TCR_OFFSET, 32'h0000_0802, 4'hF); // Reset timer
        apb_wr(`TCR_OFFSET, 32'h0000_0201, 4'hF); // timer_en=1, div_en=0, div_val=2
        wait_cycles(20);
        chk_cnt_val(64'h0000_0000_0000_001a); // Counter should count normally without division
    end
endtask