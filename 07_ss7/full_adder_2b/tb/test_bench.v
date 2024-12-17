module test_bench;
  
  	reg [1:0]  a,b;
  	wire [2:0] sum;
  	reg [2:0] res;
    integer i;

  	full_adder_2b dut(.a(a), .b(b), .sum(sum[1:0]), .carry(sum[2]));

  	initial
  	begin
  		for( i = 0; i < 50; i=i+1 ) begin
  	  			a = $urandom_range(0,3);
  	  			b = $urandom_range(0,3);
  	  		#5;
  	  		$display("====================================");	
  	  		$display("==== Case:%2d a = %d, b = %d =======",i,a,b);
  	  		$display("====================================");	
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
