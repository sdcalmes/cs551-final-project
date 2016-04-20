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
    localparam COMPWR           = 4'b0001;
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
    localparam ERR              = 4'b1111;

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

    assign  comp = comp_w;
    assign  write = write_w;
    assign  valid_in = valid_in_w;
    assign  cache_data_in = cache_data_in_w;
    assign  four_wr = four_wr_w;
    assign  four_rd = four_rd_w;
    assign  four_addr = four_addr_w;
    assign  four_data_in = four_data_in_w;

    //outputs
    assign DataOut = dataout_w;
    assign Done = done_w;
    assign Stall = four_stall | stall_w;
    assign CacheHit = hit & valid_out;
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
                           .valid_in             (valid_in));

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
    always @(*) begin
        state_err_w = 1'b0;
        comp_w = 1'b0;
        write_w = 1'b0;
        valid_in_w = 1'b1;
        cache_data_in_w = 16'h0000;
        stall_w = 1'b0;
        four_wr_w = 1'b0;
        four_rd_w = 1'b0;
        four_addr_w = 16'h0000;
        four_data_in_w = 16'h0000;
        done_w = 1'b0;
        
        case(state)
            IDLE : begin
                case({Wr,Rd})
                    2'b00 : nxtState = IDLE;
                    2'b01 : nxtState = COMPRD;
                    2'b10 : nxtState = COMPWR;
                    2'b11 : nxtState = ERR;
                endcase
            end    
            
            COMPRD : begin
                comp_w = 1'b1;
                comp_w = 1'b1;
                case({hit,valid_out,dirty})
                    3'b0x0 : nxtState = ACESRD;
                    3'b001 : nxtState = COMPRD;
                    3'b011 : nxtState = PRE_ACESWR;
                    3'b100 : nxtState = COMPRD; 
                    3'b101 : nxtState = COMPRD; 
                    3'b11x : nxtState = DONE;
                endcase
            end
            
            COMPWR : begin
                comp_w = 1'b1;
                write_w = 1'b1;
                stall_w = 1'b1;
                casex({hit, valid_out, dirty})
                    3'b0x0 : nxtState = ACESRD;
                    3'b0x1 : nxtState = ACESWR;
                    3'b10x : nxtState = ACESWR;
                    3'b11x : nxtState = DONE;
                endcase
            end
            
            DONE : begin
                dataout_w = cache_data_out;
                done_w = 1'b1;
                nxtState = IDLE;
            end
            
            ACESRD : begin
                stall_w = 1'b1;
                four_rd_w = 1'b1;
                four_addr_w = Addr;
                case(four_stall)
                    1'b0 : nxtState = WAIT_1;
                    1'b1 : nxtState = ACESRD;
                endcase
            end
            
            WAIT_1 : begin
                stall_w = 1'b1;
                nxtState = WAIT_1;
                case(four_stall)
                    1'b0 : nxtState = WAIT_2;
                    1'b1 : nxtState = WAIT_1;
                endcase
            end
            
            WAIT_2 : begin
                stall_w = 1'b1;
                nxtState = WAIT_2;
                case(four_stall)
                    1'b0 : nxtState = WAIT_3;
                    1'b1 : nxtState = WAIT_2;
                endcase
            end
            
            WAIT_3 : begin
                stall_w = 1'b1;
                nxtState = WAIT_3;
                case(four_stall)
                    1'b0 : nxtState = WRtoCACHE;
                    1'b1 : nxtState = WAIT_3;
                endcase
            end
            
            WRtoCACHE : begin
                stall_w = 1'b1;
                case({Wr, Rd})
                    2'b00 : nxtState = ERR;
                    2'b01 : nxtState = DONE; 
                    2'b10 : nxtState = WR_MISS_DONE;
                    2'b11 : nxtState = ERR;
                endcase
            end
            
            PRE_ACESWR : begin
                stall_w = 1'b1;
                nxtState = ACESWR;
            end
            
            ACESWR : begin
                nxtState = ACESRD;
                stall_w = 1'b1;
                if(four_stall) begin
                    four_data_in_w = cache_data_out;
                    four_addr_w = Addr; 
                    four_wr_w = 1'b1;
                    nxtState = ACESWR;
                end
            end
            
            WR_MISS_DONE : begin
                done_w = 1'b1;
                nxtState = IDLE;
            end
            
            ERR : begin
                valid_in_w = 1'b0;
                state_err_w = 1'b1;
            end
        endcase
    end


    
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
