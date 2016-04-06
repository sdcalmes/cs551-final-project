/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module rf_bypass (
            // Outputs
            read1data, read2data, err,
            // Inputs
            clk, rst, read1regsel, read2regsel, writeregsel, writedata, write
            );

    input clk, rst;
    input [2:0] read1regsel;
    input [2:0] read2regsel;
    input [2:0] writeregsel;
    input [15:0] writedata;
    input        write;
    
    output [15:0] read1data;
    output [15:0] read2data;
    output        err;

    reg [15:0] tmp_writedata;
    wire [15:0] outRead1, outRead2;
    reg  [15:0] read1Data, read2Data;
    
    // your code
    rf r(.clk(clk), .rst(rst), .read1regsel(read1regsel), .read2regsel(read2regsel), 
        .writeregsel(writeregsel), .writedata(writedata), .write(write), 
        .read1data(outRead1), .read2data(outRead2), .err(err)); 

    always @(*) begin
        tmp_writedata = writedata;
        case(write)
            1'b0 : begin
                read1Data = outRead1;
                read2Data = outRead2;
            end
            2'b1 : begin
                read1Data = (writeregsel == read1regsel) ? tmp_writedata : outRead1;
                read2Data = (writeregsel == read2regsel) ? tmp_writedata : outRead2;
            end
        endcase
    end

    assign read1data = read1Data;
    assign read2data = read2Data;

endmodule
// DUMMY LINE FOR REV CONTROL :1:
