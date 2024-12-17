module edge_detector(
    input wire clk,
    input wire rst_n,
    input wire sig_in,
    output wire pulse_out_p,
    output wire pulse_out_n
);

reg sig_in_1d; // Previous sig_in value

// Store the previous value of sig_in on the rising edge of clk or when reset is active
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sig_in_1d <= 1'b0;  // Reset the stored value when rst_n is low
    else
        sig_in_1d <= sig_in;  // Update the stored value with the current sig_in value
end

// Generate the pulse for rising and falling edges, with reset control
assign pulse_out_p = (rst_n == 1'b0) ? 1'b0 : sig_in & (~sig_in_1d);  // Rising edge: current = 1, previous = 0
assign pulse_out_n = (rst_n == 1'b0) ? 1'b0 : (~sig_in) & sig_in_1d;  // Falling edge: current = 0, previous = 1

endmodule