/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module fifo(/*AUTOARG*/
    // Outputs
    data_out, fifo_empty, fifo_full, err,
    // Inputs
    data_in, data_in_valid, pop_fifo, clk, rst
    );
   
    input [63:0] data_in;
    input        data_in_valid;
    input        pop_fifo;
    
    input        clk;
    input        rst;
    output [63:0] data_out;
    output        fifo_empty;
    output        fifo_full;
    output        err;
    
    //your code here
    
    wire [3:0] state;
    reg  [3:0] nxt_state;
    reg  f_e, f_f, e;
    
    reg  [63:0] inData;
    
    reg  writeSel0, writeSel1, writeSel2, writeSel3;
    reg  [63:0] writeData0, writeData1, writeData2, writeData3;
    wire [63:0] outRead0, outRead1, outRead2, outRead3;
    
    dff state_flop[3:0] (
        .d(nxt_state),
        .q(state),
        .clk(clk),
        .rst(rst)
    );

    reg_64 data0(.WriteData(writeData0), .WriteSel(writeSel0), .ReadData(outRead0), .clk(clk), .rst(rst));
    reg_64 data1(.WriteData(writeData1), .WriteSel(writeSel1), .ReadData(outRead1), .clk(clk), .rst(rst));
    reg_64 data2(.WriteData(writeData2), .WriteSel(writeSel2), .ReadData(outRead2), .clk(clk), .rst(rst));
    reg_64 data3(.WriteData(writeData3), .WriteSel(writeSel3), .ReadData(outRead3), .clk(clk), .rst(rst));

    always @(*) begin
        writeSel0 = 1'b0;
        writeSel1 = 1'b0;
        writeSel2 = 1'b0;
        writeSel3 = 1'b0;
        f_e = 1'b0;
        f_f = 1'b0;
        e = 1'b0;
        inData = data_in;
        
        case(state)
            // there is nothing in the fifo
            3'b000: begin
                f_e = 1'b1;
                if(data_in_valid) begin
                    writeSel0 = 1'b1;
                    writeData0 = inData;
                    nxt_state = 3'b001;
                end
            end
            
            // there is one thing in the fifo
            3'b001: begin
                if(data_in_valid && !pop_fifo) begin
                    writeSel1 = 1'b1;
                    writeData1 = inData;
                    nxt_state = 3'b010;
                end

                // pop the data out
                else if(pop_fifo && !data_in_valid) begin
                    writeSel0 = 1'b1;
                    writeData0 = 64'h0;
                    nxt_state = 3'b000;
                end
                
                // pop the oldest item and added to the new item to the end
                else if(pop_fifo && data_in_valid) begin
                    writeSel0 = 1'b1;
                    writeData0 = inData;
                end
                else begin end
            end
            
            // there are two things in the fifo
            3'b010: begin
                // add the data to the end of the fifo
                if(data_in_valid && !pop_fifo) begin
                    writeSel2 = 1'b1;
                    writeData2 = inData;
                    nxt_state = 3'b011;
                end
                
                if(pop_fifo && !data_in_valid) begin
                    writeSel0 = 1'b1;
                    writeData0 = outRead1;
                    writeSel1 = 1'b1;
                    writeData1 = 64'h0;
                    nxt_state = 3'b001;
                end
                
                if(pop_fifo && data_in_valid) begin
                    writeSel0 = 1'b1;
                    writeData0 = outRead1;
                    writeSel1 = 1'b1;
                    writeData1 = inData;
                end
            end
            
            // there are three things in the fifo
            3'b011: begin
                if(data_in_valid && !pop_fifo) begin
                    writeSel3 = 1'b1;
                    writeData3 = inData;
                    nxt_state = 3'b100;
                end
                
                if(pop_fifo && !data_in_valid) begin
                    writeSel0 = 1'b1;
                    writeData0 = outRead1;
                    writeSel1 = 1'b1;
                    writeData1 = outRead2;
                    writeSel2 = 1'b1;
                    writeData2 = 64'h0;
                    nxt_state = 3'b010;
                end
                
                if(pop_fifo && data_in_valid) begin
                    writeSel0 = 1'b1;
                    writeData0 = outRead1;
                    writeSel1 = 1'b1;
                    writeData1 = outRead2;
                    writeSel2 = 1'b1;
                    writeData2 = inData;
                end
            end
            
            // the fifo is full, with four things in the fifo
            3'b100: begin
                f_f = 1'b1;
                if(pop_fifo) begin
                    writeSel0 = 1'b1;
                    writeData0 = outRead1;
                    writeSel1 = 1'b1;
                    writeData1 = outRead2;
                    writeSel2 = 1'b1;
                    writeData2 = outRead3;
                    writeSel3 = 1'b1;
                    writeData3 = 64'h0;
                    nxt_state = 3'b011;
                end
            end
            default: e = 1'b1; // any other state is an error
        endcase
    end

    assign data_out = outRead0;
    assign fifo_empty = f_e;
    assign fifo_full = f_f;
    assign err = e;

endmodule
// DUMMY LINE FOR REV CONTROL :1:
