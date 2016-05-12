module reg_1 (WriteData, stall, flush, ReadData, clk, rst);

    input WriteData, stall, flush;
    input clk, rst;
    output ReadData;

    reg  writedata;
    wire storeData;
    wire flopRst;

    dff flops(
        .d(stall ? ReadData : WriteData),
        .q(ReadData),
        .clk(clk),
        .rst(rst | flush)
    );

endmodule
