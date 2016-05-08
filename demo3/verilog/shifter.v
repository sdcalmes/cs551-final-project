module shifter (In, Cnt, Op, Out);
   
    input [15:0] In;
    input [3:0]  Cnt;
    input [1:0]  Op;
    output [15:0] Out;

    wire [15:0] sh1, sh2, sh3;
    

    // barrel 1
    shift1 sh_1 (In , Cnt[0], Op, sh1);
    // barrel 2
    shift2 sh_2 (sh1, Cnt[1], Op, sh2);
    // barrel 4
    shift4 sh_4 (sh2, Cnt[2], Op, sh3);
    // barrel 8
    shift8 sh_8 (sh3, Cnt[3], Op, Out);
    
endmodule

