module test_bench;
  
  	reg [15:0]  a,b;
  	wire [16:0] sum;
  	reg [16:0] res;
    integer i;

  	full_adder_16b dut(.a(a), .b(b), .sum(sum[15:0]), .carry(sum[16]));

  	initial
  	begin
  		for( i = 0; i < 1000; i=i+1 ) begin
            if( i == 999) begin
                a = 16'hffff;
                b = 16'hffff;
            end else begin
  	  	        a = $urandom_range(0,65535);
  	  		    b = $urandom_range(0,65535);
            end
  	  		#5;
  	  		$display("========================================================");	
  	  		$display("=============== Case:%d a = %d, b = %d ==============",i,a,b);
  	  		$display("========================================================");	
  	  		res = a+b;
  	  		$display("Exp: %d Actual: %d", res, sum);
  	  		if( res === sum) begin 
  	  			$display(">>>>>>>>>>>  PASS <<<<<<<<<<<<<\n");
  	  		end else begin
  	  			$display(">>>>>>>>>>>  FAIL <<<<<<<<<<<<<\n");
  	  			$finish;
  	  		end
  	  end
  	  	
  	#100; $finish;
  	end

  //initial
  //begin
  //  //$monitor("%t: a = %d, b = %d, c = %0b. Expected value = %d, Actual Value = %d",$time,a,b,cin,exp,res);
  //  //$monitor("%t: a = %d, b = %d. Expected value = %d, Actual Value = %d",$time,a,b,exp,res);
  //end

  //always @* begin
  //  res = sum + (carry << 2);
  //  exp = a + b;
  //end

endmodule
