module full_adder_16b(
    input wire [15:0] a,
    input wire [15:0] b,
    output wire [15:0] sum,
    output wire carry
);

    wire [16:0] carry_intermediate;
   
    // Set the initial carry to 0
    assign carry_intermediate[0] = 1'b0;
   
    // Generate all full adders in a loop
    generate
        for (genvar i = 0; i < 16; i = i + 1) begin : gen_full_adders
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .c(carry_intermediate[i]),
                .sum(sum[i]),
                .carry(carry_intermediate[i+1])
            );
        end
    endgenerate

    // Assign the final carry
    assign carry = carry_intermediate[16];

endmodule
