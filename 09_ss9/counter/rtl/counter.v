module counter(
    input wire clk,
    input wire rst_n,
    output reg [7:0] count,
    output wire overflow
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 0;
    end else begin
        if (count == 8'hFF) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
end

assign overflow = 1 ? (count == 8'hFF) : 0;

endmodule
