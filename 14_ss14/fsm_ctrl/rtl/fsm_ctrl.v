module fsm_ctrl #(
    parameter MEALY_FSM = 1'b0  // 0: Moore FSM, 1: Mealy FSM
)(
    input  wire clk,    // Clock input
    input  wire rst_n,  // Active low reset
    input  wire coin,   // Coin insert signal
    input  wire start,  // Start button signal
    output wire lock,   // Lock output signal  
    output wire unlock  // Unlock output signal
);
    // State encoding - single bit is sufficient
    localparam LOCK_STATE   = 1'b0;
    localparam UNLOCK_STATE = 1'b1;

    // State registers - single bit state
    reg  state, next_state;

    // Next state logic - simple conditional assignments
    always @(*) begin
        next_state = state; // Default: maintain current state
        case (state)
            LOCK_STATE:   if (coin)  next_state = UNLOCK_STATE;
            default:      if (start) next_state = LOCK_STATE;   // UNLOCK_STATE case
        endcase
    end

    // State register with async reset
    always @(posedge clk or negedge rst_n) begin
        state <= (!rst_n) ? LOCK_STATE : next_state;
    end

    // Output logic - direct wire assignments for better timing
    generate
        if (MEALY_FSM) begin: mealy_outputs
            // Mealy FSM outputs depend on state and inputs
            assign lock   = (state == LOCK_STATE) ? !coin : start;
            assign unlock = (state == LOCK_STATE) ? coin  : !start;
        end else begin: moore_outputs
            // Moore FSM outputs depend only on state
            assign lock   = (state == LOCK_STATE);
            assign unlock = (state == UNLOCK_STATE);
        end
    endgenerate

endmodule