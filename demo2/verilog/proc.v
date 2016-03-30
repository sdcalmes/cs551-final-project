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
    //random wires
    wire rand_wire [15:0];
  


    //pc adder stuff
    wire [15:0] pc_plus;
    wire ofl, z;
    wire [15:0] PC;
    reg [15:0] pc_decision_w;
    wire [15:0] pc_decision;
    //branch/jump things
    wire [15:0] branch_address;
    wire [15:0] jump_address;
    wire [15:0] jump_decision;
    
    //memory2c elements
    wire [15:0] instruction;
    reg [15:0] PC_address;
    reg [15:0] mem_address;
    reg [15:0] write_data_mem;
    wire [15:0] read_data;
    wire enable_read, enable_write, createdump;

    //control elements
    wire branch, memRead, memWrite, regWrite, sign_alu,
        branch_eqz, branch_gtz, branch_ltz, alu_res_sel;
    wire [1:0] memToReg, regDst, sign_extd, set_select, ALUSrc_a, ALUSrc_b, pc_dec;
    wire [3:0] ALUOp;
    wire halt;

    //register components
    reg [2:0] read_reg_1, read_reg_2, write_reg_w;
    wire [2:0] write_reg;
    reg [15:0] mem_write_back_w, alu_a_input_w;
    wire [15:0] mem_write_back, alu_a_input, reg2_data, reg1_data;
    reg write_data_err;

    //branch alu elemtns
    wire [15:0] sign_ext_low_bits, branch_out;
    wire b_ofl, b_z, b_zero;
    reg [15:0] sign_ext_low_bits_w;

    //alu elements
    wire [15:0] alu_b_input, alu_out, alu_result;
    wire alu_z, alu_ltz, alu_Cout, sle_lt_zero;
    wire [2:0] alu_op;
    wire Cin;
    reg [15:0] alu_b_input_w, set_out;
    //not sure about invA yet
    wire invA, invB;

   

    //errors
    wire control_err;
    wire alu_src_err;
    reg alu_src_err_w;
    wire i_type_err;
    reg i_type_err_w;
    reg shifted_data_err_w;
    wire shifted_data_err;

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

