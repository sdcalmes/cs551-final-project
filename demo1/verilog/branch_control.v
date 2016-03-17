module branch_control(control_eq_z, Z, control_gt_zero, alu_lt_zero, control_lt_zero, branch, branch_logic_out, data_1, A_lt_z);

	input control_eq_z, Z, control_gt_zero, alu_lt_zero, control_lt_zero, branch, A_lt_z;
	input [15:0] data_1;
	output branch_logic_out;

	//level 1 logic
//	and u1(xnor_out, control_eq_z, Z);
//	nor u7(nand_out, control_eq_z, Z);
//	xor  u8(xor_out, xnor_out, nand_out);
//	xnor u1(xnor_out, control_eq_z, Z);
//	nand u7(nor_gt_lt, control_gt_zero, control_lt_zero);
	
	//not  u2(alu_not_lt_zero, alu_lt_zero);
	//not  u9(not_eq_z, Z);
	//and  u3(and1, control_gt_zero, alu_not_lt_zero, not_eq_z);
	//and  u4(and2, control_lt_zero, alu_lt_zero);

	//2nd level logic
	//or   u5(or1, and1, and2, ~(|data_1), (control_lt_z & A_lt_z));

	//3rd and last level logic
	//and  u6(branch_logic_out, branch, or1);
	
	assign branch_logic_out = branch & (|data_1 & control_gt_zero & control_lt_zero) | (~(|data_1) & control_eq_z) |
					(data_1[15] & control_lt_zero) | (~data_1[15] & control_gt_zero & control_eq_z);
//	assign branch_logic_out = (|(data_1) & control_eq_z) | (|data_1 & control_gt_zero & control_lt_zero) | (~data_1[15] & control_lt_zero) | (data_1[15] & (control_eq_z | control_gt_zero));

endmodule
