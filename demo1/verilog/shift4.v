module shift4(in, sh, op, out);
    input [15:0] in;
    input [1:0] op;
    input sh;
    output [15:0] out;
    reg [15:0] outreg;

    assign out = outreg;

    always @(*) begin
        case(op)
            2'b00 : outreg = sh ? {in[11:0], in[15:12]}  : in;
            2'b01 : outreg = sh ? {in[14:0], 4'b0}       : in;
            2'b10 : outreg = sh ? {{4{in[15]}}, in[15:4]} : in;
            2'b11 : outreg = sh ? {4'b0, in[15:4]}       : in;
        endcase
    end
    
endmodule

