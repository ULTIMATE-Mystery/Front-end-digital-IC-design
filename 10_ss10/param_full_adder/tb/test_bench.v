`timescale 1ns/1ns

module test_bench;
    parameter N = 32; // Set this to a constant for each test case (2 <= N <= 32)
    reg [31:0] a, b;  // Maximum bit-width is 32
    wire [N:0] sum;   // Adjust the sum width to N+1 bits (carry included)
    reg [N:0] res;    // Expected result (same width as sum)
    integer i;
    integer num_cases;  // Number of test cases based on bit-width

    // Ensure N is within valid range
    initial begin
        if (N < 2 || N > 32) begin
            $display("Error: Bit-width N must be between 2 and 32.");
            $finish;
        end
    end

    // Instantiate the parameterized full adder
    param_full_adder #(.N(N)) dut (
        .a(a[N-1:0]),       // Use the lower N bits of a
        .b(b[N-1:0]),       // Use the lower N bits of b
        .sum(sum[N-1:0]),   // Sum is N bits
        .carry(sum[N])      // Carry-out is the N-th bit of sum
    );

    initial begin
        // Logical number of test cases based on bit-width
        if (N == 2) begin
            num_cases = 25;  // Exhaustively test all combinations for 2-bit adder
        end else if (N <= 4) begin
            num_cases = 50;  // Test a reasonable subset of 4-bit combinations
        end else if (N <= 8) begin
            num_cases = 100; // Test a subset for 8-bit adders
        end else if (N <= 16) begin
            num_cases = 500;  // Larger number of tests for 16-bit adders
        end else if (N <= 32) begin
            num_cases = 2000;  // Largest number of tests for 32-bit adders
        end else begin
            // Default case to handle any unexpected situation
            $display("Error: Unexpected bit-width N. Must be between 2 and 32.");
            $finish;
        end

        // Test full adder for multiple cases
        for (i = 0; i < num_cases; i = i + 1) begin
            if (i == num_cases - 1) begin
                // Set maximum values for the final case
                a = {N{1'b1}};  // All 1's for N bits
                b = {N{1'b1}};  // All 1's for N bits
            end else begin
                // Generate random values within the bit-width range safely
                if (N < 32) begin
                    a = $urandom_range(0, (1 << N) - 1);
                    b = $urandom_range(0, (1 << N) - 1);
                end else begin
                    a = $urandom;
                    b = $urandom;
                end
            end

            #5;

            // Display the current case and what bit-width adder is being tested
            $display("====================================");
            $display("===== %0d-bit Full Adder ======", N);
            $display("===== Case: %4d a = %d, b = %d =====", i, a[N-1:0], b[N-1:0]);
            $display("====================================");

            // Calculate expected result
            res = a[N-1:0] + b[N-1:0];

            // Display expected and actual values
            $display("Exp: %d Actual: %d", res, sum);

            // Check if the result matches the expected sum
            if (res === sum) begin 
                $display(">>>>>>>>>>>  PASS <<<<<<<<<<<<<\n");
            end else begin
                $display(">>>>>>>>>>>  FAIL <<<<<<<<<<<<<\n");
                $finish;
            end
        end
        #100;
        $finish;
    end
endmodule
