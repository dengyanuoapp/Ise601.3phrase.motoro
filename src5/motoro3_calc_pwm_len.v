module motoro3_calc_pwm_len(
    plLen                       ,
    m3r_power_percent           ,	
    m3r_stepCNT_speedSET        ,	
    m3r_pwmLenWant              ,
    m3r_pwmMinMask              ,
    lcStep                      ,

    slLen                 
);

input   wire    [7:0]       m3r_power_percent       ;	// to control the percent of power , max 255 % , min 1 %.
input   wire    [24:0]      m3r_stepCNT_speedSET    ;	 // to control the speed
input   wire    [11:0]      m3r_pwmLenWant          ;	
input   wire    [11:0]      m3r_pwmMinMask          ;	
input   wire    [3:0]       lcStep                  ;	
input   wire    [15:0]      slLen                   ;	

output  wire    [15:0]      plLen                   ;	

wire            [19:0]      pwmPOS1                 ;	
wire            [11:0]      pwmPOS2                 ;	
wire            [11:0]      pwmPOS9                 ;	

/*
always @( slStep ) begin
    case ( slStep )
                                         
        4'd1    :   begin   pi6 = 16'd17560 ; pi12 = 16'd8628   ; pi24 = 16'd4295   ;   end
        default :   begin   pi6 = 16'd0     ; pi12 = 16'd0      ; pi24 = 16'd0      ;   end
    endcase
end

assign slLen    = pi24 ;
*/
assign plLen    = lcStep + slLen ;

assign  pwmPOS1 =   m3r_power_percent * m3r_pwmLenWant ;
assign  pwmPOS2 =   pwmPOS1[19:8] ;
assign  pwmPOS9 =   (pwmPOS2 < m3r_pwmMinMask) ? m3r_pwmMinMask : pwmPOS2 ;


endmodule
