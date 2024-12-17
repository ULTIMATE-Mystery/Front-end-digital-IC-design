module cnt_ctrl(
    input  wire         clk     ,
    input  wire         rst_n   ,
    input  wire         div_en  ,
    input  wire [3:0]   div_val ,
    input  wire         timer_en,
    input  wire         halt_req,
    output wire         count_en
);

    reg  [7:0]  cnt     ;   //reg
    reg         cnt_en;     //reg
    reg  [7:0]  limit   ;
    wire [7:0]  cnt_pre ;
    wire        cnt_rst ;
    wire        def_mode;
    wire        ctrl_mode_0;
    wire        ctrl_mode_other;
    
    //convert div_val to internal counter limit
    always@* begin
        case (div_val[3:0])
            4'h1:   limit = 1;
            4'h2:   limit = 3;
            4'h3:   limit = 7;
            4'h4:   limit = 15;
            4'h5:   limit = 31;
            4'h6:   limit = 63;
            4'h7:   limit = 127;
            4'h8:   limit = 255;
            default:limit = 0;
        endcase
    end
    //reset when internal cnt reach limit value
    //or timer_en or div_en equal zero
    assign cnt_rst  =  (cnt == limit) | (!timer_en) | (!div_en);

    assign cnt_pre  =  halt_req        ? cnt :
                       cnt_rst         ? 8'h0 :
                       cnt + 1'b1      ; 


    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            cnt         <= 8'h0;
        end else begin
            cnt         <= cnt_pre;
        end
    end


    assign def_mode = timer_en & !div_en;
    assign ctrl_mode_0 = timer_en & div_en & (div_val == 0);
    assign ctrl_mode_other = timer_en & div_en & (div_val != 0);

    //count_en logic
    //counter_en is 1 in below condition
    //default counting mode (div_en = 0)
    //control counting mode & div_val = 0
    //control couting mode and internal cnt reach limit value
    assign count_en = (def_mode |  ctrl_mode_0 | (ctrl_mode_other & (cnt == limit))) & !halt_req;


endmodule
