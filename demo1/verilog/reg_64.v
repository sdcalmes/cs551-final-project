module reg_64 (WriteData, WriteSel, ReadData, clk, rst);

    input [63:0] WriteData;
    input WriteSel, clk, rst;
    output [63:0] ReadData;

    reg  [63:0] writedata;
    wire  [63:0] storeData;
    wire flopRst;

    dff flops[63:0] (
        .d(writedata), // input
        .q(storeData),  // output
        .clk(clk),     // Clock signal
        .rst(rst)      // reset signal
    );

    dff rst_flop(
        .d(rst),
        .q(flopRst),
        .clk(clk),
        .rst(rst)
    );

    always @(*)
        case({WriteSel,flopRst})
            2'b00 : writedata   = storeData;
            2'b10 : writedata   = WriteData;
            default : writedata = 64'h0;
        endcase

    assign ReadData = storeData;



endmodule
