module counter (
	input wire clk,
	input wire rst_n,
	input wire count_en,
	input wire count_clr,
	output wire overflow,
	output reg [7:0] count
);

always @(posedge clk or negedge rst_n) begin
	if (!rst_n || count_clr) begin
		count <= 8'h00;
	end else if (count_en) begin
		count <= (count == 8'hFF) ? 8'h00 : count + 1'b1;
	end
end

assign overflow = (count == 8'hFF);

endmodule
