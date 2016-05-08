module mem_wb(mem_regWrite, mem_memToReg, mem_write_reg, mem_alu_out, mem_pc_plus,
    mem_read_data, mem_sign_ext_low_bits, mem_halt, wb_regWrite, wb_memToReg, wb_write_reg,
    wb_alu_out, wb_pc_plus, wb_read_data, wb_sign_ext_low_bits, wb_halt, clk, rst, wr_stall);

    input mem_regWrite, mem_halt, clk, rst, wr_stall;
    input [1:0] mem_memToReg;
    input [2:0] mem_write_reg;
    input [15:0] mem_alu_out, mem_pc_plus, mem_read_data, mem_sign_ext_low_bits;

    output wb_regWrite, wb_halt;
    output [1:0] wb_memToReg;
    output [2:0] wb_write_reg;
    output [15:0] wb_alu_out, wb_pc_plus, wb_read_data, wb_sign_ext_low_bits;

    /* wires for testing
    assign wb_regWrite = mem_regWrite;
    assign wb_memToReg = mem_memToReg;
    assign wb_write_reg = mem_write_reg;
    assign wb_alu_out = mem_alu_out;
    assign wb_pc_plus = mem_pc_plus;
    assign wb_read_data = mem_read_data;
    assign wb_sign_ext_low_bits = mem_sign_ext_low_bits;
*/
    reg_1 regWrite_flop (
        .WriteData(mem_regWrite),
        .ReadData(wb_regWrite),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 halt_flop(
        .WriteData(mem_halt),
        .ReadData(wb_halt),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 memToReg_flop[1:0](
        .WriteData(mem_memToReg),       //input
        .ReadData(wb_memToReg),       //output
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 write_reg_flop[2:0](
        .WriteData(mem_write_reg),
        .ReadData(wb_write_reg),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 alu_out_flop[15:0](
        .WriteData(mem_alu_out),       //input
        .ReadData(wb_alu_out),       //output
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 pc_plus_flop[15:0](
        .WriteData(mem_pc_plus),       //input
        .ReadData(wb_pc_plus),       //output
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 read_data_flop[15:0](
        .WriteData(mem_read_data),       //input
        .ReadData(wb_read_data),       //output
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    reg_1 sign_ext_low_bits_flop[15:0](
        .WriteData(mem_sign_ext_low_bits),       //input
        .ReadData(wb_sign_ext_low_bits),       //output
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );

endmodule
