module fetch(pc_decision, instruction, createdump, pc_plus, clk, rst, err);

   input clk;
   input rst;
   
   output err;

   input [15:0] pc_decision;
   output [15:0] instruction, pc_plus;
   input createdump;

   wire [15:0] PC;




   reg_16	pc_reg(.WriteData(pc_decision), .WriteSel(1'b1), .ReadData(PC), .clk(clk), .rst(rst));

   memory2c	inst_mem(.data_in(), .data_out(instruction), .addr(PC), .enable(1'b1), .wr(1'b0),
	   		.createdump(createdump), .clk(clk), .rst(rst));

   pc_inc	pc_add(.A(PC), .Out(pc_plus));


endmodule

