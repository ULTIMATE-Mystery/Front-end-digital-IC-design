module alu (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [2:0] ctrl,
    output wire [7:0] y,
    output wire zero,
    output wire carry,
    output wire negative
);

reg [8:0] result;  // 9-bit result to hold carry out for add/sub

always @(*) begin
    case (ctrl)
        3'b000:  result = {1'b0, a & b};  // AND
        3'b001:  result = {1'b0, a | b};  // OR
        3'b010:  result = a + b;          // Addition
        3'b110:  result = a - b;          // Subtraction
        default: result = 9'h0;           // Default case to handle unrecognized control signals
    endcase
end

assign y = result[7:0];

// Only assert flags for supported operations (AND, OR, ADD, SUB)
assign zero = (ctrl == 3'b000 || ctrl == 3'b001 || ctrl == 3'b010 || ctrl == 3'b110) && (y == 8'b0);
assign carry = (ctrl == 3'b010 || ctrl == 3'b110) && result[8];  // Carry only for ADD and SUB
assign negative = (ctrl == 3'b110) ? (a < b) : 1'b0;             // Negative flag only for SUB

endmodule
