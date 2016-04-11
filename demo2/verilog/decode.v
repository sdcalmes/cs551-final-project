module decode(wb_regWrite, wb_write_reg, instruction, mem_write_back, alu_res_sel,
        branch, branch_eqz, branch_gtz, branch_ltz, Cin, invA, invB, id_memEn,
        memWrite, id_regWrite, sign_alu, ALUSrc_a, ALUSrc_b, memToReg, pc_dec,
        set_select, alu_op, id_write_reg, reg1_data, reg2_data, sign_ext_low_bits,
        control_err, createdump, halt, clk, rst);

      input wb_regWrite, clk, rst;
      input [2:0] wb_write_reg;
      input [15:0] instruction, mem_write_back;

      output alu_res_sel, branch, branch_eqz, branch_gtz, branch_ltz, Cin, invA,
            invB, id_memEn, memWrite, id_regWrite, sign_alu, control_err, halt,
            createdump;
      output [1:0] ALUSrc_a, ALUSrc_b, memToReg, pc_dec, set_select;
      output [2:0] alu_op, id_write_reg;
      output [15:0] reg1_data, reg2_data, sign_ext_low_bits;

      // state machine logic
      reg regWrite_w, memEn_w;
      wire regWrite, regWrite_1, regWrite_2, regWrite_3;
      wire memEn, memEn_1, memEn_2, memEn_3;
      reg [1:0] regWrite_nxtState, memEn_nxtState;
      wire [1:0] regWrite_state, memEn_state;

      reg [2:0] write_reg_w;
      reg [15:0] sign_ext_low_bits_w;
      reg i_type_err_w;
      wire i_type_err;
      wire [1:0] regDst;

      wire [3:0] ALUOp;
      wire [1:0] sign_extd;
      

    rf_bypass   register(.read1regsel(instruction[10:8]),
                .read2regsel(instruction[7:5]), .writeregsel(wb_write_reg),
                .writedata(mem_write_back), .write(wb_regWrite), 
                .read1data(reg1_data), .read2data(reg2_data), .clk(clk),
                .rst(rst), .err());

    control     control(.instr(instruction[15:11]), .regDst(regDst),
                .regWrite(regWrite), .sign_extd(sign_extd),
                .ALUSrc_a(ALUSrc_a), .ALUSrc_b(ALUSrc_b), .ALUOp(ALUOp),
                .sign_alu(sign_alu), .set_select(set_select),
                .alu_res_sel(alu_res_sel), .memToReg(memToReg), .pc_dec(pc_dec),
                .branch(branch), .branch_eqz(branch_eqz), .branch_gtz(branch_gtz),
                .branch_ltz(branch_ltz), .memEn(memEn), .memWrite(memWrite),
                .err(control_err), .halt(halt), .createdump(createdump),
                .rst(rst));
    
    alu_control alu_cntl(.cmd(ALUOp), .alu_op(alu_op),
                .lowerBits(instruction[1:0]), .invB(invB), .invA(invA), .Cin(Cin));

    //assign alu_res_sel = flush ? 1'b0 : alu_res_sel_w;

    /* State Machine for regWrite */
    dff regWrite_state_flop[1:0] (
        .d(regWrite_nxtState),
        .q(regWrite_state),
        .clk(clk),
        .rst(rst)
    );

    dff regWrite1_flop (
        .d(regWrite_w ),
        .q(regWrite_1),
        .clk(clk),
        .rst(rst)
    );
    dff regWrite2_flop (
        .d(regWrite_1),
        .q(regWrite_2),
        .clk(clk),
        .rst(rst)
    );

    assign id_regWrite = regWrite_w;

    always @(*) begin
        regWrite_w = 1'b0;
        regWrite_nxtState = 2'b00;
        case(regWrite_state)
            2'b00 : begin
                regWrite_w = regWrite;
                regWrite_nxtState = (regWrite & ~regWrite_1 & ~regWrite_2) ? 2'b01 : 2'b00;
            end
            2'b01 : begin
                regWrite_nxtState = (regWrite & regWrite_1 & ~regWrite_2) ? 2'b10 : 2'b00;
                regWrite_w = (regWrite & regWrite_1 & ~regWrite_2) ? 1'b0 : regWrite;
            end
            2'b10 : begin
                regWrite_w = (regWrite & ~regWrite_1 & regWrite_2) ? 1'b0 : regWrite;
            end
            default : begin
            end
        endcase
    end

    /* State Machine for memEn */
    dff memEn_state_flop[1:0] (
        .d(memEn_nxtState),
        .q(memEn_state),
        .clk(clk),
        .rst(rst)
    );

    dff memEn1_flop (
        .d(memEn_w ),
        .q(memEn_1),
        .clk(clk),
        .rst(rst)
    );
    dff memEn2_flop (
        .d(memEn_1),
        .q(memEn_2),
        .clk(clk),
        .rst(rst)
    );

    assign id_memEn = memEn_w;

    always @(*) begin
        memEn_w = 1'b0;
        memEn_nxtState = 2'b00;
        case(memEn_state)
            2'b00 : begin
                memEn_w = memEn;
                memEn_nxtState = (memEn & ~memEn_1 & ~memEn_2) ? 2'b01 : 2'b00;
            end
            2'b01 : begin
                memEn_nxtState = (memEn & memEn_1 & ~memEn_2) ? 2'b10 : 2'b00;
                memEn_w = (memEn & memEn_1 & ~memEn_2) ? 1'b0 : memEn;
            end
            2'b10 : begin
                memEn_w = (memEn & ~memEn_1 & memEn_2) ? 1'b0 : memEn;
            end
            default : begin
            end
        endcase
    end
    
    always@(*) begin
	sign_ext_low_bits_w = 16'h0000;
    i_type_err_w = 1'b0;
        case(sign_extd)
            2'b00 : sign_ext_low_bits_w = { {11{instruction[4]}}, instruction[4:0]};
            2'b01 : sign_ext_low_bits_w = { {8{instruction[7]}}, instruction[7:0]};
            2'b10 : sign_ext_low_bits_w = { 11'b0, instruction[4:0] };
            default : i_type_err_w = 1'b1;
        endcase
    end
    assign sign_ext_low_bits = sign_ext_low_bits_w;
    assign i_type_err = i_type_err_w;

    always @(*) begin
        write_reg_w = 3'b000;
        case(regDst)
            2'b00 : write_reg_w = instruction[10:8];
            2'b01 : write_reg_w = instruction[4:2];
            2'b10 : write_reg_w = 3'b111;
            2'b11 : write_reg_w = instruction[7:5];
        endcase
    end
    assign id_write_reg = write_reg_w;

endmodule
