
`timescale 1ns/1ns

module test_bench;
    reg in1, in2, in3, in4;
    wire out;

    and_gate_func dut(.*);

    initial begin
        in1 = 0;
        in2 = 0;
        in3 = 0;
        in4 = 0;

        #100;

        in1 = 1;
        in2 = 1;

        in3 = 1;
        in4 = 1;

        #1;

        if( out == 1 ) begin
            $display("PASS");

        end else begin
            $display("FAIL");

        end




        #100;

        $finish;
  	end




endmodule
