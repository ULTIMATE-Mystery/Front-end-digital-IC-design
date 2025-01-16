module timer_apb_if (
    // System signals
    input  wire         clk,
    input  wire         rst_n,
    
    // APB slave interface
    input  wire         psel,
    input  wire         pwrite,
    input  wire         penable,
    input  wire [12:0]  paddr,
    input  wire [31:0]  pwdata,
    input  wire [3:0]   pstrb,
    output wire [31:0]  prdata,
    output wire         pready,
    output wire         pslverr,

    // Register interface
    output wire         wr_en,
    output wire         rd_en,
    output reg  [12:0]  reg_addr,
    output reg  [31:0]  reg_wdata,
    output reg  [3:0]   reg_wstrb,
    input  wire [31:0]  reg_rdata,
    input  wire         reg_error
);

    // FSM State Definition
    localparam IDLE   = 2'b00;
    localparam SETUP  = 2'b01; 
    localparam ACCESS = 2'b10;

    // Internal registers
    reg [1:0] current_state, next_state;

    // State machine sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            reg_addr <= 12'h0;
            reg_wdata <= 32'h0;
            reg_wstrb <= 4'h0;
        end else begin
            current_state <= next_state;
            
            // Register address and data in SETUP state
            if (current_state == SETUP) begin
                reg_addr <= paddr;
                reg_wdata <= pwdata;
                reg_wstrb <= pstrb;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (psel && !penable) 
                    next_state = SETUP;
                else
                    next_state = IDLE;
            end
            
            SETUP: begin
                if (psel && penable)
                    next_state = ACCESS;
                else if (!psel)
                    next_state = IDLE;
            end

            ACCESS: begin
                // Always exit ACCESS after one cycle
                if (psel && !penable)
                    next_state = SETUP;  // Start new transaction
                else
                    next_state = IDLE;   // No new transaction
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Combinational output logic
    assign wr_en = (current_state == ACCESS) ? pwrite : 1'b0;
    assign rd_en = (current_state == ACCESS) ? !pwrite : 1'b0;
    assign pready = (current_state == ACCESS);
    assign pslverr = pready ? reg_error : 1'b0;
    assign prdata = rd_en ? reg_rdata : 32'h0;

endmodule
