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

output  wire                aHp             ;	
output  wire                aLp             ;	
output  wire                bHp             ;	
output  wire                bLp             ;	
output  wire                cHp             ;	
output  wire                cLp             ;	

input   wire                m3start         ;	

// if 0 , normal . 
// if 1 -> force stop ,according to the m3freq : 0 -> forceStop ; or , inverse. 
input   wire                m3invOrStop     ;	 

// freq 1 - 1000, ==> 60 - 60,000 rpm(round per minutes)
input   wire    [9:0]       m3freq          ;	

input   wire                clk             ;			// 10MHz
input   wire                nRst            ;		

wire            [3:0]       m3stepA         ;	
wire            [3:0]       m3stepB         ;	
wire            [3:0]       m3stepC         ;	
wire            [24:0]      m3cnt           ;	
wire                        m3cntLast1      ;

wire                        aStEE           ;		
wire                        aStH1_L0        ;		
wire                        bStEE           ;		
wire                        bStH1_L0        ;		
wire                        cStEE           ;		
wire                        cStH1_L0        ;		

wire                        pwmA            ;	
wire                        pwmB            ;	
wire                        pwmC            ;	

motoro3_pwm_generator
pwm0A
(
    .pwm                ( pwmA        ),
    .aE                 ( aStEE       ),
    .bE                 ( bStEE       ),
    .cE                 ( cStEE       ),
    .m3cnt              ( m3cnt       ),
    .m3cntLast1         ( m3cntLast1  ),
    .nRst               ( nRst        ),
    .clk                ( clk         ) 
);// motoro3_pwm_generator A
motoro3_pwm_generator
pwm0B
(
    .pwm                ( pwmB        ),
    .aE                 ( aStEE       ),
    .bE                 ( bStEE       ),
    .cE                 ( cStEE       ),
    .m3cnt              ( m3cnt       ),
    .m3cntLast1         ( m3cntLast1  ),
    .nRst               ( nRst        ),
    .clk                ( clk         ) 
);// motoro3_pwm_generator B
motoro3_pwm_generator
pwm0C
(
    .pwm                ( pwmC        ),
    .aE                 ( aStEE       ),
    .bE                 ( bStEE       ),
    .cE                 ( cStEE       ),
    .m3cnt              ( m3cnt       ),
    .m3cntLast1         ( m3cntLast1  ),
    .nRst               ( nRst        ),
    .clk                ( clk         ) 
);// motoro3_pwm_generator C

motoro3_step_to_mosdriver
step2mos
(
    .aE                 ( aStEE         ),
    .bE                 ( bStEE         ),
    .cE                 ( cStEE         ),
    .aH1_L0             ( aStH1_L0      ),
    .bH1_L0             ( bStH1_L0      ),
    .cH1_L0             ( cStH1_L0      ),
    .m3step             ( m3stepA       ) 
);

motoro3_state_machine
st
(
    .m3stepA                ( m3stepA       ),
    .m3stepB                ( m3stepB       ),
    .m3stepC                ( m3stepC       ),
    .m3cnt                  ( m3cnt         ),
    .m3cntLast1             ( m3cntLast1    ),
    .m3start                ( m3start       ),
    .m3freq                 ( m3freq        ),

    .nRst                   ( nRst          ),
    .clk                    ( clk           )
);// motoro3_state_machine

motoro3_mos_driver
mA
(
    .pwm                    ( pwmA          ),
    .mosHp                  ( aHp           ),
    .mosLp                  ( aLp           ),
    .mosEnable              ( aStEE         ),
    .h1_L0                  ( aStH1_L0      ),
    .nRst                   ( nRst          ),
    .clk                    ( clk           )  
);// motoro3_mos_driver A

motoro3_mos_driver
mB
(
    .pwm                    ( pwmB          ),
    .mosHp                  ( bHp           ),
    .mosLp                  ( bLp           ),
    .mosEnable              ( bStEE         ),
    .h1_L0                  ( bStH1_L0      ),
    .nRst                   ( nRst          ),
    .clk                    ( clk           )  
);// motoro3_mos_driver B

motoro3_mos_driver
mC
(
    .pwm                    ( pwmC          ),
    .mosHp                  ( cHp           ),
    .mosLp                  ( cLp           ),
    .mosEnable              ( cStEE         ),
    .h1_L0                  ( cStH1_L0      ),
    .nRst                   ( nRst          ),
    .clk                    ( clk           )  
);// motoro3_mos_driver C

endmodule
