module shift2(in, sh, op, out);
    input [15:0] in;
    input [1:0] op;
    input sh;
    output [15:0] out;
    reg [15:0] outreg;

    assign out = outreg;

    always @(*) begin
        case(op)
            2'b00 : outreg = sh ? {in[13:0], in[15:14]}   : in;
            2'b01 : outreg = sh ? {in[13:0], 2'b0}        : in;
            2'b10 : outreg = sh ? {in[1:0] , in[15:2]}    : in;
            2'b11 : outreg = sh ? {2'b0, in[15:2]}        : in;
        endcase
    end
    
endmodule

