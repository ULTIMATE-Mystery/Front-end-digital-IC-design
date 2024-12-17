module mux (
	input wire a,
	input wire b,
	input wire c,
	input wire d,
	input wire [1:0] sel,
	output reg y
);

always @ (sel or a or b or c or d) begin
	if (sel==0)
		y=a;
	else if (sel==1)
		y=b;
	else if (sel==2)
		y=c;
	else 
		y=d;
end
endmodule
