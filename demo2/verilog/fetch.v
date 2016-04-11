module fetch(createdump, pc_decision, instruction, pc_plus, valid, clk, rst, err);

   input clk, rst, createdump;
   input [15:0] pc_decision;
   
   output err, valid;
   output [15:0] instruction, pc_plus;

   wire [15:0] PC;

   assign valid = rst ? 1'b0 : 1'b1;
   assign err = 1'b0;

   reg_16	pc_reg(.WriteData(pc_decision), .WriteSel(1'b1), .ReadData(PC),
            .clk(clk), .rst(rst));

   memory2c	inst_mem(.data_in(), .data_out(instruction), .addr(PC), 
            .enable(1'b1), .wr(1'b0), .createdump(createdump), .clk(clk),
            .rst(rst));

   pc_inc	pc_add(.A(PC), .Out(pc_plus));


endmodule

