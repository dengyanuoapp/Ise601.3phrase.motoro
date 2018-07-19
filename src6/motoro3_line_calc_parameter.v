module motoro3_line_calc_parameter(
    pwmLen                      ,
    pwmMin                      ,
    lcStep                   
);

input   wire    [7:0]       pwmLen          ;	
input   wire    [7:0]       pwmMin          ;	
input   wire    [3:0]       lcStep          ;	


wire            [15:0]      slLen           ;	
wire            [15:0]      plLen           ;	

motoro3_calc_pwm_len
lcPWMlen
(
    .plLen              ( plLen             ),
    .pwmLen             ( pwmLen            ),
    .pwmMin             ( pwmMin            ),
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
