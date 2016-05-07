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
	////			Connections				////
	///////////////////////////////////////////

	localparam IDLE = 4'b0000;
	localparam STGE = 4'b0110;
	localparam WR2M = 4'b0111;
	localparam STL1 = 4'b0001;
	localparam STL2 = 4'b0010;
	localparam STL3 = 4'b0011;
	localparam STL4 = 4'b0100;
	localparam STL5 = 4'b0101;
	localparam CHCK = 4'b1000;
	localparam DONE = 4'b1001;
	localparam ERR  = 4'b1111;

    //outputs
    reg Done, CacheHit;

	//Cache inputs
    reg comp, write, en;
    wire cache_1_write, cache_2_write, cacheWrite;
    wire [2:0] offset;
    wire [15:0] cache_data_in;
	
	//Cache output
    wire cache_1_hit, cache_1_dirty, cache_1_valid;
    wire [4:0] cache_1_tag_out;
    wire cache_2_hit, cache_2_dirty, cache_2_valid;
    wire [4:0] cache_2_tag_out;
    wire [15:0] cache_1_data_out, cache_2_data_out;
	
	//Four-bank input
    reg mem_rd, mem_wr;
    wire [15:0] mem_addr, mem_data_in;
	
	//Four-bank output
    wire mem_stall;
    wire [3:0] mem_busy;
    wire [15:0] mem_data_out;
	
	//state logic
    reg [3:0] nxtState;
    wire [3:0] state;
    reg stall_w;
	
	//Cache select
    reg cache_in_sel, cache_sel;
    wire [4:0] selectedTagOut;

    //other connections
	wire victimway, victimway_in, forcedCache, cacheForceble;
	reg invVictimway, triggerWriteback;
	reg [1:0] mem_count, cache_count;
	
    //Errors	
    wire cache_1_err, cache_2_err, mem_err, err_addr;
    reg state_err_w;
	

	reg [15:0] addrFlopped;


	assign err = cache_1_err | cache_2_err | mem_err | state_err_w | err_addr;

	assign err_addr = addrFlopped[0];

	assign Stall = mem_stall | stall_w;

	assign DataOut = (cache_sel) ? cache_2_data_out : cache_1_data_out;

	assign mem_data_in = DataOut;
	assign selectedTagOut = (cache_sel) ? cache_2_tag_out : cache_1_tag_out;

	assign offset = mem_wr ? {mem_count, 1'b0} : 
				   (cache_in_sel) ? {cache_count, 1'b0} : addrFlopped[2:0];

	always @ (*) begin
	    casex (nxtState)
		    4'b0000: addrFlopped = addrFlopped;
		    default: addrFlopped = Addr;
        endcase
    end

	assign cache_data_in = cache_in_sel ? mem_data_out : DataIn;

	assign mem_addr = mem_wr ? 
			{selectedTagOut, addrFlopped[10:3], mem_count, 1'b0} : 
			{addrFlopped[15:3], mem_count, 1'b0};
				
    assign cacheWrite = (cache_1_valid & cache_1_hit) ? 1'b0 :
                         cache_2_valid & cache_2_hit; 

    assign cacheForceble = (!cache_1_valid | !cache_2_valid) | 
						 ( (cache_1_valid & cache_2_valid) & 
						 (!cache_1_dirty | !cache_2_dirty) );

    assign forcedCache = (!cache_1_valid) ? 1'b0 : 
                        (!cache_2_valid) ? 1'b1 :
                        (cache_1_valid & !cache_1_dirty) ? 1'b0 :
                        (cache_2_valid & !cache_2_dirty);

	assign cache_1_write = triggerWriteback ? (!cacheWrite) : 
						cacheForceble ? ((!forcedCache) & write) : 
										((!victimway) & write);
	assign cache_2_write = triggerWriteback ? cacheWrite : 
						cacheForceble ? ((forcedCache) & write) : 
										((victimway) & write);

    dff victimway_ff (
        .q(victimway), 
        .d(victimway_in), 
        .clk(clk), 
        .rst(rst)
    );
    
    assign victimway_in = (invVictimway) ? ~victimway : victimway;


  parameter mem_type = 0;
  cache #(0 + mem_type) c0(
          // Outputs
          .tag_out              (cache_1_tag_out),
          .data_out             (cache_1_data_out),
          .hit                  (cache_1_hit),
          .dirty                (cache_1_dirty),
          .valid                (cache_1_valid),
          .err                  (cache_1_err),

          // Inputs
          .enable               (en),
          .clk                  (clk),
          .rst                  (rst),
          .createdump           (createdump),
          .tag_in               (addrFlopped[15:11]),
          .index                (addrFlopped[10:3]),
          .offset               (offset),
          .data_in              (cache_data_in),
          .comp                 (comp),
          .write                (cache_1_write),
          .valid_in             (1'b1));   

  cache #(1 + mem_type) c1(
          // Outputs
          .tag_out              (cache_2_tag_out),
          .data_out             (cache_2_data_out),
          .hit                  (cache_2_hit),
          .dirty                (cache_2_dirty),
          .valid                (cache_2_valid),
          .err                  (cache_2_err),

          // Inputs
          .enable               (en),
          .clk                  (clk),
          .rst                  (rst),
          .createdump           (createdump),
          .tag_in               (addrFlopped[15:11]),
          .index                (addrFlopped[10:3]),
          .offset               (offset),
          .data_in              (cache_data_in),
          .comp                 (comp),
          .write                (cache_2_write),
          .valid_in             (1'b1));

  four_bank_mem mem(
          // Outputs
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

  dff state_flop[3:0] (
		.d(nxtState), 
		.q(state), 
		.clk(clk), 
		.rst(rst)
	); 

always @ (*) begin
    nxtState = IDLE;
    en = 1'b1;
    comp = 1'b0;
    write = 1'b0;
    Done = 1'b0;
    stall_w = 1'b1;
    mem_rd = 1'b0;
    mem_wr = 1'b0;
    cache_in_sel = 1'b0;
    CacheHit = 1'b0;
    mem_count = 2'b00;
    cache_count = 2'b00;
    cache_sel = 1'b0;
    invVictimway = 1'b0;
    triggerWriteback = 1'b0;
    state_err_w = 1'b0;
    casex (state)
		IDLE : begin
			casex ({Rd, Wr})
				2'b00 : begin
					nxtState = IDLE;
					en = 1'b0;
					stall_w = 1'b0;
				end
				2'b01 : begin
					nxtState = STGE;
					comp = 1'b1;
					write = 1'b1;
					invVictimway = 1'b1;
					triggerWriteback = 1'b1;
				end
				2'b10 : begin
					nxtState = STGE;
					comp = 1'b1;
					invVictimway = 1'b1;
				end
				2'b11 : nxtState = ERR;	
			endcase
		end
        
		STGE : begin
			nxtState = IDLE;
			casex ({Rd, Wr, 
			cache_1_valid, cache_1_hit, cache_1_dirty, 
			cache_2_valid, cache_2_hit, cache_2_dirty})
				8'b10_11x_0xx, 8'b10_11x_11x, 8'b10_11x_10x,
				8'b01_110_0xx, 8'b01_110_110, 8'b01_110_100 : begin
					stall_w = 1'b0;
					Done = 1'b1;
					CacheHit = 1'b1;
				end
				
				8'b10_x0x_11x, 8'b10_01x_11x,
				8'b01_x0x_110, 8'b01_01x_110 : begin
					stall_w = 1'b0;
					Done = 1'b1;
					CacheHit = 1'b1;
					cache_sel = 1'b1;
				end
				
				8'b01_111_0xx, 8'b01_111_110, 
				8'b01_110_111, 8'b01_111_111, 
				8'b01_111_10x, 8'b01_110_101 : begin 
					Done = 1'b1;
					CacheHit = 1'b1;
				end
				
				8'b01_x0x_111, 8'b01_01x_111 : begin
					Done = 1'b1;
					CacheHit = 1'b1;
					cache_sel = 1'b1;
				end
				
				8'b10_0xx_xxx, 8'b10_xxx_0xx,
				8'b10_100_xxx, 8'b10_xxx_100,
				8'b01_0xx_xxx, 8'b01_xxx_0xx,
				8'b01_100_xxx, 8'b01_xxx_100 : begin
					nxtState = STL1;
					mem_rd = 1'b1;
				end
				
				8'bxx_101_101 : begin
					nxtState = WR2M;
					mem_wr = 1'b1;
					cache_sel = victimway;
				end
				8'b11_xxx_xxx : nxtState = ERR;
			endcase
		end

		WR2M : begin
			mem_wr = 1'b1;
			nxtState = WR2M;
			casex (mem_busy)
				4'b0001 : begin
					mem_count = 2'b01;
					cache_sel = victimway;
				end   
				4'b0011 : begin
					mem_count = 2'b10;
					cache_sel = victimway;
				end
				4'b0111 : begin
					mem_count = 2'b11;
					cache_sel = victimway;
				end
				4'b1110 : begin
					nxtState = STL1;
					mem_wr = 1'b0;
					mem_rd = 1'b1;
					mem_count = 2'b00;
				end
			endcase
		end

		STL1 : begin
			nxtState = STL2;
			mem_rd = 1'b1;
			mem_count = 2'b01;
		end

		STL2 : begin
			nxtState = STL3;
			write = 1'b1;
			cache_in_sel = 1'b1;
			cache_count = 2'b00;
			mem_rd = 1'b1;
			mem_count = 2'b10;
		end
      
		STL3 : begin
			nxtState = STL4;
			write = 1'b1;
			cache_in_sel = 1'b1;
			cache_count = 2'b01;
			mem_rd = 1'b1;
			mem_count = 2'b11;
		end
      
		STL4 : begin
			nxtState = STL5;
			write = 1'b1;
			cache_in_sel = 1'b1;
			cache_count = 2'b10;
		end

		STL5 : begin
			nxtState = CHCK;
			write = 1'b1;
			cache_in_sel = 1'b1;
			cache_count = 2'b11;
		end

		CHCK : begin
			casex ({Rd, Wr})
				2'b01 : begin
					comp = 1'b1;
					write = 1'b1;
					nxtState = DONE;
					triggerWriteback = 1'b1;
				end
				2'b10, 2'b00 : begin
					comp = 1'b1;
					nxtState = DONE;
				end
				2'b11 : nxtState = ERR;
			endcase
		end
		
		DONE: begin 
			casex ({cache_2_valid, cache_2_hit, cache_2_dirty})
				3'b00x, 3'b01x, 3'b10x : begin
					Done = 1'b1;
					stall_w = 1'b0;
					nxtState = IDLE;
				end
				3'b11x : begin 
					Done = 1'b1;
					stall_w = 1'b0;
					nxtState = IDLE;
					cache_sel = 1'b1;
				end
			endcase
		end

		ERR : state_err_w = 1'b1;
    endcase
end
   
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
