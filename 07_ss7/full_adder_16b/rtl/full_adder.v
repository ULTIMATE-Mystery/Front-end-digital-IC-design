module full_adder(
    input wire a,
    input wire b,
    input wire c,
    output wire sum,
    output wire carry
);

    wire tmp1, tmp2, tmp3;

    //First half adder
    half_adder ha1 (
        .a_in(a),
        .b_in(b),
        .sum_out(tmp1),
        .carry_out(tmp2)
    );

    //Second half adder
    half_adder ha2 (
   	 .a_in(tmp1),
       	 .b_in(c),
      	 .sum_out(sum),
      	 .carry_out(tmp3)
    );

    //OR gate for final carry
    assign carry = tmp2 || tmp3;

endmodule
