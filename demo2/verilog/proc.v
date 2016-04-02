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


    //fetch - output
    wire [15:0] pc_plus, instruction;
    
    //decode - output
    wire branch, branch_eqz, branch_gtz, branch_ltz, memRead, memWrite, invA,
         invB, Cin, sign_alu,  alu_res_sel, halt, createdump;
    wire [1:0] ALUSrc_a, ALUSrc_b, set_select, memToReg, pc_dec;
    wire [2:0] alu_op;
    wire [15:0] reg1_data, reg2_data, sign_ext_low_bits;

    //execute - output
    wire [15:0] jump_address, branch_address, alu_out;
    
    //memory - output
    wire [15:0] read_data, pc_decision;

    //write back - output
    wire [15:0] mem_write_back;


    //errors
    wire fetch_err;
    wire control_err;

    ////////////////////////////////
    /////    Instantiate     //////
    //////////////////////////////

    fetch	fetch0(.createdump(createdump), .pc_decision(pc_decision),
            .instruction(instruction), .pc_plus(pc_plus), 
            .clk(clk), .rst(rst), .err(fetch_err));

    decode	decode0(.instruction(instruction), .mem_write_back(mem_write_back),
            .alu_res_sel(alu_res_sel), .branch(branch), .branch_eqz(branch_eqz),
            .branch_gtz(branch_gtz), .branch_ltz(branch_ltz), .Cin(Cin),
            .invA(invA), .invB(invB), .memRead(memRead), .memWrite(memWrite),
            .sign_alu(sign_alu), .ALUSrc_a(ALUSrc_a), .ALUSrc_b(ALUSrc_b),
            .memToReg(memToReg), .pc_dec(pc_dec), .set_select(set_select),
            .alu_op(alu_op), .reg1_data(reg1_data), .reg2_data(reg2_data),
            .sign_ext_low_bits(sign_ext_low_bits), .control_err(control_err),
            .createdump(createdump), .halt(halt), .clk(clk), .rst(rst));

    execute	execute0(.alu_res_sel(alu_res_sel), .branch(branch),
            .branch_eqz(branch_eqz), .branch_gtz(branch_gtz),
            .branch_ltz(branch_ltz), .Cin(Cin), .invA(invA), .invB(invB),
            .sign_alu(sign_alu), .ALUSrc_a(ALUSrc_a), .ALUSrc_b(ALUSrc_b),
            .pc_dec(pc_dec), .set_select(set_select), .alu_op(alu_op),
            .pc_plus(pc_plus), .instruction(instruction), .reg1_data(reg1_data),
            .reg2_data(reg2_data), .sign_ext_low_bits(sign_ext_low_bits),
            .alu_out(alu_out), .pc_decision(pc_decision));

    memory	memory0(.memRead(memRead), .memWrite(memWrite), .alu_out(alu_out), 
            .reg2_data(reg2_data), .read_data(read_data),
            .createdump(createdump), .clk(clk), .rst(rst));

    write_back	write_back(.memToReg(memToReg), .alu_out(alu_out),
            .pc_plus(pc_plus), .read_data(read_data),
            .sign_ext_low_bits(sign_ext_low_bits),
            .mem_write_back(mem_write_back));


endmodule

