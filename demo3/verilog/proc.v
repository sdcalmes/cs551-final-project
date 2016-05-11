/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (/*AUTOARG*/
    // Outputs
    err, 
    // Inputs
    clk, rst
    );

    input clk;
    input rst;

    output err;

    // None of the above lines can be modified

    // OR all the err ouputs for every sub-module and assign it as this
    // err output
   
    // As desribed in the homeworks, use the err signal to trap corner
    // cases that you think are illegal in your statemachines

    /////////////////////////////////
    /////    REG/Wire          /////
    ///////////////////////////////


    //flop 1
    wire if_valid, id_valid, icache_done, icache_stall, icache_hit;
    wire [15:0] if_pc_plus, if_instruction;
    wire [15:0] id_pc_plus, id_instruction;

    //flop 2
    wire id_alu_res_sel, id_branch, id_branch_eqz, id_branch_gtz, id_branch_ltz,
         id_Cin, id_invA, id_invB, id_memEn, id_memWrite, id_regWrite,
         id_sign_alu, id_createdump, clk, rst;
    wire [1:0] id_ALUSrc_a, id_ALUSrc_b, id_memToReg, id_pc_dec, id_set_select;
    wire [2:0] id_alu_op, id_write_reg, id_reg1_sel, id_reg2_sel;
    wire [15:0] id_reg1_data, id_reg2_data, id_sign_ext_low_bits, 
         id_instruction_w;
    
    wire ex_alu_res_sel, ex_branch, ex_branch_eqz, ex_branch_gtz, ex_branch_ltz,
          ex_Cin, ex_invA, ex_invB, ex_memEn, ex_memWrite, ex_regWrite,
          ex_sign_alu, ex_createdump;
    wire [1:0] ex_ALUSrc_a, ex_ALUSrc_b, ex_memToReg, ex_pc_dec, ex_set_select;
    wire [2:0] ex_alu_op, ex_write_reg, ex_reg1_sel, ex_reg2_sel;
    wire [15:0] ex_instruction, ex_pc_plus, ex_reg1_data, ex_reg2_data,
            ex_sign_ext_low_bits;

    //flop 3
    wire [15:0] ex_alu_out;

    wire mem_memEn, mem_memWrite, mem_regWrite, mem_createdump, dcache_done, dcache_stall, dcache_hit, dcache_err;
    wire [1:0] mem_memToReg;
    wire [2:0] mem_write_reg;
    wire [15:0] mem_alu_out, mem_pc_plus, mem_reg2_data, mem_sign_ext_low_bits;

    //memory - output
    wire [15:0] pc_decision;
    wire [15:0] mem_read_data;
    wire wb_regWrite;
    wire [1:0] wb_memToReg;
    wire [2:0] wb_write_reg;
    wire [15:0] wb_alu_out, wb_pc_plus, wb_read_data, wb_sign_ext_low_bits;

    //write back - output
    wire [15:0] wb_mem_write_back;

    //forwarding
    wire rs_valid, rt_valid;
    wire [15:0] reg1_forward,reg2_forward;

    //errors
    wire fetch_err;
    wire control_err;
    wire id_halt, ex_halt, mem_halt, wb_halt;

    assign flop_stall = ~(dcache_stall ^ icache_stall);

    ////////////////////////////////
    /////    Instantiate     //////
    //////////////////////////////

    fetch	fetch0(.createdump(mem_createdump), .pc_decision(pc_decision),
            .instruction(if_instruction), .pc_plus(if_pc_plus), 
            .valid(if_valid), .clk(clk), .rst(rst), .icache_err(fetch_err), .icache_done(icache_done),
    	    .icache_stall(icache_stall), .icache_hit(icache_hit), .flop_stall(flop_stall), .flush(flush));

    if_id   pipe0(.if_pc_plus(if_pc_plus), .if_instruction(if_instruction),
            .if_valid(if_valid), .id_pc_plus(id_pc_plus), 
            .id_instruction(id_instruction), .id_valid(id_valid), 
            .clk(clk), .rst(rst), .flop_stall(flop_stall));

    decode	decode0(.wb_regWrite(wb_regWrite), .wb_write_reg(wb_write_reg), 
            .instruction(id_instruction_w), .mem_write_back(wb_mem_write_back),
            .alu_res_sel(id_alu_res_sel), .branch(id_branch), 
            .branch_eqz(id_branch_eqz), .branch_gtz(id_branch_gtz),
            .branch_ltz(id_branch_ltz), .Cin(id_Cin), .invA(id_invA),
            .invB(id_invB), .id_memEn(id_memEn), .memWrite(id_memWrite), 
            .id_regWrite(id_regWrite), .sign_alu(id_sign_alu),
            .ALUSrc_a(id_ALUSrc_a), .ALUSrc_b(id_ALUSrc_b),
            .memToReg(id_memToReg), .pc_dec(id_pc_dec),
            .set_select(id_set_select), .alu_op(id_alu_op),
            .id_write_reg(id_write_reg), .reg1_sel(id_reg1_sel), .reg2_sel(id_reg2_sel), 
            .reg1_data(id_reg1_data), .reg2_data(id_reg2_data), 
            .sign_ext_low_bits(id_sign_ext_low_bits),
            .control_err(control_err), .createdump(id_createdump),
            .halt(id_halt), .clk(clk), .rst(rst), .flop_stall(flop_stall),
            .rs_valid(id_rs_valid), .rt_valid(id_rt_valid));

    id_ex pipe1(.id_alu_res_sel(id_alu_res_sel), .id_branch(id_branch),
            .id_branch_eqz(id_branch_eqz), .id_branch_gtz(id_branch_gtz),
            .id_branch_ltz(id_branch_ltz), .id_Cin(id_Cin), .id_invA(id_invA),
            .id_invB(id_invB), .id_memEn(id_memEn), .id_memWrite(id_memWrite),
            .id_regWrite(id_regWrite), .id_sign_alu(id_sign_alu),
            .id_createdump(id_createdump), .id_ALUSrc_a(id_ALUSrc_a),
            .id_ALUSrc_b(id_ALUSrc_b), .id_memToReg(id_memToReg),
            .id_pc_dec(id_pc_dec), .id_set_select(id_set_select),
            .id_alu_op(id_alu_op), .id_write_reg(id_write_reg),
            .id_reg1_data(id_reg1_data), .id_reg2_data(id_reg2_data),
            .id_sign_ext_low_bits(id_sign_ext_low_bits),
            .id_instruction(id_instruction_w), .id_pc_plus(id_pc_plus), .id_halt(id_halt),
            .ex_alu_res_sel(ex_alu_res_sel), .ex_branch(ex_branch),
            .ex_branch_eqz(ex_branch_eqz), .ex_branch_gtz(ex_branch_gtz),
            .ex_branch_ltz(ex_branch_ltz), .ex_Cin(ex_Cin), .ex_invA(ex_invA),
            .ex_invB(ex_invB), .ex_memEn(ex_memEn), .ex_memWrite(ex_memWrite),
            .ex_regWrite(ex_regWrite), .ex_sign_alu(ex_sign_alu),
            .ex_createdump(ex_createdump), .ex_ALUSrc_a(ex_ALUSrc_a),
            .ex_ALUSrc_b(ex_ALUSrc_b), .ex_memToReg(ex_memToReg),
            .ex_pc_dec(ex_pc_dec), .ex_set_select(ex_set_select),
            .ex_alu_op(ex_alu_op), .ex_instruction(ex_instruction),
            .ex_pc_plus(ex_pc_plus), .ex_write_reg(ex_write_reg),
            .ex_reg1_data(ex_reg1_data), .ex_reg2_data(ex_reg2_data),
            .ex_sign_ext_low_bits(ex_sign_ext_low_bits),
            .ex_halt(ex_halt), .clk(clk), .rst(rst), .flop_stall(flop_stall), .id_rs_valid(id_rs_valid), 
	    .id_rt_valid(id_rt_valid), .ex_rs_valid(ex_rs_valid), .ex_rt_valid(ex_rt_valid), 
	    .id_reg1_sel(id_reg1_sel), .id_reg2_sel(id_reg2_sel), .ex_reg1_sel(ex_reg1_sel), 
	    .ex_reg2_sel(ex_reg2_sel));

    forwarding fw0(.mem_regWrite(mem_regWrite), .wb_regWrite(wb_regWrite), .ex_rs_valid(ex_rs_valid), 
	    .ex_rt_valid(ex_rt_valid), .id_rs(ex_reg1_sel), .id_rt(ex_reg2_sel), .em_rd(mem_write_reg), 
	    .mw_rd(wb_write_reg), .mem_alu_out(mem_alu_out), .wb_mem_write_back(wb_mem_write_back), 
	    .ex_reg1_data(ex_reg1_data), .ex_reg2_data(ex_reg2_data), .reg1_forward(reg1_forward), 
	    .reg2_forward(reg2_forward));

    execute	execute0(.alu_res_sel(ex_alu_res_sel), .branch(ex_branch),
            .branch_eqz(ex_branch_eqz), .branch_gtz(ex_branch_gtz),
            .branch_ltz(ex_branch_ltz), .Cin(ex_Cin), .invA(ex_invA),
            .invB(ex_invB), .sign_alu(ex_sign_alu), .ALUSrc_a(ex_ALUSrc_a),
            .ALUSrc_b(ex_ALUSrc_b), .pc_dec(ex_pc_dec), .set_select(ex_set_select),
            .alu_op(ex_alu_op), .pc_plus(ex_pc_plus), .instruction(ex_instruction),
            .reg1_data(reg1_forward), .reg2_data(reg2_forward),
            .sign_ext_low_bits(ex_sign_ext_low_bits), .alu_out(ex_alu_out),
            .pc_decision(pc_decision), .flush(flush));

    ex_mem  pipe2(.ex_memEn(ex_memEn), .ex_memWrite(ex_memWrite),
            .ex_regWrite(ex_regWrite), .ex_memToReg(ex_memToReg),
            .ex_write_reg(ex_write_reg), .ex_createdump(ex_createdump),
            .ex_alu_out(ex_alu_out), .ex_pc_plus(ex_pc_plus),
            .ex_reg2_data(ex_reg2_data), .ex_sign_ext_low_bits(ex_sign_ext_low_bits),
            .ex_halt(ex_halt), .mem_memEn(mem_memEn), .mem_memWrite(mem_memWrite),
            .mem_regWrite(mem_regWrite), .mem_memToReg(mem_memToReg),
            .mem_write_reg(mem_write_reg), .mem_createdump(mem_createdump),
            .mem_alu_out(mem_alu_out), .mem_pc_plus(mem_pc_plus),
            .mem_reg2_data(mem_reg2_data),
            .mem_sign_ext_low_bits(mem_sign_ext_low_bits),
            .mem_halt(mem_halt), .clk(clk), .rst(rst), .flop_stall(flop_stall));

    memory  memory0(.memEn(mem_memEn), .memWrite(mem_memWrite),
            .alu_out(mem_alu_out), .reg2_data(mem_reg2_data),
            .read_data(mem_read_data), .createdump(mem_createdump),
            .clk(clk), .rst(rst), .dcache_done(dcache_done), .dcache_stall(dcache_stall),
    	    .dcache_hit(dcache_hit), .dcache_err(dcache_err));

    mem_wb  pipe3(.mem_regWrite(mem_regWrite), .mem_memToReg(mem_memToReg),
            .mem_write_reg(mem_write_reg), .mem_alu_out(mem_alu_out),
            .mem_pc_plus(mem_pc_plus), .mem_read_data(mem_read_data), 
            .mem_sign_ext_low_bits(mem_sign_ext_low_bits), .mem_halt(mem_halt),
            .wb_regWrite(wb_regWrite), .wb_memToReg(wb_memToReg),
            .wb_write_reg(wb_write_reg), .wb_alu_out(wb_alu_out),
            .wb_pc_plus(wb_pc_plus), .wb_read_data(wb_read_data),
            .wb_sign_ext_low_bits(wb_sign_ext_low_bits),
            .wb_halt(wb_halt), .clk(clk), .rst(rst), .flop_stall(flop_stall));

    write_back	write_back(.memToReg(wb_memToReg), .alu_out(wb_alu_out),
            .pc_plus(wb_pc_plus), .read_data(wb_read_data),
            .sign_ext_low_bits(wb_sign_ext_low_bits),
            .mem_write_back(wb_mem_write_back));


    assign id_instruction_w = id_valid ? id_instruction : 16'h0800;

    assign err = (fetch_err | control_err | dcache_err);

endmodule

