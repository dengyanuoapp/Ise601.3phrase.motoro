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
    uTx,

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
output  wire                uTx;	

output  wire    [3:0]       led4;	
input   wire                clk50mhz;			// 50MHz
input   wire                nReset;		// reset button on the core board

wire                        clkUtx ;
wire                        clkM3;			// 10MHz


//assign {tp01 , tp02 } = { nReset , ~nReset };
assign {tp01 , tp02 } = { clkUtx , ~clkUtx };

`ifndef m3perCent 
    `define m3pos1_neg0                     8'd1
    `define m3perCent                       8'd10
`endif

`ifndef m3speedRoundPerSecondL8 
    `define m3speedRoundPerSecondH8         8'd0
    `ifdef  synthesising 
        `define m3speedRoundPerSecondL8     8'd1
    `endif
    `ifdef  synthesising 
        `define m3speedRoundPerSecondL8     8'd100
    `endif
`endif

led4
ledTop(
    .led            (   led4        ),

    .nRst           (   nReset      ),
    .clk            (   clk50mhz    )
);

uart_set_show_config_top
ussc(
    .busDefault     ( { 
        `m3pos1_neg0 , 
        `m3perCent , 
        `m3speedRoundPerSecondH8 , 
        `m3speedRoundPerSecondL8 
    } ),
    .busNow         (                   ),

    .uTx            (   uTx             ),
    .clkUtx         (   clkUtx          ),

    .nRst           (   nReset          ),
    .clk10mhz       (   clkM3           )
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
    .clkHI          (   clk50mhz        ),
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
