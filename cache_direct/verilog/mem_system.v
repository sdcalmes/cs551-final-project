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
    //// states
    localparam IDLE             = 4'b0000;
    localparam COMPWR           = 4'b0001;
    localparam COMPRD           = 4'b0010;
    localparam DONE             = 4'b0011;
    localparam ACESRD           = 4'b0100;
    localparam WAIT             = 4'b0101;
    localparam WRtoCACHE        = 4'b0110;
    localparam PRE_WB_MEM       = 4'b0111;
    localparam WB_MEM           = 4'b1000;
    localparam WR_MISS_DONE     = 4'b1001;
    localparam ERR              = 4'b1111;

    wire cache_err, mem_err;
    reg state_err_w;


    /////////////////////////////////////////////
    ////            Assignments             ////
    ///////////////////////////////////////////
    assign err = cache_err | mem_err | state_err_w;

    /////////////////////////////////////////////
    ////            Instatioations          ////
    ///////////////////////////////////////////
    cache (0 + memtype) c0(// Outputs
                           .tag_out              (),
                           .data_out             (),
                           .hit                  (),
                           .dirty                (),
                           .valid                (),
                           .err                  (cache_err),
                           // Inputs
                           .enable               (),
                           .clk                  (clk),
                           .rst                  (rst),
                           .createdump           (createdump),
                           .tag_in               (),
                           .index                (),
                           .offset               (),
                           .data_in              (),
                           .comp                 (),
                           .write                (),
                           .valid_in             ());

    four_bank_mem mem(// Outputs
                      .data_out          (),
                      .stall             (),
                      .busy              (),
                      .err               (mem_err),
                      // Inputs
                      .clk               (clk),
                      .rst               (rst),
                      .createdump        (createdump),
                      .addr              (),
                      .data_in           (),
                      .wr                (),
                      .rd                ());

    
    /////////////////////////////////////////////
    ////            State Machine           ////
    ///////////////////////////////////////////



    
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
