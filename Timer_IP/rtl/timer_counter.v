module timer_counter (
    // System signals
    input wire clk,
    input wire rst_n,

    // Control signals
    input wire timer_en,
    input wire cnt_en,
    input wire tdr0_wr_en,
    input wire tdr1_wr_en,
    input wire [63:0] TDR,

    // Counter interface
    input wire [63:0] tcmp,
    output reg [63:0] cnt_val,
    output wire cmp_match
);

    wire  cnt_init;
    reg   delay_timer_en;
    reg   delay_tdr0_wr_en, delay_tdr1_wr_en;

    assign cnt_init = ~timer_en & delay_timer_en;
    assign cmp_match = (cnt_val == tcmp);

    // Counter implementation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || cnt_init) begin
            cnt_val <= 0;
        end else if (!delay_tdr0_wr_en && !delay_tdr1_wr_en && cnt_en && timer_en) begin
            cnt_val <= cnt_val + 1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            delay_timer_en <= 1'b0;
        end else begin
            delay_timer_en <= timer_en;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            delay_tdr0_wr_en <= 1'b0;
            delay_tdr1_wr_en <= 1'b0;
        end else begin
            delay_tdr0_wr_en <= tdr0_wr_en;
            delay_tdr1_wr_en <= tdr1_wr_en;
        end
    end

    always @(*) begin
        if (delay_tdr0_wr_en) begin
            cnt_val [31:0] = TDR [31:0];
        end else if (delay_tdr1_wr_en) begin
            cnt_val [63:32] = TDR [63:32]; 
        end
    end

endmodule
