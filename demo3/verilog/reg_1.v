module reg_1 (WriteData, WriteSel, ReadData, clk, rst);

    input WriteData;
    input WriteSel, clk, rst;
    output ReadData;

    reg  writedata;
    wire storeData;
    wire flopRst;

    dff flops(
        .d(writedata), // input
        .q(storeData),  // output
        .clk(clk),     // Clock signal
        .rst(rst)      // reset signal
    );

    always @(*)
        case({WriteSel,rst})
            2'b00 : writedata   = storeData;
            2'b10 : writedata   = WriteData;
            default : writedata = 1'b0;
        endcase

    assign ReadData = storeData;



endmodule
