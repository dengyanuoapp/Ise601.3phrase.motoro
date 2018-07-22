
`timescale 10ns / 1ns

module motoro301_tb(
);

wire                        aHP ;	
wire                        aLN ;	
wire                        bHP ;	
wire                        bLN ;	
wire                        cHP ;	
wire                        cLN ;	
reg                         m3start;	
reg                         m3forceStop;	 
reg                         m3invRotate;	 
reg                         m3freqINC;	 
reg                         m3freqDEC;	 

wire                        tp01;	
wire                        tp02;	
wire                        uTx;	

wire            [3:0]       led4;	
reg                         clk;			// 50MHz
reg                         nRst;		// reset button on the core board

motoro301_rtl_top
rtl(
    .aHP             (   aHP              ),
    .aLN             (   aLN              ),
    .bHP             (   bHP              ),
    .bLN             (   bLN              ),
    .cHP             (   cHP              ),
    .cLN             (   cLN              ),
                                       
    .m3start        (   m3start         ),
    .m3freqINC      (   m3freqINC       ),
    .m3freqDEC      (   m3freqDEC       ),
    .m3forceStop    (   m3forceStop     ),
    .m3invRotate    (   m3invRotate     ),

    .tp01           (   tp01            ),
    .tp02           (   tp02            ),
    .uTx            (   uTx             ),
                   
    .led4           (   led4            ),
                   
    .nReset         (   nRst            ),
    .clk50mhz       (   clk             )
);

initial begin
    $fsdbDumpfile("verdi.fsdb") ;
    $fsdbDumpvars(0,motoro301_tb) ;
end

initial
begin

//    $dumpfile("Counter.vcd");
//    $dumpvars(0, Counter_tb);

    #1
    clk = 0;
    nRst = 1;

    #1
    nRst = 0;

    m3start = 0;	
    m3forceStop = 0 ;	 
    m3invRotate = 0 ;	 
    m3freqINC   = 0 ;
    m3freqDEC   = 0 ;

    #1
    nRst = 1;

    #10
    m3start = 1;	

    #1_200_000      // 12ms
    #1_200_000      // 12ms
    #7_200_000      // 12ms
`ifdef simulating
`endif
    //#10_000_000      // 100ms
    //#100_000_000    // 1s
    $finish;
end

always begin
    #1 clk = !clk ;
end




endmodule
