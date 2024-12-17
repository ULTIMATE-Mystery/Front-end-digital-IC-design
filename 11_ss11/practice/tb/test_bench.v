module test_bench;

    // Define 4-bit registers a and b
    reg [3:0] a, b;

    // Task to swap values of two 4-bit inputs
    task swap(inout [3:0] data1, inout [3:0] data2);
        reg [3:0] temp; // Temporary 4-bit register
        begin
            temp = data1; // Store data1 in temp
            data1 = data2; // Assign data2 to data1
            data2 = temp;  // Assign temp to data2
        end
    endtask

    // Initial block to run test
    initial begin
        a = 5; // Assign 5 to a
        b = 10; // Assign 10 to b
        swap(a, b); // Swap values of a and b
        $display("a = %0d, b = %0d", a, b); // Display values of a and b
        $finish; // End simulation
    end

endmodule
