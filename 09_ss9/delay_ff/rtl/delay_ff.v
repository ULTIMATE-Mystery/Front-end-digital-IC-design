module delay_ff (
    input clk, rst_n, a,
    output b, c
);

    reg q1, q2;

    // Asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q1 <= 1'b0;
            q2 <= 1'b0;
        end else begin
            q1 <= a;
            q2 <= q1;
        end
    end

    assign b = q1;
    assign c = q2;

endmodule
