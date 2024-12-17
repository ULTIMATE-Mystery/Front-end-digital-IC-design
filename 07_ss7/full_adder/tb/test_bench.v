module test_bench;

    reg a, b, c;
    wire sum, carry;

    full_adder u_dut(.*);

    initial begin
        a = 0;
        b = 0;
        c = 0;
        #100;
  	    $display("======================================");	
  	    $display("==== Case 1: a = 0, b = 0, c = 0 =====");
  	    $display("======================================");	

        if( carry === 0 & sum === 0 ) begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: a=%b b=%b c=%b sum=%b carry =",$time, a,b,c,sum,carry);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: a=%b b=%b c=%b sum=%b carry =",$time, a,b,c,sum,carry);
			$display("EXPECT: sum = 0, carry = 0");
			$display("------------------------------------------------");
            #100;
            $finish;
        end
  	    
        #100;
        $display("======================================");	
  	    $display("==== Case 2: a = 0, b = 0, c = 1 =====");
  	    $display("======================================");	

        a = 0;
        b = 0;
        c = 1;
        #100;
        if( sum === 1 & carry === 0 ) begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: a=%b b=%b c=%b sum=%b carry =",$time, a,b,c,sum,carry);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: a=%b b=%b c=%b sum=%b carry =",$time, a,b,c,sum,carry);
			$display("EXPECT: sum = 1, carry = 0");
			$display("------------------------------------------------");
            #100;
            $finish;
        end
        
        #100;
        $display("======================================");	
  	    $display("==== Case 3: a = 0, b = 1, c = 0 =====");
  	    $display("======================================");	

        a = 0;
        b = 1;
        c = 0;
        #100;
        if( sum === 1 & carry === 0 ) begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: a=%b b=%b c=%b sum=%b carry =",$time, a,b,c,sum,carry);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: a=%b b=%b c=%b sum=%b carry =",$time, a,b,c,sum,carry);
			$display("EXPECT: sum = 1, carry = 0");
			$display("------------------------------------------------");
            #100;
            $finish;
        end
        
        #100;
        $display("======================================");	
  	    $display("==== Case 4: a = 0, b = 1, c = 1 =====");
  	    $display("======================================");	

        a = 0;
        b = 1;
        c = 1;
        #100;
        if( sum === 0 & carry === 1 ) begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: a=%b b=%b c=%b sum=%b carry =",$time, a,b,c,sum,carry);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: a=%b b=%b c=%b sum=%b carry =",$time, a,b,c,sum,carry);
			$display("EXPECT: sum = 0, carry = 1");
			$display("------------------------------------------------");
            #100;
            $finish;
        end

        #100;
  	    $display("======================================");	
  	    $display("==== Case 5: a = 1, b = 0, c = 0 =====");
  	    $display("======================================");	
        a = 1;
        b = 0;
        c = 0;
        #100;

        if( sum === 1 & carry === 0 ) begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: a=%b b=%b c=%b sum=%b carry =",$time, a,b,c,sum,carry);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: a=%b b=%b c=%b sum=%b carry =",$time, a,b,c,sum,carry);
			$display("EXPECT: sum = 1, carry = 0");
			$display("------------------------------------------------");
            #100;
            $finish;
        end
  	    
        #100;
        $display("======================================");	
  	    $display("==== Case 6: a = 1, b = 0, c = 1 =====");
  	    $display("======================================");	

        a = 1;
        b = 0;
        c = 1;
        #100;
        if( sum === 0 & carry === 1 ) begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: a=%b b=%b c=%b sum=%b carry =",$time, a,b,c,sum,carry);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: a=%b b=%b c=%b sum=%b carry =",$time, a,b,c,sum,carry);
			$display("EXPECT: sum = 0, carry = 1");
			$display("------------------------------------------------");
            #100;
            $finish;
        end
        
        #100;
        $display("======================================");	
  	    $display("==== Case 7: a = 1, b = 1, c = 0 =====");
  	    $display("======================================");	

        a = 1;
        b = 1;
        c = 0;
        #100;
        if( sum === 0 & carry === 1 ) begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: a=%b b=%b c=%b sum=%b carry =",$time, a,b,c,sum,carry);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: a=%b b=%b c=%b sum=%b carry =",$time, a,b,c,sum,carry);
			$display("EXPECT: sum = 0, carry = 1");
			$display("------------------------------------------------");
            #100;
            $finish;
        end
        
        #100;
        $display("======================================");	
  	    $display("==== Case 8: a = 1, b = 1, c = 1 =====");
  	    $display("======================================");	

        a = 1;
        b = 1;
        c = 1;
        #100;
        if( sum === 1 & carry === 1 ) begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: a=%b b=%b c=%b sum=%b carry =",$time, a,b,c,sum,carry);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: a=%b b=%b c=%b sum=%b carry =",$time, a,b,c,sum,carry);
			$display("EXPECT: sum = 1, carry = 1");
			$display("------------------------------------------------");
            #100;
            $finish;
        end

        #100;
        
        $finish;

    end

endmodule
