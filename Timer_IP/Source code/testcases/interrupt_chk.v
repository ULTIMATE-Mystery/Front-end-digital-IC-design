task run_test;
    begin
        // Test case 33: Counter continue counting normally when interrupt occurs
        $display("\n[Test] Counter continue counting normally when interrupt occurs");
        sys_reset();
        apb_wr(`TCMP0_OFFSET, 32'h0000_00FF, 4'hF); // Set TCMP0 
        apb_wr(`TCMP1_OFFSET, 32'h0000_0000, 4'hF); // Set TCMP1
        apb_wr(`TCR_OFFSET, 32'h0000_0001, 4'hF); // Enable timer
        apb_wr(`TIER_OFFSET, 32'h0000_0001, 4'hF); // Enable interrupt
        wait_cycles(255);
        if (tim_int == 1'b1) begin
            $display("----------------------------------------");
            $display("t = %0t PASS: Timer interrupt is asserted correctly", $time);
        end else begin
            $display("----------------------------------------");
            $display("t = %0t FAIL: Timer interrupt is not asserted", $time);
            test_passed = 1'b0;
        end
        wait_cycles(77);
        chk_cnt_val(64'h0000_0000_0000_0156); // Counter should continue counting normally
        
        // Test case 59: After reset, timer can work normally
        $display("\n[Test] After reset, timer can work normally");
        apb_wr(`TCMP0_OFFSET, 32'h0000_0ED, 4'hF); // Set TCMP0 
        apb_wr(`TCMP1_OFFSET, 32'h0000_0000, 4'hF); // Set TCMP1
        apb_wr(`TCR_OFFSET, 32'h0000_0000, 4'hF); // Disable timer
        apb_wr(`TCR_OFFSET, 32'h0000_0001, 4'hF); // Enable timer
        wait_cycles(237);
        if (tim_int == 1'b1) begin
            $display("----------------------------------------");
            $display("t = %0t PASS: Timer interrupt is asserted correctly", $time);
        end else begin
            $display("----------------------------------------");
            $display("t = %0t FAIL: Timer interrupt is not asserted", $time);
            test_passed = 1'b0;
        end
        sys_reset();
        if (tim_int == 1'b0) begin
            $display("----------------------------------------");
            $display("t = %0t PASS: Interrupt is cleared correctly", $time);
        end else begin
            $display("----------------------------------------");
            $display("t = %0t FAIL: Interrupt is not cleared", $time);
            test_passed = 1'b0;
        end
        apb_wr(`TCMP0_OFFSET, 32'h0000_00FF, 4'hF); // Set TCMP0 
        apb_wr(`TCMP1_OFFSET, 32'h0000_0000, 4'hF); // Set TCMP1
        apb_wr(`TCR_OFFSET, 32'h0000_0001, 4'hF); // Enable timer
        apb_wr(`TIER_OFFSET, 32'h0000_0001, 4'hF); // Enable interrupt
        wait_cycles(255);
        if (tim_int == 1'b1) begin
            $display("----------------------------------------");
            $display("t = %0t PASS: Timer interrupt is asserted correctly", $time);
        end else begin
            $display("----------------------------------------");
            $display("t = %0t FAIL: Timer interrupt is not asserted", $time);
            test_passed = 1'b0;
        end

        // Test case 60: Set condition for interrupt pending
        $display("\n[Test] Set condition for interrupt pending");
        sys_reset();
        apb_wr(`TCMP0_OFFSET, 32'h0000_00FF, 4'hF); // Set TCMP0 
        apb_wr(`TCMP1_OFFSET, 32'h0000_0000, 4'hF); // Set TCMP1
        apb_wr(`TCR_OFFSET, 32'h0000_0001, 4'hF); // Enable timer
        wait_cycles(255);
        if (tim_int == 1'b0) begin
            $display("t = %0t PASS: Interrupt output is not asserted", $time);
        end else begin
            $display("t = %0t FAIL: Interrupt output is asserted", $time);
            test_passed = 1'b0;
        end
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0001);

        // Test case 61: Clear condition
        $display("\n[Test] Clear condition");
        sys_reset();
        apb_wr(`TCMP0_OFFSET, 32'h0000_00FF, 4'hF); // Set TCMP0 
        apb_wr(`TCMP1_OFFSET, 32'h0000_0000, 4'hF); // Set TCMP1
        apb_wr(`TCR_OFFSET, 32'h0000_0001, 4'hF); // Enable timer
        wait_cycles(255);
        if (tim_int == 1'b0) begin
            $display("t = %0t PASS: Interrupt output is not asserted", $time);
        end else begin
            $display("t = %0t FAIL: Interrupt output is asserted", $time);
            test_passed = 1'b0;
        end
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0001);
        apb_wr(`TISR_OFFSET, 32'h0000_0000, 4'hF); 
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0001);
        apb_wr(`TISR_OFFSET, 32'h0000_0001, 4'hF); // Clear interrupt
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0000);

        // Test case 62: Manual condition
        $display("\n[Test] Manual condition");
        sys_reset();
        apb_wr(`TDR0_OFFSET, 32'hFFFF_FFFF, 4'hF); 
        apb_wr(`TDR1_OFFSET, 32'hFFFF_FFFF, 4'hF); 
        if (tim_int == 1'b0) begin
            $display("t = %0t PASS: Interrupt output is not asserted", $time);
        end else begin
            $display("t = %0t FAIL: Interrupt output is asserted", $time);
            test_passed = 1'b0;
        end
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0001);

        // Test case 63: Interrupt enable
        $display("\n[Test] Interrupt enable");
        sys_reset();
        apb_wr(`TCMP0_OFFSET, 32'h0000_00FF, 4'hF); // Set TCMP0 
        apb_wr(`TCMP1_OFFSET, 32'h0000_0000, 4'hF); // Set TCMP1
        apb_wr(`TIER_OFFSET, 32'h0000_0001, 4'hF); // Enable interrupt
        apb_wr(`TCR_OFFSET, 32'h0000_0001, 4'hF); // Enable timer
        wait_cycles(256);
        if (tim_int == 1'b1) begin
            $display("t = %0t PASS: Interrupt is asserted correctly", $time);
        end else begin
            $display("t = %0t FAIL: Interrupt is not asserted", $time);
            test_passed = 1'b0;
        end
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0001);

        // Test case 64: Clear condition
        $display("\n[Test] Clear condition");
        sys_reset();
        apb_wr(`TCMP0_OFFSET, 32'h0000_00FF, 4'hF); // Set TCMP0 
        apb_wr(`TCMP1_OFFSET, 32'h0000_0000, 4'hF); // Set TCMP1
        apb_wr(`TIER_OFFSET, 32'h0000_0001, 4'hF); // Enable interrupt
        apb_wr(`TCR_OFFSET, 32'h0000_0001, 4'hF); // Enable timer
        wait_cycles(256);
        if (tim_int == 1'b1) begin
            $display("t = %0t PASS: Interrupt is asserted correctly", $time);
        end else begin
            $display("t = %0t FAIL: Interrupt is not asserted", $time);
            test_passed = 1'b0;
        end
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0001);
        apb_wr(`TISR_OFFSET, 32'h0000_0000, 4'hF); 
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0001);
        apb_wr(`TISR_OFFSET, 32'h0000_0001, 4'hF); // Clear interrupt
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0000);
        if (tim_int == 1'b0) begin
            $display("----------------------------------------");
            $display("t = %0t PASS: Interrupt is cleared correctly", $time);
        end else begin
            $display("----------------------------------------");
            $display("t = %0t FAIL: Interrupt is not cleared", $time);
            test_passed = 1'b0;
        end

        // Test case 65: Manual condition
        $display("\n[Test] Manual condition");
        sys_reset();
        apb_wr(`TDR0_OFFSET, 32'hFFFF_FFFF, 4'hF); 
        apb_wr(`TDR1_OFFSET, 32'hFFFF_FFFF, 4'hF); 
        apb_wr(`TIER_OFFSET, 32'h0000_0001, 4'hF); // Enable interrupt
        if (tim_int == 1'b1) begin
            $display("----------------------------------------");
            $display("t = %0t PASS: Timer interrupt is asserted correctly", $time);
        end else begin
            $display("----------------------------------------");
            $display("t = %0t FAIL: Timer interrupt is not asserted", $time);
            test_passed = 1'b0;
        end
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0001);

        // Test case 66: Mask condition
        $display("\n[Test] Mask condition");
        sys_reset();
        apb_wr(`TCMP0_OFFSET, 32'h0000_00FF, 4'hF); // Set TCMP0 
        apb_wr(`TCMP1_OFFSET, 32'h0000_0000, 4'hF); // Set TCMP1
        apb_wr(`TIER_OFFSET, 32'h0000_0001, 4'hF); // Enable interrupt
        apb_wr(`TCR_OFFSET, 32'h0000_0001, 4'hF); // Enable timer
        wait_cycles(256);
        if (tim_int == 1'b1) begin
            $display("t = %0t PASS: Interrupt is asserted correctly", $time);
        end else begin
            $display("t = %0t FAIL: Interrupt is not asserted", $time);
            test_passed = 1'b0;
        end
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0001);
        apb_wr(`TIER_OFFSET, 32'h0000_0000, 4'hF); // Disable interrupt
        if (tim_int == 1'b0) begin
            $display("----------------------------------------");
            $display("t = %0t PASS: Interrupt is cleared correctly", $time);
        end else begin
            $display("----------------------------------------");
            $display("t = %0t FAIL: Interrupt is not cleared", $time);
            test_passed = 1'b0;
        end
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0001);

        // Test case 67: Once asserted, interrupt must be kept
        $display("\n[Test] Once asserted, interrupt must be kept");
        apb_wr(`TCMP0_OFFSET, 32'h0000_0ED, 4'hF); // Set TCMP0 
        apb_wr(`TCMP1_OFFSET, 32'h0000_0000, 4'hF); // Set TCMP1
        apb_wr(`TIER_OFFSET, 32'h0000_0001, 4'hF); // Enable interrupt
        apb_wr(`TCR_OFFSET, 32'h0000_0000, 4'hF); // Disable timer
        apb_wr(`TCR_OFFSET, 32'h0000_0001, 4'hF); // Enable timer
        wait_cycles(237);
        if (tim_int == 1'b1) begin
            $display("----------------------------------------");
            $display("t = %0t PASS: Timer interrupt is asserted correctly", $time);
        end else begin
            $display("----------------------------------------");
            $display("t = %0t FAIL: Timer interrupt is not asserted", $time);
            test_passed = 1'b0;
        end
        apb_wr(`TCR_OFFSET, 32'h0000_0000, 4'hF); // Disable timer
        wait_cycles(5);
        if (tim_int == 1'b1) begin
            $display("----------------------------------------");
            $display("t = %0t PASS: Timer interrupt keeps HIGH", $time);
        end else begin
            $display("----------------------------------------");
            $display("t = %0t FAIL: Timer interrupt don't keep HIGH", $time);
            test_passed = 1'b0;
        end
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0001);
    end

endtask