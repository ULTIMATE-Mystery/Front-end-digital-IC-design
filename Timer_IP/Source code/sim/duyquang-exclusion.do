coverage exclude -scope /testbench/u_timer_top/u_timer_registers -togglenode {THCSR[2]} {THCSR[3]} {THCSR[4]} {THCSR[5]} {THCSR[6]} {THCSR[7]} {THCSR[8]} {THCSR[9]} {THCSR[10]} {THCSR[11]} -comment {Reserved bits} 
coverage exclude -scope /testbench/u_timer_top/u_timer_registers -togglenode {THCSR[12]} {THCSR[13]} {THCSR[14]} {THCSR[15]} {THCSR[16]} {THCSR[17]} {THCSR[18]} {THCSR[19]} {THCSR[20]} {THCSR[21]} -comment {Reserved bits} 
coverage exclude -scope /testbench/u_timer_top/u_timer_registers -togglenode {THCSR[22]} {THCSR[23]} {THCSR[24]} {THCSR[25]} {THCSR[26]} {THCSR[27]} {THCSR[28]} {THCSR[29]} {THCSR[30]} {THCSR[31]}
coverage exclude -scope /testbench/u_timer_top/u_timer_registers -togglenode TISR -comment {Reserved bits} 
