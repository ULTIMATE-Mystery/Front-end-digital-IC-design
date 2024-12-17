module timer_top (
   // System signals
   input wire sys_clk,
   input wire sys_rst_n,

   // APB slave interface
   input  wire         tim_psel,
   input  wire         tim_pwrite,
   input  wire         tim_penable,
   input  wire [12:0]  tim_paddr,
   input  wire [31:0]  tim_pwdata,
   input  wire [3:0]   tim_pstrb,
   output wire [31:0]  tim_prdata,
   output wire         tim_pready,
   output wire         tim_pslverr,

   // Debug interface
   input wire dbg_mode,

   // Timer interface
   output wire tim_int
);

   // Internal wires
   wire         reg_wr_en;
   wire         reg_rd_en;
   wire [12:0]  reg_addr;
   wire [31:0]  reg_wdata;
   wire [3:0]   reg_wstrb;
   wire [31:0]  reg_rdata;
   wire         reg_error;

   wire         timer_en;
   wire         div_en;
   wire [3:0]   div_val;
   wire         halt_req;
   wire         cnt_en;
   wire         halt_ack;
   wire         tdr0_wr_en;
   wire         tdr1_wr_en;

   wire [63:0]  TDR;
   wire [63:0]  tcmp;
   wire [63:0]  cnt_val;
   wire         cmp_match;

   wire         int_en;
   wire         int_st;

   timer_apb_if u_timer_apb_if (
       .clk        (sys_clk),
       .rst_n      (sys_rst_n),
       .psel       (tim_psel),
       .pwrite     (tim_pwrite),
       .penable    (tim_penable),
       .paddr      (tim_paddr),
       .pwdata     (tim_pwdata),
       .pstrb      (tim_pstrb),
       .prdata     (tim_prdata),
       .pready     (tim_pready), 
       .pslverr    (tim_pslverr),
       .wr_en      (reg_wr_en),
       .rd_en      (reg_rd_en),
       .reg_addr   (reg_addr),
       .reg_wdata  (reg_wdata),
       .reg_wstrb  (reg_wstrb), 
       .reg_rdata  (reg_rdata),
       .reg_error  (reg_error)
   );

   timer_registers u_timer_registers (
       .clk        (sys_clk),
       .rst_n      (sys_rst_n),
       .wr_en      (reg_wr_en),
       .rd_en      (reg_rd_en), 
       .reg_addr   (reg_addr),
       .reg_wdata  (reg_wdata),
       .reg_wstrb  (reg_wstrb),
       .reg_rdata  (reg_rdata),
       .reg_error  (reg_error),
       .timer_en   (timer_en),
       .TDR        (TDR),
       .div_en     (div_en),
       .div_val    (div_val),
       .halt_req   (halt_req),
       .tcmp       (tcmp),
       .tdr0_wr_en (tdr0_wr_en),
       .tdr1_wr_en (tdr1_wr_en),
       .cnt_val    (cnt_val),
       .cmp_match  (cmp_match),
       .halt_ack   (halt_ack),
       .int_en     (int_en),
       .int_st     (int_st)
   );

   timer_ctrl u_timer_ctrl (
       .clk        (sys_clk),
       .rst_n      (sys_rst_n),
       .dbg_mode   (dbg_mode),
       .timer_en   (timer_en),
       .div_en     (div_en),
       .div_val    (div_val),
       .halt_req   (halt_req),
       .cnt_en     (cnt_en),
       .halt_ack   (halt_ack)
   );

   timer_counter u_timer_counter (
       .clk        (sys_clk),
       .rst_n      (sys_rst_n),
       .timer_en   (timer_en),
       .cnt_en     (cnt_en),
       .tdr0_wr_en (tdr0_wr_en),
       .tdr1_wr_en (tdr1_wr_en),
       .TDR        (TDR),
       .tcmp       (tcmp),
       .cnt_val    (cnt_val),
       .cmp_match  (cmp_match)
   );

   timer_interrupt u_timer_interrupt (
       .int_en     (int_en),
       .int_st     (int_st),
       .tim_int    (tim_int)
   );

endmodule