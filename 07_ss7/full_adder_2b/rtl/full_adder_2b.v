module full_adder_2b(
    input wire [1:0] a,
    input wire [1:0] b,
    output wire [1:0] sum,
    output wire carry
);
    wire cout_0;

    // First 1-bit full adder for least significant bit
    full_adder fa0(
        .a(a[0]),
        .b(b[0]),
        .c(1'b0),  // No initial carry-in
        .sum(sum[0]),
        .carry(cout_0)
    );

    // Second 1-bit full adder for most significant bit
    full_adder fa1(
        .a(a[1]),
        .b(b[1]),
        .c(cout_0),
        .sum(sum[1]),
        .carry(carry)
    );

endmodule
