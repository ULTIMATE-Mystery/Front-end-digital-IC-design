
`timescale 1ns/1ns

module test_bench;
  	reg clk,rst_n;
	reg	count_en, count_clr;
  	wire [7:0] count;
  	wire overflow;

  	counter dut(
  		.clk		(clk		),
  	  .rst_n		(rst_n	),
  	  .count_en		(count_en	),
  	  .count_clr	(count_clr	),
  	  .count  		(count  	),
  	  .overflow		(overflow 	)
  	 );
			
  	initial begin 
  	  clk = 0;
  	  forever #10 clk = ~clk;
  	end

  	initial begin
  	  rst_n = 1'b0;
  	  #10 rst_n = 1'b1;
  	end

	initial begin
		count_en = 1'b0;
		count_clr = 1'b0;
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
		@(posedge clk);
		count_en = 1'b1;
		repeat (256) begin
			@(posedge clk);
		end
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
		if( overflow == 1'b1) begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: overflow is not negated",$stime);
			$display("------------------------------------------------");
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

		//count_en = 1'b0;
		//repeat (10) begin
		//	@(posedge clk);
		//end
		//	
		//if( count != 8'hb ) begin
		//	$display("------------------------------------------------");
		//	$display("t=%10d FAIL: counter value is not stopped when count_en = 0, count = %2h , expect: 8'hb",$stime,count);
		//	$display("------------------------------------------------");
		//end else begin
		//	$display("------------------------------------------------");
		//	$display("t=%10d PASS: counter value is stopped when count_en = 0",$stime);
		//	$display("------------------------------------------------");
		//end

		count_clr = 1'b1;
		
		//@(posedge clk);
		//count_clr = 1'b0;
		@(posedge clk);
        #1;
		if( count != 8'h0 ) begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: counter value is not cleared when count_clr = 1'b1",$stime); 
			$display("------------------------------------------------");
		    #100;
		    $finish;
		end else begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: counter value is cleared when count_clr is 1'b1",$stime); 
			$display("------------------------------------------------");
		end
	
		repeat (10) begin
			@(posedge clk);
		end

		if( count != 8'h0 ) begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: counter start counting even if counter_en is 1'b0",$stime); 
			$display("------------------------------------------------");
		    #100;
		    $finish;
		end else begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: counter does not start counting when counter_en is 1'b0",$stime); 
			$display("------------------------------------------------");
		end


		#100;
		$finish;


	end

  	//initial 
  	//  $monitor("Time = %t: reset = %0b, count = %0d, overflow = %0b",$stime,reset,count,overflow);
endmodule
