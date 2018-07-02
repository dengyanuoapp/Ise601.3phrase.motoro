
`timescale 10ps / 1ps

module motoro301_tb(
);

wire                    tp01;	
wire                    tp02;	
wire                    rs232_tx;	

wire    [3:0]           led4;	
wire                    clk50mhz;			// 50MHz
wire                    nReset;		// reset button on the core board

motoro301_top
motoro301_top_01(
    .tp01       (   tp01        ),
    .tp02       (   tp02        ),
    .rs232_tx   (   rs232_tx    ),

    .led4       (   led4        ),

    .nReset     (   nReset      ),
    .clk50mhz   (   clk50mhz    )
);

initial begin
    $fsdbDumpfile("verdi.fsdb") ;
    $fsdbDumpvars(0,Counter_tb) ;
end

initial
begin

//    $dumpfile("Counter.vcd");
//    $dumpvars(0, Counter_tb);

    rst = 1;
    clk = 0;

    #40
    rst = 0;

    #600
    $finish;
end

always begin
    #1 clk = !clk ;
end




endmodule
