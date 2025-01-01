`timescale 1ns/1ps

module test_bench;
    // Test signals
    reg         clk;
    reg         rst_n;
    reg         wr_en;
    reg         rd_en;
    reg  [9:0]  addr;
    reg  [31:0] wdata;
    wire [31:0] rdata;
    wire        overflow;
    
    // Test status
    reg         test_passed;
    integer     test_count;
    integer     error_count;
    
    // Register addresses
    localparam CTRL_REG    = 10'h000;  // Control register
    localparam STATUS_REG  = 10'h004;  // Status register
    
    // Control register bit positions
    localparam COUNT_START_BIT = 0;
    localparam COUNT_CLR_BIT   = 1;

    // DUT instantiation
    counter_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .addr(addr),
        .wdata(wdata),
        .rdata(rdata),
        .overflow(overflow)
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

    task wait_cycles;
        input [63:0] cycles;
        integer i;
        begin
            for (i = 0; i < cycles; i = i + 1) begin
                @(posedge clk);
            end
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
        $display("\nCounter with Register Interface Test");
        $display("=====================================");
        
        // Test 1: Reset and Initial Value Check
        reset_dut();
        $display("\nTest 1: Reset Value Check");
        read_check(CTRL_REG, 32'h0);     // Control register should be 0
        read_check(STATUS_REG, 32'h0);    // Counter value should be 0
        
        // Test 2: Basic Counter Operation
        $display("\nTest 2: Basic Counter Operation - Count Enable");
        write_reg(CTRL_REG, 32'h1);       // Set count_start=1
        wait_cycles(10);                    // Wait for counter to increment
        read_check(STATUS_REG, 32'hA);     // Verify counter value after 10 cycles
        
        // Test 3: Start/Stop Operation
        $display("\nTest 3: Counter Start/Stop Operation Test");
        write_reg(CTRL_REG, 32'h0);  // Disable counting
        wait_cycles(5);    
        read_check(STATUS_REG, 32'hC);
        write_reg(CTRL_REG, 32'h1);  // Set count_start=1
        wait_cycles(10);
        read_check(STATUS_REG, 32'h16);    
        
        // Test 4: Counter Clear 
        $display("\nTest 4: Counter Clear Operation Test");
        write_reg(CTRL_REG, 32'h2);  // Assert clear
        wait_cycles(1);
        read_check(STATUS_REG, 32'h0);
        wait_cycles(5);
        read_check(STATUS_REG, 32'h0);
        
        // Test 5: Full Counting Sequence to Overflow
        $display("\nTest 5: Full Counting Sequence and Overflow Test");
        write_reg(CTRL_REG, 32'h1);       // Enable counting
        wait_cycles(255); #1;
        // Check overflow behavior
        if (!overflow) begin
            $display("----------------------------------------");
            $display("t = %0t FAIL: Overflow is not asserted", $time);
            test_count = test_count + 1;
            error_count = error_count + 1;
            test_passed = 0;
        end else begin
            $display("----------------------------------------");
            $display("t = %0t PASS: Overflow is asserted", $time);
            test_count = test_count + 1;
        end
        read_check(STATUS_REG, 32'hFF); #1;
        if (overflow) begin
            $display("----------------------------------------");
            $display("t = %0t FAIL: Overflow is not negated", $time);
            test_count = test_count + 1;
            error_count = error_count + 1;
            test_passed = 0;
        end else begin
            $display("----------------------------------------");
            $display("t = %0t PASS: Overflow is negated", $time);
            test_count = test_count + 1;
        end
        read_check(STATUS_REG, 32'h0);    // Verify counter wrapped to 0       
        wait_cycles(10);
        read_check(STATUS_REG, 32'hB);

        // Test 6: Counter Clear Priority
        $display("\nTest 6: Counter Clear Priority Test");
        write_reg(CTRL_REG, 32'h3); // Set both count_start and count_clr
        wait_cycles(10);
        read_check(STATUS_REG, 32'h0);
        
        // Test 7: Register Access
        $display("\nTest 7: Register Access Test");
        write_reg(STATUS_REG, 32'hFFFFFFFF);  // Try to write to status register
        read_check(STATUS_REG, 32'h0);        // Should be unchanged from counter value
        write_reg(CTRL_REG, 32'hFFFFFFFF);
        read_check(CTRL_REG, 32'h3);
        
        // Test 8: Unmapped Register Access
        $display("\nTest 8: Unmapped Register Access Test");
        write_reg(10'h008, 32'hFFFFFFFF);     // Write to unmapped address
        read_check(10'h008, 32'h0);           // Should read as 0
        write_reg(10'h100, 32'hFFFFFFFF);     // Write to unmapped address
        read_check(10'h100, 32'h0);           // Another unmapped address
        
        // Report final results
        $display("\n=====================================");
        $display("Test Summary:");
        $display("  Total Tests    : %0d", test_count);
        $display("  Failed Tests   : %0d", error_count);
        $display("  Overall Status : %s", test_passed ? "PASSED" : "FAILED");
        $display("=====================================\n");
        
        #100 $finish;
    end

    // Timeout watchdog
    initial begin
        #10000;
        $display("ERROR: Test timeout!");
        $finish;
    end

endmodule