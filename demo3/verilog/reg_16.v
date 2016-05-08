module reg_16 (WriteData, WriteSel, ReadData, clk, rst);

    input [15:0] WriteData;
    input WriteSel, clk, rst;
    output [15:0] ReadData;

    //wire [15:0] flopData;
    reg  [15:0] writedata;
    wire  [15:0] storeData;
    wire flopRst;

    dff flops[15:0] (
        .d(writedata), // input
        .q(storeData),  // output
        .clk(clk),     // Clock signal
        .rst(rst)      // reset signal
    );

    always @(*)
        case({WriteSel,rst})
            2'b00 : writedata   = storeData;
            2'b10 : writedata   = WriteData;
            default : writedata = 16'h0000;
        endcase

    assign ReadData = storeData;



endmodule
