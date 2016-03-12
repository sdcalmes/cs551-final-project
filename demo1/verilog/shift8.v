module shift8(in, sh, op, out);
    input [15:0] in;
    input [1:0] op;
    input sh;
    output [15:0] out;
    reg [15:0] outreg;

    assign out = outreg;

    always @(*) begin
        case(op)
            2'b00 : outreg = sh ? {in[7:0], in[15:8]}     : in;
            2'b01 : outreg = sh ? {in[7:0], 8'b0}         : in;
            2'b10 : outreg = sh ? {{8{in[15]}}, in[15:8]} : in;
            2'b11 : outreg = sh ? {8'b0, in[15:8]}        : in;
        endcase
    end
    
endmodule

