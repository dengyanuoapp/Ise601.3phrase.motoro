module motoro3_line_generator(
    lgStep                      ,
    lgHp                        ,
    lgLp                        ,

    m3cnt                       ,
    m3cntLast1                  ,

    m3reg_step_cnt_reload1      ,	
    m3reg_power_percent         ,	
    pwmLenMask                      ,
    pwmMinMask                      ,

    nRst                        ,
    clk

);

output  wire                lgHp            ;	
output  wire                lgLp            ;	

input   wire                clk             ;			// 10MHz
input   wire                nRst            ;		

input   wire    [3:0]       lgStep          ;	
input   wire    [24:0]      m3cnt           ;	
input   wire                m3cntLast1      ;
input   wire    [7:0]       m3reg_power_percent     ;	// to control the percent of power , max 255 % , min 1 %.
input   wire    [24:0]      m3reg_step_cnt_reload1  ;	 // to control the speed
input   wire    [7:0]       pwmLenMask          ;	
input   wire    [7:0]       pwmMinMask          ;	

wire                        lgEE            ;		
wire                        lgForceLow      ;		
wire                        lgH1_L0         ;		

wire                        lgPWM           ;	


motoro3_line_calc_parameter
lCalc
(
    .pwmLenMask                 ( pwmLenMask        ),
    .pwmMinMask                 ( pwmMinMask        ),
    .lcStep                 ( lgStep        ) 
);// motoro3_line_calc_parameter 


motoro3_pwm_generator
pwmSG
(
    .pwmLenMask                 ( pwmLenMask        ),
    .pwmMinMask                 ( pwmMinMask        ),
    .pwm                    ( lgPWM         ),
    .m3cnt                  ( m3cnt         ),
    .m3cntLast1             ( m3cntLast1    ),
    .nRst                   ( nRst          ),
    .clk                    ( clk           ) 
);// motoro3_pwm_generator 

motoro3_step_to_mosdriver
lMos
(
    .xE                     ( lgEE          ),
    .xForceLow              ( lgForceLow    ),
    .xH1_L0                 ( lgH1_L0       ),
    .m3step                 ( lgStep        ) 
); // motoro3_step_to_mosdriver lMos

motoro3_mos_driver
mD
(
    .mosHp                  ( lgHp          ),
    .mosLp                  ( lgLp          ),

    .pwm                    ( lgPWM         ),
    .mosEnable              ( lgEE          ),
    .h1_L0                  ( lgH1_L0       ),
    .forceLow               ( lgForceLow    ),

    .nRst                   ( nRst          ),
    .clk                    ( clk           )  
); // motoro3_mos_driver mD


endmodule
