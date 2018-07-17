module motoro3_real(
    aHp,
    aLp,
    bHp,
    bLp,
    cHp,
    cLp,

    m3start         ,
    m3invOrStop     ,
    m3freq          ,

    nRst,
    clk

);

output  wire                aHp      ;	
output  wire                aLp      ;	
output  wire                bHp      ;	
output  wire                bLp      ;	
output  wire                cHp      ;	
output  wire                cLp      ;	

input   wire                m3start;	

// if 0 , normal . 
// if 1 -> force stop ,according to the m3freq : 0 -> forceStop ; or , inverse. 
input   wire                m3invOrStop;	 

// freq 1 - 1000, ==> 60 - 60,000 rpm(round per minutes)
input   wire    [9:0]       m3freq;	

input   wire                clk;			// 10MHz
input   wire                nRst;		

wire            [3:0]       m3step;	
wire            [24:0]      m3cnt;	

wire                        aStEE              ;		
wire                        aStH1_L0          ;		
wire                        bStEE              ;		
wire                        bStH1_L0          ;		
wire                        cStEE              ;		
wire                        cStH1_L0          ;		

wire                        pwm     ;	

motoro3_state_machine
st
(
    .pwm                    ( pwm           ),

    .aE                     ( aStEE            ),
    .aH1_L0                 ( aStH1_L0        ),
    .bE                     ( bStEE            ),
    .bH1_L0                 ( bStH1_L0        ),
    .cE                     ( cStEE            ),
    .cH1_L0                 ( cStH1_L0        ),

    .m3step                 ( m3step        ),
    .m3cnt                  ( m3cnt         ),
    .m3start                ( m3start       ),
    .m3freq                 ( m3freq        ),

    .nRst                   ( nRst ),
    .clk                    ( clk )
);

motoro3_mos_driver
mA
(
    .mosHp                  ( aHp            ),
    .mosLp                  ( aLp            ),
    .mosEnable              ( aStEE            ),
    .h1_L0                  ( aStH1_L0        ),
    .nRst                   ( nRst          ),
    .clk                    ( clk           )  
);

motoro3_mos_driver
mB
(
    .mosHp                  ( bHp            ),
    .mosLp                  ( bLp            ),
    .mosEnable              ( bStEE            ),
    .h1_L0                  ( bStH1_L0        ),
    .nRst                   ( nRst          ),
    .clk                    ( clk           )  
);

motoro3_mos_driver
mC
(
    .mosHp                  ( cHp            ),
    .mosLp                  ( cLp            ),
    .mosEnable              ( cStEE            ),
    .h1_L0                  ( cStH1_L0        ),
    .nRst                   ( nRst          ),
    .clk                    ( clk           )  
);


endmodule
