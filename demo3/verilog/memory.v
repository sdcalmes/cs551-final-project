module memory(memEn, memWrite, alu_out, reg2_data, dcache_done, 
	      dcache_stall, dcache_hit, dcache_err, read_data,
              createdump, clk, rst);

    input memEn, memWrite, createdump, clk, rst;
    input [15:0] alu_out, reg2_data;
    output dcache_done, dcache_stall, dcache_hit, dcache_err;
    output [15:0] read_data;

    mem_system  dcache(.Addr(alu_out), .DataIn(reg2_data), .DataOut(read_data),
	    	.Rd((memEn&!memWrite)), .Wr((memEn&memWrite)), .createdump(createdump),
		.Done(dcache_done), .Stall(dcache_stall), .CacheHit(dcache_hit),
		.clk(clk), .rst(rst), .err(dcache_err));

endmodule
