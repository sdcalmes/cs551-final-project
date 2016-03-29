module branch_control(control_eqz, control_gtz, control_ltz, branch, alu_z, alu_ltz, pc_plus, branch_offset, branch_address);

	input control_eqz, control_gtz, control_ltz, branch, alu_z, alu_ltz;
	input [15:0] pc_plus, branch_offset;
    output [15:0] branch_address;

    wire branch_logic;
    wire [15:0] branch_out;
    reg [15:0] branch_address_w;

    add_16 branch_add(.A(pc_plus), 
                      .B(branch_offset), 
                      .Out(branch_out));
	
    assign branch_logic = branch & ((~alu_z & control_gtz & control_ltz) |      //bnez 
                                    (alu_z  & control_eqz) |                    //beqz
                                    (alu_ltz & control_ltz) |                   //bltz
                                    (~alu_ltz & control_gtz & control_eqz));    //bgez

    assign branch_address = branch_logic ? branch_out : pc_plus;

endmodule
