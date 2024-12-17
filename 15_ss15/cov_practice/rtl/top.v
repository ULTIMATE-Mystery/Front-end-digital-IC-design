module top (
    input   wire a,
    input   wire b,
    input   wire c,
    output  wire z 
);

    assign z = a & (b | c);

endmodule
