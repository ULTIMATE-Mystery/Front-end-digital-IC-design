module half_adder(a_in, b_in, sum_out, carry_out);
	input wire a_in;
	input wire b_in;
	output reg sum_out;
	output reg carry_out;

	always @(a_in or b_in) begin
		sum_out = a_in ^ b_in;
		carry_out = a_in & b_in;
	end
endmodule
