`timescale 1ns/1ps

module test_bench;
    // Signal declarations
    reg clk, rst_n, enable;
    reg [7:0] data;
    
    // Clock generator: 100ns period (50ns high, 50ns low)
    initial begin
        clk = 0;
        #50;
        forever #50 clk = ~clk;
    end
    
    // Main stimulus
    initial begin
        // Initial values
        rst_n = 0;
        enable = 0;
        data = 8'h00;
        
        // Wait 2 clock cycles in reset
        repeat(2) @(posedge clk);
        
        // Release reset
        #1 rst_n = 1'b1;
        
        // Wait 1 clock and enable
        @(posedge clk);
        #1 enable = 1'b1;
        data = 8'hAA;
        
        @(posedge clk);
        #1 data = 8'hBB;
        
        @(posedge clk);
        #1 data = 8'hCC;
        
        // Disable and clear data
        @(posedge clk);
        #1 begin
            enable = 1'b0;
            data = 8'h00;
        end
        
        // Run for a bit more then finish
        #100 $finish;
    end

    // Optional: Monitor changes
    initial begin
        $monitor("[t = %0t] rst_n=%b enable=%b data=%h", 
                 $time, rst_n, enable, data);
    end

endmodule