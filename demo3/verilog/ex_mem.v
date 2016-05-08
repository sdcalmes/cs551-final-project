module ex_mem(ex_memEn, ex_memWrite, ex_regWrite, ex_memToReg, ex_createdump,
    ex_write_reg, ex_alu_out, ex_pc_plus, ex_reg2_data, ex_sign_ext_low_bits,
    ex_halt,
    mem_memEn, mem_memWrite, mem_regWrite, mem_memToReg, mem_createdump,
    mem_write_reg, mem_alu_out, mem_pc_plus, mem_reg2_data,
    mem_sign_ext_low_bits, mem_halt, clk, rst, flop_stall);
    
    input ex_memEn, ex_memWrite, ex_regWrite, ex_createdump, ex_halt, clk, rst, flop_stall;
    input [1:0] ex_memToReg;
    input [2:0] ex_write_reg;
    input [15:0] ex_alu_out, ex_pc_plus, ex_reg2_data, ex_sign_ext_low_bits;

    output mem_memEn, mem_memWrite, mem_regWrite, mem_createdump, mem_halt;
    output [1:0] mem_memToReg;
    output [2:0] mem_write_reg;
    output [15:0] mem_alu_out, mem_pc_plus, mem_reg2_data, mem_sign_ext_low_bits;

    reg_1 memEn_flop(
        .WriteData(ex_memEn),   //input
        .ReadData(mem_memEn),   //output
        .WriteSel(flop_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 memWrite_flop(
        .WriteData(ex_memWrite),   //input
        .ReadData(mem_memWrite),   //output
        .WriteSel(flop_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 regWrite_flop(
        .WriteData(ex_regWrite),   //input
        .ReadData(mem_regWrite),   //output
        .WriteSel(flop_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 createdump_flop(
        .WriteData(ex_createdump),   //input
        .ReadData(mem_createdump),   //output
        .WriteSel(flop_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 halt_flop(
        .WriteData(ex_halt),
        .ReadData(mem_halt),
        .WriteSel(flop_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 memToReg_flop[1:0](
        .WriteData(ex_memToReg),   //input
        .ReadData(mem_memToReg),   //output
        .WriteSel(flop_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 write_reg_flop[2:0](
        .WriteData(ex_write_reg),
        .ReadData(mem_write_reg),
        .WriteSel(flop_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 alu_out_flop[15:0](
        .WriteData(ex_alu_out),   //input
        .ReadData(mem_alu_out),   //output
        .WriteSel(flop_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 pc_plus_flop[15:0](
        .WriteData(ex_pc_plus),   //input
        .ReadData(mem_pc_plus),   //output
        .WriteSel(flop_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 reg2_data_flop[15:0](
        .WriteData(ex_reg2_data),   //input
        .ReadData(mem_reg2_data),   //output
        .WriteSel(flop_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 sign_ext_low_bits_flop[15:0](
        .WriteData(ex_sign_ext_low_bits),   //input
        .ReadData(mem_sign_ext_low_bits),   //output
        .WriteSel(flop_stall),
        .clk(clk),
        .rst(rst)
    );
endmodule
