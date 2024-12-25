module test_bench;
    parameter MEALY_FSM = 1'b0;

    reg  clk, rst_n;
    reg  stream;
    wire match;

    // Test vectors
    reg [31:0] test_stream = 32'b11001100101100101010110110101111;
    reg [31:0] expected_matches;
    integer    i;

    // DUT instantiation
    detect_string #(
        .MEALY_FSM(MEALY_FSM)
    ) dut (.*);

    // Clock generation - 100MHz
    initial begin 
        clk = 0;
        forever #25 clk = ~clk;
    end

    // Reset generation
    initial begin
        rst_n = 0;
        stream = 0;
        #25 rst_n = 1;
    end

    // Calculate expected matches based on FSM type
    initial begin
        if (MEALY_FSM)
            expected_matches = 32'b00000000000100000000010010000100;
        else
            expected_matches = 32'b00000000000010000000001001000010;
    end

    // Main test process
    initial begin
        $display("------------------------------------------------");
        $display("TB IS RUNNING WITH MEALY_FSM = %d", MEALY_FSM);
        
        // Display test vectors
        $display("------------------------------------------------");
        $display("Test stream      [31:0]: %b", test_stream);
        $display("Expected matches [31:0]: %b", expected_matches);

        // Wait for reset
        @(posedge rst_n);
        @(posedge clk);

        // Feed test stream
        for(i = 31; i >= 0; i = i - 1) begin
            stream = test_stream[i];
            #1;  // Check outputs after small delay

            if (match === 1'bx || match === 1'bz) begin
                $display("------------------------------------------------");
                $display("t = %10d FAILED: Match signal is %s at position %0d", 
                        $time, match === 1'bx ? "undefined" : "high impedance", i);
                #100;
                $finish;
            end

            if (expected_matches[i] && !match) begin
                if (MEALY_FSM) begin
                    $display("------------------------------------------------");
                    $display("t = %10d FAILED: Match not detected at position %0d in Mealy FSM", $time, i);
                    $display("Input stream = %b", stream);
                    $display("Expected match = 1, Got = %b", match);
                end else begin
                    $display("------------------------------------------------");
                    $display("t = %10d FAILED: Match not detected at position %0d in Moore FSM", $time, i);
                    $display("Input stream = %b", stream);
                    $display("Expected match = 1, Got = %b", match);
                end
                #100;
                $finish;
            end

            if (!expected_matches[i] && match) begin
                if (MEALY_FSM) begin
                    $display("------------------------------------------------");
                    $display("t = %10d FAILED: False match detected at position %0d in Mealy FSM", $time, i);
                    $display("Input stream = %b", stream);
                    $display("Expected match = 0, Got = %b", match);
                end else begin
                    $display("------------------------------------------------");
                    $display("t = %10d FAILED: False match detected at position %0d in Moore FSM", $time, i);
                    $display("Input stream = %b", stream);
                    $display("Expected match = 0, Got = %b", match);
                end
                #100;
                $finish;
            end

            // Print PASSED messages for successful matches
            if (expected_matches[i] && match) begin
                if (MEALY_FSM) begin
                    $display("------------------------------------------------");
                    $display("t = %10d PASSED: Pattern detected correctly in Mealy FSM", $time);
                end else begin
                    $display("------------------------------------------------");
                    $display("t = %10d PASSED: Pattern detected correctly in Moore FSM", $time);
                end
            end

            @(posedge clk);

        end

        $display("------------------------------------------------");
        $display("t = %10d PASSED: All sequence detections were correct!", $time);
        $display("------------------------------------------------");

        #100;
        $finish;
    end

endmodule