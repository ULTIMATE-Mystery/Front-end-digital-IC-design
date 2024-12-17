module counter #(
    parameter CNT_W = 8  // Parameter to configure the bit-width of the counter
)(
    input wire clk,
    input wire rst_n,
    output reg [CNT_W-1:0] count,  // Counter width is now parameterized
    output wire overflow
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 0;
    end else begin
        if (count == {CNT_W{1'b1}}) begin  // Compare with the maximum value of CNT_W
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
end

assign overflow = (count == {CNT_W{1'b1}});  // Overflow when counter reaches its maximum value

endmodule
