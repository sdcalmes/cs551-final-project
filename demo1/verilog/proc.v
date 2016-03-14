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

    reg PC;
    //memory2c elements
    reg [15:0] instruction;
    reg [15:0] PC_address;
    reg [15:0] mem_address;
    reg [15:0] write_data;
    reg [15:0] read_data;
    wire enable_read, enable_write;

    //control elements
    wire regDst, jump, branch, memRead, memToReg, ALUOp, memWrite, ALUSrc, regWrite,
	    branch_eq_z, branch_gt_z, branch_lt_z;

    ////////////////////////////////
    /////    Instantiate     //////
    //////////////////////////////
    
    alu         main_alu(.A(), .B(), .Cin, .Op(), .invA(), .invB(), .sign(), 
                         .Out(), .Ofl(), .Z());

    memory2c    inst_mem(.data_in(PC_address), .data_out(instruction), .addr(),
	    			.enable(enable_read), .wr(enable_write), 
                         	.createdump(), .clk(clk), .rst(rst));

    rf_bypass   register(.read1regsel(), .read2regsel(), .writeregsel(), .writedata(), 
                         .write(), .read1data(), .read2data(), .err());

    memory2c    data_mem(.data_in(write_data), .data_out(read_data), .addr(mem_address),
	    			.enable(enable_read), .wr(enable_write), 
                         	.createdump(), .clk(clk), .rst(rst));

    control     control(.instr(instruction[4:0]), .regDst(regDst), .jump(jump), .branch(branch),
	    			.memRead(memRead), .memToReg(memToReg), .ALUOp(ALUOp),
				.memWrite(memWrite), .ALUSrc(ALUSrc), .regWrite(regWrite),
				.branch_eq_z(branch_eq_z), .branch_gt_z(branch_gt_z),
				.branch_lt_z(branch_lt_z));

    alu_control alu_cntl();

    alu         add_off ();



    //////////////////////////////
    /////    Logic          /////
    ////////////////////////////



endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
