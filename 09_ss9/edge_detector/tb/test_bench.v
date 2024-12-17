`timescale 1ns/1ns

module test_bench;
    reg clk, rst_n, sig_in;
    wire pulse_out_p, pulse_out_n;

    // Instantiate the edge_detector module
    edge_detector dut (
        .clk(clk),
        .rst_n(rst_n),
        .sig_in(sig_in),
        .pulse_out_p(pulse_out_p),
        .pulse_out_n(pulse_out_n)
    );

    // Clock generation (20 ns period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Test sequence
    initial begin
        // 1. Apply Reset
        rst_n = 1'b0; sig_in = 1'b0;
        #15 rst_n = 1'b1; // Deassert reset after 15ns
        // Check after reset
        if (pulse_out_p !== 1'b0 || pulse_out_n !== 1'b0)
            $display("t=%0d FAIL: pulse_out_p or pulse_out_n not reset to 0", $time);
        else
            $display("t=%0d PASS: Reset behavior is correct", $time);

        // 2. Test Rising Edge Detection
        @(posedge clk); sig_in = 1'b1;
        @(posedge clk);
        if (pulse_out_p !== 1'b1)
            $display("t=%0d FAIL: Rising edge not detected correctly", $time);
        else
            $display("t=%0d PASS: Rising edge detection is correct", $time);
        @(posedge clk); // Ensure pulse_out_p returns to 0
        if (pulse_out_p !== 1'b0)
            $display("t=%0d FAIL: pulse_out_p did not return to 0", $time);

        // 3. Test Falling Edge Detection
        @(posedge clk); sig_in = 1'b0;
        @(posedge clk);
        if (pulse_out_n !== 1'b1)
            $display("t=%0d FAIL: Falling edge not detected correctly", $time);
        else
            $display("t=%0d PASS: Falling edge detection is correct", $time);
        @(posedge clk); // Ensure pulse_out_n returns to 0
        if (pulse_out_n !== 1'b0)
            $display("t=%0d FAIL: pulse_out_n did not return to 0", $time);

        // 4. Test Stability (No spurious pulses)
        $display("t=%0d Testing stability (no edges)", $time);
        @(posedge clk); @(posedge clk); // Keep sig_in stable
        if (pulse_out_p !== 1'b0 || pulse_out_n !== 1'b0)
            $display("t=%0d FAIL: Spurious pulse detected", $time);
        else
            $display("t=%0d PASS: No spurious pulses detected", $time);

        // 5. Test Multiple Rising and Falling Edges in a Row
        @(posedge clk); sig_in = 1'b1; // Rising edge
        @(posedge clk); // Check pulse_out_p after the rising edge
        if (pulse_out_p !== 1'b1) begin
            $display("t=%0d FAIL: pulse_out_p not detected on the rising edge", $time);
            $finish;
        end
        @(posedge clk); // Ensure pulse_out_p returns to 0
        if (pulse_out_p !== 1'b0) begin
            $display("t=%0d FAIL: pulse_out_p did not return to 0 after one clock cycle", $time);
            $finish;
        end

        @(posedge clk); sig_in = 1'b0; // Falling edge
        @(posedge clk); // Check pulse_out_n after the falling edge
        if (pulse_out_n !== 1'b1) begin
            $display("t=%0d FAIL: pulse_out_n not detected on the falling edge", $time);
            $finish;
        end
        @(posedge clk); // Ensure pulse_out_n returns to 0
        if (pulse_out_n !== 1'b0) begin
            $display("t=%0d FAIL: pulse_out_n did not return to 0 after one clock cycle", $time);
            $finish;
        end

        // 6. Extended Stability Test (Long Stable Signal)
        @(posedge clk); sig_in = 1'b1; // Stable high
        repeat(3) @(posedge clk); // Hold stable for multiple cycles
        if (pulse_out_p !== 1'b0 || pulse_out_n !== 1'b0)
            $display("t=%0d FAIL: Spurious pulse detected during extended stability", $time);
        else
            $display("t=%0d PASS: No spurious pulses detected during extended stability", $time);

        // 7. Edge Case Reset Mid-Operation
        $display("t=%0d Testing reset during operation", $time);
        sig_in = 1'b0; @(posedge clk);
        sig_in = 1'b1; rst_n = 1'b0; 
        @(posedge clk); sig_in = 1'b0;
        repeat(2) @(posedge clk);
        if (pulse_out_p !== 1'b0 || pulse_out_n !== 1'b0)
            $display("t=%0d FAIL: Signals not cleared after mid-operation reset", $time);
        else
            $display("t=%0d PASS: Mid-operation reset handled correctly", $time);

        // Finish the test
        $display("t=%0d All tests completed", $time);
        $finish;
    end
endmodule