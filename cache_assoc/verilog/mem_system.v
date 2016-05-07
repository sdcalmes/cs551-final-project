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


    /////////////////////////////////////////////
    ////            Connections             ////
    ///////////////////////////////////////////
    // states
	localparam IDLE = 4'b0000;
    localparam STGE = 4'b0001;
    localparam WR2M = 4'b0010;
    localparam STL1 = 4'b0011;
    localparam STL2 = 4'b0100;
    localparam STL3 = 4'b0101;
    localparam STL4 = 4'b0110;
    localparam STL5 = 4'b0111;
    localparam CCFN = 4'b1000;
    localparam CCWB = 4'b1001;
    localparam ERR  = 4'b1111;

    //Cache input
    wire comp, write, en, cache_1_write, cache_2_write;
    reg comp_w, write_w, valid_in_w;
    wire [2:0] offset;
    wire [4:0] tag_in;
    wire [7:0] index;
    wire [15:0] cache_data_in;
   
    //Cache output
    wire cache_hit, cache_valid, cache_dirty;
    wire cache_1_hit, cache_1_dirty, cache_1_valid;
    wire [4:0] cache_1_tag_out;
    wire cache_2_hit, cache_2_dirty, cache_2_valid;
    wire [4:0] cache_2_tag_out;
    wire[15:0] cache_1_data_out, cache_2_data_out;

    //Four-bank input
    wire mem_wr, mem_rd;
    reg  mem_wr_w, mem_rd_w;
    wire [15:0] mem_addr, mem_data_in;

    //Four-bank output
    wire mem_stall;
    wire [3:0] mem_busy;
    wire [15:0] mem_data_out;

    //state logic
    reg [3:0] nxtState;
    wire [3:0] state;
    reg stall_w, done_w;
    //Cache select
    wire victimWay, cache_in_sel, cache_sel, trigwb, cacheWrite;
    reg victim_w, cache_in_sel_w, cache_sel_w, trigwb_w;

    //other connections
    wire forcedCache, cacheForceble;
    reg [1:0] mem_count_w, cache_count_w;
    wire [1:0] mem_count, cache_count;

    wire cache_err_1, cache_err_2, mem_err;
    reg state_err_w;

    /////////////////////////////////////////////
    ////            Assignments             ////
    ///////////////////////////////////////////

    //cache output signals
    assign cache_hit = cache_1_hit | cache_2_hit;
    assign cache_valid = (cache_1_hit & cache_1_valid) | 
                         (cache_2_hit & cache_2_valid);
        
        /// cache data signals
    assign cache_data_in = cache_in_sel ? mem_data_out : DataIn;
    assign DataOut = cache_sel ? cache_2_data_out : cache_1_data_out;
    assign mem_data_in = cache_sel ? cache_2_data_out : cache_1_data_out;
    
        /// mem address select
    assign tag_in = Addr[15:11];
    assign index = Addr[10:3];
    assign en = Wr ^ Rd;
    assign cache_tag_out = cache_sel ? cache_2_tag_out : cache_1_tag_out;
    assign offset = mem_wr ? {mem_count, 1'b0} :
              cache_in_sel ? {cache_count, 1'b0} : Addr[2:0];
    assign mem_addr = mem_wr ? {cache_tag_out, Addr[10:3], mem_count, 1'b0} :
                               {Addr[15:3], mem_count, 1'b0};
        /// Write select
    assign cacheWrite = (cache_1_hit & cache_1_valid) ? 1'b0 :  
                        (cache_2_hit & cache_2_valid);
    assign cacheForceble = (!cache_1_valid | !cache_2_valid) | 
                           ( (cache_1_valid & cache_2_valid) & 
                           (!cache_1_dirty | !cache_2_dirty) );
    assign forcedCache = !cache_1_valid ? 1'b0 : 
                         !cache_2_valid ? 1'b1 :
                         (cache_1_valid & !cache_1_dirty) ? 1'b0 :
                         (cache_2_valid & !cache_2_dirty);                     
    assign cache_1_write = trigwb ? !cacheWrite : 
                              cacheForceble ? ((!forcedCache) & write) : 
                                              ((!victimway) & write);
    assign cache_2_write = trigwb ? cacheWrite : 
                              cacheForceble ? ((forcedCache) & write) : 
                                              ((victimway) & write); 

    //state signals
    assign comp = comp_w;
    assign write = write_w;
    assign cache_count = cache_count_w;
    assign mem_count = mem_count_w;
    assign mem_wr = mem_wr_w;
    assign mem_rd = mem_rd_w;
    assign cache_in_sel = cache_in_sel_w;
    assign cache_sel = cache_sel_w;
    assign trigwb = trigwb_w;

    //outputs
    assign Done = done_w;
    assign Stall = mem_stall | stall_w;
    assign CacheHit = cache_hit & cache_valid;
    assign err = cache_err_1 | cache_err_2 | mem_err | state_err_w | Addr[0];

    /////////////////////////////////////////////
    ////            Instatioations          ////
    ///////////////////////////////////////////
    dff state_flop[3:0] (
        .d(nxtState),
        .q(state),
        .clk(clk),
        .rst(rst)
    );
    
    always @(*) begin
        casex({rst,(cache_hit & cache_valid & comp)})
            2'b00 : victim_w = victimWay;
            2'b01 : victim_w = ~victimWay;
            2'b1x : victim_w = 1'b0;
        endcase
    end
    dff victim_flop (
        .d(victim_w),
        .q(victimWay),
        .clk(clk),
        .rst(rst)
    );

   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (cache_1_tag_out),
                          .data_out             (cache_1_data_out),
                          .hit                  (cache_1_hit),
                          .dirty                (cache_1_dirty),
                          .valid                (cache_1_valid),
                          .err                  (cache_err_1),
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
                          .write                (cache_1_write),
                          .valid_in             (1'b1));

   cache #(2 + memtype) c1(// Outputs
                          .tag_out              (cache_2_tag_out),
                          .data_out             (cache_2_data_out),
                          .hit                  (cache_2_hit),
                          .dirty                (cache_2_dirty),
                          .valid                (cache_2_valid),
                          .err                  (cache_err_2),
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
                          .write                (cache_2_write),
                          .valid_in             (1'b1));

   four_bank_mem mem(// Outputs
                     .data_out          (mem_data_out),
                     .stall             (mem_stall),
                     .busy              (mem_busy),
                     .err               (mem_err),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (mem_addr),
                     .data_in           (mem_data_in),
                     .wr                (mem_wr),
                     .rd                (mem_rd));
   

    /////////////////////////////////////////////
    ////            State Machine           ////
    ///////////////////////////////////////////

    always @(*) begin
        comp_w = 1'b0;
        write_w = 1'b0;
        done_w = 1'b0;
        stall_w = 1'b1;
        cache_count_w = 2'b00;
        mem_count_w = 2'b00;
        mem_wr_w = 1'b0;
        mem_rd_w = 1'b0;
        cache_in_sel_w = 1'b0;
        cache_sel_w = 1'b0;
        trigwb_w = 1'b0;
        nxtState = ERR;
        state_err_w = 1'b0;
        case(state)
            IDLE : begin
                done_w = (cache_hit&cache_valid);
                stall_w = 1'b0;
                nxtState = IDLE;
                casex({Wr,Rd})
                    4'b00 : nxtState = IDLE;
                    4'b01 : begin
                        nxtState = STGE;
                        comp_w = 1'b1;
                    end
                    4'b10 : begin 
                        nxtState = STGE;
                        comp_w = 1'b1;
                        write_w = 1'b1;
                        trigwb_w = 1'b1;
                    4'b11 : nxtState = ERR;
                endcase
            end

            STGE : begin
                nxtState = STGE;
                casex({Wr,Rd, (cache_1_hit&cache_1_valid), cache_1_dirty, (cache_2_hit&cache_2_valid), cache_2_dirty})
                    6'b00xxxx : nxtState = STGE;
/******************************************************************************/
                    6'b010000 : begin
                        nxtState = STL1;
                        mem_rd_w = 1'b1;
                    end
                    //eviction, cache two is dirty
                    6'b010001 : begin
                        nxtState = WR2M;
                        mem_wr_w = 1'b1;
                        mem_count_w = 2'b00;
                        cache_sel_w = victimWay;
                    end
                    //valid hit done
                    6'b01001x : begin 
                        nxtState = IDLE;
                        stall_w = 1'b0;
                        cache_sel_w = 1'b1;
                        done_w = 1'b1;
                    end
                    6'b010100 : begin
                        nxtState = WR2M;
                        mem_wr_w = 1'b1;
                        mem_count_w = 2'b00;
                        cache_sel_w = victimWay;
                    end
                    6'b010101 : begin
                        nxtState = WR2M;
                        mem_wr_w = 1'b1;
                        mem_count_w = 2'b00;
                        cache_sel_w = victimWay;
                    end
                    6'b011xxx : begin 
                        nxtState = IDLE;
                        stall_w = 1'b0;
                        done_w = 1'b1;
                    end
/******************************************************************************/
                    6'b100000 : begin
                        nxtState = STL1;
                        mem_rd_w = 1'b1;
                    end
                    //eviction
                    6'b100001 : begin
                        nxtState = WR2M;
                        mem_wr_w = 1'b1;
                        mem_count_w = 2'b00;
                        cache_sel_w = victimWay;
                    end
                    6'b10001x : begin 
                        nxtState = IDLE;
                        stall_w = 1'b0;
                        cache_sel_w = 1'b1;
                        done_w = 1'b1;
                    end
                    6'b100100 : begin
                        nxtState = WR2M;
                        mem_wr_w = 1'b1;
                        mem_count_w = 2'b00;
                        cache_sel_w = victimWay;
                    end
                    6'b100101 : begin
                        nxtState = WR2M;
                        mem_wr_w = 1'b1;
                        mem_count_w = 2'b00;
                        cache_sel_w = victimWay;
                    end
                    6'b101xxx : begin 
                        nxtState = IDLE;
                        stall_w = 1'b0;
                        done_w = 1'b1;
                    end
/******************************************************************************/
                    6'b11xxxx : nxtState = ERR;
                endcase
            end

            WR2M : begin
                mem_wr_w  = 1'b1;
                casex(mem_busy)
                    4'b0001 : begin
                        nxtState = WR2M;
                        mem_count_w = 2'b01;
                        cache_sel_w = victimWay;
					end
                    4'b0011 : begin
                        nxtState = WR2M;
                        mem_count_w = 2'b10;
                        cache_sel_w = victimWay;
					end
                    4'b0111 : begin
                        nxtState = WR2M;
                        mem_count_w = 2'b11;
                        cache_sel_w = victimWay;
					end
                    4'b1110 : begin
                        nxtState = STL1;
                        mem_wr_w = 1'b0;
                        mem_rd_w = 1'b1;
                        mem_count_w = 2'b00;
					end
                    default : nxtState = ERR;
                endcase
            end

            STL1 : begin
                nxtState = STL2;
                mem_rd_w  = 1'b1;
                mem_count_w = 2'b01;
                cache_count_w = 2'b00;
            end

            STL2 : begin
                nxtState = STL3;
                mem_rd_w  = 1'b1;
                mem_count_w = 2'b10;
                cache_count_w = 2'b00;
                cache_in_sel = 1'b1;
            end

            STL3 : begin
                nxtState = STL4;
                mem_rd_w  = 1'b1;
                mem_count_w = 2'b11;
                cache_count_w = 2'b01;
                cache_in_sel = 1'b1;
                write_w = 1'b1;
            end

            STL4 : begin
                nxtState = STL5;
                mem_rd_w  = 1'b1;
                mem_count_w = 2'b00;
                cache_count_w = 2'b10;
                cache_in_sel = 1'b1;
                write_w = 1'b1;
            end

            STL5 : begin
                nxtState = CCFN;
                mem_rd_w  = 1'b1;
                mem_count_w = 2'b00;
                cache_count_w = 2'b11;
                cache_in_sel_w = 1'b1;
                write_w = 1'b1;
            end

            CCFN : begin
                nxtState = CCWB;
                casex({Wr,Rd})
                    2'b0x : comp_w = 1'b1;
                    2'b10 : begin
                        comp_w = 1'b1;
                        write_w = 1'b1;
                        trigwb_w =1'b1;
                    end
                    2'b11 : nxtState = ERR;
                write_w = 1'b1;
            end
            
            CCWB : begin
                done_w = 1'b1;
                stall_w = 1'b0;
                comp_w = 1'b1;
                casex({Wr,Rd, (cache_1_hit&cache_1_valid), cache_1_dirty, (cache_2_hit&cache_2_valid), cache_2_dirty})
                    6'b00xxxx : nxtState = STGE;
/******************************************************************************/
                    6'b010000 : begin
                        nxtState = STL1;
                        mem_rd_w = 1'b1;
                    end
                    //eviction, cache two is dirty
                    6'b010001 : begin
                        nxtState = WR2M;
                        mem_wr_w = 1'b1;
                        mem_count_w = 2'b00;
                        cache_sel_w = victimWay;
                    end
                    //valid hit done
                    6'b01001x : begin 
                        nxtState = IDLE;
                        stall_w = 1'b0;
                        cache_sel_w = 1'b1;
                        done_w = 1'b1;
                    end
                    6'b010100 : begin
                        nxtState = WR2M;
                        mem_wr_w = 1'b1;
                        mem_count_w = 2'b00;
                        cache_sel_w = victimWay;
                    end
                    6'b010101 : begin
                        nxtState = WR2M;
                        mem_wr_w = 1'b1;
                        mem_count_w = 2'b00;
                        cache_sel_w = victimWay;
                    end
                    6'b011xxx : begin 
                        nxtState = IDLE;
                        stall_w = 1'b0;
                        done_w = 1'b1;
                    end
/******************************************************************************/
                    6'b100000 : begin
                        nxtState = STL1;
                        mem_rd_w = 1'b1;
                    end
                    //eviction
                    6'b100001 : begin
                        nxtState = WR2M;
                        mem_wr_w = 1'b1;
                        mem_count_w = 2'b00;
                        cache_sel_w = victimWay;
                    end
                    6'b10001x : begin 
                        nxtState = IDLE;
                        stall_w = 1'b0;
                        cache_sel_w = 1'b1;
                        done_w = 1'b1;
                    end
                    6'b100100 : begin
                        nxtState = WR2M;
                        mem_wr_w = 1'b1;
                        mem_count_w = 2'b00;
                        cache_sel_w = victimWay;
                    end
                    6'b100101 : begin
                        nxtState = WR2M;
                        mem_wr_w = 1'b1;
                        mem_count_w = 2'b00;
                        cache_sel_w = victimWay;
                    end
                    6'b101xxx : begin 
                        nxtState = IDLE;
                        stall_w = 1'b0;
                        done_w = 1'b1;
                    end
/******************************************************************************/
                    6'b11xxxx : nxtState = ERR;
                endcase
            end
            
            ERR : begin
                state_err_w = 1'b1;
            end
        endcase
    end
    
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
