task run_test;
    begin
        $display("===================================");
        $display("Test Case: APB Multiple Access Check");
        $display("===================================");

        sys_reset();

        // Write continuously to TDR0 and TDR1
        apb_cons_wr(`TDR0_OFFSET, 32'hFFFF_FFFF, 4'hF);
        apb_cons_wr(`TDR1_OFFSET, 32'hEEEE_EEEE, 4'hF);

        // Read continuously from TDR0 and TDR1
        apb_cons_rd_chk(`TDR0_OFFSET, 32'hFFFF_FFFF);
        apb_cons_rd_chk(`TDR1_OFFSET, 32'hEEEE_EEEE);

        // Write continuously to TDR0 and TDR1
        apb_cons_wr(`TDR0_OFFSET, 32'hDDDD_DDDD, 4'hF);
        apb_cons_wr(`TDR1_OFFSET, 32'hCCCC_CCCC, 4'hF);

        // Read continuously from TDR0 and TDR1
        apb_cons_rd_chk(`TDR0_OFFSET, 32'hDDDD_DDDD);
        apb_cons_rd_chk(`TDR1_OFFSET, 32'hCCCC_CCCC);

        // Write continuously to TDR0 and TDR1
        apb_cons_wr(`TDR0_OFFSET, 32'hBBBB_BBBB, 4'hF);
        apb_cons_wr(`TDR1_OFFSET, 32'hAAAA_AAAA, 4'hF);

        // Read continuously from TDR0 and TDR1
        apb_cons_rd_chk(`TDR0_OFFSET, 32'hBBBB_BBBB);
        apb_cons_rd_chk(`TDR1_OFFSET, 32'hAAAA_AAAA);

        // Write continuously to TDR0 and TDR1
        apb_cons_wr(`TDR0_OFFSET, 32'h9999_9999, 4'hF);
        apb_cons_wr(`TDR1_OFFSET, 32'h8888_8888, 4'hF);

        // Read continuously from TDR0 and TDR1
        apb_cons_rd_chk(`TDR0_OFFSET, 32'h9999_9999);
        apb_rd_chk(`TDR1_OFFSET, 32'h8888_8888);
            
        // Test: Write and read TDR0 continuously
        
        apb_cons_wr(`TDR0_OFFSET, 32'h6666_6666, 4'hF);
        apb_cons_rd_chk(`TDR0_OFFSET, 32'h6666_6666);
        apb_cons_wr(`TDR0_OFFSET, 32'h4444_4444, 4'hF);
        apb_cons_rd_chk(`TDR0_OFFSET, 32'h4444_4444);
        apb_cons_wr(`TDR0_OFFSET, 32'h2222_2222, 4'hF);
        apb_cons_rd_chk(`TDR0_OFFSET, 32'h2222_2222);
        apb_cons_wr(`TDR0_OFFSET, 32'h0246_8ACE, 4'hF);
        apb_rd_chk(`TDR0_OFFSET, 32'h0246_8ACE);

        // Test: Write and read TDR1 continuously

        apb_cons_wr(`TDR1_OFFSET, 32'h7777_7777, 4'hF);
        apb_cons_rd_chk(`TDR1_OFFSET, 32'h7777_7777);
        apb_cons_wr(`TDR1_OFFSET, 32'h5555_5555, 4'hF);
        apb_cons_rd_chk(`TDR1_OFFSET, 32'h5555_5555);
        apb_cons_wr(`TDR1_OFFSET, 32'h3333_3333, 4'hF);
        apb_cons_rd_chk(`TDR1_OFFSET, 32'h3333_3333);
        apb_cons_wr(`TDR1_OFFSET, 32'h1357_9BDF, 4'hF);
        apb_rd_chk(`TDR1_OFFSET, 32'h1357_9BDF);

    end
endtask