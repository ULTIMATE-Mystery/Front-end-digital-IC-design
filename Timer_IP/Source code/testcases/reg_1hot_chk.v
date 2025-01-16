task run_test;
    begin
        $display("===================================");
        $display("Test Case: One-hot Check");
        $display("===================================");

        sys_reset();

        // Write different value to all registers
        apb_wr(`TCR_OFFSET, 32'h8888_8888, 4'hF);
        apb_wr(`TDR0_OFFSET, 32'h7777_7777, 4'hF); 
        apb_wr(`TDR1_OFFSET, 32'h6666_6666, 4'hF);
        apb_wr(`TCMP0_OFFSET, 32'h5555_5555, 4'hF);
        apb_wr(`TCMP1_OFFSET, 32'h4444_4444, 4'hF);
        apb_wr(`TIER_OFFSET, 32'h3333_3333, 4'hF);
        apb_wr(`TISR_OFFSET, 32'h2222_2222, 4'hF);
        apb_wr(`THCSR_OFFSET, 32'h1111_1111, 4'hF);
        
        // Verify that the read value is the same as the expected value
        apb_rd_chk(`TCR_OFFSET, 32'h0000_0800);
        apb_rd_chk(`TDR0_OFFSET, 32'h7777_7777);
        apb_rd_chk(`TDR1_OFFSET, 32'h6666_6666);
        apb_rd_chk(`TCMP0_OFFSET, 32'h5555_5555);
        apb_rd_chk(`TCMP1_OFFSET, 32'h4444_4444);
        apb_rd_chk(`TIER_OFFSET, 32'h0000_0001);
        apb_rd_chk(`TISR_OFFSET, 32'h0000_0000);
        apb_rd_chk(`THCSR_OFFSET, 32'h0000_0001);
    end
endtask