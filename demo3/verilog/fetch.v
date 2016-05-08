module fetch(icache_done, icache_stall, icache_hit,createdump, 
	     pc_decision, instruction, pc_plus, valid, clk, rst, icache_err);

   input icache_done, icache_stall, icache_hit, clk, rst, createdump;
   input [15:0] pc_decision;
   
   output icache_err, valid;
   output [15:0] instruction, pc_plus;

   wire [15:0] PC;

   assign valid = rst ? 1'b0 : 1'b1;
   assign err = 1'b0;

   reg_16	pc_reg(.WriteData(pc_decision), .WriteSel(1'b1), .ReadData(PC),
            .clk(clk), .rst(rst));

    mem_system  icache(.Addr(PC), .DataIn(), .DataOut(instruction),
	    	.Rd(1'b1), .Wr(1'b0), .createdump(createdump),
		.Done(icache_done), .Stall(icache_stall), .CacheHit(icache_hit),
		.clk(clk), .rst(rst), .err(icache_err));

   pc_inc	pc_add(.A(PC), .Out(pc_plus));


endmodule

