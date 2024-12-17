module test_bench;

    reg [2:0] X;
    wire [7:0] Y;
  	
    reg [7:0] exp_res;
    integer i;

    decoder_3to8 u_dut(.*);

    initial begin
        X = 0; 
        exp_res =0;
        
        #100;

  		for( i = 0; i < 50; i=i+1 ) begin
  	  		X = $urandom_range(0,7);
  	  		#5;
  	  		$display("====================================");	
  	  		$display("==== Case:%2d X = %d    =======",i,X);
  	  		$display("====================================");	
  	  		exp_res = 1 << X;
  	  		$display("Exp: %d Actual: %d", exp_res, Y);
  	  		if( exp_res === Y) begin 
  	  			$display(">>>>>>>>>>>  PASS <<<<<<<<<<<<<\n");
  	  		end else begin
  	  			$display(">>>>>>>>>>>  FAIL <<<<<<<<<<<<<\n");
  	  			$finish;
  	  		end
         end


        #100;
        
        $finish;

    end

endmodule
