module motoro3_real(
    pwm,
    aH,
    aL,
    bH,
    bL,
    cH,
    cL,

    m3start         ,
    m3invOrStop     ,
    m3freq          ,

    nRst,
    clk

);

output  wire                pwm     ;	
output  wire                aH      ;	
output  wire                aL      ;	
output  wire                bH      ;	
output  wire                bL      ;	
output  wire                cH      ;	
output  wire                cL      ;	

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

wire                        aE              ;		
wire                        aH1_L0          ;		
wire                        bE              ;		
wire                        bH1_L0          ;		
wire                        cE              ;		
wire                        cH1_L0          ;		


motoro3_state_machine
st
(
    .pwm                    ( pwm           ),

    .aE                     ( aE            ),
    .aH1_L0                 ( aH1_L0        ),
    .bE                     ( bE            ),
    .bH1_L0                 ( bH1_L0        ),
    .cE                     ( cE            ),
    .cH1_L0                 ( cH1_L0        ),

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
    .mosH                   ( aH            ),
    .mosL                   ( aL            ),
    .mosEnable              ( aE            ),
    .h1_L0                  ( aH1_L0        ),
    .nRst                   ( nRst          ),
    .clk                    ( clk           )  
);

motoro3_mos_driver
mB
(
    .mosH                   ( bH            ),
    .mosL                   ( bL            ),
    .mosEnable              ( bE            ),
    .h1_L0                  ( bH1_L0        ),
    .nRst                   ( nRst          ),
    .clk                    ( clk           )  
);

motoro3_mos_driver
mC
(
    .mosH                   ( cH            ),
    .mosL                   ( cL            ),
    .mosEnable              ( cE            ),
    .h1_L0                  ( cH1_L0        ),
    .nRst                   ( nRst          ),
    .clk                    ( clk           )  
);


endmodule
