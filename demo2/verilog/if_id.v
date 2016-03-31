module if_id(if_pc_plus, if_instruction, id_pc_plus, id_instruction, clk, rst);

    input [15:0] if_pc_plus, if_instruction;
    output [15:0] id_pc_plus, id_instruction;

    dff inst_flop[15:0] (
        .d(if_instruction), // input
        .q(if_instruction), // output
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
