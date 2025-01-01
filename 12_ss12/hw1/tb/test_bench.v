`timescale 1ns/1ps

module test_bench;
    // Inputs to the DUT
    reg         clk;
    reg         rst_n;
    reg         wr_en;
    reg         rd_en;
    reg  [9:0]  addr;
    reg  [31:0] wdata;
    wire [31:0] rdata;
    
    // Test status
    reg         test_passed;
    integer     test_count;
    integer     error_count;
    
    // Address parameters
    localparam DATA0_ADDR     = 10'h0;
    localparam DATA0_SR_ADDR  = 10'h4;
    localparam DATA1_ADDR     = 10'h8;
    localparam DATA1_SR_ADDR  = 10'hC;
    
    // Expected reset values
    localparam DATA0_RESET = 32'h0000_0000;
    localparam DATA1_RESET = 32'hFFFF_FFFF;

    // DUT instantiation
    regset uut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .addr(addr),
        .wdata(wdata),
        .rdata(rdata)
    );

    // Clock generation - 100MHz
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset task
    task reset_dut;
        begin
            rst_n = 0;
            wr_en = 0;
            rd_en = 0;
            addr = 0;
            wdata = 0;
            test_count = 0;
            error_count = 0;
            test_passed = 1;
            #10;
            rst_n = 1;
            #15;
        end
    endtask

    // Write task
    task write_reg;
        input [9:0] write_addr;
        input [31:0] write_data;
        begin
            wr_en = 1;
            addr = write_addr;
            wdata = write_data;
            $display("----------------------------------------");
            $display("t = %0t [TB WRITE]: Address = 0x%h, Data = 0x%h", $time, write_addr, write_data);
            @(posedge clk);
            wr_en = 0;
            addr = 0;
            wdata = 0;
        end
    endtask

    // Read and verify task
    task read_check;
        input [9:0] read_addr;
        input [31:0] expected_data;
        begin
            rd_en = 1;
            addr = read_addr;
            $display("----------------------------------------");
            $display("t = %0t [TB READ]: Address = 0x%h", $time, read_addr);
            #1;
            if (rdata === expected_data) begin
                $display("t = %0t PASS: rdata = 0x%h at Address = 0x%h is correct", 
                        $time, rdata, read_addr);
                test_count = test_count + 1;
            end else begin
                $display("t = %0t FAIL: rdata at Address = 0x%h is not correct\nExpected: 0x%h\nActual: 0x%h", 
                        $time, read_addr, expected_data, rdata);
                test_count = test_count + 1;
                error_count = error_count + 1;
                test_passed = 0;
            end
            @(posedge clk);
            rd_en = 0;
            addr = 0;
        end
    endtask

    // Test sequence
    initial begin
        $display("\nRegister Module Test");
        $display("================================");
        
        // Initialize and reset
        reset_dut();
        
        // Test 1: Reset Value Check
        $display("\nTest 1: Reset Value Check");
        read_check(DATA0_ADDR, DATA0_RESET);     // Check DATA0 reset value
        @(posedge clk);
        read_check(DATA0_SR_ADDR, DATA0_RESET);
        @(posedge clk);
        read_check(DATA1_ADDR, DATA1_RESET);     // Check DATA1 reset value
        @(posedge clk);
        read_check(DATA1_SR_ADDR, DATA1_RESET);
        
        // Test 2: Write and Read DATA0
        $display("\nTest 2: Basic Write/Read Test");
        @(posedge clk);
        write_reg(DATA0_ADDR, 32'hDEAD_BEEF);
        @(posedge clk);
        read_check(DATA0_ADDR, 32'hDEAD_BEEF);   // Verify DATA0 write
        @(posedge clk);
        read_check(DATA0_SR_ADDR, 32'hDEAD_BEEF);// Verify SR_DATA0 mirrors DATA0
        
        // Test 3: Write and Read DATA1
        @(posedge clk);
        write_reg(DATA1_ADDR, 32'hCAFE_BABE);
        @(posedge clk);
        read_check(DATA1_ADDR, 32'hCAFE_BABE);   // Verify DATA1 write
        @(posedge clk);
        read_check(DATA1_SR_ADDR, 32'hCAFE_BABE);// Verify SR_DATA1 mirrors DATA1
        
        // Test 4: Write to Status Registers (should not change)
        $display("\nTest 3: Write to Read-Only Register");
        @(posedge clk);
        write_reg(DATA0_SR_ADDR, 32'h1234_5678);
        @(posedge clk);
        read_check(DATA0_SR_ADDR, 32'hDEAD_BEEF);// SR_DATA0 should remain unchanged

        @(posedge clk);
        write_reg(DATA1_SR_ADDR, 32'h8765_4321);
        @(posedge clk);
        read_check(DATA1_SR_ADDR, 32'hCAFE_BABE);// SR_DATA1 should remain unchanged
        
        // Test 5: Unmapped Register Address Access
        $display("\nTest 4: Unmapped Register Address Access");
        @(posedge clk);
        read_check(10'h001, 32'h0000_0000);
        @(posedge clk);
        read_check(10'h007, 32'h0000_0000);
        @(posedge clk);
        read_check(10'h100, 32'h0000_0000);     // Should return 0 for invalid address
        
        // Test 6: Continuous Write/Read Operations Test with Timing Check
        $display("\nTest 5: Continuous Write/Read Operations Test with Timing Check");
        // Write with wr_en High for multiple cycles
        @(posedge clk);
        write_reg(DATA0_ADDR, 32'h1111_2222);
        write_reg(DATA1_ADDR, 32'h3333_4444);
        write_reg(DATA0_ADDR, 32'h5555_6666);
        write_reg(DATA1_ADDR, 32'h7777_8888);
        // Read with rd_en High for multiple cycles
        read_check(DATA0_ADDR, 32'h5555_6666);
        read_check(DATA0_SR_ADDR, 32'h5555_6666);
        read_check(DATA1_ADDR, 32'h7777_8888);
        read_check(DATA1_SR_ADDR, 32'h7777_8888);
        // Continuous Write/Read
        @(posedge clk);
        write_reg(DATA0_ADDR, 32'h9999_AAAA);
        read_check(DATA0_ADDR, 32'h9999_AAAA);
        write_reg(DATA0_SR_ADDR, 32'h1234_5678);
        read_check(DATA0_SR_ADDR, 32'h9999_AAAA);
        write_reg(DATA1_ADDR, 32'hBBBB_CCCC);
        read_check(DATA1_ADDR, 32'hBBBB_CCCC);
        write_reg(DATA1_SR_ADDR, 32'h1234_5678);
        read_check(DATA1_SR_ADDR, 32'hBBBB_CCCC);

        // Report results
        $display("\n================================");
        $display("Test Summary:");
        $display("  Total Tests    : %0d", test_count);
        $display("  Failed Tests   : %0d", error_count);
        $display("  Overall Status : %s", test_passed ? "PASSED" : "FAILED");
        $display("================================\n");
        
        #100 $finish;
    end

    // Timeout watchdog
    initial begin
        #10000;
        $display("ERROR: Test timeout!");
        $finish;
    end

endmodule