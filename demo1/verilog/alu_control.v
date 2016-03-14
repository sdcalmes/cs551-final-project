module alu_control(cmd, alu_op, lowerBits);

    input cmd;
    input [1:0] lowerBits;
    output [2:0] alu_op;

    assign alu_op = {cmd, lowerBits};

endmodule
