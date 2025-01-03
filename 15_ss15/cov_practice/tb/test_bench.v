module test_bench;
    reg a, b, c;
    wire z;
    reg [31:0] test_count;
    reg [31:0] error_count;

    // Instantiate the DUT
    top u_dut (
        .a(a),
        .b(b),
        .c(c),
        .z(z)
    );

    // Function to calculate expected output
    function expected_z;
        input a_in, b_in, c_in;
        begin
            expected_z = a_in & (b_in | c_in);
        end
    endfunction

    // Function to check output and report pass/fail
    task check_output;
        input [31:0] test_num;
        begin
            $display("[t = %0t] a = %b, b = %b, c = %b", $time, a, b, c);
            #1; // Small delay to allow z to settle
            if (z !== expected_z(a, b, c)) begin
                $display("Test %0d failed!", test_num);
                $display("Expected: z = %b, Got: z = %b", expected_z(a, b, c), z);
                error_count = error_count + 1;
            end else begin
                $display("Test %0d passed: z = %b", test_num, z);
            end
            test_count = test_count + 1;
            #4;
        end
    endtask

    // Test stimulus
    initial begin
        // Initialize inputs and counters
        test_count = 0;
        error_count = 0;
        $display("\nStarting tests...");
        // Test vectr 0: Test a, b, c = 0 case
        a = 0; b = 0; c = 0;
        check_output(test_count);

        // Test vector 1: Test a=0 case
        a = 0; b = 1; c = 1;
        check_output(test_count);

        // Test vector 2: Test a=1 with b=1
        a = 1; b = 1; c = 0;
        check_output(test_count);

        // Test vector 3: Test a=1 with c=1
        a = 1; b = 0; c = 1;
        check_output(test_count);

        // Test vector 4: Test b=0 with c=0
        a = 1; b = 0; c = 0;
        check_output(test_count);

        // Report final results
        $display("\n=== Test Summary ===");
        $display("Total tests run: %0d", test_count);
        $display("Tests passed: %0d", test_count - error_count);
        $display("Tests failed: %0d", error_count);
        
        if (error_count == 0) begin
            $display("\nPASSED: All tests passed successfully!");
        end else begin
            $display("\nFAILED: %0d out of %0d tests failed!", error_count, test_count);
        end
        
        $finish;
    end

endmodule