module motoro3_sine_generator(
    sgStep                  ,
    sgHp                    ,
    sgLp                    ,

    m3cnt                   ,
    m3cntLast1              ,

    nRst                    ,
    clk

);

output  wire                sgHp            ;	
output  wire                sgLp            ;	

input   wire                clk             ;			// 10MHz
input   wire                nRst            ;		

input   wire    [3:0]       sgStep          ;	
input   wire    [24:0]      m3cnt           ;	
input   wire                m3cntLast1      ;

wire                        sgEE            ;		
wire                        sgForceLow      ;		
wire                        sgH1_L0         ;		

wire                        sgPWM           ;	

motoro3_pwm_generator
pwmSG
(
    .pwm                ( sgPWM       ),
    .aE                 ( sgEE        ),
    .bE                 ( 1'b1        ),
    .cE                 ( 1'b1        ),
    .m3cnt              ( m3cnt       ),
    .m3cntLast1         ( m3cntLast1  ),
    .nRst               ( nRst        ),
    .clk                ( clk         ) 
);// motoro3_pwm_generator A

motoro3_step_to_mosdriver
step2mosA
(
    .xE                 ( sgEE          ),
    .xForceLow          ( sgForceLow    ),
    .xH1_L0             ( sgH1_L0       ),
    .m3step             ( sgStep        ) 
);

motoro3_mos_driver
mD
(
    .mosHp                  ( sgHp          ),
    .mosLp                  ( sgLp          ),

    .pwm                    ( sgPWM         ),
    .mosEnable              ( sgEE          ),
    .h1_L0                  ( sgH1_L0       ),
    .forceLow               ( sgForceLow    ),

    .nRst                   ( nRst          ),
    .clk                    ( clk           )  
);// motoro3_mos_driver A


endmodule
