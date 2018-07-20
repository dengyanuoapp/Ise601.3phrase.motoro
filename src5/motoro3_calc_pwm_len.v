module motoro3_calc_pwm_len(
    plLen                   ,
    pwmLenWant              ,
    pwmMinMask              ,
    lcStep                  ,

    slLen                 
);

input   wire    [7:0]       pwmLenWant      ;	
input   wire    [7:0]       pwmMinMask      ;	
input   wire    [3:0]       lcStep          ;	
input   wire    [15:0]      slLen           ;	

output  wire    [15:0]      plLen           ;	

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

endmodule
