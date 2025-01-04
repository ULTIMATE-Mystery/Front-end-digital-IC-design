var g_data = {"name":"../rtl/timer_interrupt.v","src":"module timer_interrupt (   \r\n    // Interrupt control\r\n    input  wire         int_en,\r\n    input  wire         int_st,\r\n    \r\n    // Timer interrupt\r\n    output wire         tim_int\r\n);\r\n\r\n    // Timer interrupt output\r\n    assign tim_int = int_en & int_st;\r\n\r\nendmodule","lang":"verilog"};
processSrcData(g_data);