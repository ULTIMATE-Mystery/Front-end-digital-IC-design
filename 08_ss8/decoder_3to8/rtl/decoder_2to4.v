// 2:4 Decoder with Enable
module decoder_2to4 (
	input wire [1:0] X,
	input wire E,
	output reg [3:0] Y
);

	always @(*) begin
		if (E) begin 
			case (X)
				2'b00: Y = 4'b0001;
				2'b01: Y = 4'b0010;
				2'b10: Y = 4'b0100;
				2'b11: Y = 4'b1000;
				default: Y = 4'b0000;
			endcase
		end else begin
			Y = 4'b0000;
		end
	end
endmodule
