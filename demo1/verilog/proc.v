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
    wire ofl, z;
    wire [15:0] PC;
    
    //memory2c elements
    wire [15:0] instruction;
    reg [15:0] PC_address;
    reg [15:0] mem_address;
    reg [15:0] write_data_mem;
    wire [15:0] read_data;
    wire enable_read, enable_write;

    //control elements
    wire jump, branch, memRead, memWrite, ALUSrc, regWrite,
	    branch_eq_z, branch_gt_z, branch_lt_z;
    wire [1:0] memToReg, regDst;
    wire [3:0] ALUOp;
    wire halt;

    //register components
    reg [2:0] read_reg_1, read_reg_2, write_reg_w;
    wire [2:0] write_reg;
    reg [15:0] mem_write_back_w;
    wire [15:0] mem_write_back, read_reg_1_data, read_reg_2_data;
    wire write_data_err;

    //branch alu elemtns
    wire [15:0] sign_ext_low_bits, branch_out;
    wire b_ofl, b_z, b_zero;

    //main alu elements
    wire [15:0] alu_b_input, main_alu_out;
    wire main_ofl, main_z, main_lt_z;
    wire [2:0] alu_op;

    //shifter elements
    wire [15:0] shift_in, shift_out;
    wire [3:0] shift_cnt;
    wire [1:0] shift_op;
    //branch/jump things
    wire [15:0] branch_address;
    wire [15:0] jump_address;
    wire branch_logic_out;

    //errors
    wire control_err;

    ////////////////////////////////
    /////    Instantiate     //////
    //////////////////////////////
    //
    
    reg_16	pc_reg(.WriteData(pc_plus), .WriteSel(1'b1), .ReadData(PC), .clk(clk), .rst(rst));

    memory2c    inst_mem(.data_in(), .data_out(instruction), .addr(PC),
	    		.enable(1'b1), .wr(1'b0), .createdump(1'b0), 
                .clk(clk), .rst(rst));

    rf_bypass   register(.read1regsel(instruction[10:8]), .read2regsel(instruction[7:5]),
	    		.writeregsel(write_data_reg), .writedata(mem_write_back), .write(regWrite), 
                .read1data(read_reg_1_data), .read2data(read_reg_2_data), .err(reg_err), 
                .clk(clk), .rst(rst));

    control     control(.instr(instruction[15:11]), .regDst(regDst), .jump(jump), .branch(branch),
                .memRead(memRead), .memToReg(memToReg), .ALUOp(ALUOp), .sign_alu(sign_alu),
				.memWrite(memWrite), .ALUSrc(ALUSrc), .regWrite(regWrite),
				.branch_eq_z(branch_eq_z), .branch_gt_z(branch_gt_z),
				.branch_lt_z(branch_lt_z), .err(control_err), .halt(halt));

    alu_control alu_cntl(.cmd(ALUOp), .alu_op(alu_op), .lowerBits(instruction[1:0]));

    alu         main_alu(.A(read_reg_1_data), .B(alu_b_input), .Cin(1'b0), .Op(alu_op),
	    		.invA(1'b0), .invB(1'b0), .sign(sign_alu), .Out(main_alu_out),
				.Ofl(main_ofl), .Z(main_z), .lt_zero(main_lt_z));

    alu         pc_add(.A(PC), .B(16'h0002), .Cin(1'b0), .Op(3'b100), .invA(1'b0), .invB(1'b0),
    			.sign(1'b0), .Out(pc_plus), .Ofl(ofl), .Z(z), .lt_zero());

    alu		branch_add(.A(pc_plus), .B(shift_out), .Cin(1'b0), .Op(3'b100), .invA(1'b0),
	    		.invB(1'b0), .sign(1'b0), .Out(branch_out), .Ofl(b_ofl), .Z(b_z),
				.lt_zero(b_zero));

    shifter	branch_shifter(.In(shift_in), .Cnt(shift_cnt), .Op(shift_op), .Out(shift_out));

    branch_control	branch_control(.control_eq_z(branch_eq_z), .control_gt_zero(branch_gt_z),
	    		.alu_lt_zero(alu_lt_zero), .control_lt_zero(branch_lt_z),
				.branch(branch), .branch_logic_out(branch_logic_out), .Z(main_z));

    memory2c    data_mem(.data_in(write_data_mem), .data_out(read_data), .addr(mem_address),
	    		.enable(memRead), .wr(memWrite), .createdump(1'b0), .clk(clk), .rst(rst));



    //////////////////////////////
    /////    Logic          /////
    ////////////////////////////
    
    //pc update (jump or dont jump?)
     
    assign jump_address = {pc_plus[15:13], {instruction[12:0], 2'b0}};
    assign branch_address = branch_logic_out ? branch_out : pc_plus;
    //assign PC = jump ? jump_address : branch_address;

    //sign extended lower 8 bits
    assign sign_ext_low_bits = { {8{instruction[7]}}, instruction[7:0]};
    
    //mux before main alu
    assign alu_b_input = ALUSrc ? sign_ext_low_bits : read_reg_2_data;

    //branch alu input
    assign shift_in = sign_ext_low_bits;
    assign shift_cnt = 2'b10;
    assign shift_op = 2'b01;

    //write data back to register
    assign mem_write_back = mem_write_back_w;
    always @(*) begin
        case(memToReg)
            2'b00 : mem_write_back_w = read_data;           // read data from data memory
            2'b01 : mem_write_back_w = main_alu_out;        // data from alu
            2'b10 : mem_write_back_w = pc_plus;             // save (pc+2) to R7
            2'b11 : mem_write_back_w = sign_ext_low_bits;   // store immediate value to 
        endcase
    end

    assign write_reg = write_reg_w;
    always @(*) begin
        case(regDst)
            2'b00 : write_reg_w = instruction[10:8];
            2'b01 : write_reg_w = instruction[4:2];
            2'b10 : write_reg_w = 3'b111;
            default : write_data_err = 1'b1;
        endcase
    end



endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
