
`timescale 1ns/1ns

module test_bench;
    reg clk,rst_n;
    wire [7:0] count;
    wire overflow;

    counter dut(.*);

    initial begin 
  	  clk = 0;
  	  forever #25 clk = ~clk;
  	end

  	initial begin
  	    rst_n = 1'b0;

        #100;
        if( count != 8'h00 ) begin
			    $display("------------------------------------------------");
			    $display("t=%10d FAIL: the init value of counter is not 8'h00",$time);
			    $display("------------------------------------------------");
                #100;
                $finish;
		end else begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: the init value of counter is 8'h00.", $stime);
			$display("------------------------------------------------");

		end
        
        #10;

        @(negedge clk);

        rst_n = 1'b1;
		
        repeat (255) begin
			@(posedge clk);
		end
        #1;
		if( count != 8'hff ) begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: counter value is not correct, count = %2h , expect: 8'hff",$stime,count);
			$display("------------------------------------------------");
            #100;
            $finish;
		end else begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: counter value is correct,8'hff",$stime);
			$display("------------------------------------------------");
		end
		
        if( overflow != 1'b1) begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: overflow is not asserted",$stime);
			$display("------------------------------------------------");
            #100;
            $finish;
		end else begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: overflow is asserted",$stime);
			$display("------------------------------------------------");
		end
		@(posedge clk);
        #1;
		if( overflow == 1'b1) begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: overflow is not negated",$stime);
			$display("------------------------------------------------");
            #100;
            $finish;
		end else begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: overflow is negated",$stime);
			$display("------------------------------------------------");
		end
		if( count != 8'h00 ) begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: counter value is not init to 8'h00 after overflow. count = %2h , expect: 8'h00",$stime, count);
			$display("------------------------------------------------");
            #100;
            $finish;
		end else begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: counter value is 8'h00 after overflow",$stime);
			$display("------------------------------------------------");
		end

		repeat (10) begin
			@(posedge clk);
		end
        #1;
		if( count != 8'ha ) begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: counter value is not correct, count = %2h , expect: 8'ha",$stime,count);
			$display("------------------------------------------------");
            #100;
            $finish;
		end else begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: counter value is correct - 8'ha",$stime);
			$display("------------------------------------------------");
		end
        #100;

        $finish;
  	end




endmodule
