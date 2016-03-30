module alu_control(cmd, alu_op, lowerBits, invB, invA, Cin);

    input [3:0] cmd;
    input [1:0] lowerBits;
    output [2:0] alu_op;
    output invB, Cin, invA;

    reg [2:0] alu_op_w;
    reg invB_w, Cin_w, invA_w;

    assign alu_op = alu_op_w;
    assign invB = invB_w;
    assign Cin = Cin_w;
    assign invA = invA_w;
    
    always @(*) begin
	    alu_op_w = 3'b0;
        casex(cmd)
            4'b00xx : alu_op_w = {1'b0, lowerBits};     // op for rotate
	    4'b01xx : alu_op_w = {1'b1, lowerBits};	//op for arith
            4'b1xxx : alu_op_w = cmd[2:0];              // op for immediate value
        endcase
    end

    always @(*)begin
	    invB_w = 1'b0;
	    invA_w = 1'b0;
	    Cin_w = 1'b0;
	    casex(alu_op)
		    3'b101 : begin
			    invA_w = 1'b1;
			    Cin_w = 1'b1;
		    end
		    3'b111 : invB_w = 1'b1;

		    default : begin
			    invA_w = 1'b0;
			    invB_w = 1'b0;
			    Cin_w = 1'b0;
		    end
	    endcase
    end

endmodule
