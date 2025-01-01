module counter(
    input wire clk,
    input wire rst_n,
    input wire count_en,
    input wire count_clr,
    output reg [7:0] count,
    output wire overflow
);

// Counting logic in always block
always @(posedge clk or negedge rst_n) begin
    if (!rst_n || count_clr) begin
        count <= 8'h00;  // Reset count when rst_n is low or count_clr is high
    end else if (count_en) begin
        count <= (count == 8'hFF) ? 8'h00 : count + 1'b1;  // Increment and reset when count reaches max
    end
end

// Overflow is asserted when count reaches 8'hFF
assign overflow = (count == 8'hFF);

endmodule
