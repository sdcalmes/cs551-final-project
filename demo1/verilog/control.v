module control(instr, regDst, jump, branch, memRead, memToReg, ALUOp, sign_alu, memWrite, ALUSrc, regWrite, 
               branch_eq_z, branch_gt_z, branch_lt_z);

    output  jump, branch, memRead, memWrite, ALUSrc, regWrite, ALUOp, sign_alu, branch_eq_z,
        branch_gt_z, branch_lt_z;
    output [1:0] regDst, memToReg;
    
	input [4:0] instr;

    reg jump_w, branch_w, memRead_w, memWrite_w, ALUSrc_w, regWrite_w, sign_alu_w, ALUOp_w,
        branch_eq_z_w, branch_gt_z_w, branch_lt_z_w;
    reg [3:0] ALUOp_w;
    
    reg [1:0] regDst_w, memToReg_w;

    localparam HALT  = 5'b0_0000;
    localparam NOP   = 5'b0_0001;

    localparam IMM_ARITH  = 5'b0_10xx;
    localparam IMM_SHIFT  = 5'b1_01xx;
    localparam ST    = 5'b1_0000;
    localparam LD    = 5'b1_0001;
    localparam STU   = 5'b1_0011;

    localparam BTR   = 5'b1_1001;
    localparam ALU1  = 5'b1_101x;
    localparam SEQ   = 5'b1_11xx;

	localparam BEQZ  = 5'b0_1100;
	localparam BNEZ  = 5'b0_1101;
	localparam BLTZ  = 5'b0_1110;
	localparam BGEZ  = 5'b0_1111;
	localparam LBI   = 5'b1_1000;
 	localparam SLBI  = 5'b1_0010;
	
	localparam J     = 5'b0_0100;
	localparam JR    = 5'b0_0101;
	localparam JAL   = 5'b0_0110;
	localparam JALR  = 5'b0_0111;
	
	localparam SIIC  = 5'b0_0010;
	localparam RTI   = 5'b0_0011;


	assign regDst = regDst_w;
	assign jump = jump_w;
	assign branch = branch_w;
	assign memRead = memRead_w;
	assign memToReg = memToReg_w;
	assign memWrite = memWrite_w;
	assign ALUSrc = ALUSrc_w;
	assign ALUOp = ALUOp_w;
    assign sign_alu = sign_alu_w;
	assign regWrite = regWrite_w;
	assign branch_eq_z = branch_eq_z_w;
	assign branch_gt_z = branch_gt_z_w;
	assign branch_lt_z = branch_lt_z_w;

	always@(*) begin

		regDst_w = 2'b00;
		ALUSrc_w = 1'b0;
        ALUOp_w  = 4'h0;
        sign_alu_w = 1'b0;
		jump_w = 1'b1;
		memToReg_w = 2'b00;
		regWrite_w = 1'b0;
		memRead_w = 1'b0;
		memWrite_w = 1'b0;
		branch_w = 1'b0;
		branch_eq_z_w = 1'b0;
		branch_gt_z_w = 1'b0;
		branch_lt_z_w = 1'b0;

		casex(instr)
			HALT: begin
			end

			NOP: begin
			end

			IMM_ARITH: begin
                sign_alu_w = 1'b1;
				ALUSrc_w = 1'b1;
				regWrite_w = 1'b1;
                ALUOp_w = {2'b11,instr[1:0]};
			end

            IMM_SHIFT: begin
                ALUOp_w = {2'b10, instr[1:0]};
                ALUSrc_w = 1'b1;
                regWrite_w = 1'b1;
            end

			ST: begin
                sign_alu_w = 1'b1;
				ALUSrc_w = 1'b1;
				memWrite_w = 1'b1;
                ALUOp_w = 3'b1100;
			end

			LD: begin
				ALUSrc_w = 1'b1;
				memToReg_w = 2'b01;
				regWrite_w = 1'b1;
				memRead_w = 1'b1;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1100;
			end

			STU: begin
				ALUSrc_w = 1'b1;
				regWrite_w = 1'b1;
				memWrite_w = 1'b1;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1100;
			end

			BTR: begin
				regDst_w = 2'b01;
				jump_w = 1'b1;
				regWrite_w = 1'b1;
			end

			ALU1: begin
				regDst_w = 2'b01;
				jump_w = 1'b1;
				regWrite_w = 1'b1;
                ALUOp_w = {1'b1, instr[0], 2'b00};
			end

			SEQ: begin
				regDst_w = 2'b01;
                sign_alu_w = 1'b1;
				jump_w = 1'b1;
				regWrite_w = 1'b1;
                ALUOp_w = 4'b1101;
			end

			BEQZ: begin
				jump_w = 1'b1;
				branch_w = 1'b1;
				branch_eq_z_w = 1'b1;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1101;
			end

			BNEZ: begin
				jump_w = 1'b1;
				branch_w = 1'b1;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1101;
			end

			BLTZ: begin
				jump_w = 1'b1;
				branch_w = 1'b1;
				branch_lt_z_w = 1'b1;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1101;
			end

			BGEZ: begin
				jump_w = 1'b1;
				branch_w = 1'b1;
				branch_gt_z_w = 1'b1;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1101;
			end

			LBI: begin
				ALUSrc_w = 1'b1;
				jump_w = 1'b1;
				regWrite_w = 1'b1;
                sign_alu_w = 1'b1;
			end

			SLBI: begin
				ALUSrc_w = 1'b1;
				jump_w = 1'b1;
				regWrite_w = 1'b1;
                sign_alu_w = 1'b0;
                ALUOp_w = 4'b1010;
			end

			J: begin
				jump_w = 1'b1;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1100;
			end

			JR: begin
				ALUSrc_w = 1'b1;
				jump_w = 1'b1;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1100;
			end

			JAL: begin
				regDst_w = 2'b10;
				jump_w = 1'b1;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1100;
			end

			JALR: begin
				regDst_w = 2'b10;
				jump_w = 1'b1;
				ALUSrc_w = 1'b1;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1100;
			end

			SIIC: begin
			end

			RTI: begin
			end

            default : err = 1'b1;

	endcase
end endmodule 
