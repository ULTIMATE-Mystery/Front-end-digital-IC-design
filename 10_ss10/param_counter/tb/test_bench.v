`timescale 1ns/1ns

module test_bench;
    reg clk, rst_n;
    parameter CNT_W = 16;  // Parameter for configurable counter bit-width
    wire [CNT_W-1:0] count;
    wire overflow;

    // Instantiate the counter with parameterized bit-width
    counter #(.CNT_W(CNT_W)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .count(count),
        .overflow(overflow)
    );

    // Clock generation
    initial begin 
        clk = 0;
        forever #25 clk = ~clk;
    end

    // Test sequence
    initial begin
        $display("------------------------------------------------");
        $display("Testing a %0d-bit Counter", CNT_W);
        $display("Expected max value: %0d'h%0h", CNT_W, {CNT_W{1'b1}});
        $display("------------------------------------------------");

        rst_n = 1'b0;
        #100;
        
        // Check initial reset value
        if (count !== {CNT_W{1'b0}}) begin
            $display("------------------------------------------------");
            $display("t=%10d FAIL: the init value of counter is not %0d'h%0h", $time, CNT_W, {CNT_W{1'b0}});
            $display("------------------------------------------------");
            #100;
            $finish;
        end else begin
            $display("------------------------------------------------");
            $display("t=%10d PASS: the init value of counter is %0d'h%0h.", $time, CNT_W, {CNT_W{1'b0}});
            $display("------------------------------------------------");
        end
        
        #10;

        // Release reset
        @(negedge clk);
        rst_n = 1'b1;

        // Wait for the counter to reach its maximum value
        repeat ((1 << CNT_W) - 1) @(posedge clk);
        
        #1;
        if (count !== {CNT_W{1'b1}}) begin
            $display("------------------------------------------------");
            $display("t=%10d FAIL: counter value is not correct, count = %0d'h%0h, expect: %0d'h%0h", $time, CNT_W, count, CNT_W, {CNT_W{1'b1}});
            $display("------------------------------------------------");
            #100;
            $finish;
        end else begin
            $display("------------------------------------------------");
            $display("t=%10d PASS: counter value is correct, %0d'h%0h", $time, CNT_W, {CNT_W{1'b1}});
            $display("------------------------------------------------");
        end

        // Check overflow assertion
        if (overflow !== 1'b1) begin
            $display("------------------------------------------------");
            $display("t=%10d FAIL: overflow is not asserted", $time);
            $display("------------------------------------------------");
            #100;
            $finish;
        end else begin
            $display("------------------------------------------------");
            $display("t=%10d PASS: overflow is asserted", $time);
            $display("------------------------------------------------");
        end

        @(posedge clk);
        #1;
        if (overflow == 1'b1) begin
            $display("------------------------------------------------");
            $display("t=%10d FAIL: overflow is not negated", $time);
            $display("------------------------------------------------");
            #100;
            $finish;
        end else begin
            $display("------------------------------------------------");
            $display("t=%10d PASS: overflow is negated", $time);
            $display("------------------------------------------------");
        end

        // Check if counter resets to 0 after overflow
        if (count !== {CNT_W{1'b0}}) begin
            $display("------------------------------------------------");
            $display("t=%10d FAIL: counter value is not init to %0d'h%0h after overflow. Got: %0d'h%0h", $time, CNT_W, {CNT_W{1'b0}}, CNT_W, count);
            $display("------------------------------------------------");
            #100;
            $finish;
        end else begin
            $display("------------------------------------------------");
            $display("t=%10d PASS: counter value is %0d'h%0h after overflow", $time, CNT_W, {CNT_W{1'b0}});
            $display("------------------------------------------------");
        end

        // Test a few additional counts after overflow
        repeat (10) @(posedge clk);
        #1;

        if (CNT_W <= 3) begin
            // Handle smaller counters (1-bit, 2-bit, 3-bit) by wrapping the values after overflow
            if (count !== (10 % (1 << CNT_W))) begin
                $display("------------------------------------------------");
                $display("t=%10d FAIL: counter value is not correct, count = %0d'h%0h, expect: %0d'h%0h", $time, CNT_W, count, CNT_W, (10 % (1 << CNT_W)));
                $display("------------------------------------------------");
                #100;
                $finish;
            end else begin
                $display("------------------------------------------------");
                $display("t=%10d PASS: counter value is correct - %0d'h%0h", $time, CNT_W, (10 % (1 << CNT_W)));
                $display("------------------------------------------------");
            end
        end else begin
            // For larger counters, use the standard value check
            if (count !== {CNT_W{1'b0}} + 10) begin
                $display("------------------------------------------------");
                $display("t=%10d FAIL: counter value is not correct, count = %0d'h%0h, expect: %0d'h%0h", $time, CNT_W, count, CNT_W, {CNT_W{1'b0}} + 10);
                $display("------------------------------------------------");
                #100;
                $finish;
            end else begin
                $display("------------------------------------------------");
                $display("t=%10d PASS: counter value is correct - %0d'h%0h", $time, CNT_W, {CNT_W{1'b0}} + 10);
                $display("------------------------------------------------");
            end
        end

        #100;
        $finish;
    end
endmodule
