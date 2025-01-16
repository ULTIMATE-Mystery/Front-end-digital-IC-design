task run_test;
    begin
        $display("===================================");
        $display("Test Case: Reserved Address Space Check");
        $display("===================================");
        
        // Initialize test environment
        sys_reset();

        //----------------------------------------
        // Test ID 24: Reserved registers access
        //----------------------------------------
        $display("\n[Test ID 24] Reserved Address Space Access Test");

        // First reserved address after registers (0x01C + 4 = 0x020)
        apb_wr(12'h020, 32'hFFFF_FFFF, 4'hF);
        apb_rd_chk(12'h020, 32'h0000_0000);  // Should read as 0

        // Middle of reserved space
        apb_wr(12'h400, 32'hFFFF_FFFF, 4'hF);
        apb_rd_chk(12'h400, 32'h0000_0000);  // Should read as 0

        // Last address in 4KB space
        apb_wr(12'hFFC, 32'hFFFF_FFFF, 4'hF);
        apb_rd_chk(12'hFFC, 32'h0000_0000);  // Should read as 0

        // Test byte access to reserved space
        apb_wr(12'h100, 32'hFFFF_FFFF, 4'b0001); // Only byte 0
        apb_rd_chk(12'h100, 32'h0000_0000);

        apb_wr(12'h200, 32'hFFFF_FFFF, 4'b0010); // Only byte 1
        apb_rd_chk(12'h200, 32'h0000_0000);

        apb_wr(12'h300, 32'hFFFF_FFFF, 4'b0100); // Only byte 2
        apb_rd_chk(12'h300, 32'h0000_0000);

        apb_wr(12'h400, 32'hFFFF_FFFF, 4'b1000); // Only byte 3
        apb_rd_chk(12'h400, 32'h0000_0000);

        // Test consecutive read/writes to reserved space
        // Write 0xFFFF_FFFF to last address in 4KB space
        apb_wr(12'hFFC, 32'hFFFF_FFFF, 4'hF);
        // Write 0x5555_5555 to first reserved address
        apb_wr(12'h020, 32'h5555_5555, 4'hF);
        // Verify both still read as 0
        apb_rd_chk(12'hFFC, 32'h0000_0000);
        apb_rd_chk(12'h020, 32'h0000_0000);
    end
endtask