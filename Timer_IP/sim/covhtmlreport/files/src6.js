var g_data = {"name":"../rtl/timer_ctrl.v","src":"module timer_ctrl (\r\n    // System signals\r\n    input  wire         clk,\r\n    input  wire         rst_n,\r\n\r\n    // Debug interface\r\n    input  wire         dbg_mode,\r\n    \r\n    // Control interface\r\n    input  wire         timer_en,\r\n    input  wire         div_en,\r\n    input  wire [3:0]   div_val,\r\n    input  wire         halt_req,\r\n    \r\n    // Counter control\r\n    output wire         cnt_en,\r\n    output wire         halt_ack\r\n);\r\n\r\n    // Internal signals\r\n    reg [7:0] div_cnt;\r\n    wire div_match;\r\n\r\n    // Division match detection\r\n    assign div_match = (div_cnt == get_div_value(div_val));\r\n    \r\n    // Counter enable and halt acknowledge generation\r\n    assign halt_ack = halt_req && dbg_mode;\r\n    assign cnt_en = (!div_en || div_match) && (!halt_ack);\r\n    \r\n    // Division counter\r\n    always @(posedge clk or negedge rst_n) begin\r\n        if (!rst_n || !timer_en) begin\r\n            div_cnt <= 8'd0;\r\n        end else if (halt_ack) begin\r\n            div_cnt <= div_cnt;\r\n        end else if (!div_en || div_match) begin\r\n            div_cnt <= 8'd0;\r\n        end else begin\r\n            div_cnt <= div_cnt + 1'b1;\r\n        end\r\n    end\r\n    \r\n    // Division value decoder function\r\n    function [7:0] get_div_value;\r\n        input [3:0] div_val;\r\n        begin\r\n            case (div_val)\r\n                4'b0000: get_div_value = 8'd0;    // No division\r\n                4'b0001: get_div_value = 8'd1;    // Divide by 2\r\n                4'b0010: get_div_value = 8'd3;    // Divide by 4\r\n                4'b0011: get_div_value = 8'd7;    // Divide by 8\r\n                4'b0100: get_div_value = 8'd15;   // Divide by 16\r\n                4'b0101: get_div_value = 8'd31;   // Divide by 32\r\n                4'b0110: get_div_value = 8'd63;   // Divide by 64\r\n                4'b0111: get_div_value = 8'd127;  // Divide by 128\r\n                4'b1000: get_div_value = 8'd255;  // Divide by 256\r\n                default: get_div_value = 8'd1;\r\n            endcase\r\n        end\r\n    endfunction\r\n\r\nendmodule","lang":"verilog"};
processSrcData(g_data);