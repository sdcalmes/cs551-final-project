module shift1(in, sh, op, out);
    input [15:0] in;
    input [1:0] op;
    input sh;
    output [15:0] out;
    reg [15:0] outreg;

    assign out = outreg;

    always @(*) begin
        case(op)
            2'b00 : outreg = sh ? {in[14:0], in[15]} : in;
            2'b01 : outreg = sh ? {in[14:0], 1'b0}   : in;
            2'b10 : outreg = sh ? {in[15], in[15:1]} : in;
            2'b11 : outreg = sh ? {1'b0, in[15:1]}   : in;
        endcase
    end
    
endmodule

