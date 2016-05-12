module fetch(createdump, br_tkn, pc_decision, //icache_done, icache_stall, icache_hit, 
        instruction, pc_plus, valid, clk, rst, err);

    input clk, rst, createdump, br_tkn; 
    input [15:0] pc_decision;
   
    //output icache_done, icache_stall, icache_hit, 
    output err, valid;
    output [15:0] instruction, pc_plus;

    wire [15:0] PC, pc_deci;

    assign valid = rst ? 1'b0 : 1'b1;
    assign err = 1'b0;

    assign pc_deci = br_tkn ? pc_decision : pc_plus;

    reg_16	pc_reg(.WriteData(pc_decision), .WriteSel(1'b1), .ReadData(PC),
            .clk(clk), .rst(rst));

    memory2c inst_mem(.data_in(), .data_out(instruction), .addr(PC), 
            .enable(1'b1), .wr(1'b0), .createdump(createdump), .clk(clk),
            .rst(rst));

    /*stallmem icache(.DataOut(instruction), .Done(icache_done), .Stall(icache_stall), 
            .CacheHit(icache_hit), .DataIn(), .Addr(pc_decision), .Wr(1'b0), .Rd(1'b1),
            .createdump(createdump), .clk(clk), .rst(rst), .err(err));
            */

    pc_inc	pc_add(.A(PC), .Out(pc_plus));


endmodule

