module branch_control(control_eq_z, Z, control_gt_zero, alu_lt_zero, control_lt_zero, branch, branch_logic_out);

	input control_eq_z, Z, control_gt_zero, alu_lt_zero, control_lt_zero, branch;
	output branch_logic_out;

	wire xnor_out, alu_not_lt_zero, and1, and2, or1, and3;

	//level 1 logic
	and u1(xnor_out, control_eq_z, Z);
	nand u7(nand_out, control_eq_z, Z);
	xnor  u8(xor_out, xnor_out, nand_out);
	not  u2(alu_not_lt_zero, alu_lt_zero);
	and  u3(and1, control_gt_zero, alu_not_lt_zero);
	and  u4(and2, control_lt_zero, alu_lt_zero);

	//2nd level logic
	or   u5(or1, xor_out, and1, and2);

	//3rd and last level logic
	and  u6(branch_logic_out, branch, or1);

endmodule
