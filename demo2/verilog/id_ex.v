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
        ex_sign_ext_low_bits, ex_halt, clk, rst);

    input id_alu_res_sel, id_branch, id_branch_eqz, id_branch_gtz, id_branch_ltz,
          id_Cin, id_invA, id_invB, id_memEn, id_memWrite, id_regWrite,
          id_sign_alu, id_createdump, id_halt, clk, rst;
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
    dff alu_res_sel_flop(
        .d(id_alu_res_sel),
        .q(ex_alu_res_sel),
        .clk(clk),
        .rst(rst)
    );
    dff branch_flop(
        .d(id_branch),
        .q(ex_branch),
        .clk(clk),
        .rst(rst)
    );
    dff branch_eqz_flop(
        .d(id_branch_eqz),
        .q(ex_branch_eqz),
        .clk(clk),
        .rst(rst)
    );
    dff branch_gtz_flop(
        .d(id_branch_gtz),
        .q(ex_branch_gtz),
        .clk(clk),
        .rst(rst)
    );
    dff branch_ltz_flop(
        .d(id_branch_ltz),
        .q(ex_branch_ltz),
        .clk(clk),
        .rst(rst)
    );
    dff Cin_flop(
        .d(id_Cin),
        .q(ex_Cin),
        .clk(clk),
        .rst(rst)
    );
    dff invA_flop(
        .d(id_invA),
        .q(ex_invA),
        .clk(clk),
        .rst(rst)
    );
    dff invB_flop(
        .d(id_invB),
        .q(ex_invB),
        .clk(clk),
        .rst(rst)
    );
    dff memEn_flop(
        .d(id_memEn),
        .q(ex_memEn),
        .clk(clk),
        .rst(rst)
    );
    dff memWrite_flop(
        .d(id_memWrite),
        .q(ex_memWrite),
        .clk(clk),
        .rst(rst)
    );
    dff regWrite_flop(
        .d(id_regWrite),
        .q(ex_regWrite),
        .clk(clk),
        .rst(rst)
    );
    dff sign_alu_flop(
        .d(id_sign_alu),
        .q(ex_sign_alu),
        .clk(clk),
        .rst(rst)
    );
    dff createdump_flop(
        .d(id_createdump),
        .q(ex_createdump),
        .clk(clk),
        .rst(rst)
    );
    dff halt_flop(
        .d(id_halt),
        .q(ex_halt),
        .clk(clk),
        .rst(rst)
    );
    dff ALUSrc_a_flop[1:0](
        .d(id_ALUSrc_a),
        .q(ex_ALUSrc_a),
        .clk(clk),
        .rst(rst)
    );
    dff ALUSrc_b_flop[1:0](
        .d(id_ALUSrc_b),
        .q(ex_ALUSrc_b),
        .clk(clk),
        .rst(rst)
    );
    dff memToReg_flop[1:0](
        .d(id_memToReg),
        .q(ex_memToReg),
        .clk(clk),
        .rst(rst)
    );
    dff pc_dec_flop[1:0](
        .d(id_pc_dec),
        .q(ex_pc_dec),
        .clk(clk),
        .rst(rst)
    );
    dff set_select_flop[1:0](
        .d(id_set_select),
        .q(ex_set_select),
        .clk(clk),
        .rst(rst)
    );
    dff alu_op_flop[2:0](
        .d(id_alu_op),
        .q(ex_alu_op),
        .clk(clk),
        .rst(rst)
    );
    dff write_reg_flop[2:0](
        .d(id_write_reg),
        .q(ex_write_reg),
        .clk(clk),
        .rst(rst)
    );
    dff instruction_flop[15:0](
        .d(id_instruction),
        .q(ex_instruction),
        .clk(clk),
        .rst(rst)
    );
    dff pc_plus_flop[15:0](
        .d(id_pc_plus),
        .q(ex_pc_plus),
        .clk(clk),
        .rst(rst)
    );
    dff reg1_data_flop[15:0](
        .d(id_reg1_data),
        .q(ex_reg1_data),
        .clk(clk),
        .rst(rst)
    );
    dff reg2_data_flop[15:0](
        .d(id_reg2_data),
        .q(ex_reg2_data),
        .clk(clk),
        .rst(rst)
    );
    dff sign_ext_low_bits_flop[15:0](
        .d(id_sign_ext_low_bits),
        .q(ex_sign_ext_low_bits),
        .clk(clk),
        .rst(rst)
    );

endmodule
