`timescale 1ns/1ps

module testbench;
    // Clock and control signals
    reg sys_clk;
    reg sys_rst_n;
    reg tim_psel;
    reg tim_pwrite;
    reg tim_penable;
    reg [12:0] tim_paddr;
    reg [31:0] tim_pwdata;
    reg [3:0] tim_pstrb;
    reg dbg_mode;

    // Output signals
    wire [31:0] tim_prdata;
    wire tim_pready;
    wire tim_pslverr;
    wire tim_int;

    // Test result flag
    reg test_passed;

    // Counter tracking variables
    reg [3:0] current_div_val;
    reg current_div_en;
    reg current_timer_en;
    reg current_halt;

    // Clock generation (200MHz)
    initial sys_clk = 0;
    always #2.5 sys_clk = ~sys_clk;

    // DUT instance
    timer_top u_timer_top (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .tim_psel(tim_psel),
        .tim_pwrite(tim_pwrite),
        .tim_penable(tim_penable),
        .tim_paddr(tim_paddr),
        .tim_pwdata(tim_pwdata),
        .tim_pstrb(tim_pstrb),
        .tim_prdata(tim_prdata),
        .tim_pready(tim_pready),
        .tim_pslverr(tim_pslverr),
        .dbg_mode(dbg_mode),
        .tim_int(tim_int)
    );

    `define TCR_OFFSET      12'h000
    `define TDR0_OFFSET     12'h004  
    `define TDR1_OFFSET     12'h008
    `define TCMP0_OFFSET    12'h00C
    `define TCMP1_OFFSET    12'h010
    `define TIER_OFFSET     12'h014
    `define TISR_OFFSET     12'h018
    `define THCSR_OFFSET    12'h01C

    // Universal APB access task
    task apb_acc;
        input [12:0] addr;
        input is_write;
        input [31:0] wdata;
        input [3:0] strb;
        input [31:0] exp_rdata;
        input keep_sel;
        input is_cnt_chk;
        input [63:0] exp_cnt_val;

        reg [63:0] temp_cnt_val;

        begin
            if (!tim_psel) begin
                tim_psel = 1'b1;
                tim_penable = 1'b0;
                tim_pwrite = is_write;
                tim_paddr = addr;
                if (is_write) begin
                    tim_pwdata = wdata;
                    tim_pstrb = strb;
                end
                @(posedge sys_clk);
            end else begin
                tim_penable = 1'b0;
                tim_pwrite = is_write;
                tim_paddr = addr;
                if (is_write) begin
                    tim_pwdata = wdata;
                    tim_pstrb = strb;
                end
                @(posedge sys_clk);
            end

            tim_penable = 1'b1;
            wait(tim_pready == 1'b1);

            if (is_write && !tim_pslverr) begin
                if (addr == `TCR_OFFSET && strb[0]) begin
                    current_timer_en = wdata[0];
                    current_div_en = wdata[1];
                    if (strb[1]) begin
                        current_div_val = wdata[11:8];
                    end
                end else if (addr == `THCSR_OFFSET && strb[0]) begin
                    current_halt = wdata[0] & dbg_mode;
                end
            end

            if (!is_write) begin
            #1;
            if (!is_cnt_chk) begin
            if (tim_prdata === exp_rdata)
                $display("t = %0t PASS: rdata = %h at addr 0x%h is correct", $time, tim_prdata, addr);
            else begin
                $display("t = %0t FAIL: rdata at addr 0x%h is not correct\nExpected: %h\nActual: %h", 
                $time, addr, exp_rdata, tim_prdata);
                test_passed = 1'b0;
            end
            end else begin
                if (addr == `TDR0_OFFSET) begin
                    temp_cnt_val[31:0] = tim_prdata;
                end else if (addr == `TDR1_OFFSET) begin
                    temp_cnt_val[63:32] = tim_prdata;
                        // Only add compensation when counter is running
                    if (!current_halt && current_timer_en) begin
                        // Adjust compensation based on division setting
                        if (!current_div_en || current_div_val == 0) begin
                            // No division case
                            temp_cnt_val[31:0] = temp_cnt_val[31:0] + 3;
                        end else begin
                            // Division case - compensate based on div_val
                            case (current_div_val)
                                4'h1: temp_cnt_val[31:0] = temp_cnt_val[31:0] + 2; // div by 2
                                4'h2: temp_cnt_val[31:0] = temp_cnt_val[31:0] + 1; // div by 4
                                4'h3: temp_cnt_val[31:0] = temp_cnt_val[31:0]; // div by 8
                                4'h4: temp_cnt_val[31:0] = temp_cnt_val[31:0]; // div by 16
                                // 4'h5: temp_cnt_val[31:0] = temp_cnt_val[31:0]; // div by 32
                                // 4'h6: temp_cnt_val[31:0] = temp_cnt_val[31:0]; // div by 64
                                // 4'h7: temp_cnt_val[31:0] = temp_cnt_val[31:0]; // div by 128
                                // 4'h8: temp_cnt_val[31:0] = temp_cnt_val[31:0]; // div by 256
                                default: temp_cnt_val[31:0] = temp_cnt_val[31:0]; 
                            endcase
                        end
                    end
            
            if (temp_cnt_val === exp_cnt_val)
                $display("t = %0t PASS: cnt = %h matches expect value", $time, temp_cnt_val);
            else begin
                $display("t = %0t FAIL: cnt does not match expect value", $time);
                $display("Expect: %h", exp_cnt_val);
                $display("Actual: %h", temp_cnt_val);
                test_passed = 1'b0;
            end
        end
    end
end
            
            @(posedge sys_clk);

            if (!keep_sel) begin
                tim_psel = 1'b0;
                tim_penable = 1'b0;
                tim_pwrite = 1'b0;
                @(posedge sys_clk);
            end
        end
    endtask

    // Helper Tasks for Common Operations
    task apb_wr;
    input [12:0] addr;
    input [31:0] data;
    input [3:0] strb;
    begin
        $display("----------------------------------------");
        $display("t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b", $time, addr, data, strb);
        apb_acc(addr, 1'b1, data, strb, 32'h0, 1'b0, 1'b0, 64'h0);
    end
endtask

    task apb_rd_chk;
        input [12:0] addr;
        input [31:0] exp_data;
        begin
            $display("----------------------------------------");
            $display("t = %0t [TB READ]: addr=0x%h", $time, addr);
            apb_acc(addr, 1'b0, 32'h0, 4'h0, exp_data, 1'b0, 1'b0, 64'h0);
        end
    endtask

    task apb_cons_wr;
    input [12:0] addr;
    input [31:0] data;
    input [3:0] strb;
    begin
        $display("----------------------------------------");
        $display("t = %0t [TB CONSECUTIVE WRITE]: addr=0x%h data=%h strb=%b", $time, addr, data, strb);
        apb_acc(addr, 1'b1, data, strb, 32'h0, 1'b1, 1'b0, 64'h0);
    end
endtask

    task apb_cons_rd_chk;
        input [12:0] addr;
        input [31:0] exp_data;
        begin
            $display("----------------------------------------");
            $display("t = %0t [TB CONSECUTIVE READ]: addr=0x%h", $time, addr);
            apb_acc(addr, 1'b0, 32'h0, 4'h0, exp_data, 1'b1, 1'b0, 64'h0);
        end
    endtask

    // Counter Check Task
    task chk_cnt_val;
        input [63:0] exp_val;
        begin
            $display("----------------------------------------");
            $display("t = %0t [TB READ]: addr=0x%h", $time, `TDR0_OFFSET);
            apb_acc(`TDR0_OFFSET, 1'b0, 32'h0, 4'h0, exp_val[31:0], 1'b1, 1'b1, exp_val);
            $display("----------------------------------------");
            $display("t = %0t [TB READ]: addr=0x%h", $time, `TDR1_OFFSET);
            apb_acc(`TDR1_OFFSET, 1'b0, 32'h0, 4'h0, exp_val[63:32], 1'b0, 1'b1, exp_val);
        end
    endtask

    task apb_wrong_protocol_rd;
        input [12:0] addr;
        input [31:0] exp_rdata;
        begin
            $display("----------------------------------------");
            $display("t = %0t [WRONG WRITE PROTOCOL]: psel=%b penable=%b pwrite=%b paddr=0x%h pwdata=%h pstrb=%b", 
                    $time, tim_psel, tim_penable, tim_pwrite, tim_paddr, tim_pwdata, tim_pstrb);
            apb_rd_chk(addr, exp_rdata);
        end
    endtask

    task wait_cycles;
        input [63:0] cycles;
        integer i;
        begin
            for (i = 0; i < cycles; i = i + 1) begin
                @(posedge sys_clk);
            end
        end
    endtask

    task sys_reset;
        begin
            sys_rst_n = 0;
            tim_psel = 0;
            tim_pwrite = 0;
            tim_penable = 0;
            tim_paddr = 0;
            tim_pwdata = 0;
            tim_pstrb = 0;
            dbg_mode = 0;
            
            // Initialize counter tracking
            current_div_val = 4'h1; // Default after reset
            current_div_en = 1'b0;
            current_timer_en = 1'b0;
            current_halt = 1'b0;
            
            repeat(1) @(posedge sys_clk);
            sys_rst_n = 1;
            repeat(2) @(posedge sys_clk);
        end
    endtask

    `include "run_test.v"

    initial begin
        test_passed = 1'b1;
        sys_rst_n = 0;
        tim_psel = 0;
        tim_penable = 0;
        tim_pwrite = 0;
        tim_paddr = 0;
        tim_pwdata = 0;
        tim_pstrb = 0;
        dbg_mode = 0;
        
        // Initialize counter tracking
        current_div_val = 4'h1;
        current_div_en = 1'b0;
        current_timer_en = 1'b0;
        current_halt = 1'b0;

        repeat(1) @(posedge sys_clk);
        run_test();

        if (test_passed)
            $display("===================================\nTEST RESULT: PASSED\n===================================");
        else
            $display("===================================\nTEST RESULT: FAILED\n===================================");

        #1000 $finish;
    end

endmodule