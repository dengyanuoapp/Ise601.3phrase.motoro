module motoro3_calc_sine_len_against_to_step(
    lcStep                  ,
    slLen                
);

input   wire    [3:0]       lcStep          ;	
output  wire    [15:0]      slLen           ;	
reg             [15:0]      pi6             ;	
reg             [15:0]      pi12            ;	
reg             [15:0]      pi24            ;	

always @( lcStep ) begin
    case ( lcStep )
                                         
        4'd0    :   begin   pi6 = 16'd17560 ; pi12 = 16'd8628   ; pi24 = 16'd4295   ;   end
        4'd1    :   begin   pi6 = 16'd17560 ; pi12 = 16'd8628   ; pi24 = 16'd12813  ;   end
        4'd2    :   begin   pi6 = 16'd17560 ; pi12 = 16'd25296  ; pi24 = 16'd21111  ;   end
        4'd3    :   begin   pi6 = 16'd17560 ; pi12 = 16'd25296  ; pi24 = 16'd29048  ;   end
                                                                   
        4'd4    :   begin   pi6 = 16'd47976 ; pi12 = 16'd40240  ; pi24 = 16'd36488  ;   end
        4'd5    :   begin   pi6 = 16'd47976 ; pi12 = 16'd40240  ; pi24 = 16'd43304  ;   end
        4'd6    :   begin   pi6 = 16'd47976 ; pi12 = 16'd52442  ; pi24 = 16'd49378  ;   end
        4'd7    :   begin   pi6 = 16'd47976 ; pi12 = 16'd52442  ; pi24 = 16'd54608  ;   end
                                                                  
        4'd8    :   begin   pi6 = 16'd65535 ; pi12 = 16'd61070  ; pi24 = 16'd58904  ;   end
        4'd9    :   begin   pi6 = 16'd65535 ; pi12 = 16'd61070  ; pi24 = 16'd62191  ;   end
        4'd10   :   begin   pi6 = 16'd65535 ; pi12 = 16'd65535  ; pi24 = 16'd64415  ;   end
        4'd11   :   begin   pi6 = 16'd65535 ; pi12 = 16'd65535  ; pi24 = 16'd65535  ;   end
                                                                   
        default :   begin   pi6 = 16'd0     ; pi12 = 16'd0      ; pi24 = 16'd0      ;   end
    endcase
end

assign slLen    = pi24 ;

endmodule
