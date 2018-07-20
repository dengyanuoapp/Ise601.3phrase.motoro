module motoro3_line_calc_parameter(
    pwmLenWant                      ,
    pwmMinMask                      ,
    lcStep                   
);

input   wire    [11:0]      pwmLenWant          ;	
input   wire    [11:0]      pwmMinMask          ;	
input   wire    [3:0]       lcStep          ;	


wire            [15:0]      slLen           ;	
wire            [15:0]      plLen           ;	

motoro3_calc_pwm_len
lcPWMlen
(
    .plLen              ( plLen             ),
    .pwmLenWant         ( pwmLenWant        ),
    .pwmMinMask         ( pwmMinMask        ),
    .slLen              ( slLen             ),

    .lcStep             ( lcStep            ) 
);// motoro3_calc_pwm_len 

motoro3_calc_sine_len_against_to_step
lcSINEline
(
    .slLen              ( slLen             ) ,
    .lcStep             ( lcStep            ) 
);// motoro3_calc_sine_len_against_to_step 

endmodule
