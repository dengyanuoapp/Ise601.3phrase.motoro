module motoro3_line_calc_parameter(
    m3LpwmStep                  ,
    m3r_power_percent           ,	
    m3r_stepCNT_speedSET        ,	
    m3r_pwmLenWant              ,
    m3r_pwmMinMask              ,
    m3r_stepSplitMax            ,	
    lcStep                   
);

input   wire    [1:0]       m3LpwmStep              ;	
input   wire    [7:0]       m3r_power_percent       ;	// to control the percent of power , max 255 % , min 1 %.
input   wire    [24:0]      m3r_stepCNT_speedSET    ;	 // to control the speed
input   wire    [11:0]      m3r_pwmLenWant          ;	
input   wire    [11:0]      m3r_pwmMinMask          ;	
input   wire    [1:0]       m3r_stepSplitMax        ;	
input   wire    [3:0]       lcStep                  ;	
                                                   
                                                   
wire            [15:0]      slLen                   ;	
wire            [15:0]      plLen                   ;	

motoro3_calc_pwm_len
lcPWMlen
(
    .m3LpwmStep             ( m3LpwmStep                ),
    .plLen                  ( plLen                     ),
    .m3r_power_percent      ( m3r_power_percent         ),
    .m3r_stepCNT_speedSET   ( m3r_stepCNT_speedSET      ),
    .m3r_pwmLenWant         ( m3r_pwmLenWant            ),
    .m3r_pwmMinMask         ( m3r_pwmMinMask            ),
    .m3r_stepSplitMax       ( m3r_stepSplitMax          ),
    .slLen                  ( slLen                     ),
                                                       
    .lcStep                 ( lcStep                    ) 
);// motoro3_calc_pwm_len 

motoro3_calc_sine_len_against_to_step
lcSINEline
(
    .slLen                  ( slLen                     ),
    .lcStep                 ( lcStep                    ) 
);// motoro3_calc_sine_len_against_to_step 

endmodule
