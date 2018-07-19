module motoro3_line_calc_parameter(
    pwmLen                      ,
    pwmMin                      ,
    lcStep                   
);

input   wire    [7:0]       pwmLen          ;	
input   wire    [7:0]       pwmMin          ;	
input   wire    [3:0]       lcStep          ;	


wire            [15:0]      lcConst         ;	

motoro3_calc_sine_len_against_to_step
lcSLen
(
    .slConst            ( lcConst           ) ,
    .slStep             ( lcStep            ) 
);// motoro3_calc_sine_len_against_to_step 

endmodule
