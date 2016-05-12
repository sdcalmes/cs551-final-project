module if_id(if_valid, if_pc_plus, if_instruction, id_valid, 
        id_pc_plus, id_instruction, clk, rst, stall, flush);

    input if_valid, clk, rst, stall, flush;
    output id_valid;
    input [15:0] if_pc_plus, if_instruction;
    output [15:0] id_pc_plus, id_instruction;

    reg_1 valid_flop (
        .WriteData(if_valid),
        .ReadData(id_valid),
        .stall(stall),
        .flush(flush),
        .clk(clk),
        .rst(rst)
    );
    
    reg_1 inst_flop[15:0] (
        .WriteData(if_instruction), // input
        .ReadData(id_instruction), // output
        .stall(stall),
        .flush(flush),
        .clk(clk),          // Clock signal
        .rst(rst)           // reset signal
    );
    
    reg_1 pc_plus_flop[15:0] (
        .WriteData(if_pc_plus),  // input
        .ReadData(id_pc_plus),  // output
        .stall(stall),
        .flush(flush),
        .clk(clk),       // Clock signal
        .rst(rst)        // reset signal
    );
endmodule
