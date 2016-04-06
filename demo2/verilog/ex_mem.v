module ex_mem(ex_memEn, ex_memWrite, ex_regWrite, ex_memToReg, ex_createdump,
    ex_write_reg, ex_alu_out, ex_pc_plus, ex_reg2_data, ex_sign_ext_low_bits,
    ex_halt,
    mem_memEn, mem_memWrite, mem_regWrite, mem_memToReg, mem_createdump,
    mem_write_reg, mem_alu_out, mem_pc_plus, mem_reg2_data,
    mem_sign_ext_low_bits, mem_halt, clk, rst);
    
    input ex_memEn, ex_memWrite, ex_regWrite, ex_createdump, ex_halt, clk, rst;
    input [1:0] ex_memToReg;
    input [2:0] ex_write_reg;
    input [15:0] ex_alu_out, ex_pc_plus, ex_reg2_data, ex_sign_ext_low_bits;

    output mem_memEn, mem_memWrite, mem_regWrite, mem_createdump, mem_halt;
    output [1:0] mem_memToReg;
    output [2:0] mem_write_reg;
    output [15:0] mem_alu_out, mem_pc_plus, mem_reg2_data, mem_sign_ext_low_bits;

    /* wires for normal testing
    assign mem_memEn = ex_memEn;
    assign mem_memWrite = ex_memWrite;
    assign mem_regWrite = ex_regWrite;
    assign mem_memToReg = ex_memToReg;
    assign mem_createdump = ex_createdump;
    assign mem_write_reg = ex_write_reg;
    assign mem_alu_out = ex_alu_out;
    assign mem_pc_plus = ex_pc_plus;
    assign mem_reg2_data = ex_reg2_data;
    assign mem_sign_ext_low_bits = ex_sign_ext_low_bits;

*/
    dff memEn_flop(
        .d(ex_memEn),   //input
        .q(mem_memEn),   //output
        .clk(clk),
        .rst(rst)
    );
    dff memWrite_flop(
        .d(ex_memWrite),   //input
        .q(mem_memWrite),   //output
        .clk(clk),
        .rst(rst)
    );
    dff regWrite_flop(
        .d(ex_regWrite),   //input
        .q(mem_regWrite),   //output
        .clk(clk),
        .rst(rst)
    );
    dff createdump_flop(
        .d(ex_createdump),   //input
        .q(mem_createdump),   //output
        .clk(clk),
        .rst(rst)
    );
    dff halt_flop(
        .d(ex_halt),
        .q(mem_halt),
        .clk(clk),
        .rst(rst)
    );
    dff memToReg_flop[1:0](
        .d(ex_memToReg),   //input
        .q(mem_memToReg),   //output
        .clk(clk),
        .rst(rst)
    );
    dff write_reg_flop[2:0](
        .d(ex_write_reg),
        .q(mem_write_reg),
        .clk(clk),
        .rst(rst)
    );
    dff alu_out_flop[15:0](
        .d(ex_alu_out),   //input
        .q(mem_alu_out),   //output
        .clk(clk),
        .rst(rst)
    );
    dff pc_plus_flop[15:0](
        .d(ex_pc_plus),   //input
        .q(mem_pc_plus),   //output
        .clk(clk),
        .rst(rst)
    );
    dff reg2_data_flop[15:0](
        .d(ex_reg2_data),   //input
        .q(mem_reg2_data),   //output
        .clk(clk),
        .rst(rst)
    );
    dff sign_ext_low_bits_flop[15:0](
        .d(ex_sign_ext_low_bits),   //input
        .q(mem_sign_ext_low_bits),   //output
        .clk(clk),
        .rst(rst)
    );
endmodule
