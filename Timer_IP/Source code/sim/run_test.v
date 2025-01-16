task run_test;
    begin
        $display("===================================");
        $display("Test Case: Unaligned Access Check");
        $display("===================================");

        sys_reset();

        // Start APB transaction with unaligned address
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = 12'h001;
        tim_pwdata = 32'hFFFF_FFFF;
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

        apb_rd_chk(12'h001, 32'h0000_0000);

        // Start APB transaction with unaligned address
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = 12'h002;
        tim_pwdata = 32'hFFFF_FFFF;
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

        apb_rd_chk(12'h002, 32'h0000_0000);
    
        // Start APB transaction with unaligned address
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = 12'h006;
        tim_pwdata = 32'hFFFF_FFFF;
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

        apb_rd_chk(12'h006, 32'h0000_0000);

        // Start APB transaction with unaligned address
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = 12'h013;
        tim_pwdata = 32'hFFFF_FFFF;
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

        apb_rd_chk(12'h00b, 32'h0000_0000);

        // Start APB transaction with unaligned address
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = 12'h001;
        tim_pwdata = 32'hFFFF_FFFF;
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

        apb_rd_chk(12'h013, 32'h0000_0000);

        // Start APB transaction with unaligned address
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = 12'h01a;
        tim_pwdata = 32'hFFFF_FFFF;
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

        apb_rd_chk(12'h01a, 32'h0000_0000);

        // Start APB transaction with unaligned address
        tim_psel = 1'b1;
        tim_penable = 1'b0;
        tim_pwrite = 1'b1;
        tim_paddr = 12'h020;
        tim_pwdata = 32'hFFFF_FFFF;
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

        apb_rd_chk(12'h020, 32'h0000_0000);

    end
endtask