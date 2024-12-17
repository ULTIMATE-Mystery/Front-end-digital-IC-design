module timer_registers (
    // System signals
    input wire clk,
    input wire rst_n,

    // APB interface
    input wire wr_en,
    input wire rd_en,
    input wire [12:0] reg_addr,
    input wire [31:0] reg_wdata,
    input wire [3:0]  reg_wstrb,
    output reg [31:0] reg_rdata,
    output reg reg_error,

    // Counter module
    output wire timer_en,
    output wire [63:0] TDR,
    output wire div_en,
    output wire [3:0] div_val,
    output wire halt_req,
    output wire [63:0] tcmp,
    output wire tdr0_wr_en,
    output wire tdr1_wr_en,
    input wire [63:0] cnt_val,
    input wire cmp_match,
    input wire halt_ack,

    // Interrupt interface
    output wire int_en,
    output wire int_st
);

    // Register Definitions
    reg [31:0] TCR;
    reg [31:0] TDR0, TDR1;
    reg [31:0] TCMP0, TCMP1;
    reg [31:0] TIER, TISR, THCSR;

    // Address Map
    localparam TCR_ADDR   = 12'h00,
               TDR0_ADDR  = 12'h04,
               TDR1_ADDR  = 12'h08,
               TCMP0_ADDR = 12'h0C,
               TCMP1_ADDR = 12'h10,
               TIER_ADDR  = 12'h14,
               TISR_ADDR  = 12'h18,
               THCSR_ADDR = 12'h1C;

    // Control signals

    wire valid_addr_space = (reg_addr <= 13'hFFF);

    function [31:0] get_write_data;
        input [31:0] reg_data;
        input [31:0] reg_wdata;
        input [3:0]  strb;
        begin
            get_write_data = (reg_wdata & {{8{strb[3]}}, {8{strb[2]}}, {8{strb[1]}}, {8{strb[0]}}}) |
                             (reg_data & ~{{8{strb[3]}}, {8{strb[2]}}, {8{strb[1]}}, {8{strb[0]}}});
        end
    endfunction

    // TCR register write error
    wire tcr_wr_err = (wr_en && (reg_addr == TCR_ADDR)) && 
                 ((reg_wstrb[1] && (reg_wdata[11:8] > 4'h8)) || 
                 (TCR[0] && ((reg_wstrb[1] && (reg_wdata[11:8] != TCR[11:8])) || 
                            (reg_wstrb[0] && (reg_wdata[1] != TCR[1])))));

    // Register Write Access
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            TCR   <= 32'h0000_0100;
            TDR0  <= 32'h0000_0000;
            TDR1  <= 32'h0000_0000;
            TCMP0 <= 32'hFFFF_FFFF;
            TCMP1 <= 32'hFFFF_FFFF;
            TIER  <= 32'h0000_0000;
            TISR  <= 32'h0000_0000;
            THCSR <= 32'h0000_0000;
            reg_error <= 0;

        end else begin
            if (wr_en) begin
                case (reg_addr)

                    TCR_ADDR: begin
                        if (tcr_wr_err) begin
                            reg_error <= 1'b1;
                        end else begin
                            TCR <= get_write_data (TCR, reg_wdata, reg_wstrb);
                        end
                    end

                    TDR0_ADDR: TDR0 <= get_write_data (TDR0, reg_wdata, reg_wstrb);                 

                    TDR1_ADDR: TDR1 <= get_write_data (TDR1, reg_wdata, reg_wstrb);       

                    TCMP0_ADDR: TCMP0 <= get_write_data (TCMP0, reg_wdata, reg_wstrb);

                    TCMP1_ADDR: TCMP1 <= get_write_data (TCMP1, reg_wdata, reg_wstrb);

                    TIER_ADDR:  TIER <= get_write_data (TIER, reg_wdata, reg_wstrb);

                    TISR_ADDR: begin
                        if (reg_wstrb[0] && reg_wdata[0]) begin
                            TISR[0] <= 0;
                        end else begin
                            TISR[0] <= TISR[0];
                        end
                    end

                    THCSR_ADDR: begin
                        if (reg_wstrb[0]) begin
                            THCSR[0] <= reg_wdata[0];
                        end
                    end

                    default: begin
                        // No default action required
                    end
                endcase
            end
        end
    end

    // Register Read Access
    always @(*) begin
        if (rd_en) begin
            case (reg_addr)
                TCR_ADDR:   reg_rdata = {20'h0, TCR[11:8], 6'h0, TCR[1], TCR[0]};
                TDR0_ADDR:  reg_rdata = cnt_val [31:0];
                TDR1_ADDR:  reg_rdata = cnt_val [63:32];
                TCMP0_ADDR: reg_rdata = TCMP0;
                TCMP1_ADDR: reg_rdata = TCMP1;
                TIER_ADDR:  reg_rdata = {31'h0, TIER[0]};
                TISR_ADDR:  reg_rdata = {31'h0, TISR[0]};
                THCSR_ADDR: reg_rdata = {30'h0, THCSR[1], THCSR[0]};
                default:    reg_rdata = 32'h0000_0000;
            endcase
        end else begin
            reg_rdata = 32'h0;
        end
    end

    // Set interrupt status flag when counter equals compare value
    always @(posedge clk or negedge rst_n) begin
        if (cmp_match) begin
            TISR[0] <= 1'b1;
        end else begin
            TISR[0] <= TISR[0];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            THCSR[1] <= 1'b0;
        else  
            THCSR[1] <= halt_ack;  // Sync halt_ack into register
    end

    // Logic for `pslverr` (`reg_error`)
    always @(*) begin
        if (!valid_addr_space || tcr_wr_err) begin
            reg_error = 1'b1;
        end else begin
            reg_error = 1'b0; // No error for valid address range, even if unmapped register address
        end
    end

    assign tdr0_wr_en = wr_en && (reg_addr == TDR0_ADDR);
    assign tdr1_wr_en = wr_en && (reg_addr == TDR1_ADDR);

    // Output Assignments
    assign timer_en = TCR[0];
    assign div_en = TCR[1];
    assign div_val = TCR[11:8];
    assign halt_req = THCSR[0];
    assign TDR = {TDR1, TDR0};
    assign tcmp = {TCMP1, TCMP0};
    assign int_en = TIER[0];
    assign int_st = TISR[0];

endmodule