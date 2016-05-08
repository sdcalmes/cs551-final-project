module id_ex(id_alu_res_sel, id_branch, id_branch_eqz, id_branch_gtz,
        id_branch_ltz, id_Cin, id_invA, id_invB, id_memEn, id_memWrite,
        id_regWrite, id_sign_alu, id_createdump, id_ALUSrc_a, id_ALUSrc_b,
        id_memToReg, id_pc_dec, id_set_select, id_alu_op, id_write_reg,
        id_reg1_data, id_reg2_data, id_sign_ext_low_bits, id_instruction,
        id_pc_plus, id_halt, ex_alu_res_sel, ex_branch, ex_branch_eqz, ex_branch_gtz,
        ex_branch_ltz, ex_Cin, ex_invA, ex_invB, ex_memEn, ex_memWrite,
        ex_regWrite, ex_sign_alu,ex_createdump, ex_ALUSrc_a, ex_ALUSrc_b,
        ex_memToReg, ex_pc_dec, ex_set_select, ex_alu_op, ex_write_reg,
        ex_instruction, ex_pc_plus, ex_reg1_data, ex_reg2_data,
        ex_sign_ext_low_bits, ex_halt, clk, rst, wr_stall);

    input id_alu_res_sel, id_branch, id_branch_eqz, id_branch_gtz, id_branch_ltz,
          id_Cin, id_invA, id_invB, id_memEn, id_memWrite, id_regWrite,
          id_sign_alu, id_createdump, id_halt, clk, rst, wr_stall;
    input [1:0] id_ALUSrc_a, id_ALUSrc_b, id_memToReg, id_pc_dec, id_set_select;
    input [2:0] id_alu_op, id_write_reg;
    input [15:0] id_instruction, id_pc_plus, id_reg1_data, id_reg2_data,
          id_sign_ext_low_bits;
    
    output ex_alu_res_sel, ex_branch, ex_branch_eqz, ex_branch_gtz,
           ex_branch_ltz, ex_Cin, ex_invA, ex_invB, ex_memEn, ex_memWrite,
           ex_regWrite, ex_sign_alu, ex_createdump, ex_halt;
    output [1:0] ex_ALUSrc_a, ex_ALUSrc_b, ex_memToReg, ex_pc_dec, ex_set_select;
    output [2:0] ex_alu_op, ex_write_reg;
    output [15:0] ex_instruction, ex_pc_plus, ex_reg1_data, ex_reg2_data,
            ex_sign_ext_low_bits;
/*assign statements
    assign ex_alu_res_sel = id_alu_res_sel;   
    assign ex_branch = id_branch;
    assign ex_branch_eqz = id_branch_eqz; 
    assign ex_branch_gtz = id_branch_gtz;
    assign ex_branch_ltz = id_branch_ltz;
    assign ex_Cin = id_Cin;
    assign ex_invA = id_invA;
    assign ex_invB = id_invB;
    assign ex_memEn = id_memEn;
    assign ex_memWrite = id_memWrite;
    assign ex_regWrite = id_regWrite;
    assign ex_sign_alu = id_sign_alu;
    assign ex_createdump = id_createdump;    
    assign ex_ALUSrc_a = id_ALUSrc_a;
    assign ex_ALUSrc_b = id_ALUSrc_b;
    assign ex_memToReg = id_memToReg;
    assign ex_pc_dec = id_pc_dec;
    assign ex_set_select = id_set_select;
    assign ex_alu_op = id_alu_op;
    assign ex_write_reg = id_write_reg;
    assign ex_instruction = id_instruction;
    assign ex_pc_plus = id_pc_plus;
    assign ex_reg1_data = id_reg1_data;
    assign ex_reg2_data = id_reg2_data;
    assign ex_sign_ext_low_bits = id_sign_ext_low_bits; 

    */
    reg_1 alu_res_sel_flop(
        .WriteData(id_alu_res_sel),
        .ReadData(ex_alu_res_sel),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 branch_flop(
        .WriteData(id_branch),
        .ReadData(ex_branch),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 branch_eqz_flop(
        .WriteData(id_branch_eqz),
        .ReadData(ex_branch_eqz),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 branch_gtz_flop(
        .WriteData(id_branch_gtz),
        .ReadData(ex_branch_gtz),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 branch_ltz_flop(
        .WriteData(id_branch_ltz),
        .ReadData(ex_branch_ltz),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 Cin_flop(
        .WriteData(id_Cin),
        .ReadData(ex_Cin),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 invA_flop(
        .WriteData(id_invA),
        .ReadData(ex_invA),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 invB_flop(
        .WriteData(id_invB),
        .ReadData(ex_invB),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 memEn_flop(
        .WriteData(id_memEn),
        .ReadData(ex_memEn),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 memWrite_flop(
        .WriteData(id_memWrite),
        .ReadData(ex_memWrite),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 regWrite_flop(
        .WriteData(id_regWrite),
        .ReadData(ex_regWrite),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 sign_alu_flop(
        .WriteData(id_sign_alu),
        .ReadData(ex_sign_alu),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 createdump_flop(
        .WriteData(id_createdump),
        .ReadData(ex_createdump),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 halt_flop(
        .WriteData(id_halt),
        .ReadData(ex_halt),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 ALUSrc_a_flop[1:0](
        .WriteData(id_ALUSrc_a),
        .ReadData(ex_ALUSrc_a),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 ALUSrc_b_flop[1:0](
        .WriteData(id_ALUSrc_b),
        .ReadData(ex_ALUSrc_b),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 memToReg_flop[1:0](
        .WriteData(id_memToReg),
        .ReadData(ex_memToReg),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 pc_dec_flop[1:0](
        .WriteData(id_pc_dec),
        .ReadData(ex_pc_dec),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 set_select_flop[1:0](
        .WriteData(id_set_select),
        .ReadData(ex_set_select),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 alu_op_flop[2:0](
        .WriteData(id_alu_op),
        .ReadData(ex_alu_op),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 write_reg_flop[2:0](
        .WriteData(id_write_reg),
        .ReadData(ex_write_reg),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 instruction_flop[15:0](
        .WriteData(id_instruction),
        .ReadData(ex_instruction),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 pc_plus_flop[15:0](
        .WriteData(id_pc_plus),
        .ReadData(ex_pc_plus),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 reg1_data_flop[15:0](
        .WriteData(id_reg1_data),
        .ReadData(ex_reg1_data),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 reg2_data_flop[15:0](
        .WriteData(id_reg2_data),
        .ReadData(ex_reg2_data),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 sign_ext_low_bits_flop[15:0](
        .WriteData(id_sign_ext_low_bits),
        .ReadData(ex_sign_ext_low_bits),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );

endmodule
