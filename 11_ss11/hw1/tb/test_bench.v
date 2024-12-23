`timescale 1ns/1ps

module test_bench;
    // Clock
    reg pclk;
    
    // APB signals
    reg         psel;
    reg         pwrite;
    reg         penable;
    reg [15:0]  paddr;
    reg [31:0]  pwdata;

    // Clock generation - 100MHz
    initial begin
        pclk = 0;
        forever #5 pclk = ~pclk;
    end

    // APB write task
    task master_write;
        input [15:0] addr;
        input [31:0] wdata;
        begin
            @(posedge pclk);
            $display("[t = %0t] Master write: addr=0x%h data=0x%h", $time, addr, wdata);
            psel    = 1'b1;
            pwrite  = 1'b1;
            penable = 1'b0;
            paddr   = addr;
            pwdata  = wdata;

            @(posedge pclk);
            penable = 1'b1;

            @(posedge pclk);
            psel    = 1'b0;
            pwrite  = 1'b0;
            penable = 1'b0;
            paddr   = 16'h0;
            pwdata  = 32'h0;
        end
    endtask

    // APB read task
    task master_read;
        input [15:0] addr;
        begin
            @(posedge pclk);
            $display("[t = %0t] Master read request:  addr=0x%h", $time, addr);
            psel    = 1'b1;
            pwrite  = 1'b0;
            penable = 1'b0;
            paddr   = addr;

            @(posedge pclk);
            penable = 1'b1;

            @(posedge pclk);
            psel    = 1'b0;
            pwrite  = 1'b0;
            penable = 1'b0;
            paddr   = 16'h0;
        end
    endtask

    // Task for random transfers
    task gen_transfer;
        input [31:0] num;
        reg [15:0] addr;
        reg [31:0] data;
        reg is_write;
        integer i;
        begin
            for (i = 0; i < num; i = i + 1) begin
                // Generate random values
                addr = {$random} & 16'hFFFF;
                data = {$random, $random} & 32'hFFFFFFFF;
                is_write = {$random} & 1'b1;
                
                // Random idle cycles (0-3)
                repeat($random & 2'b11) @(posedge pclk);

                if (is_write) begin
                    master_write(addr, data);
                end else begin
                    master_read(addr);
                end
            end
        end
    endtask

    // Main test sequence
    initial begin
        // Initialize
        psel    = 0;
        pwrite  = 0;
        penable = 0;
        paddr   = 0;
        pwdata  = 0;

        // Wait for stable clock
        repeat(2) @(posedge pclk);

        // Run test sequence
        $display("Starting test sequence...");
        gen_transfer(20);
        
        // End test
        repeat(2) @(posedge pclk);
        $display("Test sequence completed.");
        $finish;
    end

endmodule