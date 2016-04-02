module decode(instruction, mem_write_back, alu_res_sel, branch, branch_eqz,
        branch_gtz, branch_ltz, Cin, invA, invB, memRead, memWrite, sign_alu,
        ALUSrc_a, ALUSrc_b, memToReg, pc_dec, set_select, alu_op, reg1_data,
        reg2_data, sign_ext_low_bits, control_err, createdump, halt, clk, rst);

      input clk, rst;
      input [15:0] instruction, mem_write_back;

      output alu_res_sel, branch, branch_eqz, branch_gtz, branch_ltz, Cin, invA,
            invB, memRead, memWrite, sign_alu, control_err, halt, createdump;
      output [1:0] ALUSrc_a, ALUSrc_b, memToReg, pc_dec, set_select;
      output [2:0] alu_op;
      output [15:0] reg1_data, reg2_data, sign_ext_low_bits;


      reg [2:0] write_reg_w;
      reg [15:0] sign_ext_low_bits_w;
      reg i_type_err_w;

      wire [2:0] write_reg;
      wire [3:0] ALUOp;
      reg write_data_err;
      wire [1:0] regDst, sign_extd;
      wire regWrite;
      

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



    always@(*) begin
	sign_ext_low_bits_w = 16'h0000;
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
            default : write_data_err = 1'b1;
        endcase
    end
    assign write_reg = write_reg_w;

endmodule
