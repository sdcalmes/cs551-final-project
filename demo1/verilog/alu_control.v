module alu_control(cmd, alu_op, lowerBits);

    input [3:0] cmd;
    input [1:0] lowerBits;
    output [2:0] alu_op;

    reg [2:0] alu_op_w;

    assign alu_op = alu_op_w;
    
    always @(*) begin
        casex(cmd)
            4'b00xx : alu_op_w = {1'b0, lowerBits};
            4'b01xx : alu_op_w = {1'b1, lowerBits};
            4'b1xxx : alu_op_w = cmd[2:0];
        endcase
    end
endmodule
