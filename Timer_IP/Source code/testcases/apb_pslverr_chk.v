task run_test;
    begin
        $display("===================================");
        $display("Test Case: PSLVERR Check");
        $display("===================================");

        sys_reset();
        // Test invalid address beyond upper bound
        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = 13'h1000;
        tim_pwdata = 32'h1234_5678;
        tim_pstrb = 4'hF;
        $display("t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b", $time, tim_paddr, tim_pwdata, tim_pstrb);
        @(posedge sys_clk);
        
        // Assert penable 
        tim_penable = 1'b1;

        // Complete the transaction
        wait (tim_pready);
        #1;
        if (tim_pslverr == 1'b1) begin
            $display("t = %0t PASS: pslverr is asserted correctly", $time);
        end else begin
            $display("t = %0t FAIL: pslverr is not asserted", $time);
            test_passed = 1'b0;
        end

        @(posedge sys_clk);
        tim_psel = 1'b0;
        tim_penable = 1'b0;
        tim_pwrite = 1'b0;
        @(posedge sys_clk);

        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b0;
        tim_paddr = 13'h1000;
        tim_pwdata = 32'h1234_5678;
        tim_pstrb = 4'hF;
        $display("t = %0t [TB READ]: addr=0x%h", $time, tim_paddr);
        @(posedge sys_clk);
        
        // Assert penable 
        tim_penable = 1'b1;

        // Complete the transaction
        wait (tim_pready);
        #1;
        if (tim_pslverr == 1'b1) begin
            $display("t = %0t PASS: pslverr is asserted correctly", $time);
        end else begin
            $display("t = %0t FAIL: pslverr is not asserted", $time);
            test_passed = 1'b0;
        end

        @(posedge sys_clk);
        tim_psel = 1'b0;
        tim_penable = 1'b0;
        tim_pwrite = 1'b0;
        @(posedge sys_clk);

        // Test ID 52: Access wrong value of div_val
        sys_reset();
        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = `TCR_OFFSET;
        tim_pwdata = 32'h0000_0900;
        tim_pstrb = 4'hF;
        $display("t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b", $time, tim_paddr, tim_pwdata, tim_pstrb);
        @(posedge sys_clk);
        
        // Assert penable 
        tim_penable = 1'b1;

        // Complete the transaction
        wait (tim_pready);
        #1;
        if (tim_pslverr == 1'b1) begin
            $display("t = %0t PASS: pslverr is asserted correctly", $time);
        end else begin
            $display("t = %0t FAIL: pslverr is not asserted", $time);
            test_passed = 1'b0;
        end

        @(posedge sys_clk);
        tim_psel = 1'b0;
        tim_penable = 1'b0;
        tim_pwrite = 1'b0;
        @(posedge sys_clk);
        
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0100);
        
        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = `TCR_OFFSET;
        tim_pwdata = 32'h0000_0a00;
        tim_pstrb = 4'hF;
        $display("t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b", $time, tim_paddr, tim_pwdata, tim_pstrb);
        @(posedge sys_clk);
        
        // Assert penable 
        tim_penable = 1'b1;

        // Complete the transaction
        wait (tim_pready);
        #1;
        if (tim_pslverr == 1'b1) begin
            $display("t = %0t PASS: pslverr is asserted correctly", $time);
        end else begin
            $display("t = %0t FAIL: pslverr is not asserted", $time);
            test_passed = 1'b0;
        end

        @(posedge sys_clk);
        tim_psel = 1'b0;
        tim_penable = 1'b0;
        tim_pwrite = 1'b0;
        @(posedge sys_clk);
        
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0100);

        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = `TCR_OFFSET;
        tim_pwdata = 32'h0000_0b00;
        tim_pstrb = 4'hF;
        $display("t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b", $time, tim_paddr, tim_pwdata, tim_pstrb);
        @(posedge sys_clk);
        
        // Assert penable 
        tim_penable = 1'b1;

        // Complete the transaction
        wait (tim_pready);
        #1;
        if (tim_pslverr == 1'b1) begin
            $display("t = %0t PASS: pslverr is asserted correctly", $time);
        end else begin
            $display("t = %0t FAIL: pslverr is not asserted", $time);
            test_passed = 1'b0;
        end

        @(posedge sys_clk);
        tim_psel = 1'b0;
        tim_penable = 1'b0;
        tim_pwrite = 1'b0;
        @(posedge sys_clk);
        
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0100);

        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = `TCR_OFFSET;
        tim_pwdata = 32'h0000_0c00;
        tim_pstrb = 4'hF;
        $display("t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b", $time, tim_paddr, tim_pwdata, tim_pstrb);
        @(posedge sys_clk);
        
        // Assert penable 
        tim_penable = 1'b1;

        // Complete the transaction
        wait (tim_pready);
        #1;
        if (tim_pslverr == 1'b1) begin
            $display("t = %0t PASS: pslverr is asserted correctly", $time);
        end else begin
            $display("t = %0t FAIL: pslverr is not asserted", $time);
            test_passed = 1'b0;
        end

        @(posedge sys_clk);
        tim_psel = 1'b0;
        tim_penable = 1'b0;
        tim_pwrite = 1'b0;
        @(posedge sys_clk);
        
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0100);

        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = `TCR_OFFSET;
        tim_pwdata = 32'h0000_0d00;
        tim_pstrb = 4'hF;
        $display("t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b", $time, tim_paddr, tim_pwdata, tim_pstrb);
        @(posedge sys_clk);
        
        // Assert penable 
        tim_penable = 1'b1;

        // Complete the transaction
        wait (tim_pready);
        #1;
        if (tim_pslverr == 1'b1) begin
            $display("t = %0t PASS: pslverr is asserted correctly", $time);
        end else begin
            $display("t = %0t FAIL: pslverr is not asserted", $time);
            test_passed = 1'b0;
        end

        @(posedge sys_clk);
        tim_psel = 1'b0;
        tim_penable = 1'b0;
        tim_pwrite = 1'b0;
        @(posedge sys_clk);
        
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0100);

        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = `TCR_OFFSET;
        tim_pwdata = 32'h0000_0e00;
        tim_pstrb = 4'hF;
        $display("t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b", $time, tim_paddr, tim_pwdata, tim_pstrb);
        @(posedge sys_clk);
        
        // Assert penable 
        tim_penable = 1'b1;

        // Complete the transaction
        wait (tim_pready);
        #1;
        if (tim_pslverr == 1'b1) begin
            $display("t = %0t PASS: pslverr is asserted correctly", $time);
        end else begin
            $display("t = %0t FAIL: pslverr is not asserted", $time);
            test_passed = 1'b0;
        end

        @(posedge sys_clk);
        tim_psel = 1'b0;
        tim_penable = 1'b0;
        tim_pwrite = 1'b0;
        @(posedge sys_clk);
        
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0100);

        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = `TCR_OFFSET;
        tim_pwdata = 32'h0000_0f00;
        tim_pstrb = 4'hF;
        $display("t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b", $time, tim_paddr, tim_pwdata, tim_pstrb);
        @(posedge sys_clk);
        
        // Assert penable 
        tim_penable = 1'b1;

        // Complete the transaction
        wait (tim_pready);
        #1;
        if (tim_pslverr == 1'b1) begin
            $display("t = %0t PASS: pslverr is asserted correctly", $time);
        end else begin
            $display("t = %0t FAIL: pslverr is not asserted", $time);
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
        tim_pwdata = 32'h0000_0800;
        tim_pstrb = 4'hF;
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
        
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0800);

        // Test ID 53: Change value of div_en and div_val when timer_en is High
        sys_reset();
        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = `TCR_OFFSET;
        tim_pwdata = 32'h0000_0001;
        tim_pstrb = 4'hF;
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
        
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0001);

        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = `TCR_OFFSET;
        tim_pwdata = 32'h0000_0103;
        tim_pstrb = 4'hF;
        $display("t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b", $time, tim_paddr, tim_pwdata, tim_pstrb);
        @(posedge sys_clk);
        
        // Assert penable 
        tim_penable = 1'b1;

        // Complete the transaction
        wait (tim_pready);
        #1;
        if (tim_pslverr == 1'b1) begin
            $display("t = %0t PASS: pslverr is asserted correctly", $time);
        end else begin
            $display("t = %0t FAIL: pslverr is not asserted", $time);
            test_passed = 1'b0;
        end

        @(posedge sys_clk);
        tim_psel = 1'b0;
        tim_penable = 1'b0;
        tim_pwrite = 1'b0;
        @(posedge sys_clk);
        
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0001);

        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = `TCR_OFFSET;
        tim_pwdata = 32'h0000_0100;
        tim_pstrb = 4'hF;
        $display("t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b", $time, tim_paddr, tim_pwdata, tim_pstrb);
        @(posedge sys_clk);
        
        // Assert penable 
        tim_penable = 1'b1;

        // Complete the transaction
        wait (tim_pready);
        #1;
        if (tim_pslverr == 1'b1) begin
            $display("t = %0t PASS: pslverr is asserted correctly", $time);
        end else begin
            $display("t = %0t FAIL: pslverr is not asserted", $time);
            test_passed = 1'b0;
        end

        @(posedge sys_clk);
        tim_psel = 1'b0;
        tim_penable = 1'b0;
        tim_pwrite = 1'b0;
        @(posedge sys_clk);
        
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0001);

        // Start APB transaction
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = `TCR_OFFSET;
        tim_pwdata = 32'h0000_0002;
        tim_pstrb = 4'hF;
        $display("t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b", $time, tim_paddr, tim_pwdata, tim_pstrb);
        @(posedge sys_clk);
        
        // Assert penable 
        tim_penable = 1'b1;

        // Complete the transaction
        wait (tim_pready);
        #1;
        if (tim_pslverr == 1'b1) begin
            $display("t = %0t PASS: pslverr is asserted correctly", $time);
        end else begin
            $display("t = %0t FAIL: pslverr is not asserted", $time);
            test_passed = 1'b0;
        end

        @(posedge sys_clk);
        tim_psel = 1'b0;
        tim_penable = 1'b0;
        tim_pwrite = 1'b0;
        @(posedge sys_clk);
        
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0001);

    end
endtask