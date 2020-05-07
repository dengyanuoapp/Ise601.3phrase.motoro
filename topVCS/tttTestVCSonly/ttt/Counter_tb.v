/*****************************************************************************************************
* Description:                 Test bench of Counter for Demo
*
* Author:                      Dengxue Yan
*
* Email:                       Dengxue.Yan@wustl.edu
*
* Rev History:
*       <Author>        <Date>        <Hardware>     <Version>        <Description>
*     Dengxue Yan   2016-09-09 23:00       --           1.00             Create
*****************************************************************************************************/
`timescale 1ns / 1ps

module Counter_tb;

    reg  rst;
    reg  clk;

    wire [4:0] c;

    Counter DUT(
    .rst(rst),
    .clk(clk),
    .c(c)
    );

    //initial begin
    //    $fsdbDumpfile("verdi.fsdb") ;
    //    $fsdbDumpvars(0,Counter_tb) ;
    //end

    initial
    begin

        $dumpfile("Counter.vcd"); 
        $dumpvars(0, Counter_tb); 

        rst = 1;
        clk = 0;

        #40
        rst = 0;

        #600
        rst = 1;

        #40
        rst = 0;

        #600

        #20
        $finish;

    end
    always
        #10 clk = !clk;
endmodule
