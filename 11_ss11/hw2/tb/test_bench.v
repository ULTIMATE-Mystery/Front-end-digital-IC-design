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
    reg         pready;
    reg [31:0]  prdata;

    // Internal variables
    reg [2:0]   ready_delay;
    integer     i;

    // Clock generation - 100MHz
    initial begin
        pclk = 0;
        forever #5 pclk = ~pclk;
    end

    // Slave response logic
    always @(posedge pclk) begin
        if (psel && penable) begin
            if (ready_delay == 0) begin
                pready = 1'b1;
                if (!pwrite) begin
                    prdata = {$random, $random};
                end
            end else begin
                pready = 1'b0;
                ready_delay = ready_delay - 1;
            end
        end else begin
            pready = 1'b0;
            prdata = 32'h0;
        end
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
            ready_delay = ($random % 5 + 5) % 5;  // 0-4 cycles delay

            @(posedge pclk);
            penable = 1'b1;

            // Wait for slave ready
            wait(pready);

            @(posedge pclk);
            psel    = 1'b0;
            pwrite  = 1'b0;
            penable = 1'b0;
            paddr   = 16'h0;
            pwdata  = 32'h0;
            pready = 1'b0;
        end
    endtask

    // APB read task
    task master_read;
        input [15:0] addr;
        begin
            @(posedge pclk);
            $display("[t = %0t] Master read request: addr=0x%h", $time, addr);
            psel    = 1'b1;
            pwrite  = 1'b0;
            penable = 1'b0;
            paddr   = addr;
            ready_delay = ($random % 5 + 5) % 5;  // 0-4 cycles delay

            @(posedge pclk);
            penable = 1'b1;

            // Wait for slave ready
            wait(pready);
            $display("[t = %0t] Slave read data return: 0x%h", $time, prdata);

            @(posedge pclk);
            psel    = 1'b0;
            pwrite  = 1'b0;
            penable = 1'b0;
            paddr   = 16'h0;
            pready  = 1'b0;
            prdata  = 1'b0;
        end
    endtask

    // Task for random transfers
    task gen_transfer;
        input [31:0] num;
        reg [15:0] addr;
        reg [31:0] data;
        reg is_write;
        begin
            for (i = 0; i < num; i = i + 1) begin
                // Random address and data
                addr = {$random} & 16'hFFFF;
                data = {$random, $random} & 32'hFFFFFFFF;
                is_write = {$random} & 1'b1;

                // Random idle cycles (0-3)
                repeat($random & 2'b11) @(posedge pclk);

                // Perform transfer
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
        // Initialize signals
        psel    = 0;
        pwrite  = 0;
        penable = 0;
        paddr   = 0;
        pwdata  = 0;
        pready  = 0;
        prdata  = 0;
        ready_delay = 0;

        // Wait for stable clock
        repeat(2) @(posedge pclk);

        // Run test sequence
        $display("\nStarting test sequence...");
        gen_transfer(20);

        // End test
        repeat(2) @(posedge pclk);
        $display("\nTest sequence completed.");
        $finish;
    end

endmodule