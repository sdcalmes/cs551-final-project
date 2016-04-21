/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
    // Outputs
    DataOut, Done, Stall, CacheHit, err,
    // Inputs
    Addr, DataIn, Rd, Wr, createdump, clk, rst
    );
   
    input [15:0] Addr;
    input [15:0] DataIn;
    input        Rd;
    input        Wr;
    input        createdump;
    input        clk;
    input        rst;
    
    output [15:0] DataOut;
    output Done;
    output Stall;
    output CacheHit;
    output err;

    /* data_mem = 1, inst_mem = 0 *
     * needed for cache parameter */
    
    /////////////////////////////////////////////
    ////            Connections             ////
    ///////////////////////////////////////////
    parameter mem_type = 0;
    // states
    localparam IDLE             = 4'b0000;
   /* localparam COMPWR           = 4'b0001;
    localparam COMPRD           = 4'b0010;
    localparam DONE             = 4'b0011;
    localparam ACESRD           = 4'b0100;
    localparam WRtoCACHE        = 4'b0101;
    localparam PRE_ACESWR       = 4'b0110;
    localparam ACESWR           = 4'b0111;
    localparam WR_MISS_DONE     = 4'b1000;
    localparam WAIT_1           = 4'b1001;
    localparam WAIT_2           = 4'b1010;
    localparam WAIT_3           = 4'b1011;
    localparam ERR              = 4'b1111;*/
    
    localparam WR1  = 4'b0001;
    localparam WR2  = 4'b0010;
    localparam WR3  = 4'b0011;
    localparam WRST = 4'b0100;
    localparam STGE = 4'b0101;
    localparam WAT1 = 4'b0110;
    localparam WAT2 = 4'b0111;
    localparam WAT3 = 4'b1000;
    localparam WAT4 = 4'b1001;
    localparam ALT  = 4'b1010;
    localparam TOCH = 4'b1011;
    localparam DONE = 4'b1100;
    localparam ERR  = 4'b1111;

    //Outputs
    reg done_w;
    reg [15:0] dataout_w;

    //Cache input
    wire comp, write, en, valid_in;
    reg comp_w, write_w, valid_in_w;
    wire [2:0] offset;
    wire [4:0] tag_in;
    wire [7:0] index;
    wire [15:0] cache_data_in;
    reg [15:0] cache_data_in_w;

    //Cache output
    wire hit, dirty, valid_out;
    wire [4:0] tag_out;
    wire [15:0] cache_data_out;

    //Four-bank input
    wire four_wr, four_rd;
    reg  four_wr_w, four_rd_w;
    wire [15:0] four_addr, four_data_in;
    reg  [15:0] four_addr_w, four_data_in_w;

    //Four-bank output
    wire four_stall;
    wire [3:0] four_busy;
    wire [15:0] four_data_out;

    //state logic
    reg [3:0] nxtState;
    wire [3:0] state;
    reg stall_w;

    //other connections
    wire cache_cycle_complete, cache_writing;
    reg  cache_cycle_complete_w, cache_writing_w, cache_hit_w;
    reg [1:0] mem_count_w, cache_count_w;
    wire [1:0] mem_count, cache_count;

    wire cache_err, mem_err;
    reg state_err_w;


    /////////////////////////////////////////////
    ////            Assignments             ////
    ///////////////////////////////////////////
    assign offset = Addr[2:0];
    assign tag_in = Addr[15:11];
    assign index = Addr[10:3];
    assign comp = comp_w;
    assign write = write_w;
    assign en = Wr ^ Rd;

    assign cache_cycle_complete = cache_cycle_complete_w;
    assign cache_count = cache_count_w;
    assign cache_writing = cache_writing_w;
    assign mem_count = mem_count_w;
    assign comp = comp_w;
    assign write = write_w;
    assign valid_in = valid_in_w;
    assign cache_data_in = cache_data_in_w;
    assign four_wr = four_wr_w;
    assign four_rd = four_rd_w;
    assign four_addr = four_addr_w;
    assign four_data_in = four_data_in_w;

    //outputs
    assign DataOut = dataout_w;
    assign Done = done_w;
    assign Stall = four_stall | stall_w;
    assign CacheHit = cache_hit_w;
    assign err = cache_err | mem_err | state_err_w | offset[0];

    /////////////////////////////////////////////
    ////            Instatioations          ////
    ///////////////////////////////////////////
    dff state_flop[3:0] (
        .d(nxtState),
        .q(state),
        .clk(clk),
        .rst(rst)
    );

    cache #(0 + mem_type ) c0(// Outputs
                           .tag_out              (tag_out),
                           .data_out             (cache_data_out),
                           .hit                  (hit),
                           .dirty                (dirty),
                           .valid                (valid_out),
                           .err                  (cache_err),
                           // Inputs
                           .enable               (en),
                           .clk                  (clk),
                           .rst                  (rst),
                           .createdump           (createdump),
                           .tag_in               (tag_in),
                           .index                (index),
                           .offset               (offset),
                           .data_in              (cache_data_in),
                           .comp                 (comp),
                           .write                (write),
                           .valid_in             (1'b1));

    four_bank_mem mem(// Outputs
                      .data_out          (four_data_out),
                      .stall             (four_stall),
                      .busy              (four_busy),
                      .err               (mem_err),
                      // Inputs
                      .clk               (clk),
                      .rst               (rst),
                      .createdump        (createdump),
                      .addr              (four_addr),
                      .data_in           (four_data_in),
                      .wr                (four_wr),
                      .rd                (four_rd));

    
    /////////////////////////////////////////////
    ////            State Machine           ////
    ///////////////////////////////////////////
    assign write = cache_cycle_complete ? Wr : cache_writing;
    assign data_in = cache_cycle_complete ? DataIn : four_data_out;
    assign offset = cache_cycle_complete ? Addr[2:0] : {cache_count, 1'b0};

    always @(*) begin
        comp_w = 1'b0;
        done_w = 1'b0;
        cache_cycle_complete_w = 1'b0;
        cache_count_w = 2'b00;
        cache_writing_w = 1'b1;
        mem_count_w = 2'b00;
        cache_hit_w = 1'b0;
        four_wr_w = 1'b0;
        four_rd_w = 1'b0;
        stall_w = 1'b0;
        case(state)
            IDLE : begin
                done_w = (hit&valid_out);
                cache_hit_w = (hit&valid_out);
                comp_w = 1'b1;
                nxtState = IDLE;
                casex({Wr,Rd, (hit&valid_out), dirty})
                    4'b00xx : nxtState = IDLE;
                    4'b01x0 : nxtState = STGE;
                    4'b01x1 : nxtState = WR1;
                    4'b10x0 : nxtState = STGE;
                    4'b10x1 : nxtState = WR1;
                    4'b11xx : nxtState = ERR;
                endcase
            end

            WR1  : begin
                stall_w = 1'b1;
                cache_writing_w = 1'b1;
                cache_cycle_complete_w = 1'b1;
                nxtState = WR2;
                four_wr_w  = 1'b1;
            end

            WR2  : begin
                stall_w = 1'b1;
                mem_count_w = 2'b01;
                cache_writing_w = 1'b1;
                cache_count_w = 2'b01;
                cache_cycle_complete_w = 1'b1;
                nxtState = WR3;
                four_wr_w  = 1'b1;
            end

            WR3  : begin
                stall_w = 1'b1;
                mem_count_w = 2'b10;
                cache_writing_w = 1'b1;
                cache_count_w = 2'b10;
                cache_cycle_complete_w = 1'b1;
                nxtState = WRST;
                four_wr_w  = 1'b1;
            end

            WRST : begin
                stall_w = 1'b1;
                mem_count_w = 2'b11;
                cache_writing_w = 1'b1;
                cache_count_w = 2'b11;
                cache_cycle_complete_w = 1'b1;
                nxtState = WRST;
                four_wr_w  = 1'b1;
            end

            STGE : begin
                four_rd_w = 1'b1;
                stall_w = 1'b1;
                nxtState = WAT1;
                four_rd_w = 1'b1;
            end

            WAT1 : begin
                four_rd_w = 1'b1;
                stall_w = 1'b1;
                mem_count_w = 2'b01;
                nxtState = WAT2;
                four_rd_w = 1'b1;
            end

            WAT2 : begin
                four_rd_w = 1'b1;
                stall_w = 1'b1;
                mem_count_w = 2'b10;
                cache_cycle_complete_w = 1'b1;
                nxtState = WAT3;
                four_rd_w = 1'b1;
            end

            WAT3 : begin
                four_rd_w = 1'b1;
                stall_w = 1'b1;
                mem_count_w = 2'b11;
                cache_count_w = 2'b01;
                cache_cycle_complete_w = 1'b1;
                nxtState = WAT4;
                four_rd_w = 1'b1;
            end
            
            WAT4 : begin
                stall_w = 1'b1;
                cache_count_w = 2'b10;
                cache_cycle_complete_w = 1'b1;
                nxtState = ALT;
            end

            ALT  : begin
                stall_w = 1'b1;
                cache_count_w = 2'b11;
                cache_cycle_complete_w = 1'b1;
                nxtState = TOCH;
            end

            TOCH : begin
                stall_w = 1'b1;
                nxtState = DONE;
                comp_w = 1'b1;
            end

            DONE : begin
                done_w = 1'b1;
                stall_w = 1'b1;
                comp_w = 1'b1;
                casex({Wr,Rd, (hit&valid_out), dirty})
                    4'b00xx : nxtState = IDLE;
                    4'b01x0 : nxtState = STGE;
                    4'b01x1 : nxtState = WR1;
                    4'b10x0 : nxtState = STGE;
                    4'b10x1 : nxtState = WR1;
                    4'b11xx : nxtState = ERR;
                endcase
            end

            ERR : begin
                state_err_w = 1'b1;
            end
        endcase
    end

    
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
