var g_data = {"3":{"pr":"/test_bench","t":"inst","br":[{"bs":[{"s":"		if( count != 8'h00 ) begin","f":1,"i":1,"l":33,"h":0},{"s":"		end else begin","f":1,"i":1,"l":39,"h":2}],"br":{"s":"		if( count != 8'h00 ) begin","f":1,"l":33,"i":1,"p":50.00}},{"bs":[{"s":"		if( count != 8'hff ) begin","f":1,"i":1,"l":51,"h":0},{"s":"		end else begin","f":1,"i":1,"l":57,"h":2}],"br":{"s":"		if( count != 8'hff ) begin","f":1,"l":51,"i":1,"p":50.00}},{"bs":[{"s":"		if( overflow != 1'b1) begin","f":1,"i":1,"l":63,"h":0},{"s":"		end else begin","f":1,"i":1,"l":69,"h":2}],"br":{"s":"		if( overflow != 1'b1) begin","f":1,"l":63,"i":1,"p":50.00}},{"bs":[{"s":"		if( overflow == 1'b1) begin","f":1,"i":1,"l":75,"h":0},{"s":"		end else begin","f":1,"i":1,"l":79,"h":2}],"br":{"s":"		if( overflow == 1'b1) begin","f":1,"l":75,"i":1,"p":50.00}},{"bs":[{"s":"		if( count != 8'h00 ) begin","f":1,"i":1,"l":84,"h":0},{"s":"		end else begin","f":1,"i":1,"l":90,"h":2}],"br":{"s":"		if( count != 8'h00 ) begin","f":1,"l":84,"i":1,"p":50.00}},{"bs":[{"s":"		if( count != 8'ha ) begin","f":1,"i":1,"l":99,"h":0},{"s":"		end else begin","f":1,"i":1,"l":105,"h":2}],"br":{"s":"		if( count != 8'ha ) begin","f":1,"l":99,"i":1,"p":50.00}},{"bs":[{"s":"		if( count != 8'h0 ) begin","f":1,"i":1,"l":132,"h":0},{"s":"		end else begin","f":1,"i":1,"l":138,"h":2}],"br":{"s":"		if( count != 8'h0 ) begin","f":1,"l":132,"i":1,"p":50.00}},{"bs":[{"s":"		if( count != 8'h0 ) begin","f":1,"i":1,"l":148,"h":0},{"s":"		end else begin","f":1,"i":1,"l":154,"h":2}],"br":{"s":"		if( count != 8'h0 ) begin","f":1,"l":148,"i":1,"p":50.00}}]},"4":{"pr":"/test_bench/dut","t":"inst","br":[{"bs":[{"s":"    if (!rst_n || count_clr) begin","f":2,"i":1,"l":12,"h":6},{"s":"    end else if (count_en) begin","f":2,"i":1,"l":14,"h":534},{"s":"All False","f":2,"i":1,"l":12,"h":2}],"br":{"s":"    if (!rst_n || count_clr) begin","f":2,"l":12,"i":1,"p":100.00}},{"bs":[{"s":"        count <= (count == 8'hFF) ? 8'h00 : count + 1'b1;  // Increment and reset when count reaches max","f":2,"i":1,"l":15,"h":2},{"s":"        count <= (count == 8'hFF) ? 8'h00 : count + 1'b1;  // Increment and reset when count reaches max","t":42,"n":1,"f":2,"i":2,"l":15,"h":532}],"br":{"s":"        count <= (count == 8'hFF) ? 8'h00 : count + 1'b1;  // Increment and reset when count reaches max","f":2,"l":15,"i":1,"p":100.00}}]}};
processBranchesData(g_data);