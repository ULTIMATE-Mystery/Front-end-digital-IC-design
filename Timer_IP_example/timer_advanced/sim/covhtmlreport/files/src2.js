var g_data = {"name":"run_test.v","src":"task run_test();\n    reg [31:0]  task_rdata;\n    reg         err;\n    begin\n  	    err = 0;\n        $display(\"=====================================\");	\n  	    $display(\"=== Test Case: APB Un-aligned Test===\");\n  	    $display(\"=====================================\");	\n        \n        //normal APB \n        test_bench.apb_wr(ADDR_TDR0, 32'h3333_3333);\n\n        test_bench.apb_rd( ADDR_TDR0, task_rdata);\n        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h3333_3333, 32'hffff_ffff);\n\n        //un-aligned: offset 0x1\n        $display(\"un-aligned: offset 0x1\");\n        test_bench.apb_wr(ADDR_TDR0+1, 32'h4444_4444);\n\n        test_bench.apb_rd( ADDR_TDR0+1, task_rdata);\n        test_bench.cmp_data( ADDR_TDR0+1, task_rdata, 32'h0, 32'hffff_ffff);\n\n        test_bench.apb_rd( ADDR_TDR0, task_rdata);\n        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h3333_3333, 32'hffff_ffff);\n\n        //un-aligned: offset 0x2\n        $display(\"un-aligned: offset 0x2\");\n        test_bench.apb_wr(ADDR_TDR0+2, 32'h4444_4444);\n\n        test_bench.apb_rd( ADDR_TDR0+2, task_rdata);\n        test_bench.cmp_data( ADDR_TDR0+2, task_rdata, 32'h0, 32'hffff_ffff);\n\n        test_bench.apb_rd( ADDR_TDR0, task_rdata);\n        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h3333_3333, 32'hffff_ffff);\n        \n        //un-aligned: offset 0x3\n        $display(\"un-aligned: offset 0x3\");\n        test_bench.apb_wr(ADDR_TDR0+2, 32'h4444_4444);\n\n        test_bench.apb_rd( ADDR_TDR0+3, task_rdata);\n        test_bench.cmp_data( ADDR_TDR0+3, task_rdata, 32'h0, 32'hffff_ffff);\n\n        test_bench.apb_rd( ADDR_TDR0, task_rdata);\n        test_bench.cmp_data( ADDR_TDR0, task_rdata, 32'h3333_3333, 32'hffff_ffff);\n\n        if( test_bench.err != 0 )\n            $display(\"Test_result FAILED\");\n        else\n            $display(\"Test_result PASSED\");\n\n    end\n\n\nendtask\n","lang":"verilog"};
processSrcData(g_data);