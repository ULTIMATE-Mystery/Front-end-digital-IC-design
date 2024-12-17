task run_test;
    begin
        $display("===================================");
        $display("Test Case: check reset value");
        $display("===================================");
        
        sys_reset();

        // TCR reset value = 0x100 (default div_val)  
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0100);

        // TDR0/1 reset value = 0
        apb_rd_chk(`TDR0_OFFSET, 32'h0000_0000);
        apb_rd_chk(`TDR1_OFFSET, 32'h0000_0000);

        // TCMP0/1 reset value = 0xFFFFFFFF
        apb_rd_chk(`TCMP0_OFFSET, 32'hFFFF_FFFF);
        apb_rd_chk(`TCMP1_OFFSET, 32'hFFFF_FFFF);

        // TIER reset value = 0
        apb_rd_chk(`TIER_OFFSET, 32'h0000_0000);

        // TISR reset value = 0
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0000);

        // THCSR reset value = 0
        apb_rd_chk(`THCSR_OFFSET, 32'h0000_0000);
    end
endtask