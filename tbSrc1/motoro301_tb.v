
`timescale 10ns / 1ns

module motoro301_tb(
);

output  wire                aH ;	
output  wire                aL ;	
output  wire                bH ;	
output  wire                bL ;	
output  wire                cH ;	
output  wire                cL ;	
input   wire                m3start;	
input   wire                m3invOrStop;	 
input   wire    [9:0]       m3freq;	

wire                        tp01;	
wire                        tp02;	
wire                        rs232_tx;	

wire            [3:0]       led4;	
reg                         clk;			// 50MHz
reg                         nRst;		// reset button on the core board

motoro301_rtl_top
rtl(
    .aH             (   aH              ),
    .aL             (   aL              ),
    .bH             (   bH              ),
    .bL             (   bL              ),
    .cH             (   cH              ),
    .cL             (   cL              ),
                                       
    .m3start        (   m3start         ),
    .m3freq         (   m3freq          ),
    .m3invOrStop    (   m3invOrStop     ),

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
    clk = 0;
    nRst = 1;

    #10
    nRst = 0;

    #10
    nRst = 1;

    #600
    $finish;
end

always begin
    #1 clk = !clk ;
end




endmodule
