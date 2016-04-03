module mem_wb(mem_regWrite, mem_memToReg, mem_write_reg, mem_alu_out, mem_pc_plus, mem_read_data,
    mem_sign_ext_low_bits, wb_regWrite, wb_memToReg, wb_write_reg, wb_alu_out, wb_pc_plus, wb_read_data,
    wb_sign_ext_low_bits);

    input mem_regWrite;
    input [1:0] mem_memToReg;
    input [2:0] mem_write_reg;
    input [15:0] mem_alu_out, mem_pc_plus, mem_read_data, mem_sign_ext_low_bits;

    output wb_regWrite;
    output [1:0] wb_memToReg;
    output [2:0] wb_write_reg;
    output [15:0] wb_alu_out, wb_pc_plus, wb_read_data, wb_sign_ext_low_bits;

    assign wb_regWrite = mem_regWrite;
    assign wb_memToReg = mem_memToReg;
    assign wb_write_reg = mem_write_reg;
    assign wb_alu_out = mem_alu_out;
    assign wb_pc_plus = mem_pc_plus;
    assign wb_read_data = mem_read_data;
    assign wb_sign_ext_low_bits = mem_sign_ext_low_bits;
/*
    dff memToReg_flop[1:0](
        .d(mem_memToReg),       //input
        .q(wb_memToReg),       //output
        .clk(clk),
        .rst(rst)
    );
    dff alu_out_flop[15:0](
        .d(mem_alu_out),       //input
        .q(wb_alu_out),       //output
        .clk(clk),
        .rst(rst)
    );
    dff pc_plus_flop[15:0](
        .d(mem_pc_plus),       //input
        .q(wb_pc_plus),       //output
        .clk(clk),
        .rst(rst)
    );
    dff read_data_flop[15:0](
        .d(mem_read_data),       //input
        .q(wb_read_data),       //output
        .clk(clk),
        .rst(rst)
    );
    dff sign_ext_low_bits_flop[15:0](
        .d(mem_sign_ext_low_bits),       //input
        .q(wb_sign_ext_low_bits),       //output
        .clk(clk),
        .rst(rst)
    );
*/
endmodule
