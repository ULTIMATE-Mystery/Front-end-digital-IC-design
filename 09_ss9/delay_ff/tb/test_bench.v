module test_bench;

    reg     a;
    wire    b, c;
    reg     clk;
    reg     rst_n;
  	

    delay_ff u_dut(.*);

    initial begin
        a = 0; 
        
        #100;
        
        @(negedge clk);
        a = 1;

        @(posedge clk);
        $display("t=%10d first posedge clk : a = %b b = %b c = %b",$time,a,test_bench.u_dut.b, c);
        @(negedge clk);
        a = 0;
        @(posedge clk);
        $display("t=%10d second posedge clk: a = %b b = %b c = %b",$time,a,test_bench.u_dut.b,c);
        @(posedge clk);
        $display("t=%10d third posedge clk : a = %b b = %b c = %b",$time,a,test_bench.u_dut.b,c);
        @(posedge clk);
        $display("t=%10d fourth posedge clk: a = %b b = %b c = %b",$time,a,test_bench.u_dut.b,c);


        #100;
        
        $finish;

    end
    
    initial begin 
  	  clk = 0;
  	  forever #25 clk = ~clk;
  	end

  	initial begin
  	  rst_n = 1'b0;
  	  #25 rst_n = 1'b1;
  	end

endmodule
