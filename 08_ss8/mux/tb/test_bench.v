module test_bench;

    reg a,b,c,d;
    reg [1:0] sel;
    wire y;

    mux u_dut(.*);

    initial begin
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        sel = 0;
        
        #100;

        a = 1;
        b = 0;
        c = 0;
        d = 0;
        sel = 0;
        #1; 
  	    $display("====================================");	
  	    $display("========== Case 1:  sel = 0, =======");
  	    $display("====================================");	

        if( y === a ) begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: a=%b b=%b c=%b d=%b sel=%b y=%b",$time, a,b,c,d,sel,y);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: a=%b b=%b c=%b d=%b sel=%b y=%b",$time, a,b,c,d,sel,y);
			$display("EXPECT: y=a");
			$display("------------------------------------------------");
            #100;
            $finish;
        end
        
        #100;
        a = 0;
        b = 1;
        c = 0;
        d = 0;
        sel = 1;
        #1; 
  	    $display("====================================");	
  	    $display("========== Case 2:  sel = 1, =======");
  	    $display("====================================");	

        if( y === b ) begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: a=%b b=%b c=%b d=%b sel=%b y=%b",$time, a,b,c,d,sel,y);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: a=%b b=%b c=%b d=%b sel=%b y=%b",$time, a,b,c,d,sel,y);
			$display("EXPECT: y=b");
			$display("------------------------------------------------");
            #100;
            $finish;
        end
  	    
        #100;
        a = 0;
        b = 0;
        c = 1;
        d = 0;
        sel = 2;
        #1; 
  	    $display("====================================");	
  	    $display("========== Case 3:  sel = 2, =======");
  	    $display("====================================");	

        if( y === c ) begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: a=%b b=%b c=%b d=%b sel=%b y=%b",$time, a,b,c,d,sel,y);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: a=%b b=%b c=%b d=%b sel=%b y=%b",$time, a,b,c,d,sel,y);
			$display("EXPECT: y=c");
			$display("------------------------------------------------");
            #100;
            $finish;
        end
        
        #100;
        a = 0;
        b = 0;
        c = 0;
        d = 1;
        sel = 3;
        #1; 
  	    $display("====================================");	
  	    $display("========== Case 4:  sel = 3, =======");
  	    $display("====================================");	

        if( y === d ) begin
			$display("------------------------------------------------");
			$display("t=%10d PASS: a=%b b=%b c=%b d=%b sel=%b y=%b",$time, a,b,c,d,sel,y);
			$display("------------------------------------------------");
        end else begin
			$display("------------------------------------------------");
			$display("t=%10d FAIL: a=%b b=%b c=%b d=%b sel=%b y=%b",$time, a,b,c,d,sel,y);
			$display("EXPECT: y=d");
			$display("------------------------------------------------");
            #100;
            $finish;
        end

        #100;
        
        $finish;

    end

endmodule
