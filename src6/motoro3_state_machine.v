module motoro3_state_machine(

    pwm             ,		

    aE              ,		
    aH1_L0          ,		
    bE              ,		
    bH1_L0          ,		
    cE              ,		
    cH1_L0          ,		

    m3step          ,
    m3cnt           ,

    m3start         ,
    m3freq          ,

    nRst,
    clk

);

output  wire                pwm             ;		

output  wire                aE              ;		
output  wire                aH1_L0          ;		
output  wire                bE              ;		
output  wire                bH1_L0          ;		
output  wire                cE              ;		
output  wire                cH1_L0          ;		

output  wire    [3:0]       m3step          ;	

output  wire    [24:0]      m3cnt           ;	

input   wire                m3start;	
input   wire    [9:0]       m3freq;	

input   wire                clk;			// 10MHz
input   wire                nRst;		

wire                        m3cntLast1 ;



motoro3_pwm_generator
pwm01
(
    .pwm                ( pwm         ),
    .aE                 ( aE          ),
    .bE                 ( bE          ),
    .cE                 ( cE          ),
    .m3cnt              ( m3cnt       ),
    .m3cntLast1         ( m3cntLast1  ),
    .nRst               ( nRst        ),
    .clk                ( clk         ) 
);

motoro3_step_generator
stepgen
(
    .m3start            ( m3start       ),
    .m3freq             ( m3freq        ),
                                       
    .m3step             ( m3step        ),
    .m3cnt              ( m3cnt         ),
    .m3cntLast1         ( m3cntLast1    ),
                                       
    .nRst               ( nRst          ),
    .clk                ( clk           ) 
);

motoro3_step_to_mosdriver
step2mos
(
    .aE                 ( aE            ),
    .bE                 ( bE            ),
    .cE                 ( cE            ),
    .aH1_L0             ( aH1_L0        ),
    .bH1_L0             ( bH1_L0        ),
    .cH1_L0             ( cH1_L0        ),
    .m3step             ( m3step        ) 
);

endmodule
