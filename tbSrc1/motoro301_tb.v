
`timescale 1ns / 1ps

module motoro301_tb(
);

wire                    tp01;	
wire                    tp02;	
wire                    rs232_tx;	

wire    [3:0]           led4;	
reg                     clk;			// 50MHz
reg                     nRst;		// reset button on the core board

motoro301_top
rtl_top(
    .tp01       (   tp01        ),
    .tp02       (   tp02        ),
    .rs232_tx   (   rs232_tx    ),

    .led4       (   led4        ),

    .nReset     (   nRst      ),
    .clk50mhz   (   clk         )
);

initial begin
    $fsdbDumpfile("verdi.fsdb") ;
    $fsdbDumpvars(0,motoro301_tb) ;
end

initial
begin

//    $dumpfile("Counter.vcd");
//    $dumpvars(0, Counter_tb);

    #10
    nRst = 0;
    clk = 0;

    #40
    nRst = 1;

    #600
    $finish;
end

always begin
    #1 clk = !clk ;
end




endmodule
