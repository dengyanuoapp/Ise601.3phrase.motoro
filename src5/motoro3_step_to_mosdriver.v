module motoro3_step_to_mosdriver(

    aE              ,		
    aH1_L0          ,		
    bE              ,		
    bH1_L0          ,		
    cE              ,		
    cH1_L0          ,		

    m3step           
);


output  reg                 aE              ;		
output  reg                 aH1_L0          ;		
output  reg                 bE              ;		
output  reg                 bH1_L0          ;		
output  reg                 cE              ;		
output  reg                 cH1_L0          ;		

input   wire    [3:0]       m3step;	

`define m3mode01
`ifdef m3mode01
always @( m3step ) begin
    case ( m3step )
        4'd1 :  begin { aE , bE, cE }  = 3'b101 ; { aH1_L0 , bH1_L0 , cH1_L0 } = 3'b100 ; end
        4'd2 :  begin { aE , bE, cE }  = 3'b011 ; { aH1_L0 , bH1_L0 , cH1_L0 } = 3'b010 ; end
        4'd3 :  begin { aE , bE, cE }  = 3'b110 ; { aH1_L0 , bH1_L0 , cH1_L0 } = 3'b010 ; end
        4'd4 :  begin { aE , bE, cE }  = 3'b101 ; { aH1_L0 , bH1_L0 , cH1_L0 } = 3'b001 ; end
        4'd5 :  begin { aE , bE, cE }  = 3'b011 ; { aH1_L0 , bH1_L0 , cH1_L0 } = 3'b001 ; end
        4'd6 :  begin { aE , bE, cE }  = 3'b110 ; { aH1_L0 , bH1_L0 , cH1_L0 } = 3'b100 ; end
        default:begin { aE , bE, cE }  = 3'b000 ; { aH1_L0 , bH1_L0 , cH1_L0 } = 3'b000 ; end
    endcase
end
`else
always @( m3step ) begin
    case ( m3step )
        4'd1 :  begin { aE , bE, cE }  = 3'b111 ; { aH1_L0 , bH1_L0 , cH1_L0 } = 3'b100 ; end
        4'd2 :  begin { aE , bE, cE }  = 3'b111 ; { aH1_L0 , bH1_L0 , cH1_L0 } = 3'b110 ; end
        4'd3 :  begin { aE , bE, cE }  = 3'b111 ; { aH1_L0 , bH1_L0 , cH1_L0 } = 3'b010 ; end
        4'd4 :  begin { aE , bE, cE }  = 3'b111 ; { aH1_L0 , bH1_L0 , cH1_L0 } = 3'b011 ; end
        4'd5 :  begin { aE , bE, cE }  = 3'b111 ; { aH1_L0 , bH1_L0 , cH1_L0 } = 3'b001 ; end
        4'd6 :  begin { aE , bE, cE }  = 3'b111 ; { aH1_L0 , bH1_L0 , cH1_L0 } = 3'b101 ; end
        default:begin { aE , bE, cE }  = 3'b000 ; { aH1_L0 , bH1_L0 , cH1_L0 } = 3'b000 ; end
    endcase
end
`endif

endmodule
