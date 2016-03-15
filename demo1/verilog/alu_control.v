module alu_control(cmd, alu_op, lowerBits, invB);

    input [3:0] cmd;
    input [1:0] lowerBits;
    output [2:0] alu_op;
    output invB;

    reg [2:0] alu_op_w;
    reg invB_w;

    assign alu_op = alu_op_w;
    assign invB = invB_w
    
    always @(*) begin
        casex(cmd)
            4'b00xx : alu_op_w = {1'b0, lowerBits};     // op for rotate
            4'b01xx : alu_op_w = {1'b1, lowerBits};     // op for arith
            4'b0101 : invB_w = 1'b1;
            4'b1xxx : alu_op_w = cmd[2:0];              // op for immediate value
            4'b1101 : invB_w = 1'b1;
        endcase
    end

    always @(*) begin

endmodule
