`timescale 1ns/1ns

module test_bench;
  	reg[7:0] a, b, y;
    reg[2:0] ctrl;
    wire negative, carry, zero;
    integer i;

    reg[7:0] y_and, y_or; 
    reg[8:0] y_sum, y_diff;
    reg      exp_carry, exp_negative, exp_zero;

    alu dut(.*);

  	initial begin
        ctrl = 3'b111;
  		for (i = 0; i < 1000; i=i+1) begin
            a = $urandom;
            if (i == 9999)
                b = -a;
            else
  	  		    b = $urandom;
            #5;
            ctrl = $urandom % 8;
            #5;

  	  		$display("--------------- Case: %3d ctrl = %3b a = %3d, b = %3d --------------", i, ctrl,a, b);
            y_and = a & b;
            y_or = a | b;
            y_sum = a + b;
            y_diff = a - b;
            exp_negative = a < b;
            #10

            if( ctrl == 3'b000) begin
  	  		    $display("a & b = %8b, y = %8b", a & b, y);
  	  		    if (y !== y_and) begin 
  	  		    	$display("FAILED when testing AND");
  	  		    	$finish;
  	  		    end

                if( (~|y_and) !== zero) begin
                    $display("FAILED: Zero flag is mismatched");
                    $display("Exp:%b",~|y_and);
                    $display("Act:%b", zero);
                    $finish;
                end

            end else if( ctrl == 3'b001)  begin
  	  		    $display("a | b = %8b, y = %8b", a | b, y);
  	  		    if (y !== y_or) begin 
  	  		    	$display("FAILED when testing OR");
  	  		    	$finish;
  	  		    end
                
                if( (~|y_or) !== zero) begin
                    $display("FAILED Zero flag is mismatched");
                    $display("Exp:%b",~|y_or);
                    $display("Act:%b", zero);
                    $finish;
                end

            end else if( ctrl == 3'b010) begin
  	  		    $display("a + b = %8b, y = %8b", y_sum[7:0], y);
                exp_carry = y_sum[8];
  	  		    if (y !== y_sum[7:0]) begin 
  	  		    	$display("FAILED when testing ADD");
  	  		    	$finish;
  	  		    end
                
                if( (~|y_sum[7:0]) !== zero) begin
                    $display("FAILED Zero flag is mismatched");
                    $display("Exp:%b",~|y_sum[7:0]);
                    $display("Act:%b", zero);
                    $finish;
                end
                
                if( exp_carry !== carry ) begin
                    $display("FAILED Carry flag is mismatched");
                    $display("Exp:%b",exp_carry);
                    $display("Act:%b", carry);
                    $finish;
                end

            end else if ( ctrl == 3'b110) begin
  	  		    $display("a - b = %8b, y = %8b", y_diff[7:0], y);
                exp_carry = y_diff[8];
  	  		    if (y !== y_diff[7:0]) begin 
  	  		    	$display("FAILED when testing SUB");
  	  		    	$finish;
  	  		    end
                if( (~|y_diff[7:0]) !== zero) begin
                    $display("FAILED Zero flag is mismatched");
                    $display("Exp:%b",~|y_diff[7:0]);
                    $display("Act:%b", zero);
                    $finish;
                end

                if( exp_carry !==carry ) begin
                    $display("FAILED Carry flag is mismatched");
                    $display("Exp:%b",exp_carry);
                    $display("Act:%b", carry);
                    $finish;
                end
                
                if( exp_negative !== negative ) begin
                    $display("Negative flag is mismatched");
                    $display("Exp:%b",exp_negative);
                    $display("Act:%b", negative);
                    $finish;
                end
            end else begin
                if( negative | carry | zero ) begin
                    $display("FAILED: output flag is asserted unexpectedly");
                    $display("Exp:carry=0 negative=0 zero=0");
                    $display("Act:carry=%b negative=%b zero=%b", carry,negative,zero);
                    $finish;
                end

            end
            
  	    end

        $display("Simulation is PASSED");
  	  	
  	    #100;
        $finish;
  	end

endmodule
