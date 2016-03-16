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
    
    //memory2c elements
    wire [15:0] instruction;
    reg [15:0] PC_address;
    reg [15:0] mem_address;
    reg [15:0] write_data_mem;
    wire [15:0] read_data;
    wire enable_read, enable_write;

    //control elements
    wire jump, branch, memRead, memWrite, regWrite, ALUSrc,
	    branch_eq_z, branch_gt_z, branch_lt_z, alu_result_select;
    wire [1:0] memToReg, regDst, i_type_1, set_select, shifted_data_1;
    wire [3:0] ALUOp;
    wire halt;

    //register components
    reg [2:0] read_reg_1, read_reg_2, write_reg_w;
    wire [2:0] write_reg;
    reg [15:0] mem_write_back_w, read_reg_1_data_w;
    wire [15:0] mem_write_back, read_reg_1_data, read_reg_2_data, read_data_1;
    reg write_data_err;

    //branch alu elemtns
    wire [15:0] sign_ext_low_bits, branch_out;
    wire b_ofl, b_z, b_zero;
    reg [15:0] sign_ext_low_bits_w;

    //main alu elements
    wire [15:0] alu_b_input, main_alu_out, alu_result;
    wire main_ofl, main_z, main_lt_z;
    wire [2:0] alu_op;
    wire Cin;
    reg [15:0] alu_b_input_w, set_out;
    //not sure about invA yet
    wire invA, invB;

    //shifter elements
    wire [15:0] shift_in, shift_out;
    wire [3:0] shift_cnt;
    wire [1:0] shift_op;
    //branch/jump things
    wire [15:0] branch_address;
    wire [15:0] jump_address;
    wire [15:0] pc_decision;
    wire branch_logic_out;
   

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
    
    reg_16	pc_reg(.WriteData(pc_decision), .WriteSel(1'b1), .ReadData(PC), .clk(clk), .rst(rst));

    memory2c    inst_mem(.data_in(), .data_out(instruction), .addr(PC),
	    		.enable(1'b1), .wr(1'b0), .createdump(1'b0), 
                .clk(clk), .rst(rst));

    rf   register(.read1regsel(instruction[10:8]), .read2regsel(instruction[7:5]),
	    		.writeregsel(write_reg), .writedata(mem_write_back), .write(regWrite), 
                .read1data(read_data_1), .read2data(read_reg_2_data), .err(reg_err), 
                .clk(clk), .rst(rst));

    control     control(.instr(instruction[15:11]), .regDst(regDst), .jump(jump), .branch(branch),
                .memRead(memRead), .memToReg(memToReg), .ALUOp(ALUOp), .sign_alu(sign_alu),
				.memWrite(memWrite), .ALUSrc(ALUSrc), .regWrite(regWrite),
				.branch_eq_z(branch_eq_z), .branch_gt_z(branch_gt_z),
				.branch_lt_z(branch_lt_z), .err(control_err), .halt(halt), .i_type_1(i_type_1),
				.set_select(set_select), .alu_result_select(alu_result_select),
				.shifted_data_1(shifted_data_1));

    alu_control alu_cntl(.cmd(ALUOp), .alu_op(alu_op), .lowerBits(instruction[1:0]), .invB(invB), .invA(invA), .Cin(Cin));

    alu         main_alu(.A(read_reg_1_data), .B(alu_b_input), .Cin(Cin), .Op(alu_op),
	    		.invA(invA), .invB(invB), .sign(sign_alu), .Out(alu_result),
				.Ofl(main_ofl), .Z(main_z), .lt_zero(main_lt_z));

    alu         pc_add(.A(PC), .B(16'h0002), .Cin(1'b0), .Op(3'b100), .invA(1'b0), .invB(1'b0),
    			.sign(1'b0), .Out(pc_plus), .Ofl(ofl), .Z(z), .lt_zero());

    alu		jump_add(.A(pc_plus), .B({{5{instruction[10]}},{instruction[10:0]}}), .Cin(1'b0), .Op(3'b100),
	    		 .invA(1'b0), .invB(1'b0), .sign(1'b1), .Out(jump_address), .Ofl(), .Z(), .lt_zero());

    alu		branch_add(.A(pc_plus), .B({{8{instruction[7]}},instruction[7:0]}), .Cin(1'b0), .Op(3'b100), .invA(1'b0),
	    		.invB(1'b0), .sign(1'b0), .Out(branch_out), .Ofl(b_ofl), .Z(b_z),
				.lt_zero(b_zero));

    shifter	branch_shifter(.In(shift_in), .Cnt(shift_cnt), .Op(shift_op), .Out(shift_out));

    branch_control	branch_control(.control_eq_z(branch_eq_z), .control_gt_zero(branch_gt_z),
	    		.alu_lt_zero(main_lt_z), .control_lt_zero(branch_lt_z),
				.branch(branch), .branch_logic_out(branch_logic_out), .Z(main_z));

    memory2c    data_mem(.data_in(write_data_mem), .data_out(read_data), .addr(mem_address),
	    		.enable(memRead), .wr(memWrite), .createdump(1'b0), .clk(clk), .rst(rst));



    //////////////////////////////
    /////    Logic          /////
    ////////////////////////////
    
    //set select crap...if we not it, it works with negatives.
    always @(*) begin
	    case(set_select)
		    2'b00 : set_out = {15'b0, main_lt_z};
		    2'b01 : set_out = {15'b0, main_z};
		    2'b10 : set_out = {15'b0, main_ofl};
		    2'b11 : set_out = {15'b0, (main_lt_z | main_z)};
	    endcase
    end
    assign main_alu_out = alu_result_select ? set_out : alu_result;
    
    //pc update (jump or dont jump?)
    //assign jump_address = {{instruction[10:0], 2'b0}, pc_plus[15:13]};
    //need to change this to add, not concatenate
//    assign jump_address = {pc_plus[15:12], {instruction[10:0], 1'b0}};
    assign branch_address = branch_logic_out ? branch_out : pc_plus;
    assign pc_decision = jump ? jump_address : branch_address;

    //use read data1 or readdata1 shifted 8 bits?
    //assign read_reg_1_data = shifted_data_1 ? ({read_data_1[7:0], 8'b0} | {8'b0, sign_ext_low_bits[7:0]}) : read_data_1; 
    always @(*) begin
        case(shifted_data_1)
            2'b01 : read_reg_1_data_w = ({8'b0, sign_ext_low_bits[7:0]} | {8'b0, sign_ext_low_bits[7:0]});
            2'b00 : read_reg_1_data_w = read_data_1;
            2'b10 : read_reg_1_data_w = {read_data_1[0], read_data_1[1], read_data_1[2], read_data_1[3],
                    read_data_1[4], read_data_1[5], read_data_1[6], read_data_1[7], read_data_1[8],
                    read_data_1[9], read_data_1[10], read_data_1[11], read_data_1[12], read_data_1[13],
                    read_data_1[14], read_data_1[15]};
            default : shifted_data_err_w = 1'b1;
        endcase
    end
    assign shifted_data_err = shifted_data_err_w;
    assign read_reg_1_data = read_reg_1_data_w;

    //sign extended lower 8 bits

    always@(*) begin
	    case(i_type_1)
		    2'b00 : sign_ext_low_bits_w = { {11{instruction[4]}}, instruction[4:0]};
		    2'b01 : sign_ext_low_bits_w = { {8{instruction[7]}}, instruction[7:0]};
		    2'b10 : sign_ext_low_bits_w = { 11'b0, instruction[4:0] };
		    default : i_type_err_w = 1'b1;
	    endcase
    end
    assign sign_ext_low_bits = sign_ext_low_bits_w;
    assign i_type_err = i_type_err_w;
   
    //mux before main alu
    always@(*) begin
	    case(ALUSrc)
		    1'b0 : alu_b_input_w = read_reg_2_data;
		    1'b1 : alu_b_input_w = sign_ext_low_bits;
		    default : alu_src_err_w = 1'b1;
	    endcase
    end
    assign alu_b_input = alu_b_input_w;
    assign alu_src_err = alu_src_err_w;

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
	    write_reg_w = 3'b000;
        case(regDst)
            2'b00 : write_reg_w = instruction[10:8];
            2'b01 : write_reg_w = instruction[4:2];
            2'b10 : write_reg_w = 3'b111;
	    2'b11 : write_reg_w = instruction[7:5];
            default : write_data_err = 1'b1;
        endcase
    end



endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
