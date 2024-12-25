module detect_string #(
    parameter MEALY_FSM = 1'b0  // 0: Moore FSM, 1: Mealy FSM
)(
    input  wire clk,    // Clock input
    input  wire rst_n,  // Active low reset
    input  wire stream, // Input bit stream
    output wire match   // Match output signal
);
    // State encoding using one-hot encoding for better timing
    parameter [3:0] IDLE = 4'b0001;
    parameter [3:0] S1   = 4'b0010;
    parameter [3:0] S10  = 4'b0100;
    parameter [3:0] S101 = 4'b1000;

    // State registers
    reg [3:0] state, next_state;

    // Next state logic - optimized case statement
    always @(*) begin
        case (state)
            IDLE: next_state = stream ? S1   : IDLE;
            S1:   next_state = stream ? S1   : S10;
            S10:  next_state = stream ? S101 : IDLE;
            S101: next_state = stream ? S1   : S10;
            default: next_state = IDLE;
        endcase
    end

    // State register with async reset
    always @(posedge clk or negedge rst_n) begin
        state <= (!rst_n) ? IDLE : next_state;
    end

    // Output logic using generate block
    generate
        if (MEALY_FSM) begin: mealy_outputs
            // Mealy FSM: Output depends on current state and input
            assign match = (state == S101) && stream;
        end else begin: moore_outputs
            // Moore FSM: Output depends only on current state
            reg match_reg;
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n)
                    match_reg <= 1'b0;
                else
                    match_reg <= (state == S101) && (next_state == S1);
            end
            assign match = match_reg;
        end
    endgenerate

endmodule