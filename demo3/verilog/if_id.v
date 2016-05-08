module if_id(if_valid, if_pc_plus, if_instruction, id_valid, 
        id_pc_plus, id_instruction, clk, rst,wr_stall);

    input if_valid, clk, rst, wr_stall;
    output id_valid;
    input [15:0] if_pc_plus, if_instruction;
    output [15:0] id_pc_plus, id_instruction;

    //assign id_pc_plus = if_pc_plus;
    //assign id_instruction = if_instruction;

    reg_1 valid_flop (
        .WriteData(if_valid),
        .ReadData(id_valid),
	.WriteSel(wr_stall),
        .clk(clk),
        .rst(rst)
    );
    
    reg_1 inst_flop[15:0] (
        .WriteData(if_instruction), // input
        .ReadData(id_instruction), // output
	.WriteSel(wr_stall),
        .clk(clk),          // Clock signal
        .rst(rst)           // reset signal
    );
    
    reg_1 pc_plus_flop[15:0] (
        .WriteData(if_pc_plus),  // input
        .ReadData(id_pc_plus),  // output
	.WriteSel(wr_stall),
        .clk(clk),       // Clock signal
        .rst(rst)        // reset signal
    );
endmodule
