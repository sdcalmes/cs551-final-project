module alu (A, B, Cin, Op, invA, invB, sign, Out, Z, lt_zero, Cout, sle_lt_zero);

    input Cin, invA, invB, sign;
    input [2:0] Op;
    input [15:0] A, B;
    output Cout, Z, lt_zero, sle_lt_zero;
    output [15:0] Out;

    reg lt_zero_w, sle_lt_zero_w;
    reg [15:0] outreg, inA, inB;
    wire [3:0]  add1, add2, add3, add4;
    wire [15:0] out;
    wire Cout, c1, c2, c3;

    assign Out      = outreg;
    assign Z        = ~(|outreg);
    assign lt_zero  = lt_zero_w;
    assign sle_lt_zero = sle_lt_zero_w;
    //assign lt_zero  = sign ? oJOOutreg[15] : 1'b0;

   shifter sh ( .In(inA),
                .Cnt(inB[3:0]),
                .Op(Op[1:0]),
                .Out(out));

    cla4 adder1 ( .sum(add1),
                  .cout(c1),
                  .a(inA[3:0]),
                  .b(inB[3:0]),
                  .cin(Cin));

    cla4 adder2 ( .sum(add2),
                  .cout(c2),
                  .a(inA[7:4]),
                  .b(inB[7:4]),
                  .cin(c1));

    cla4 adder3 ( .sum(add3),
                  .cout(c3),
                  .a(inA[11:8]),
                  .b(inB[11:8]),
                  .cin(c2));

    cla4 adder4 ( .sum(add4),
                  .cout(Cout),
                  .a(inA[15:12]),
                  .b(inB[15:12]),
                  .cin(c3));
  
    always @(*) begin
        inA = invA ? (~A) : A;
        inB = invB ? (~B) : B;

        casex(Op)
            3'b0xx: outreg = out;

            3'b100: outreg = {add4, add3, add2, add1};

            3'b101: outreg = {add4, add3, add2, add1};

            3'b110: outreg = inA ^ inB;

            3'b111: outreg = inA & inB;
        endcase
    end

    always @(*) begin
        sle_lt_zero_w = 1'b0;
        case(sign)
            1'b1 : begin
                lt_zero_w = outreg[15];
            end
            1'b0 : begin
                lt_zero_w = ((~A[15] & ~B[15] & Cout & (|outreg)) | (A[15] & B[15] & Cout & (|outreg)) | (A[15] & ~B[15]) );
                sle_lt_zero_w = lt_zero_w & ((A[15] ~^ B[15]) | (A[15] ^ B[15]));
            end
        endcase
    end

    
endmodule
