module execute(Cin, invA, invB, sign_alu, branch_eqz, branch_gtz, branch_ltz, branch, alu_op,
		pc_plus, instruction, jump_address, branch_address, alu_res_sel, alu_out, ALUSrc_a,
	        reg1_data, reg2_data, sign_ext_low_bits, ALUSrc_b, set_select);

    input Cin, invA, invB, sign_alu, branch_eqz, branch_gtz, branch_ltz, branch, alu_res_sel;
    input [1:0] ALUSrc_a, ALUSrc_b, set_select;
    input [2:0] alu_op;
    input [15:0] pc_plus, instruction, reg1_data, reg2_data, sign_ext_low_bits;
    output [15:0] jump_address, branch_address, alu_out;

    reg [15:0] alu_a_input_w, alu_b_input_w, set_out;
    reg shifted_data_err_w, alu_src_err_w;

    wire [15:0] alu_a_input, alu_b_input, alu_result;
    wire alu_z, alu_ltz, alu_Cout, sle_lt_zero, shifted_data_err;


    alu         alu(.A(alu_a_input), .B(alu_b_input), .Cin(Cin), .Op(alu_op), .invA(invA),
                .invB(invB), .sign(sign_alu), .Out(alu_result), .Z(alu_z), .lt_zero(alu_ltz),
                .Cout(alu_Cout), .sle_lt_zero(sle_lt_zero));
    
    add_16      jump_add(.A(pc_plus), .B({{5{instruction[10]}},{instruction[10:0]}}),
                .Out(jump_address));
    
    branch_control  branch_control(.control_eqz(branch_eqz), .control_gtz(branch_gtz),
                .control_ltz(branch_ltz), .branch(branch), .alu_z(alu_z), .alu_ltz(alu_ltz),
                .pc_plus(pc_plus), .branch_offset({{8{instruction[7]}},instruction[7:0]}),
                .branch_address(branch_address));


    always @(*) begin
        case(set_select)
            2'b00 : set_out = {15'b0, alu_z};                   //SEQ
            2'b01 : set_out = {15'b0, alu_ltz};                 //SLT
            2'b10 : set_out = {15'b0, (sle_lt_zero | alu_z)};   //SLE
            2'b11 : set_out = {15'b0, alu_Cout};                //SCO
        endcase
    end
    assign alu_out = alu_res_sel ? set_out : alu_result;

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

endmodule
