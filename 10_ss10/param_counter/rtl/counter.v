module counter #(
    parameter CNT_W = 16  // Parameter to configure the bit-width of the counter, default 16 bits
)(
    input wire clk,
    input wire rst_n,
    output reg [CNT_W-1:0] count,  // Counter width is parameterized
    output wire overflow
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 0;  // Reset the counter to 0
    end else begin
        if (count == {CNT_W{1'b1}}) begin  // If count reaches the maximum value based on CNT_W
            count <= 0;  // Reset on overflow
        end else begin
            count <= count + 1;  // Increment counter
        end
    end
end

assign overflow = (count == {CNT_W{1'b1}});  // Overflow when counter reaches maximum value

endmodule
