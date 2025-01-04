var g_data = {"name":"../tb/testbench.v","src":"`timescale 1ns/1ps\r\n\r\nmodule testbench;\r\n    // Clock and control signals\r\n    reg sys_clk;\r\n    reg sys_rst_n;\r\n    reg tim_psel;\r\n    reg tim_pwrite;\r\n    reg tim_penable;\r\n    reg [12:0] tim_paddr;\r\n    reg [31:0] tim_pwdata;\r\n    reg [3:0] tim_pstrb;\r\n    reg dbg_mode;\r\n\r\n    // Output signals\r\n    wire [31:0] tim_prdata;\r\n    wire tim_pready;\r\n    wire tim_pslverr;\r\n    wire tim_int;\r\n\r\n    // Test result flag\r\n    reg test_passed;\r\n\r\n    // Counter tracking variables\r\n    reg [3:0] current_div_val;\r\n    reg current_div_en;\r\n    reg current_timer_en;\r\n    reg current_halt;\r\n\r\n    // Clock generation (200MHz)\r\n    initial sys_clk = 0;\r\n    always #2.5 sys_clk = ~sys_clk;\r\n\r\n    // DUT instance\r\n    timer_top u_timer_top (\r\n        .sys_clk(sys_clk),\r\n        .sys_rst_n(sys_rst_n),\r\n        .tim_psel(tim_psel),\r\n        .tim_pwrite(tim_pwrite),\r\n        .tim_penable(tim_penable),\r\n        .tim_paddr(tim_paddr),\r\n        .tim_pwdata(tim_pwdata),\r\n        .tim_pstrb(tim_pstrb),\r\n        .tim_prdata(tim_prdata),\r\n        .tim_pready(tim_pready),\r\n        .tim_pslverr(tim_pslverr),\r\n        .dbg_mode(dbg_mode),\r\n        .tim_int(tim_int)\r\n    );\r\n\r\n    `define TCR_OFFSET      12'h000\r\n    `define TDR0_OFFSET     12'h004  \r\n    `define TDR1_OFFSET     12'h008\r\n    `define TCMP0_OFFSET    12'h00C\r\n    `define TCMP1_OFFSET    12'h010\r\n    `define TIER_OFFSET     12'h014\r\n    `define TISR_OFFSET     12'h018\r\n    `define THCSR_OFFSET    12'h01C\r\n\r\n    // Universal APB access task\r\n    task apb_acc;\r\n        input [12:0] addr;\r\n        input is_write;\r\n        input [31:0] wdata;\r\n        input [3:0] strb;\r\n        input [31:0] exp_rdata;\r\n        input keep_sel;\r\n        input is_cnt_chk;\r\n        input [63:0] exp_cnt_val;\r\n\r\n        reg [63:0] temp_cnt_val;\r\n\r\n        begin\r\n            if (!tim_psel) begin\r\n                tim_psel = 1'b1;\r\n                tim_penable = 1'b0;\r\n                tim_pwrite = is_write;\r\n                tim_paddr = addr;\r\n                if (is_write) begin\r\n                    tim_pwdata = wdata;\r\n                    tim_pstrb = strb;\r\n                end\r\n                @(posedge sys_clk);\r\n            end else begin\r\n                tim_penable = 1'b0;\r\n                tim_pwrite = is_write;\r\n                tim_paddr = addr;\r\n                if (is_write) begin\r\n                    tim_pwdata = wdata;\r\n                    tim_pstrb = strb;\r\n                end\r\n                @(posedge sys_clk);\r\n            end\r\n\r\n            tim_penable = 1'b1;\r\n            wait(tim_pready == 1'b1);\r\n\r\n            if (is_write && !tim_pslverr) begin\r\n                if (addr == `TCR_OFFSET && strb[0]) begin\r\n                    current_timer_en = wdata[0];\r\n                    current_div_en = wdata[1];\r\n                    if (strb[1]) begin\r\n                        current_div_val = wdata[11:8];\r\n                    end\r\n                end else if (addr == `THCSR_OFFSET && strb[0]) begin\r\n                    current_halt = wdata[0] & dbg_mode;\r\n                end\r\n            end\r\n\r\n            if (!is_write) begin\r\n            #1;\r\n            if (!is_cnt_chk) begin\r\n            if (tim_prdata === exp_rdata)\r\n                $display(\"t = %0t PASS: rdata = %h at addr 0x%h is correct\", $time, tim_prdata, addr);\r\n            else begin\r\n                $display(\"t = %0t FAIL: rdata at addr 0x%h is not correct\\nExpected: %h\\nActual: %h\", \r\n                $time, addr, exp_rdata, tim_prdata);\r\n                test_passed = 1'b0;\r\n            end\r\n            end else begin\r\n                if (addr == `TDR0_OFFSET) begin\r\n                    temp_cnt_val[31:0] = tim_prdata;\r\n                end else if (addr == `TDR1_OFFSET) begin\r\n                    temp_cnt_val[63:32] = tim_prdata;\r\n                        // Only add compensation when counter is running\r\n                    if (!current_halt && current_timer_en) begin\r\n                        // Adjust compensation based on division setting\r\n                        if (!current_div_en || current_div_val == 0) begin\r\n                            // No division case\r\n                            temp_cnt_val[31:0] = temp_cnt_val[31:0] + 3;\r\n                        end else begin\r\n                            // Division case - compensate based on div_val\r\n                            case (current_div_val)\r\n                                4'h1: temp_cnt_val[31:0] = temp_cnt_val[31:0] + 2; // div by 2\r\n                                4'h2: temp_cnt_val[31:0] = temp_cnt_val[31:0] + 1; // div by 4\r\n                                4'h3: temp_cnt_val[31:0] = temp_cnt_val[31:0]; // div by 8\r\n                                4'h4: temp_cnt_val[31:0] = temp_cnt_val[31:0]; // div by 16\r\n                                // 4'h5: temp_cnt_val[31:0] = temp_cnt_val[31:0]; // div by 32\r\n                                // 4'h6: temp_cnt_val[31:0] = temp_cnt_val[31:0]; // div by 64\r\n                                // 4'h7: temp_cnt_val[31:0] = temp_cnt_val[31:0]; // div by 128\r\n                                // 4'h8: temp_cnt_val[31:0] = temp_cnt_val[31:0]; // div by 256\r\n                                default: temp_cnt_val[31:0] = temp_cnt_val[31:0]; \r\n                            endcase\r\n                        end\r\n                    end\r\n            \r\n            if (temp_cnt_val === exp_cnt_val)\r\n                $display(\"t = %0t PASS: cnt = %h matches expect value\", $time, temp_cnt_val);\r\n            else begin\r\n                $display(\"t = %0t FAIL: cnt does not match expect value\", $time);\r\n                $display(\"Expect: %h\", exp_cnt_val);\r\n                $display(\"Actual: %h\", temp_cnt_val);\r\n                test_passed = 1'b0;\r\n            end\r\n        end\r\n    end\r\nend\r\n            \r\n            @(posedge sys_clk);\r\n\r\n            if (!keep_sel) begin\r\n                tim_psel = 1'b0;\r\n                tim_penable = 1'b0;\r\n                tim_pwrite = 1'b0;\r\n                @(posedge sys_clk);\r\n            end\r\n        end\r\n    endtask\r\n\r\n    // Helper Tasks for Common Operations\r\n    task apb_wr;\r\n    input [12:0] addr;\r\n    input [31:0] data;\r\n    input [3:0] strb;\r\n    begin\r\n        $display(\"----------------------------------------\");\r\n        $display(\"t = %0t [TB WRITE]: addr=0x%h data=%h strb=%b\", $time, addr, data, strb);\r\n        apb_acc(addr, 1'b1, data, strb, 32'h0, 1'b0, 1'b0, 64'h0);\r\n    end\r\nendtask\r\n\r\n    task apb_rd_chk;\r\n        input [12:0] addr;\r\n        input [31:0] exp_data;\r\n        begin\r\n            $display(\"----------------------------------------\");\r\n            $display(\"t = %0t [TB READ]: addr=0x%h\", $time, addr);\r\n            apb_acc(addr, 1'b0, 32'h0, 4'h0, exp_data, 1'b0, 1'b0, 64'h0);\r\n        end\r\n    endtask\r\n\r\n    task apb_cons_wr;\r\n    input [12:0] addr;\r\n    input [31:0] data;\r\n    input [3:0] strb;\r\n    begin\r\n        $display(\"----------------------------------------\");\r\n        $display(\"t = %0t [TB CONSECUTIVE WRITE]: addr=0x%h data=%h strb=%b\", $time, addr, data, strb);\r\n        apb_acc(addr, 1'b1, data, strb, 32'h0, 1'b1, 1'b0, 64'h0);\r\n    end\r\nendtask\r\n\r\n    task apb_cons_rd_chk;\r\n        input [12:0] addr;\r\n        input [31:0] exp_data;\r\n        begin\r\n            $display(\"----------------------------------------\");\r\n            $display(\"t = %0t [TB CONSECUTIVE READ]: addr=0x%h\", $time, addr);\r\n            apb_acc(addr, 1'b0, 32'h0, 4'h0, exp_data, 1'b1, 1'b0, 64'h0);\r\n        end\r\n    endtask\r\n\r\n    // Counter Check Task\r\n    task chk_cnt_val;\r\n        input [63:0] exp_val;\r\n        begin\r\n            $display(\"----------------------------------------\");\r\n            $display(\"t = %0t [TB READ]: addr=0x%h\", $time, `TDR0_OFFSET);\r\n            apb_acc(`TDR0_OFFSET, 1'b0, 32'h0, 4'h0, exp_val[31:0], 1'b1, 1'b1, exp_val);\r\n            $display(\"----------------------------------------\");\r\n            $display(\"t = %0t [TB READ]: addr=0x%h\", $time, `TDR1_OFFSET);\r\n            apb_acc(`TDR1_OFFSET, 1'b0, 32'h0, 4'h0, exp_val[63:32], 1'b0, 1'b1, exp_val);\r\n        end\r\n    endtask\r\n\r\n    task apb_wrong_protocol_rd;\r\n        input [12:0] addr;\r\n        input [31:0] exp_rdata;\r\n        begin\r\n            $display(\"----------------------------------------\");\r\n            $display(\"t = %0t [WRONG WRITE PROTOCOL]: psel=%b penable=%b pwrite=%b paddr=0x%h pwdata=%h pstrb=%b\", \r\n                    $time, tim_psel, tim_penable, tim_pwrite, tim_paddr, tim_pwdata, tim_pstrb);\r\n            apb_rd_chk(addr, exp_rdata);\r\n        end\r\n    endtask\r\n\r\n    task wait_cycles;\r\n        input [63:0] cycles;\r\n        integer i;\r\n        begin\r\n            for (i = 0; i < cycles; i = i + 1) begin\r\n                @(posedge sys_clk);\r\n            end\r\n        end\r\n    endtask\r\n\r\n    task sys_reset;\r\n        begin\r\n            sys_rst_n = 0;\r\n            tim_psel = 0;\r\n            tim_pwrite = 0;\r\n            tim_penable = 0;\r\n            tim_paddr = 0;\r\n            tim_pwdata = 0;\r\n            tim_pstrb = 0;\r\n            dbg_mode = 0;\r\n            \r\n            // Initialize counter tracking\r\n            current_div_val = 4'h1; // Default after reset\r\n            current_div_en = 1'b0;\r\n            current_timer_en = 1'b0;\r\n            current_halt = 1'b0;\r\n            \r\n            repeat(1) @(posedge sys_clk);\r\n            sys_rst_n = 1;\r\n            repeat(2) @(posedge sys_clk);\r\n        end\r\n    endtask\r\n\r\n    `include \"run_test.v\"\r\n\r\n    initial begin\r\n        test_passed = 1'b1;\r\n        sys_rst_n = 0;\r\n        tim_psel = 0;\r\n        tim_penable = 0;\r\n        tim_pwrite = 0;\r\n        tim_paddr = 0;\r\n        tim_pwdata = 0;\r\n        tim_pstrb = 0;\r\n        dbg_mode = 0;\r\n        \r\n        // Initialize counter tracking\r\n        current_div_val = 4'h1;\r\n        current_div_en = 1'b0;\r\n        current_timer_en = 1'b0;\r\n        current_halt = 1'b0;\r\n\r\n        repeat(1) @(posedge sys_clk);\r\n        run_test();\r\n\r\n        if (test_passed)\r\n            $display(\"===================================\\nTEST RESULT: PASSED\\n===================================\");\r\n        else\r\n            $display(\"===================================\\nTEST RESULT: FAILED\\n===================================\");\r\n\r\n        #1000 $finish;\r\n    end\r\n\r\nendmodule","lang":"verilog"};
processSrcData(g_data);