task run_test;
    begin
        $display("===================================");
        $display("Test Case: Register Byte Access Check");
        $display("===================================");
        
        // Initialize test environment
        sys_reset();

        //----------------------------------------
        // Test ID 3: TCR byte access
        //----------------------------------------
        $display("\n[Test ID 3] TCR Register Byte Access");
        // Write with different pstrb patterns and check each byte
        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = `TCR_OFFSET;
        tim_pwdata = 32'hFFFF_FFFF;
        tim_pstrb = 4'h1;
        $display("t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b", $time, tim_paddr, tim_pwdata, tim_pstrb);
        @(posedge sys_clk);
        
        // Assert penable 
        tim_penable = 1'b1;

        // Complete the transaction
        wait (tim_pready);
        #1;
        if (tim_pslverr == 1'b0) begin
            $display("t = %0t PASS: pslverr is not asserted", $time);
        end else begin
            $display("t = %0t FAIL: pslverr is asserted", $time);
            test_passed = 1'b0;
        end

        @(posedge sys_clk);
        tim_psel = 1'b0;
        tim_penable = 1'b0;
        tim_pwrite = 1'b0;
        @(posedge sys_clk);
        
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0103);
        sys_reset();
        
        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = `TCR_OFFSET;
        tim_pwdata = 32'hFFFF_F5FF;
        tim_pstrb = 4'h2;
        $display("t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b", $time, tim_paddr, tim_pwdata, tim_pstrb);
        @(posedge sys_clk);
        
        // Assert penable 
        tim_penable = 1'b1;

        // Complete the transaction
        wait (tim_pready);
        #1;
        if (tim_pslverr == 1'b0) begin
            $display("t = %0t PASS: pslverr is not asserted", $time);
        end else begin
            $display("t = %0t FAIL: pslverr is asserted", $time);
            test_passed = 1'b0;
        end

        @(posedge sys_clk);
        tim_psel = 1'b0;
        tim_penable = 1'b0;
        tim_pwrite = 1'b0;
        @(posedge sys_clk);
        
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0500);
        sys_reset();
        
        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = `TCR_OFFSET;
        tim_pwdata = 32'hFFFF_FFFF;
        tim_pstrb = 4'h4;
        $display("t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b", $time, tim_paddr, tim_pwdata, tim_pstrb);
        @(posedge sys_clk);
        
        // Assert penable 
        tim_penable = 1'b1;

        // Complete the transaction
        wait (tim_pready);
        #1;
        if (tim_pslverr == 1'b0) begin
            $display("t = %0t PASS: pslverr is not asserted", $time);
        end else begin
            $display("t = %0t FAIL: pslverr is asserted", $time);
            test_passed = 1'b0;
        end

        @(posedge sys_clk);
        tim_psel = 1'b0;
        tim_penable = 1'b0;
        tim_pwrite = 1'b0;
        @(posedge sys_clk);
        
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0100);
        sys_reset();
        
        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = `TCR_OFFSET;
        tim_pwdata = 32'hFFFF_FFFF;
        tim_pstrb = 4'h8;
        $display("t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b", $time, tim_paddr, tim_pwdata, tim_pstrb);
        @(posedge sys_clk);
        
        // Assert penable 
        tim_penable = 1'b1;

        // Complete the transaction
        wait (tim_pready);
        #1;
        if (tim_pslverr == 1'b0) begin
            $display("t = %0t PASS: pslverr is not asserted", $time);
        end else begin
            $display("t = %0t FAIL: pslverr is asserted", $time);
            test_passed = 1'b0;
        end

        @(posedge sys_clk);
        tim_psel = 1'b0;
        tim_penable = 1'b0;
        tim_pwrite = 1'b0;
        @(posedge sys_clk);
        
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0100);    
        sys_reset();

        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = `TCR_OFFSET;
        tim_pwdata = 32'h5555_5555;
        tim_pstrb = 4'h3;
        $display("t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b", $time, tim_paddr, tim_pwdata, tim_pstrb);
        @(posedge sys_clk);
        
        // Assert penable 
        tim_penable = 1'b1;

        // Complete the transaction
        wait (tim_pready);
        #1;
        if (tim_pslverr == 1'b0) begin
            $display("t = %0t PASS: pslverr is not asserted", $time);
        end else begin
            $display("t = %0t FAIL: pslverr is asserted", $time);
            test_passed = 1'b0;
        end

        @(posedge sys_clk);
        tim_psel = 1'b0;
        tim_penable = 1'b0;
        tim_pwrite = 1'b0;
        @(posedge sys_clk);
        
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0501);
        sys_reset();

        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = `TCR_OFFSET;
        tim_pwdata = 32'hFFFF_FFFF;
        tim_pstrb = 4'hC;
        $display("t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b", $time, tim_paddr, tim_pwdata, tim_pstrb);
        @(posedge sys_clk);
        
        // Assert penable 
        tim_penable = 1'b1;

        // Complete the transaction
        wait (tim_pready);
        #1;
        if (tim_pslverr == 1'b0) begin
            $display("t = %0t PASS: pslverr is not asserted", $time);
        end else begin
            $display("t = %0t FAIL: pslverr is asserted", $time);
            test_passed = 1'b0;
        end
        
        @(posedge sys_clk);
        tim_psel = 1'b0;
        tim_penable = 1'b0;
        tim_pwrite = 1'b0;
        @(posedge sys_clk);
        
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0100);

        // First enable timer with default div_val
        apb_wr(`TCR_OFFSET, 32'h0000_0001, 4'h1);
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0101);

        // Now try to write with strb[0]=0, keeping same div_val
        apb_wr(`TCR_OFFSET, 32'h0000_0100, 4'h2);  // strb=0010, data keeps same div_val
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0101);    // Should maintain timer enabled

        sys_reset();

        //----------------------------------------
        // Test ID 6: TDR0 byte access
        //----------------------------------------
        $display("\n[Test ID 6] TDR0 Register Byte Access");
        sys_reset();
        // Write each byte and verify
        apb_wr(`TDR0_OFFSET, 32'h1111_1111, 4'h1);
        apb_rd_chk(`TDR0_OFFSET, 32'h0000_0011);

        apb_wr(`TDR0_OFFSET, 32'h2222_2222, 4'h2);
        apb_rd_chk(`TDR0_OFFSET, 32'h0000_2211);

        apb_wr(`TDR0_OFFSET, 32'h3333_3333, 4'h4);
        apb_rd_chk(`TDR0_OFFSET, 32'h0033_2211);

        apb_wr(`TDR0_OFFSET, 32'h4444_4444, 4'h8);
        apb_rd_chk(`TDR0_OFFSET, 32'h4433_2211);

        apb_wr(`TDR0_OFFSET, 32'h5555_5555, 4'h3);
        apb_rd_chk(`TDR0_OFFSET, 32'h4433_5555);

        apb_wr(`TDR0_OFFSET, 32'h6666_6666, 4'hc);
        apb_rd_chk(`TDR0_OFFSET, 32'h6666_5555);

        //----------------------------------------
        // Test ID 9: TDR1 byte access
        //----------------------------------------
        $display("\n[Test ID 9] TDR1 Register Byte Access");
        sys_reset();
        // Write each byte and verify
        apb_wr(`TDR1_OFFSET, 32'h1111_1111, 4'h1);
        apb_rd_chk(`TDR1_OFFSET, 32'h0000_0011);

        apb_wr(`TDR1_OFFSET, 32'h2222_2222, 4'h2);
        apb_rd_chk(`TDR1_OFFSET, 32'h0000_2211);

        apb_wr(`TDR1_OFFSET, 32'h3333_3333, 4'h4);
        apb_rd_chk(`TDR1_OFFSET, 32'h0033_2211);

        apb_wr(`TDR1_OFFSET, 32'h4444_4444, 4'h8);
        apb_rd_chk(`TDR1_OFFSET, 32'h4433_2211);

        apb_wr(`TDR1_OFFSET, 32'h5555_5555, 4'h3);
        apb_rd_chk(`TDR1_OFFSET, 32'h4433_5555);

        apb_wr(`TDR1_OFFSET, 32'h6666_6666, 4'hc);
        apb_rd_chk(`TDR1_OFFSET, 32'h6666_5555);

        //----------------------------------------
        // Test ID 12: TCMP0 byte access
        //----------------------------------------
        $display("\n[Test ID 12] TCMP0 Register Byte Access");
        sys_reset();
        // Write each byte and verify
        apb_wr(`TCMP0_OFFSET, 32'h1111_1111, 4'h1);
        apb_rd_chk(`TCMP0_OFFSET, 32'hFFFF_FF11);

        apb_wr(`TCMP0_OFFSET, 32'h2222_2222, 4'h2);
        apb_rd_chk(`TCMP0_OFFSET, 32'hFFFF_2211);

        apb_wr(`TCMP0_OFFSET, 32'h3333_3333, 4'h4);
        apb_rd_chk(`TCMP0_OFFSET, 32'hFF33_2211);

        apb_wr(`TCMP0_OFFSET, 32'h4444_4444, 4'h8);
        apb_rd_chk(`TCMP0_OFFSET, 32'h4433_2211);

        apb_wr(`TCMP0_OFFSET, 32'h5555_5555, 4'h3);
        apb_rd_chk(`TCMP0_OFFSET, 32'h4433_5555);

        apb_wr(`TCMP0_OFFSET, 32'h6666_6666, 4'hc);
        apb_rd_chk(`TCMP0_OFFSET, 32'h6666_5555);

        //----------------------------------------
        // Test ID 15: TCMP1 byte access
        //----------------------------------------
        $display("\n[Test ID 15] TCMP1 Register Byte Access");
        sys_reset();
        // Write each byte and verify
        apb_wr(`TCMP1_OFFSET, 32'h1111_1111, 4'h1);
        apb_rd_chk(`TCMP1_OFFSET, 32'hFFFF_FF11);

        apb_wr(`TCMP1_OFFSET, 32'h2222_2222, 4'h2);
        apb_rd_chk(`TCMP1_OFFSET, 32'hFFFF_2211);

        apb_wr(`TCMP1_OFFSET, 32'h3333_3333, 4'h4);
        apb_rd_chk(`TCMP1_OFFSET, 32'hFF33_2211);

        apb_wr(`TCMP1_OFFSET, 32'h4444_4444, 4'h8);
        apb_rd_chk(`TCMP1_OFFSET, 32'h4433_2211);

        apb_wr(`TCMP1_OFFSET, 32'h5555_5555, 4'h3);
        apb_rd_chk(`TCMP1_OFFSET, 32'h4433_5555);

        apb_wr(`TCMP1_OFFSET, 32'h6666_6666, 4'hc);
        apb_rd_chk(`TCMP1_OFFSET, 32'h6666_5555);

        //----------------------------------------
        // Test ID 18: TIER byte access
        //----------------------------------------
        $display("\n[Test ID 18] TIER Register Byte Access");
        sys_reset();
        // Only bit 0 is valid
        apb_wr(`TIER_OFFSET, 32'h1111_1111, 4'h1);
        apb_rd_chk(`TIER_OFFSET, 32'h0000_0001);

        apb_wr(`TIER_OFFSET, 32'h2222_2222, 4'h2);
        apb_rd_chk(`TIER_OFFSET, 32'h0000_0001);

        apb_wr(`TIER_OFFSET, 32'h3333_3333, 4'h4);
        apb_rd_chk(`TIER_OFFSET, 32'h0000_0001);

        apb_wr(`TIER_OFFSET, 32'h4444_4444, 4'h8);
        apb_rd_chk(`TIER_OFFSET, 32'h0000_0001);

        apb_wr(`TIER_OFFSET, 32'h6666_6666, 4'h3);
        apb_rd_chk(`TIER_OFFSET, 32'h0000_0000);

        apb_wr(`TIER_OFFSET, 32'h7777_7777, 4'hc);
        apb_rd_chk(`TIER_OFFSET, 32'h0000_0000);

        //----------------------------------------
        // Test ID 18: TISR byte access
        //----------------------------------------
        $display("\n[Test ID 18] TISR Register Byte Access");
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

        apb_wr(`TISR_OFFSET, 32'hFFFF_FFFF, 4'h2);
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0001);

        apb_wr(`TISR_OFFSET, 32'hFFFF_FFFF, 4'h4);
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0001);

        apb_wr(`TISR_OFFSET, 32'hFFFF_FFFF, 4'h8);
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0001);

        apb_wr(`TISR_OFFSET, 32'hFFFF_FFFF, 4'hC);
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0001);

        apb_wr(`TISR_OFFSET, 32'h0000_0001, 4'h1);
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0000);

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

        apb_wr(`TISR_OFFSET, 32'h0000_0001, 4'h3);
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0000);

        //----------------------------------------
        // Test ID 23: THCSR byte access
        //----------------------------------------
        $display("\n[Test ID 23] THCSR Register Byte Access");
        sys_reset();
        // Only bit 0 is valid
        apb_wr(`THCSR_OFFSET, 32'h1111_1111, 4'h1);
        apb_rd_chk(`THCSR_OFFSET, 32'h0000_0001);

        apb_wr(`THCSR_OFFSET, 32'h2222_2222, 4'h2);
        apb_rd_chk(`THCSR_OFFSET, 32'h0000_0001);

        apb_wr(`THCSR_OFFSET, 32'h3333_3333, 4'h4);
        apb_rd_chk(`THCSR_OFFSET, 32'h0000_0001);

        apb_wr(`THCSR_OFFSET, 32'h4444_4444, 4'h8);
        apb_rd_chk(`THCSR_OFFSET, 32'h0000_0001);

        apb_wr(`THCSR_OFFSET, 32'h6666_6666, 4'h3);
        apb_rd_chk(`THCSR_OFFSET, 32'h0000_0000);

        apb_wr(`THCSR_OFFSET, 32'h7777_7777, 4'hc);
        apb_rd_chk(`THCSR_OFFSET, 32'h0000_0000);
    end
endtask