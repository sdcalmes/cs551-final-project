module if_id(if_valid, if_pc_plus, if_instruction, id_valid, 
        id_pc_plus, id_instruction, clk, rst);

    input if_valid, clk, rst;
    output id_valid;
    input [15:0] if_pc_plus, if_instruction;
    output [15:0] id_pc_plus, id_instruction;

    //assign id_pc_plus = if_pc_plus;
    //assign id_instruction = if_instruction;

    dff valid_flop (
        .d(if_valid),
        .q(id_valid),
        .clk(clk),
        .rst(rst)
    );
    
    dff inst_flop[15:0] (
        .d(if_instruction), // input
        .q(id_instruction), // output
        .clk(clk),          // Clock signal
        .rst(rst)           // reset signal
    );
    
    dff pc_plus_flop[15:0] (
        .d(if_pc_plus),  // input
        .q(id_pc_plus),  // output
        .clk(clk),       // Clock signal
        .rst(rst)        // reset signal
    );
endmodule
