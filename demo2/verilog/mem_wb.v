module mem_wb(mem_regWrite, mem_memToReg, mem_write_reg, mem_alu_out, mem_pc_plus,
    mem_read_data, mem_sign_ext_low_bits, mem_halt, wb_regWrite, wb_memToReg, wb_write_reg,
    wb_alu_out, wb_pc_plus, wb_read_data, wb_sign_ext_low_bits, wb_halt, clk, rst, stall, flush);

    input mem_regWrite, mem_halt, clk, rst, stall, flush;
    input [1:0] mem_memToReg;
    input [2:0] mem_write_reg;
    input [15:0] mem_alu_out, mem_pc_plus, mem_read_data, mem_sign_ext_low_bits;

    output wb_regWrite, wb_halt;
    output [1:0] wb_memToReg;
    output [2:0] wb_write_reg;
    output [15:0] wb_alu_out, wb_pc_plus, wb_read_data, wb_sign_ext_low_bits;

    reg_1 regWrite_flop (
        .WriteData(mem_regWrite),
        .stall(stall),
        .flush(flush),
        .ReadData(wb_regWrite),
        .clk(clk),
        .rst(rst)
    );
    reg_1 halt_flop(
        .WriteData(mem_halt),
        .stall(stall),
        .flush(flush),
        .ReadData(wb_halt),
        .clk(clk),
        .rst(rst)
    );
    reg_1 memToReg_flop[1:0](
        .WriteData(mem_memToReg),       //input
        .stall(stall),
        .flush(flush),
        .ReadData(wb_memToReg),       //output
        .clk(clk),
        .rst(rst)
    );
    reg_1 write_reg_flop[2:0](
        .WriteData(mem_write_reg),
        .stall(stall),
        .flush(flush),
        .ReadData(wb_write_reg),
        .clk(clk),
        .rst(rst)
    );
    reg_1 alu_out_flop[15:0](
        .WriteData(mem_alu_out),       //input
        .stall(stall),
        .flush(flush),
        .ReadData(wb_alu_out),       //output
        .clk(clk),
        .rst(rst)
    );
    reg_1 pc_plus_flop[15:0](
        .WriteData(mem_pc_plus),       //input
        .stall(stall),
        .flush(flush),
        .ReadData(wb_pc_plus),       //output
        .clk(clk),
        .rst(rst)
    );
    reg_1 read_data_flop[15:0](
        .WriteData(mem_read_data),       //input
        .stall(stall),
        .flush(flush),
        .ReadData(wb_read_data),       //output
        .clk(clk),
        .rst(rst)
    );
    reg_1 sign_ext_low_bits_flop[15:0](
        .WriteData(mem_sign_ext_low_bits),       //input
        .stall(stall),
        .flush(flush),
        .ReadData(wb_sign_ext_low_bits),       //output
        .clk(clk),
        .rst(rst)
    );

endmodule
