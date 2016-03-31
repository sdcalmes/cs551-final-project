module write_back(read_data, pc_plus, sign_ext_low_bits, alu_out, mem_write_back, memToReg);

   input [1:0] memToReg;
   input [15:0] read_data, pc_plus, sign_ext_low_bits, alu_out;
   output [15:0] mem_write_back;

   reg [15:0] mem_write_back_w;

   always @(*) begin
       mem_write_back_w = 16'h0000;
        case(memToReg)
            2'b00 : mem_write_back_w = read_data;           // read data from data memory
            2'b01 : mem_write_back_w = alu_out;        // data from alu
            2'b10 : mem_write_back_w = pc_plus;             // save (pc+2) to R7
            2'b11 : mem_write_back_w = sign_ext_low_bits;   // store immediate value to 
        endcase
    end
    assign mem_write_back = mem_write_back_w;

endmodule

