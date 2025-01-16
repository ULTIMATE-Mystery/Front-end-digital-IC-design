task run_test;
    begin
        $display("===================================");
        $display("Test Case: Register Read/Write Check");
        $display("===================================");
        
        // Initialize test environment
        sys_reset();
        
        //----------------------------------------
        // Test ID 2: TCR R/W access
        //----------------------------------------
        $display("\n[Test ID 2] TCR Register R/W Test");
        // Standard write patterns
        apb_wr(`TCR_OFFSET, 32'h0000_0000, 4'hF);
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0000);
        
        apb_wr(`TCR_OFFSET, 32'hFFFF_FFFF, 4'hF);
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0000); 
        
        apb_wr(`TCR_OFFSET, 32'h5555_5555, 4'hF);
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0501);
        
        apb_wr(`TCR_OFFSET, 32'hAAAA_AAAA, 4'hF);
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0501);

        apb_wr(`TCR_OFFSET, 32'h5AA5_A55A, 4'hF);
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0501);

        //----------------------------------------
        // Test ID 5: TDR0 R/W access
        //----------------------------------------
        $display("\n[Test ID 5] TDR0 Register R/W Test");
        sys_reset();

        apb_wr(`TDR0_OFFSET, 32'h0000_0000, 4'hF);
        apb_rd_chk(`TDR0_OFFSET, 32'h0000_0000);
        
        apb_wr(`TDR0_OFFSET, 32'hFFFF_FFFF, 4'hF);
        apb_rd_chk(`TDR0_OFFSET, 32'hFFFF_FFFF); 
        
        apb_wr(`TDR0_OFFSET, 32'h5555_5555, 4'hF);
        apb_rd_chk(`TDR0_OFFSET, 32'h5555_5555);
        
        apb_wr(`TDR0_OFFSET, 32'hAAAA_AAAA, 4'hF);
        apb_rd_chk(`TDR0_OFFSET, 32'hAAAA_AAAA);

        apb_wr(`TDR0_OFFSET, 32'h5AA5_A55A, 4'hF);
        apb_rd_chk(`TDR0_OFFSET, 32'h5AA5_A55A);

        //----------------------------------------
        // Test ID 8: TDR1 R/W access
        //----------------------------------------
        $display("\n[Test ID 8] TDR1 Register R/W Test");
        apb_wr(`TDR1_OFFSET, 32'h0000_0000, 4'hF);
        apb_rd_chk(`TDR1_OFFSET, 32'h0000_0000);
        
        apb_wr(`TDR1_OFFSET, 32'hFFFF_FFFF, 4'hF);
        apb_rd_chk(`TDR1_OFFSET, 32'hFFFF_FFFF); 
        
        apb_wr(`TDR1_OFFSET, 32'h5555_5555, 4'hF);
        apb_rd_chk(`TDR1_OFFSET, 32'h5555_5555);
        
        apb_wr(`TDR1_OFFSET, 32'hAAAA_AAAA, 4'hF);
        apb_rd_chk(`TDR1_OFFSET, 32'hAAAA_AAAA);

        apb_wr(`TDR1_OFFSET, 32'h5AA5_A55A, 4'hF);
        apb_rd_chk(`TDR1_OFFSET, 32'h5AA5_A55A);

        //----------------------------------------
        // Test ID 11: TCMP0 R/W access
        //----------------------------------------
        $display("\n[Test ID 11] TCMP0 Register R/W Test");
        apb_wr(`TCMP0_OFFSET, 32'h0000_0000, 4'hF);
        apb_rd_chk(`TCMP0_OFFSET, 32'h0000_0000);
        
        apb_wr(`TCMP0_OFFSET, 32'hFFFF_FFFF, 4'hF);
        apb_rd_chk(`TCMP0_OFFSET, 32'hFFFF_FFFF); 
        
        apb_wr(`TCMP0_OFFSET, 32'h5555_5555, 4'hF);
        apb_rd_chk(`TCMP0_OFFSET, 32'h5555_5555);
        
        apb_wr(`TCMP0_OFFSET, 32'hAAAA_AAAA, 4'hF);
        apb_rd_chk(`TCMP0_OFFSET, 32'hAAAA_AAAA);

        apb_wr(`TCMP0_OFFSET, 32'h5AA5_A55A, 4'hF);
        apb_rd_chk(`TCMP0_OFFSET, 32'h5AA5_A55A);

        //----------------------------------------
        // Test ID 14: TCMP1 R/W access
        //----------------------------------------
        $display("\n[Test ID 14] TCMP1 Register R/W Test");
        apb_wr(`TCMP1_OFFSET, 32'h0000_0000, 4'hF);
        apb_rd_chk(`TCMP1_OFFSET, 32'h0000_0000);
        
        apb_wr(`TCMP1_OFFSET, 32'hFFFF_FFFF, 4'hF);
        apb_rd_chk(`TCMP1_OFFSET, 32'hFFFF_FFFF); 
        
        apb_wr(`TCMP1_OFFSET, 32'h5555_5555, 4'hF);
        apb_rd_chk(`TCMP1_OFFSET, 32'h5555_5555);
        
        apb_wr(`TCMP1_OFFSET, 32'hAAAA_AAAA, 4'hF);
        apb_rd_chk(`TCMP1_OFFSET, 32'hAAAA_AAAA);

        apb_wr(`TCMP1_OFFSET, 32'h5AA5_A55A, 4'hF);
        apb_rd_chk(`TCMP1_OFFSET, 32'h5AA5_A55A);

        //----------------------------------------
        // Test ID 17: TIER R/W access
        //----------------------------------------
        $display("\n[Test ID 17] TIER Register R/W Test");
        apb_wr(`TIER_OFFSET, 32'h0000_0000, 4'hF);
        apb_rd_chk(`TIER_OFFSET, 32'h0000_0000);
        
        apb_wr(`TIER_OFFSET, 32'hFFFF_FFFF, 4'hF);
        apb_rd_chk(`TIER_OFFSET, 32'h0000_0001); 
        
        apb_wr(`TIER_OFFSET, 32'h5555_5555, 4'hF);
        apb_rd_chk(`TIER_OFFSET, 32'h0000_0001);
        
        apb_wr(`TIER_OFFSET, 32'hAAAA_AAAA, 4'hF);
        apb_rd_chk(`TIER_OFFSET, 32'h0000_0000);

        apb_wr(`TIER_OFFSET, 32'h5AA5_A55A, 4'hF);
        apb_rd_chk(`TIER_OFFSET, 32'h0000_0000);

        //----------------------------------------
        // Test ID 20: TISR R/W access
        //----------------------------------------
        $display("\n[Test ID 20] TISR Register R/W Test");
        sys_reset();
        apb_wr(`TISR_OFFSET, 32'h0000_0001, 4'hF);
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0000); 
        
        apb_wr(`TISR_OFFSET, 32'h0000_0000, 4'hF);
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0000);
        
        apb_wr(`TISR_OFFSET, 32'hFFFF_FFFF, 4'hF);
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0000); 
        
        apb_wr(`TISR_OFFSET, 32'h5555_5555, 4'hF);
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0000);
        
        apb_wr(`TISR_OFFSET, 32'hAAAA_AAAA, 4'hF);
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0000);

        apb_wr(`TISR_OFFSET, 32'h5AA5_A55A, 4'hF);
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0000);

        //----------------------------------------
        // Test ID 22: THCSR R/W access
        //----------------------------------------
        $display("\n[Test ID 22] THCSR Register R/W Test");
        apb_wr(`THCSR_OFFSET, 32'h0000_0000, 4'hF);
        apb_rd_chk(`THCSR_OFFSET, 32'h0000_0000);
        
        apb_wr(`THCSR_OFFSET, 32'hFFFF_FFFF, 4'hF);
        apb_rd_chk(`THCSR_OFFSET, 32'h0000_0001); 
        
        apb_wr(`THCSR_OFFSET, 32'h5555_5555, 4'hF);
        apb_rd_chk(`THCSR_OFFSET, 32'h0000_0001);
        
        apb_wr(`THCSR_OFFSET, 32'hAAAA_AAAA, 4'hF);
        apb_rd_chk(`THCSR_OFFSET, 32'h0000_0000);

        apb_wr(`THCSR_OFFSET, 32'h5AA5_A55A, 4'hF);
        apb_rd_chk(`THCSR_OFFSET, 32'h0000_0000);

        //----------------------------------------
        // Test ID 51: Pready timing check
        //----------------------------------------
        $display("\n[Test ID 51] Check pready timing");
        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = `TCR_OFFSET;
        tim_pwdata = 32'h5555_5555;
        tim_pstrb = 4'hF;
        $display("t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b", $time, tim_paddr, tim_pwdata, tim_pstrb);
        @(posedge sys_clk);
        
        // Assert penable and verify timing
        tim_penable = 1'b1;
        if (tim_pready === 1'b1) begin
            $display("t = %0t FAIL: Pready is high when penable is asserted", $time);
            test_passed = 1'b0;
        end else begin
            $display("t = %0t PASS: Pready is not high when penable is asserted", $time);
        end

        // Complete the transaction
        wait (tim_pready);
        @(posedge sys_clk);
        tim_psel = 1'b0;
        tim_penable = 1'b0;
        tim_pwrite = 1'b0;
        @(posedge sys_clk);
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0501);

        //----------------------------------------
        // Test ID 58: Register reset values
        //----------------------------------------
        $display("\n[Test ID 58] Register Reset Value Check");
        sys_reset();
        // Verify all register reset values
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0100);    // Default div_val=1
        apb_rd_chk(`TDR0_OFFSET, 32'h0000_0000);
        apb_rd_chk(`TDR1_OFFSET, 32'h0000_0000);
        apb_rd_chk(`TCMP0_OFFSET, 32'hFFFF_FFFF);
        apb_rd_chk(`TCMP1_OFFSET, 32'hFFFF_FFFF);
        apb_rd_chk(`TIER_OFFSET, 32'h0000_0000);
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0000);
        apb_rd_chk(`THCSR_OFFSET, 32'h0000_0000);

    end
endtask