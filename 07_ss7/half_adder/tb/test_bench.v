module test_bench;

    reg a_in, b_in;
    wire sum_out, carry_out;

    half_adder u_dut(.*);

    initial begin
        a_in = 0;
        b_in = 0;
        #100;
  	    $display("====================================");	
  	    $display("==== Case 1: a_in = 0, b_in = 0=====");
  	    $display("====================================");	

        if( carry_out === 0 & sum_out === 0 ) begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: a_in=%b b_in=%b sun_out=%b carry_out =",$time, a_in,b_in,sum_out,carry_out);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: a_in=%b b_in=%b sun_out=%b carry_out =",$time, a_in,b_in,sum_out,carry_out);
			$display("EXPECT: sum_out = 0, carry_out = 0");
			$display("------------------------------------------------");
            #100;
            $finish;
        end
  	    
        $display("====================================");	
  	    $display("==== Case 2: a_in = 0, b_in = 1=====");
  	    $display("====================================");	

        a_in = 0;
        b_in = 1;
        #100;

        if( carry_out === 0 & sum_out === 1 ) begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: a_in=%b b_in=%b sun_out=%b carry_out =",$time, a_in,b_in,sum_out,carry_out);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: a_in=%b b_in=%b sun_out=%b carry_out =",$time, a_in,b_in,sum_out,carry_out);
			$display("EXPECT: sum_out = 1, carry_out = 0");
			$display("------------------------------------------------");
            #100;
            $finish;
        end
        
        $display("====================================");	
  	    $display("==== Case 3: a_in = 1, b_in = 0=====");
  	    $display("====================================");	

        a_in = 1;
        b_in = 0;
        #100;

        if( carry_out === 0 & sum_out === 1 ) begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: a_in=%b b_in=%b sun_out=%b carry_out =",$time, a_in,b_in,sum_out,carry_out);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: a_in=%b b_in=%b sun_out=%b carry_out =",$time, a_in,b_in,sum_out,carry_out);
			$display("EXPECT: sum_out = 1, carry_out = 0");
			$display("------------------------------------------------");
            #100;
            $finish;
        end
        
        $display("====================================");	
  	    $display("==== Case 4: a_in = 1, b_in = 1=====");
  	    $display("====================================");	

        a_in = 1;
        b_in = 1;
        #100;

        if( carry_out === 1 & sum_out === 0 ) begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: a_in=%b b_in=%b sun_out=%b carry_out =",$time, a_in,b_in,sum_out,carry_out);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: a_in=%b b_in=%b sun_out=%b carry_out =",$time, a_in,b_in,sum_out,carry_out);
			$display("EXPECT: sum_out = 0, carry_out = 1");
			$display("------------------------------------------------");
            #100;
            $finish;
        end

        #100;
        
        $finish;

    end

endmodule
