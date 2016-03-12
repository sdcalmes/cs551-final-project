/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */

module sc( clk, rst, ctr_rst, out, err);
   input clk;
   input rst;
   input ctr_rst;
   output [2:0] out;
   output err;

   // your code
   reg [2:0] outtie; 
   wire [2:0] out_data;
   wire rst_d;

   dff flop[2:0](.q(out_data), .d(outtie), .clk(clk), .rst(rst));
   
   dff rst_flop(.q(rst_d), .d(rst), .clk(clk), .rst(rst));


   always @(*) begin
	   //$display("RST_D: %d", rst_d);
	   case({rst_d, ctr_rst})
		   2'b00: outtie = (outtie == 3'b101) ? out_data : out_data + 1;
		   2'b01: outtie = 3'b000;
		   default: outtie = 3'b000;
	   endcase
   end

   assign out = out_data;
   

endmodule

// DUMMY LINE FOR REV CONTROL :1:
