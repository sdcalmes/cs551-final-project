module memory(reg2_data, alu_out, pc_plus, branch_address, jump_address, memRead, memWrite, createdump,
		clk, rst, pc_dec, pc_decision, read_data);

    input [15:0] reg2_data, alu_out, pc_plus, branch_address, jump_address;
    input memRead, memWrite, createdump, clk, rst;
    input [1:0] pc_dec;
    output [15:0] read_data, pc_decision;

    reg [15:0] pc_decision_w;


    memory2c	data_mem(.data_in(reg2_data), .data_out(read_data), .addr(alu_out), .enable(memRead),
			.wr(memWrite), .createdump(createdump), .clk(clk), .rst(rst));

    always @(*) begin
        pc_decision_w = 16'h0000;
        case(pc_dec)
            2'b00 : pc_decision_w = pc_plus;
            2'b01 : pc_decision_w = branch_address;
            2'b10 : pc_decision_w = jump_address;
            2'b11 : pc_decision_w = alu_out;
        endcase
    end
    assign pc_decision = pc_decision_w;


endmodule
