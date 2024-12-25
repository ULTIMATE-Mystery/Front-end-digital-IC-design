module test_bench;
    parameter MEALY_FSM = 1'b0;
    parameter STR_LEN = 32;  // Can be overridden from command line

    reg  clk, rst_n;
    reg  stream;
    wire match;

    // Test vectors
    reg [STR_LEN-1:0] test_stream;
    reg [STR_LEN-1:0] expected_matches;
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

    // Function to calculate expected matches
    function automatic [STR_LEN-1:0] calculate_matches;
        input [STR_LEN-1:0] input_stream;
        reg [1:0] state;
        integer j;
    begin
        calculate_matches = 0;
        state = 0;
        
        for(j = STR_LEN-1; j >= 0; j = j - 1) begin
            case(state)
                0: state = input_stream[j] ? 1 : 0;
                1: state = input_stream[j] ? 1 : 2;
                2: state = input_stream[j] ? 3 : 0;
                3: begin
                    if(input_stream[j]) begin
                        calculate_matches[j] = 1'b1;
                        state = 1;
                    end else begin
                        state = 2;
                    end
                end
            endcase
        end
        
        // Adjust for Moore FSM
        if(!MEALY_FSM) begin
            calculate_matches = calculate_matches >> 1;
        end
    end
    endfunction

    // Main test process
    initial begin
        $display("------------------------------------------------");
        $display("TB IS RUNNING WITH MEALY_FSM = %d", MEALY_FSM);
        $display("TESTING WITH STREAM LENGTH = %0d BITS", STR_LEN);

        // Generate random test stream
        for(i = 0; i < STR_LEN; i = i + 1) begin
            test_stream[i] = $random % 2;
        end

        // Calculate expected matches for random stream
        expected_matches = calculate_matches(test_stream);

        // Display test stream
        $display("------------------------------------------------");
        $display("Test stream      [%0d:0]: %b", STR_LEN-1, test_stream);
        $display("Expected matches [%0d:0]: %b", STR_LEN-1, expected_matches);

        // Wait for reset
        @(posedge rst_n);
        @(posedge clk);

        // Feed test stream
        for(i = STR_LEN-1; i >= 0; i = i - 1) begin
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