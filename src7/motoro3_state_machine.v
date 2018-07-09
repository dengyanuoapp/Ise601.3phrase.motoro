module motoro3_state_machine(

    pwm             ,		

    aE              ,		
    aH1_L0          ,		
    bE              ,		
    bH1_L0          ,		
    cE              ,		
    cH1_L0          ,		

    m3step          ,
    m3cnt           ,

    m3start         ,
    m3freq          ,

    nRst,
    clk

);

output  wire                pwm             ;		

output  reg                 aE              ;		
output  reg                 aH1_L0          ;		
output  reg                 bE              ;		
output  reg                 bH1_L0          ;		
output  reg                 cE              ;		
output  reg                 cH1_L0          ;		

// 0: idle
// 1,2,3,4,5,6:nomal
// 7:force stop
output  reg     [3:0]       m3step;	

output  reg     [24:0]      m3cnt;	

input   wire                m3start;	
input   wire    [9:0]       m3freq;	

input   wire                clk;			// 10MHz
input   wire                nRst;		

wire            [24:0]      m3cnt_reload1;	
reg                         m3start_clked1;	
wire                        m3start_up1;	
wire                        m3cntLast1 = ( m3cnt[24:1] == 24'd0 )? 1'd1:1'd0 ;

reg             [64:0]      roundCNT                ;	


motoro3_pwm_generator
pwm01
(
    .pwm                ( pwm         ),
    .aE                 ( aE          ),
    .bE                 ( bE          ),
    .cE                 ( cE          ),
    .m3cnt              ( m3cnt       ),
    .m3cntLast1         ( m3cntLast1  ),
    .nRst               ( nRst        ),
    .clk                ( clk         ) 
);


assign  m3start_up1 = (m3start) && (~m3start_clked1) ;
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        m3start_clked1      <= 0 ;
    end
    else begin
        m3start_clked1      <= m3start      ;
    end
end

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

`ifndef m3cnt_reload1_now 
`ifdef synthesising
`define m3cnt_reload1_now    25'd666_666
`endif
`ifdef simulating
`define m3cnt_reload1_now    25'd16_667
//`define m3cnt_reload1_now    25'd166_667
`endif
`endif

`ifndef m3cnt_reload1_now 
always begin
$error( "you should define synthesising/simulatingVERIDI , or m3cnt_reload1_now, then run again" );
$finish;
end
`endif

//assign m3cnt_reload1 = { 1'd0, m3freq , 6'd0 };
//assign m3cnt_reload1 = 25'd1_667      ; // 6*1_667        == 1,000.2 us       == 1000Hz
//assign m3cnt_reload1 = 25'd16_667     ; // 6*16_667       == 10,000.2 us      == 100Hz
//assign m3cnt_reload1 = 25'd166_667    ; // 6*166_667      == 100,000.2 us     == 10Hz
//assign m3cnt_reload1 = 25'd333_333    ; // 6*333_333      == 200,000.4 us     == 5Hz
//assign m3cnt_reload1 = 25'd666_666    ; // 6*666_666      == 400,000.8 us     == 2.5Hz
//assign m3cnt_reload1 = 25'd1_666_667  ; // 6*1_666_667    == 1,000,000.2 us   == 1Hz
assign m3cnt_reload1 = `m3cnt_reload1_now ;

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        m3cnt               <= m3cnt_reload1            ;
    end
    else begin
        if ( m3start_up1 == 1 || m3cntLast1 == 1) begin
            m3cnt           <= m3cnt_reload1            ;
        end
        else begin
            if ( m3start == 1 ) begin
                m3cnt       <= m3cnt - 25'd1 ;
            end
        end
    end
end

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        m3step                  <= 4'd0             ;
    end
    else begin
        if ( m3start_up1 == 1 ) begin
            m3step              <= 4'd1             ;
        end
        else begin
            if ( m3cntLast1 == 1'd1 ) begin
                if ( m3step == 4'd6 ) begin
                    m3step      <= 4'd1             ;
                end
                else begin
                    m3step      <= m3step + 4'd1    ;
                end
            end
        end
    end
end

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        roundCNT            <= 48'd0 ;
    end
    else begin
        if ( m3start ) begin
            if ( m3step == 4'd6 && m3cntLast1 == 1'd1 ) begin
                roundCNT    <= roundCNT + 48'd1 ;
            end
        end
        else begin
            roundCNT        <= 48'd0 ;
        end
    end
end

endmodule
