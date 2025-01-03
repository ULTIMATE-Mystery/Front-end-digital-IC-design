`timescale 1ns/1ps

module test_bench;
    // Signal declarations
    reg [7:0] a, b;
    
    // Optimized swap task - single line operations
    task swap;
        inout [7:0] x, y;
        reg [7:0] temp;
        begin
            {temp, x, y} = {x, y, x};  // More efficient parallel assignment
        end
    endtask
    
    // Testbench stimulus
    initial begin
        // Initialize test values
        {a, b} = {8'd5, 8'd10};
        
        $display("[t = %0t] Before swap: a = %0d, b = %0d", $time, a, b);
        swap(a, b);
        $display("[t = %0t] After swap:  a = %0d, b = %0d", $time, a, b);
        
        $finish;
    end

endmodule