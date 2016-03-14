/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (/*AUTOARG*/
    // Outputs
    err, 
    // Inputs
    clk, rst
    );

    input clk;
    input rst;

    output err;

    // None of the above lines can be modified

    // OR all the err ouputs for every sub-module and assign it as this
    // err output
   
    // As desribed in the homeworks, use the err signal to trap corner
    // cases that you think are illegal in your statemachines

    /////////////////////////////////
    /////    REG/Wire          /////
    ///////////////////////////////

    reg PC;

    ////////////////////////////////
    /////    Instantiate     //////
    //////////////////////////////
    
    alu         main_alu(.A(), .B(), .Cin, .Op(), .invA(), .invB(), .sign(), 
                         .Out(), .Ofl(), .Z());

    memory2c    inst_mem(.data_in(), .data_out(), .addr(), .enable(), .wr(), 
                         .createdump(), .clk(), .rst());

    rf_bypass   register(.read1regsel(), .read2regsel(), .writeregsel(), .writedata(), 
                         .write(), .read1data(), .read2data(), .err());

    memory2c    data_mem(.data_in(), .data_out(), .addr(), .enable(), .wr(), 
                         .createdump(), .clk(), .rst());

    control     control ();

    alu_control alu_cntl();

    alu         add_off ();



    //////////////////////////////
    /////    Logic          /////
    ////////////////////////////



endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
