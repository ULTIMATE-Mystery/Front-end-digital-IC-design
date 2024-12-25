module test_bench;

    parameter MEALY_FSM = 1'b0;
    
    reg     clk, rst_n;
    reg     coin, start;
    wire    lock, unlock;




    fsm_ctrl #(.MEALY_FSM(MEALY_FSM)) u_fsm (.*);
    

    initial begin 
  	  clk = 0;
  	  forever #25 clk = ~clk;
  	end

  	initial begin
  	  rst_n = 1'b0;
  	  #25 rst_n = 1'b1;
  	end


    initial begin
        coin = 0;
        start = 0;
		$display("------------------------------------------------");
	    $display("TB IS RUNNING WITH MEALY_FSM = %d",MEALY_FSM);
		$display("------------------------------------------------");

        #100;
        @(posedge clk);
        #1 coin = 1;
        #1;
        if( MEALY_FSM ) begin
            if( lock === 1'b0) begin
		        $display("------------------------------------------------");
		        $display("t=%10d PASSED: Lock is 0 right after coin = 1 in Mealy FSM",$time);
		        $display("------------------------------------------------");
            end else begin
		        $display("------------------------------------------------");
		        $display("t=%10d FAILED: Lock is 1 right after coin = 1 in Mealy FSM. Expect 0", $time);
		        $display("------------------------------------------------");
                #100;
                $finish;
            end
        end else begin
            if( lock === 1'b0) begin
		        $display("------------------------------------------------");
		        $display("t=%10d FAILED: Lock is 0 right after coin = 1 in Moore FSM. Expect 1", $time);
		        $display("------------------------------------------------");
                #100;
                $finish;
            end else begin
		        $display("------------------------------------------------");
		        $display("t=%10d PASSED: Lock is 1 right after coin = 1 in Moore FSM", $time);
		        $display("------------------------------------------------");
            end

        end

        @(posedge clk);
        #1
        if( MEALY_FSM ) begin
            //do nothing
        end else begin
            if( lock === 1'b0) begin
		        $display("------------------------------------------------");
		        $display("t=%10d PASSED: Lock is 0 1 cycle after coin = 1 in Moore FSM", $time);
		        $display("------------------------------------------------");
            end else begin
		        $display("------------------------------------------------");
		        $display("t=%10d FAILED: Lock is 1 1 cycle after coin = 1 in Moore FSM. Expect 0", $time);
		        $display("------------------------------------------------");
                #100;
                $finish;
            end

        end
        @(posedge clk);
        #1 coin = 1'b0;

        @(posedge clk);
        #1 start = 1;
        #1;
        if( MEALY_FSM ) begin
            if( lock === 1'b1) begin
		        $display("------------------------------------------------");
		        $display("t=%10d PASSED: Lock is 1 right after start = 1 in Mealy FSM", $time);
		        $display("------------------------------------------------");
            end else begin
		        $display("------------------------------------------------");
		        $display("t=%10d FAILED: Lock is 0 right after start = 1 in Mealy FSM. Expect 1", $time);
		        $display("------------------------------------------------");
                #100;
                $finish;
            end
        end else begin
            if( lock === 1'b1) begin
		        $display("------------------------------------------------");
		        $display("t=%10d FAILED: Lock is 1 right after start = 1 in Moore FSM. Expect 0", $time);
		        $display("------------------------------------------------");
                #100;
                $finish;
            end else begin
		        $display("------------------------------------------------");
		        $display("t=%10d PASSED: Lock is 0 right after start = 1 in Moore FSM", $time);
		        $display("------------------------------------------------");
            end

        end

        @(posedge clk);
        #1
        if( MEALY_FSM ) begin
            //do nothing
        end else begin
            if( lock === 1'b1) begin
		        $display("------------------------------------------------");
		        $display("t=%10d PASSED: Lock is 1 1 cycle after start = 1 in Moore FSM", $time);
		        $display("------------------------------------------------");
            end else begin
		        $display("------------------------------------------------");
		        $display("t=%10d FAILED: Lock is 0 1 cycle after start = 1 in Moore FSM. Expect 1", $time);
		        $display("------------------------------------------------");
                #100;
                $finish;
            end

        end
        @(posedge clk);
        #1 start = 1'b0;

        #100;
        $finish;
        
    end


endmodule

