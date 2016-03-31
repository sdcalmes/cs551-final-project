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


    //pc adder stuff
    wire [15:0] pc_plus;
    wire [15:0] pc_decision;
    //branch/jump things
    wire [15:0] branch_address;
    wire [15:0] jump_address;
    
    //memory2c elements
    wire [15:0] instruction;
    wire [15:0] read_data;
    wire createdump;

    //control elements
    wire branch, memRead, memWrite, sign_alu,
        branch_eqz, branch_gtz, branch_ltz, alu_res_sel;
    wire [1:0] memToReg, set_select, ALUSrc_a, ALUSrc_b, pc_dec;
    wire halt;

    //register components
    wire [15:0] mem_write_back, reg2_data, reg1_data, sign_ext_low_bits;

    //alu elements
    wire [15:0] alu_out;
    wire [2:0] alu_op;
    wire Cin;
    wire invA, invB;

   

    //errors
    wire fetch_err;
    wire control_err;

    ////////////////////////////////
    /////    Instantiate     //////
    //////////////////////////////
    //
    //new instantiation
    fetch	fetch0(.pc_decision(pc_decision), .instruction(instruction), .createdump(createdump),
    			.clk(clk), .rst(rst), .err(fetch_err), .pc_plus(pc_plus));

    decode	decode0(.instruction(instruction), .mem_write_back(mem_write_back), .reg1_data(reg1_data),
    			.reg2_data(reg2_data), .ALUSrc_a(ALUSrc_a), .ALUSrc_b(ALUSrc_b),
			.alu_op(alu_op), .sign_alu(sign_alu), .set_select(set_select), .alu_res_sel(alu_res_sel),
			.memToReg(memToReg), .pc_dec(pc_dec), .branch(branch), .branch_eqz(branch_eqz),
			.branch_gtz(branch_gtz), .branch_ltz(branch_ltz), .memRead(memRead), .memWrite(memWrite),
			.control_err(control_err), .sign_ext_low_bits(sign_ext_low_bits), .invA(invA),
			.invB(invB), .Cin(Cin), .halt(halt), .createdump(createdump), .clk(clk), .rst(rst));

    execute	execute0(.Cin(Cin), .invA(invA), .invB(invB), .sign_alu(sign_alu), .branch_eqz(branch_eqz),
    			 .branch_ltz(branch_ltz), .branch(branch), .alu_op(alu_op), .pc_plus(pc_plus),
		 	 .instruction(instruction), .jump_address(jump_address), .branch_address(branch_address),
		 	 .alu_res_sel(alu_res_sel), .alu_out(alu_out), .ALUSrc_a(ALUSrc_a), .reg1_data(reg1_data),
		 	 .reg2_data(reg2_data), .sign_ext_low_bits(sign_ext_low_bits), .ALUSrc_b(ALUSrc_b),
		 	 .set_select(set_select), .branch_gtz(branch_gtz));

    memory	memory0(.reg2_data(reg2_data), .alu_out(alu_out), .pc_plus(pc_plus),
    			.branch_address(branch_address), .jump_address(jump_address), .memRead(memRead),
			.memWrite(memWrite), .createdump(createdump), .clk(clk), .rst(rst), .pc_dec(pc_dec),
			.pc_decision(pc_decision), .read_data(read_data));

    write_back	write_back(.read_data(read_data), .pc_plus(pc_plus), .sign_ext_low_bits(sign_ext_low_bits),
    			   .alu_out(alu_out), .mem_write_back(mem_write_back), .memToReg(memToReg));


endmodule

