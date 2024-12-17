module param_full_adder #(
    parameter N = 16  // Configurable bit-width
)(
    input wire [N-1:0] a,  // Input A
    input wire [N-1:0] b,  // Input B
    output wire [N-1:0] sum,  // Sum output
    output wire carry  // Carry output
);

    wire [N:0] carry_intermediate;  // Carry chain

    // Set initial carry-in to 0
    assign carry_intermediate[0] = 1'b0;

    // Generate full adders for each bit
    generate
        genvar i;
        for (i = 0; i < N; i = i + 1) begin : gen_full_adders
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .c(carry_intermediate[i]),
                .sum(sum[i]),
                .carry(carry_intermediate[i+1])
            );
        end
    endgenerate

    // Assign final carry output
    assign carry = carry_intermediate[N];

endmodule
