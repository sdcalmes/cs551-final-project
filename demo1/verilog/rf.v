/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module rf (
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

   // your code
   reg writeSel1, writeSel2, writeSel3, writeSel4, writeSel5, writeSel6, writeSel7, writeSel8;
   wire [15:0] outRead1, outRead2, outRead3, outRead4, outRead5, outRead6, outRead7, outRead8;
   reg [15:0] read1Data, read2Data;

   reg_16 reg1(.WriteData(writedata), .WriteSel(writeSel1), .ReadData(outRead1), .clk(clk), .rst(rst));
   reg_16 reg2(.WriteData(writedata), .WriteSel(writeSel2), .ReadData(outRead2), .clk(clk), .rst(rst));
   reg_16 reg3(.WriteData(writedata), .WriteSel(writeSel3), .ReadData(outRead3), .clk(clk), .rst(rst));
   reg_16 reg4(.WriteData(writedata), .WriteSel(writeSel4), .ReadData(outRead4), .clk(clk), .rst(rst));
   reg_16 reg5(.WriteData(writedata), .WriteSel(writeSel5), .ReadData(outRead5), .clk(clk), .rst(rst));
   reg_16 reg6(.WriteData(writedata), .WriteSel(writeSel6), .ReadData(outRead6), .clk(clk), .rst(rst));
   reg_16 reg7(.WriteData(writedata), .WriteSel(writeSel7), .ReadData(outRead7), .clk(clk), .rst(rst));
   reg_16 reg8(.WriteData(writedata), .WriteSel(writeSel8), .ReadData(outRead8), .clk(clk), .rst(rst));

   assign read1data = read1Data;
   assign read2data = read2Data;

   always @(*) begin
       case(read1regsel)
           3'b000 : read1Data = outRead1;
           3'b001 : read1Data = outRead2;
           3'b010 : read1Data = outRead3;
           3'b011 : read1Data = outRead4;
           3'b100 : read1Data = outRead5;
           3'b101 : read1Data = outRead6;
           3'b110 : read1Data = outRead7;
           3'b111 : read1Data = outRead8;
       endcase
   end
   always @(*) begin
       case(read2regsel)
           3'b000 : read2Data = outRead1;
           3'b001 : read2Data = outRead2;
           3'b010 : read2Data = outRead3;
           3'b011 : read2Data = outRead4;
           3'b100 : read2Data = outRead5;
           3'b101 : read2Data = outRead6;
           3'b110 : read2Data = outRead7;
           3'b111 : read2Data = outRead8;
       endcase
   end
   always @(*) begin
       writeSel1 = 1'b0;
       writeSel2 = 1'b0;
       writeSel3 = 1'b0;
       writeSel4 = 1'b0;
       writeSel5 = 1'b0;
       writeSel6 = 1'b0;
       writeSel7 = 1'b0;
       writeSel8 = 1'b0;
       case(writeregsel)
           3'b000 : writeSel1 = write;
           3'b001 : writeSel2 = write;
           3'b010 : writeSel3 = write;
           3'b011 : writeSel4 = write;
           3'b100 : writeSel5 = write;
           3'b101 : writeSel6 = write;
           3'b110 : writeSel7 = write;
           3'b111 : writeSel8 = write;
       endcase
   end
endmodule
// DUMMY LINE FOR REV CONTROL :1:
