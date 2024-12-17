module timer_ctrl (
    // System signals
    input  wire         clk,
    input  wire         rst_n,

    // Debug interface
    input  wire         dbg_mode,
    
    // Control interface
    input  wire         timer_en,
    input  wire         div_en,
    input  wire [3:0]   div_val,
    input  wire         halt_req,
    
    // Counter control
    output wire         cnt_en,
    output wire         halt_ack
);

    // Internal signals
    reg [7:0] div_cnt;
    wire div_match;

    // Division match detection
    assign div_match = (div_cnt == get_div_value(div_val));
    
    // Counter enable and halt acknowledge generation
    assign halt_ack = halt_req && dbg_mode;
    assign cnt_en = (!div_en || div_match) && (!halt_ack);
    
    // Division counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || !timer_en) begin
            div_cnt <= 8'd0;
        end else if (halt_ack) begin
            div_cnt <= div_cnt;
        end else if (!div_en || div_match) begin
            div_cnt <= 8'd0;
        end else begin
            div_cnt <= div_cnt + 1'b1;
        end
    end
    
    // Division value decoder function
    function [7:0] get_div_value;
        input [3:0] div_val;
        begin
            case (div_val)
                4'b0000: get_div_value = 8'd0;    // No division
                4'b0001: get_div_value = 8'd1;    // Divide by 2
                4'b0010: get_div_value = 8'd3;    // Divide by 4
                4'b0011: get_div_value = 8'd7;    // Divide by 8
                4'b0100: get_div_value = 8'd15;   // Divide by 16
                4'b0101: get_div_value = 8'd31;   // Divide by 32
                4'b0110: get_div_value = 8'd63;   // Divide by 64
                4'b0111: get_div_value = 8'd127;  // Divide by 128
                4'b1000: get_div_value = 8'd255;  // Divide by 256
                default: get_div_value = 8'd1;
            endcase
        end
    endfunction

endmodule