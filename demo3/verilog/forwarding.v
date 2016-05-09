module forwarding(id_rs, id_rt, em_rd, mw_rd, forw_em, forw_mw)
    input mem_regWrite, wb_regWrite;
    input [3:0] id_rs, id_rt, em_rd, mw_rd;
	input [4:0] id_opcode, mem_opcode, wb_opcode;
	//input [15:0] 
	
	output [15:0] reg1_forward, reg2_forward;

endmodule
