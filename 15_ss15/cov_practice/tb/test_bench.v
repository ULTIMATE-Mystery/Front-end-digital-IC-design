module test_bench;

    reg a, b, c;
    wire z;

    // Instantiate the design under test (DUT)
    top u_dut (
        .a(a),
        .b(b),
        .c(c),
        .z(z)
    );

    initial begin
        // Initialize inputs
        a = 0;
        b = 0;
        c = 0;

        #100;

        // Apply test cases to cover all scenarios for (a, b, c)
        // Test vector (a, b, c) = (0, 0, 0)
        a = 0; b = 0; c = 0;
        #10;

        // Test vector (a, b, c) = (0, 0, 1)
        a = 0; b = 0; c = 1;
        #10;

        // Test vector (a, b, c) = (0, 1, 0)
        a = 0; b = 1; c = 0;
        #10;

        // Test vector (a, b, c) = (0, 1, 1)
        a = 0; b = 1; c = 1;
        #10;

        // Test vector (a, b, c) = (1, 0, 0)
        a = 1; b = 0; c = 0;
        #10;

        // Test vector (a, b, c) = (1, 0, 1)
        a = 1; b = 0; c = 1;
        #10;

        // Test vector (a, b, c) = (1, 1, 0)
        a = 1; b = 1; c = 0;
        #10;

        // Test vector (a, b, c) = (1, 1, 1)
        a = 1; b = 1; c = 1;
        #10;

        // End simulation after applying all test cases
        #100;
        $finish;
    end

endmodule
