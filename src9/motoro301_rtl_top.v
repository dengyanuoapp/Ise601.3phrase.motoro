module motoro301_rtl_top(
    aH,
    aL,
    bH,
    bL,
    cH,
    cL,

    m3start         ,
    m3invOrStop     ,
    m3freq          ,

    tp01,
    tp02,
    rs232_tx,

    led4,
    nReset,
    clk50mhz

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

output  wire                tp01;	
output  wire                tp02;	
output  wire                rs232_tx;	

output  wire    [3:0]       led4;	
input   wire                clk50mhz;			// 50MHz
input   wire                nReset;		// reset button on the core board

wire                        clk_rs232_tx ;
wire                        clkM3;			// 10MHz

//assign {tp01 , tp02 } = { nReset , ~nReset };
assign {tp01 , tp02 } = { clk_rs232_tx , ~clk_rs232_tx };

led4
ledTop(
    .led        (   led4        ),

    .nrst       (   nReset      ),
    .clk        (   clk50mhz    )
);

uart_block_19_top
uartTop(
    .rs232_tx   (   rs232_tx    ),
    .clk_rs232_tx  (   clk_rs232_tx   ),

    .nrst       (   nReset      ),
    .clk_in     (   clk50mhz    )
);

motoro3_top
m3t
(
    .aH             (   aH              ),
    .aL             (   aL              ),
    .bH             (   bH              ),
    .bL             (   bL              ),
    .cH             (   cH              ),
    .cL             (   cL              ),
                                       
    .m3start        (   m3start         ),
    .m3freq         (   m3freq          ),
    .m3invOrStop    (   m3invOrStop     ),

    .nRst           (   nReset          ),
    .clk            (   clkM3           )
);

clkGenForMotoro3
cgM3
(
    .nRst           (   nReset          ),
    .clkM3          (   clkM3           ),
    .clk50mhz       (   clk50mhz        )
);

endmodule
