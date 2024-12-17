task run_test;
    begin
        $display("===================================");
        $display("Test Case: APB Protocol Check");
        $display("===================================");

        sys_reset();

        // Add coverage test for !psel && !penable case

        // Test Case 1: SETUP -> IDLE transition
        tim_psel = 1;     // Enter SETUP
        tim_penable = 0; 
        @(posedge sys_clk);
        tim_penable = 0;  // Stay in SETUP (hits else case)
        @(posedge sys_clk);
        tim_psel = 0;     // Force SETUP->IDLE
        @(posedge sys_clk);

        // Test Case 2: ACCESS -> SETUP transition
        tim_psel = 1;  // Enter SETUP 
        tim_penable = 0;
        @(posedge sys_clk);
        tim_penable = 1; // Enter ACCESS
        @(posedge sys_clk);
        tim_penable = 0; // Go back to SETUP while keeping psel=1
        tim_psel = 1;    // Keep psel asserted
        @(posedge sys_clk);
        
        // Test Case 3: Full psel/penable combinations
        // Test 00
        tim_psel = 0;
        tim_penable = 0;
        @(posedge sys_clk);
        
        // Test 01 
        tim_psel = 0;
        tim_penable = 1;
        @(posedge sys_clk);
        
        // Test 10
        tim_psel = 1;
        tim_penable = 0;
        @(posedge sys_clk);
        
        // Test 11
        tim_psel = 1;
        tim_penable = 1;
        @(posedge sys_clk);

        // Return to idle
        tim_psel = 0;
        tim_penable = 0;
        @(posedge sys_clk);

        // Test 1: Normal APB transactions

        // TDR0
        apb_wr(`TDR0_OFFSET, 32'h89ABCDEF, 4'b1100); // Bytes 2,3
        apb_rd_chk(`TDR0_OFFSET, 32'h89AB0000);

        apb_wr(`TDR0_OFFSET, 32'hFEDCBA37, 4'b0001); // Only byte 0
        apb_rd_chk(`TDR0_OFFSET, 32'h89AB0037); 

        apb_wr(`TDR0_OFFSET, 32'h12345678, 4'hF);
        apb_rd_chk(`TDR0_OFFSET, 32'h12345678);

        // TDR1
        apb_wr(`TDR1_OFFSET, 32'h89ABCDEF, 4'b0101); // Bytes 0,2
        apb_rd_chk(`TDR1_OFFSET, 32'h00AB00EF);

        apb_wr(`TDR1_OFFSET, 32'hFEDCBA37, 4'b1110); // Bytes 1, 2, 3
        apb_rd_chk(`TDR1_OFFSET, 32'hFEDCBAEF); 

        apb_wr(`TDR1_OFFSET, 32'h87654321, 4'hF);
        apb_rd_chk(`TDR1_OFFSET, 32'h87654321);

        
        // Test 2: PENABLE without PSEL (wrong write protocol)
        tim_psel = 0;
        tim_penable = 1;
        tim_pwrite = 1;
        tim_paddr = `TDR0_OFFSET;
        tim_pwdata = 32'hFFFFFFFF;
        tim_pstrb = 4'hF;
        apb_wrong_protocol_rd (`TDR0_OFFSET, 32'h12345678);

        // Test 3: PSEL without PENABLE (wrong write protocol)
        tim_psel = 1; 
        tim_penable = 0;
        tim_pwrite = 1;
        tim_paddr = `TDR1_OFFSET;
        tim_pwdata = 32'hFFFFFFFF;
        tim_pstrb = 4'hF;
        apb_wrong_protocol_rd (`TDR1_OFFSET, 32'h87654321);

        // Test 4: Mixed tests

        // TDR0
        apb_wr(`TDR0_OFFSET, 32'h89ABCDEF, 4'b1100); // Bytes 2,3
        apb_rd_chk(`TDR0_OFFSET, 32'h89AB5678);

        apb_wr(`TDR0_OFFSET, 32'hFEDCBA37, 4'b0001); // Only byte 0
        apb_rd_chk(`TDR0_OFFSET, 32'h89AB5637); 

        apb_wr(`TDR0_OFFSET, 32'h12345678, 4'hF);
        apb_rd_chk(`TDR0_OFFSET, 32'h12345678);

        // PSEL without PENABLE (wrong write protocol)
        tim_psel = 1; 
        tim_penable = 0;
        tim_pwrite = 1;
        tim_paddr = `TDR1_OFFSET;
        tim_pwdata = 32'hFFFFFFFF;
        tim_pstrb = 4'hF;
        apb_wrong_protocol_rd (`TDR1_OFFSET, 32'h87654321);

        // TDR1
        apb_wr(`TDR1_OFFSET, 32'h89ABCDEF, 4'b0101); // Bytes 0,2
        apb_rd_chk(`TDR1_OFFSET, 32'h87AB43EF);

        apb_wr(`TDR1_OFFSET, 32'hFEDCBA37, 4'b1110); // Bytes 1, 2, 3
        apb_rd_chk(`TDR1_OFFSET, 32'hFEDCBAEF); 

        apb_wr(`TDR1_OFFSET, 32'h87654321, 4'hF);
        apb_rd_chk(`TDR1_OFFSET, 32'h87654321);

        // PENABLE without PSEL (wrong write protocol)
        tim_psel = 0;
        tim_penable = 1;
        tim_pwrite = 1;
        tim_paddr = `TDR0_OFFSET;
        tim_pwdata = 32'hFFFFFFFF;
        tim_pstrb = 4'hF;
        apb_wrong_protocol_rd (`TDR0_OFFSET, 32'h12345678);

    end
endtask