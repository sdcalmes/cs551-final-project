module control(instr, regDst, regWrite, sign_extd, ALUSrc_a, ALUSrc_b, ALUOp, sign_alu, set_select, alu_res_sel, 
            memToReg, pc_dec, branch, branch_eqz, branch_gtz, branch_ltz, memEn, memWrite, err, halt, createdump, rst);

    input rst;
    input [4:0] instr;

    output regWrite, sign_alu, alu_res_sel, branch, branch_eqz, branch_gtz, branch_ltz, memEn, memWrite;
    output [1:0] regDst, sign_extd, ALUSrc_a, ALUSrc_b, set_select, memToReg, pc_dec;
    output [3:0] ALUOp;
    
    output reg halt, err, createdump;
    
    reg regWrite_w, sign_alu_w, alu_res_sel_w, branch_w, branch_eqz_w, branch_gtz_w,
        branch_ltz_w, memEn_w, memWrite_w;
    reg [1:0] regDst_w, sign_extd_w, ALUSrc_a_w, ALUSrc_b_w, set_select_w, memToReg_w, pc_dec_w;
    reg [3:0] ALUOp_w;



    localparam HALT  = 6'b00_0000;
    localparam NOP   = 6'b00_0001;

    localparam IMM_ARITH  = 6'b00_100x;
    localparam IMM_LOGIC  = 6'b00_101x;
    localparam IMM_SHIFT  = 6'b01_01xx;
    localparam ST    = 6'b01_0000;
    localparam LD    = 6'b01_0001;
    localparam STU   = 6'b01_0011;

    localparam BTR   = 6'b01_1001;
    localparam ALU   = 6'b01_101x;
    localparam SEQ   = 6'b01_1100;
    localparam SLT   = 6'b01_1101;
    localparam SLE   = 6'b01_1110;
    localparam SCO   = 6'b01_1111;

    localparam BEQZ  = 6'b00_1100;
    localparam BNEZ  = 6'b00_1101;
    localparam BLTZ  = 6'b00_1110;
    localparam BGEZ  = 6'b00_1111;
    localparam LBI   = 6'b01_1000;
    localparam SLBI  = 6'b01_0010;
    
    localparam J     = 6'b00_0100;
    localparam JR    = 6'b00_0101;
    localparam JAL   = 6'b00_0110;
    localparam JALR  = 6'b00_0111;
    
    localparam SIIC  = 6'b00_0010;
    localparam RTI   = 6'b00_0011;

    assign regDst = regDst_w;               //2
    assign regWrite = regWrite_w;           //1
    assign sign_extd = sign_extd_w;         //2
    assign ALUSrc_a = ALUSrc_a_w;           //2
    assign ALUSrc_b = ALUSrc_b_w;           //2
    assign sign_alu = sign_alu_w;           //1
    assign ALUOp = ALUOp_w;                 //4
    assign set_select = set_select_w;       //2
    assign alu_res_sel = alu_res_sel_w;     //1
    assign memToReg = memToReg_w;           //2
    assign pc_dec = pc_dec_w;               //2
    assign branch = branch_w;               //1
    assign branch_eqz = branch_eqz_w;     //1
    assign branch_gtz = branch_gtz_w;     //1
    assign branch_ltz = branch_ltz_w;     //1
    assign memEn = memEn_w;             //1
    assign memWrite = memWrite_w;           //1

    always@(*)begin


        regDst_w = 2'b00;           //write_reg_dst
        regWrite_w = 1'b0;
        sign_extd_w = 2'b00;        //sign_extd
        ALUSrc_a_w = 2'b00;         //ALUSrc_a
        ALUSrc_b_w = 2'b0;          //ALUSrc_b
        sign_alu_w = 1'b0;
        ALUOp_w  = 4'h0;
        set_select_w = 2'b00;
        alu_res_sel_w = 1'b0;       //alu_res_sel
        memToReg_w = 2'b01;
        pc_dec_w = 2'b00;           // branch == 2'b01 | jump == 2'b10 | jumpR == 2'b11
        branch_w = 1'b0;
        branch_eqz_w = 1'b0;
        branch_gtz_w = 1'b0;
        branch_ltz_w = 1'b0;
        memEn_w = 1'b0;
        memWrite_w = 1'b0;
        halt = 1'b0;
        createdump = 1'b0;
        err = 1'b0;

        casex({rst, instr})
            6'b1xxxxx : begin
                regDst_w = 2'b00;           //write_reg_dst
                regWrite_w = 1'b0;
                sign_extd_w = 2'b00;        //sign_extd
                ALUSrc_a_w = 2'b00;         //ALUSrc_a
                ALUSrc_b_w = 2'b0;          //ALUSrc_b
                sign_alu_w = 1'b0;
                ALUOp_w  = 4'h0;
                set_select_w = 2'b00;
                alu_res_sel_w = 1'b0;       //alu_res_sel
                memToReg_w = 2'b11;
                pc_dec_w = 2'b00;           // branch == 2'b01 | jump == 2'b10 | jumpR == 2'b11
                branch_w = 1'b0;
                branch_eqz_w = 1'b0;
                branch_gtz_w = 1'b0;
                branch_ltz_w = 1'b0;
                memEn_w = 1'b0;
                memWrite_w = 1'b0;
                halt = 1'b0;
                createdump = 1'b0;
                err = 1'b0;
            end

            HALT: begin
                createdump = 1'b1;
                halt = 1'b1;
            end

            NOP: begin
            end

            IMM_ARITH: begin
                regDst_w = 2'b11;
                regWrite_w = 1'b1;
                ALUSrc_b_w = 2'b01;
                sign_alu_w = 1'b1;
                ALUOp_w = {2'b11,instr[1:0]};
            end

            IMM_LOGIC: begin
                regDst_w = 2'b11;
                regWrite_w = 1'b1;
                sign_extd_w = 2'b10;
                ALUSrc_b_w = 2'b01;
                sign_alu_w = 1'b1;
                ALUOp_w = {2'b11,instr[1:0]};
            end

            IMM_SHIFT: begin
                regDst_w = 2'b11;
                regWrite_w = 1'b1;
                ALUSrc_b_w = 2'b01;
                ALUOp_w = {2'b10, instr[1:0]};
            end

            ST: begin
                ALUSrc_b_w = 2'b01;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1100;
                memEn_w = 1'b1;
                memWrite_w = 1'b1;
            end

            LD: begin
                regDst_w = 2'b11;
                regWrite_w = 1'b1;
                ALUSrc_b_w = 2'b01;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1100;
                memToReg_w = 2'b00;
                memEn_w = 1'b1;
            end

            STU: begin
                regDst_w = 2'b00;
                regWrite_w = 1'b1;
                ALUSrc_b_w = 2'b01;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1100;
                memEn_w = 1'b1;
                memWrite_w = 1'b1;
            end

            BTR: begin
                regDst_w = 2'b01;
                regWrite_w = 1'b1;
                ALUSrc_a_w = 2'b10;
                ALUSrc_b_w = 2'b10;
                ALUOp_w = 4'b1001;
                memToReg_w = 2'b01;
            end

            ALU: begin
                regDst_w = 2'b01;
                regWrite_w = 1'b1;
                ALUOp_w = {1'b0, instr[0], 2'b00};
            end

            SEQ: begin
                regDst_w = 2'b01;
                regWrite_w = 1'b1;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1101;
                set_select_w = instr[1:0];
                alu_res_sel_w = 1'b1;
            end

            SLT: begin
                regDst_w = 2'b01;
                regWrite_w = 1'b1;
                //ALUSrc_a_w = 2'b11;
                //ALUSrc_b_w = 2'b11;
                sign_alu_w = 1'b0;
                ALUOp_w = 4'b1101;
                set_select_w = instr[1:0];
                alu_res_sel_w = 1'b1;
            end

            SLE: begin
                regDst_w = 2'b01;
                regWrite_w = 1'b1;
                //ALUSrc_a_w = 2'b11;
                //ALUSrc_b_w = 2'b11;
                sign_alu_w = 1'b0;
                ALUOp_w = 4'b1101;
                set_select_w = instr[1:0];
                alu_res_sel_w = 1'b1;
            end

            SCO: begin
                regDst_w = 2'b01;
                regWrite_w = 1'b1;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1100;
                set_select_w = instr[1:0];
                alu_res_sel_w = 1'b1;
            end

            BEQZ: begin
                sign_extd_w = 2'b01;
                ALUSrc_b_w = 2'b10;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1100;
                pc_dec_w = 2'b01;
                branch_w = 1'b1;
                branch_eqz_w = 1'b1;
            end

            BNEZ: begin
                sign_extd_w = 2'b01;
                ALUSrc_b_w = 2'b10;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1100;
                pc_dec_w = 2'b01;
                branch_w = 1'b1;
                branch_gtz_w = 1'b1;
                branch_ltz_w = 1'b1;
            end

            BLTZ: begin
                sign_extd_w = 2'b01;
                ALUSrc_b_w = 2'b10;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1100;
                pc_dec_w = 2'b01;
                branch_w = 1'b1;
                branch_ltz_w = 1'b1;
            end

            BGEZ: begin
                sign_extd_w = 2'b01;
                ALUSrc_b_w = 2'b10;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1100;
                pc_dec_w = 2'b01;
                branch_w = 1'b1;
                branch_eqz_w = 1'b1;
                branch_gtz_w = 1'b1;
            end

            LBI: begin
                regWrite_w = 1'b1;
                sign_extd_w = 2'b01;
                ALUSrc_b_w = 2'b01;
                sign_alu_w = 1'b1;
                memToReg_w = 2'b11;
            end

            SLBI: begin
                regWrite_w = 1'b1;
                sign_extd_w = 2'b01;
                ALUSrc_a_w = 2'b01;
                ALUSrc_b_w = 2'b10;
                ALUOp_w = 4'b1001;
                memToReg_w = 2'b01;
            end

            J: begin
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1100;
                pc_dec_w = 2'b10;
            end

            JR: begin
                sign_extd_w = 2'b01;
                ALUSrc_b_w = 2'b01;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1100;
                pc_dec_w = 2'b11;
            end

            JAL: begin regDst_w = 2'b10;
                regWrite_w = 1'b1;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1100;
                memToReg_w = 2'b10;
                pc_dec_w = 2'b10;
            end

            JALR: begin
                regDst_w = 2'b10;
                regWrite_w = 1'b1;
                sign_extd_w = 2'b01;
                ALUSrc_b_w = 2'b01;
                sign_alu_w = 1'b1;
                ALUOp_w = 4'b1100;
                memToReg_w = 2'b10;
                pc_dec_w = 2'b11;
            end

            SIIC: begin
            end

            RTI: begin
            end

            default : err = 1'b1;

    endcase


end 

endmodule 
