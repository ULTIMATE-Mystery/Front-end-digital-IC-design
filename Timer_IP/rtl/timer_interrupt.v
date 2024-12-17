module timer_interrupt (   
    // Interrupt control
    input  wire         int_en,
    input  wire         int_st,
    
    // Timer interrupt
    output wire         tim_int
);

    // Timer interrupt output
    assign tim_int = int_en & int_st;

endmodule