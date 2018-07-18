module motoro3_step_generator(
    m3stepA         ,
    m3stepB         ,
    m3stepC         ,
    m3cnt           ,

    m3start         ,
    m3freqINC       ,
    m3freqDEC       ,

    m3cntLast1      ,

    nRst,
    clk
);

// 0: idle
// 1,2,3,4,5,6:nomal
// 7:force stop
output  reg     [3:0]       m3stepA;	
output  reg     [3:0]       m3stepB;	
output  reg     [3:0]       m3stepC;	
output  reg     [24:0]      m3cnt;	
output  wire                m3cntLast1 ;

input   wire                m3start;	
input   wire                m3freqINC;	 
input   wire                m3freqDEC;	 

input   wire                clk;			// 10MHz
input   wire                nRst;		

wire            [24:0]      m3cnt_reload1;	
reg                         m3start_clked1;	
wire                        m3start_up1;	

reg             [64:0]      roundCNT                ;	

assign  m3cntLast1 = ( m3cnt[24:1] == 24'd0 )? 1'd1:1'd0 ;


assign  m3start_up1 = (m3start) && (~m3start_clked1) ;
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        m3start_clked1      <= 0 ;
    end
    else begin
        m3start_clked1      <= m3start      ;
    end
end

//( per pwmSTEP 511clk, 51us )
`ifndef m3cnt_reload1_now 
`ifdef synthesising
//`define m3cnt_reload1_now    25'd666_666
`define m3cnt_reload1_now    25'd1_666_667  
`endif
`ifdef simulating
`define m3cnt_reload1_now    25'd16_667   // 1_666.7us * 12 == 20_000 us == 20ms == 50Hz , 16667/511==32pwmSTEP
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
        m3stepA                 <= 4'd0             ;
    end
    else begin
        if ( m3start_up1 == 1 ) begin
            m3stepA             <= 4'd1             ;
        end
        else begin
            if ( m3cntLast1 == 1'd1 ) begin
                if ( m3stepA== 4'd12 ) begin
                    m3stepA     <= 4'd1             ;
                end
                else begin
                    m3stepA     <= m3stepA+ 4'd1    ;
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
            if ( m3stepA== 4'd6 && m3cntLast1 == 1'd1 ) begin
                roundCNT    <= roundCNT + 48'd1 ;
            end
        end
        else begin
            roundCNT        <= 48'd0 ;
        end
    end
end

always @( m3stepA ) begin
    case ( m3stepA )
        4'd1    :   begin   m3stepB = 4'd9  ;   m3stepC = 4'd5  ;   end
        4'd2    :   begin   m3stepB = 4'd10 ;   m3stepC = 4'd6  ;   end
        4'd3    :   begin   m3stepB = 4'd11 ;   m3stepC = 4'd7  ;   end
        4'd4    :   begin   m3stepB = 4'd12 ;   m3stepC = 4'd8  ;   end
                                                                   
        4'd5    :   begin   m3stepB = 4'd1  ;   m3stepC = 4'd9  ;   end
        4'd6    :   begin   m3stepB = 4'd2  ;   m3stepC = 4'd10 ;   end
        4'd7    :   begin   m3stepB = 4'd3  ;   m3stepC = 4'd11 ;   end
        4'd8    :   begin   m3stepB = 4'd4  ;   m3stepC = 4'd12 ;   end
                                                                   
        4'd9    :   begin   m3stepB = 4'd5  ;   m3stepC = 4'd1  ;   end
        4'd10   :   begin   m3stepB = 4'd6  ;   m3stepC = 4'd2  ;   end
        4'd11   :   begin   m3stepB = 4'd7  ;   m3stepC = 4'd3  ;   end
        4'd12   :   begin   m3stepB = 4'd8  ;   m3stepC = 4'd4  ;   end
                                                                   
        default :   begin   m3stepB = 4'hF  ;   m3stepC = 4'hF  ;   end
    endcase

end

endmodule
