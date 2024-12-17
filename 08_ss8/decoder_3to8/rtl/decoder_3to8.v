// 3:8 Decoder using two 2:4 Decoders
module decoder_3to8 (
	input wire [2:0] X,
	output wire [7:0] Y
);

	decoder_2to4 dec1 (
		.X(X[1:0]),
		.E(~X[2]),
		.Y(Y[3:0])
	);

	decoder_2to4 dec2 (
                .X(X[1:0]),
                .E(X[2]),
                .Y(Y[7:4])
        );
endmodule
