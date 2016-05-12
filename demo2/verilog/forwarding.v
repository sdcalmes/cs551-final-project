module forwarding(mem_regWrite, mem_memToReg, wb_regWrite, ex_rs_valid, ex_rt_valid, 
    id_rs, id_rt, em_rd, mw_rd, mem_alu_out, mem_sign_ext_low_bits, wb_mem_write_back, 
    ex_reg1_data, ex_reg2_data, reg1_forward, reg2_forward);
    input mem_regWrite, wb_regWrite, ex_rs_valid, ex_rt_valid;
    input [1:0] mem_memToReg;
    input [2:0] id_rs, id_rt, em_rd, mw_rd;
    input [15:0] mem_alu_out, mem_sign_ext_low_bits, wb_mem_write_back, 
        ex_reg1_data, ex_reg2_data;
    	
    output [15:0] reg1_forward, reg2_forward;

    reg [15:0] reg1_forward_w, reg2_forward_w;

    wire forward_rs_exmem, forward_rt_exmem, forward_rs_memwb, forward_rt_memwb;

    assign forward_rs_exmem = (id_rs==em_rd) & mem_regWrite & ex_rs_valid;
    assign forward_rt_exmem = (id_rt==em_rd) & mem_regWrite & ex_rt_valid;
    assign forward_rs_memwb = (id_rs==mw_rd) & wb_regWrite & ex_rs_valid;
    assign forward_rt_memwb = (id_rt==mw_rd) & wb_regWrite & ex_rt_valid;

    assign reg1_forward = reg1_forward_w;
    assign reg2_forward = reg2_forward_w;

    always @(*) begin
        case({forward_rs_exmem, forward_rs_memwb})
	    2'b00 : reg1_forward_w = ex_reg1_data; 
        2'b01 : reg1_forward_w = wb_mem_write_back;
	    2'b10 : reg1_forward_w = mem_memToReg[1] ? mem_sign_ext_low_bits : mem_alu_out;
	    2'b11 : reg1_forward_w = mem_memToReg[1] ? mem_sign_ext_low_bits : mem_alu_out;
        endcase
    end

    always @(*) begin
        case({forward_rt_exmem, forward_rt_memwb})
	    2'b00 : reg2_forward_w = ex_reg2_data; 
        2'b01 : reg2_forward_w = wb_mem_write_back;
	    2'b10 : reg2_forward_w = mem_memToReg[1] ? mem_sign_ext_low_bits : mem_alu_out;
	    2'b11 : reg2_forward_w = mem_memToReg[1] ? mem_sign_ext_low_bits : mem_alu_out;
        endcase
    end
endmodule
