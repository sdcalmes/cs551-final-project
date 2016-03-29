module add_16 (A, B, Out);
   
    input [15:0]  A, B;
    output [15:0] Out;

    reg [15:0] outreg;
    wire [3:0] add1, add2, add3, add4;
    wire c1, c2, c3;

    assign Out = outreg;

    cla4 adder1 ( .sum(add1),
                  .cout(c1),
                  .a(A[3:0]),
                  .b(B[3:0]),
                  .cin(1'b0)
                  );

    cla4 adder2 ( .sum(add2),
                  .cout(c2),
                  .a(A[7:4]),
                  .b(B[7:4]),
                  .cin(c1)
                  );

    cla4 adder3 ( .sum(add3),
                  .cout(c3),
                  .a(A[11:8]),
                  .b(B[11:8]),
                  .cin(c2)
                  );

    cla4 adder4 ( .sum(add4),
                  .cout(),
                  .a(A[15:12]),
                  .b(B[15:12]),
                  .cin(c3)
                  );

    always @(*) begin
        outreg = {add4, add3, add2, add1};
    end

endmodule
