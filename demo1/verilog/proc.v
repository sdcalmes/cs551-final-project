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
    
    reg_16      pc_reg(.WriteData(pc_decision), .WriteSel(1'b1), .ReadData(PC), .clk(clk),
                .rst(rst));

    memory2c    inst_mem(.data_in(), .data_out(instruction), .addr(PC),
                .enable(1'b1), .wr(1'b0), .createdump(createdump), 
                .clk(clk), .rst(rst));

    rf          register(.read1regsel(instruction[10:8]), .read2regsel(instruction[7:5]),
                .writeregsel(write_reg), .writedata(mem_write_back), .write(regWrite),
                .read1data(reg1_data), .read2data(reg2_data), .clk(clk), .rst(rst));

    control     control(.instr(instruction[15:11]), .regDst(regDst), .regWrite(regWrite),
                .sign_extd(sign_extd), .ALUSrc_a(ALUSrc_a), .ALUSrc_b(ALUSrc_b), .ALUOp(ALUOp),
                .sign_alu(sign_alu), .set_select(set_select), .alu_res_sel(alu_res_sel),
                .memToReg(memToReg), .pc_dec(pc_dec), .branch(branch), .branch_eqz(branch_eqz),
                .branch_gtz(branch_gtz), .branch_ltz(branch_ltz), .memRead(memRead),
                .memWrite(memWrite), .err(control_err), .halt(halt), .createdump(createdump));

    alu_control alu_cntl(.cmd(ALUOp), .alu_op(alu_op), .lowerBits(instruction[1:0]),
                .invB(invB), .invA(invA), .Cin(Cin));

    alu         alu(.A(alu_a_input), .B(alu_b_input), .Cin(Cin), .Op(alu_op), .invA(invA),
                .invB(invB), .sign(sign_alu), .Out(alu_result), .Z(alu_z), .lt_zero(alu_ltz),
                .Cout(alu_Cout), .sle_lt_zero(sle_lt_zero));

    pc_inc      pc_add(.A(PC), .Out(pc_plus));

    add_16      jump_add(.A(pc_plus), .B({{5{instruction[10]}},{instruction[10:0]}}),
                .Out(jump_address));

    branch_control  branch_control(.control_eqz(branch_eqz), .control_gtz(branch_gtz),
                .control_ltz(branch_ltz), .branch(branch), .alu_z(alu_z), .alu_ltz(alu_ltz),
                .pc_plus(pc_plus), .branch_offset({{8{instruction[7]}},instruction[7:0]}),
                .branch_address(branch_address));

    memory2c    data_mem(.data_in(reg2_data), .data_out(read_data),.addr(alu_out),
                .enable(memRead), .wr(memWrite), .createdump(createdump), .clk(clk),
                .rst(rst));



    //////////////////////////////
    /////    Logic          /////
    ////////////////////////////
    
    //set select crap...if we not it, it works with negatives.
    always @(*) begin
        case(set_select)
            2'b00 : set_out = {15'b0, alu_z};                   //SEQ
            2'b01 : set_out = {15'b0, alu_ltz};                 //SLT
            2'b10 : set_out = {15'b0, (sle_lt_zero | alu_z)};   //SLE
            2'b11 : set_out = {15'b0, alu_Cout};                //SCO
        endcase
    end
    assign alu_out = alu_res_sel ? set_out : alu_result;

    
    //pc update (jump or dont jump?)
    always @(*) begin
        pc_decision_w = 16'h0000;
        case(pc_dec)
            2'b00 : pc_decision_w = pc_plus;
            2'b01 : pc_decision_w = branch_address;
            2'b10 : pc_decision_w = jump_address;
            2'b11 : pc_decision_w = alu_out;
        endcase
    end
    assign pc_decision = pc_decision_w;
    

    //use read data1 or readdata1 shifted 8 bits?e
    always @(*) begin
        alu_a_input_w = 2'b00;
        case(ALUSrc_a)
            2'b00 : alu_a_input_w = reg1_data;
            2'b01 : alu_a_input_w = ({reg1_data[7:0], 8'b0} | {8'b0, sign_ext_low_bits[7:0]});
            2'b10 : alu_a_input_w = {reg1_data[0], reg1_data[1], reg1_data[2], reg1_data[3],
                    reg1_data[4], reg1_data[5], reg1_data[6], reg1_data[7], reg1_data[8],
                    reg1_data[9], reg1_data[10], reg1_data[11], reg1_data[12], reg1_data[13],
                    reg1_data[14], reg1_data[15]};
            2'b11 : alu_a_input_w = reg2_data;
            default : shifted_data_err_w = 1'b1;
        endcase
    end
    assign shifted_data_err = shifted_data_err_w;
    assign alu_a_input = alu_a_input_w;

    //sign extended lower 8 bits

    always@(*) begin
        sign_ext_low_bits_w = 2'b00;
        case(sign_extd)
            2'b00 : sign_ext_low_bits_w = { {11{instruction[4]}}, instruction[4:0]};
            2'b01 : sign_ext_low_bits_w = { {8{instruction[7]}}, instruction[7:0]};
            2'b10 : sign_ext_low_bits_w = { 11'b0, instruction[4:0] };
            default : i_type_err_w = 1'b1;
        endcase
    end
    assign sign_ext_low_bits = sign_ext_low_bits_w;
    assign i_type_err = i_type_err_w;
   
    //mux before alu
    always@(*) begin
        alu_b_input_w = 2'b00;
        case(ALUSrc_b)
            2'b00 : alu_b_input_w = reg2_data;
            2'b01 : alu_b_input_w = sign_ext_low_bits;
            2'b10 : alu_b_input_w = 16'b0;
            2'b11 : alu_b_input_w = reg1_data;
            default : alu_src_err_w = 1'b1;
        endcase
    end
    assign alu_b_input = alu_b_input_w;
    assign alu_src_err = alu_src_err_w;

    //write data back to register
    assign mem_write_back = mem_write_back_w;
    always @(*) begin
        case(memToReg)
            2'b00 : mem_write_back_w = read_data;           // read data from data memory
            2'b01 : mem_write_back_w = alu_out;        // data from alu
            2'b10 : mem_write_back_w = pc_plus;             // save (pc+2) to R7
            2'b11 : mem_write_back_w = sign_ext_low_bits;   // store immediate value to 
        endcase
    end

    // change to wrtite_reg_dst
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
