module branch_control_bench();

	
	wire branch_logic_out;
	reg control_eq_z, z, control_gt_zero, alu_lt_zero, control_lt_zero, branch;



	branch_control DUT(.control_eq_z(control_eq_z), .Z(z), .control_gt_zero(control_gt_zero),
			   .alu_lt_zero(alu_lt_zero), .control_lt_zero(control_lt_zero), .branch(branch),
			   .branch_logic_out(branch_logic_out));



	initial
	begin
		control_eq_z = 0;
		z = 0;
		control_gt_zero = 0;
		alu_lt_zero = 0;
		control_lt_zero = 0;
		branch = 0;
	end

	initial begin
		branch = 1'b1;
		control_eq_z = 1'b1;
		z = 1'b1;
		control_gt_zero = 1'b0;
		alu_lt_zero = 1'b0;
		control_lt_zero = 1'b0;
		$display("BranchOut: %d", branch_logic_out);
	end



 endmodule
		   
