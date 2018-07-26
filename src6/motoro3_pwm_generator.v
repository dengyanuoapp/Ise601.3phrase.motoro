module motoro3_pwm_generator(
    pwmLastStep1                ,
    pwmActive1                  ,

    posSumExtA                  ,	
    posSumExtB                  ,	
    posSumExtC                  ,	

    sgStep                      ,
    pwmLENpos                   ,
                               
    m3r_pwmLenWant              ,
    m3r_pwmMinMask              ,
    m3r_stepSplitMax            ,	
    pwm                         ,		
                               
    m3cnt                       ,
    m3cntLast1                  ,
    m3cntLast2                  ,
    m3cntFirst1                 ,
    m3cntFirst2                 ,
                               
    nRst                        ,
    clk

);

input   wire                pwmLastStep1            ;
input   wire                pwmActive1              ;		

output  wire    [15:0]      posSumExtA              ;	
input   wire    [15:0]      posSumExtB              ;	
input   wire    [15:0]      posSumExtC              ;	

input   wire    [3:0]       sgStep                  ;	
input   wire    [15:0]      pwmLENpos               ;	

input   wire    [11:0]      m3r_pwmLenWant          ;	
input   wire    [11:0]      m3r_pwmMinMask          ;	
input   wire    [1:0]       m3r_stepSplitMax        ;	
output  wire                pwm                     ;		

input   wire                m3cntLast1              ;		
input   wire                m3cntLast2              ;		
input   wire                m3cntFirst1             ;		
input   wire                m3cntFirst2             ;		
input   wire    [24:0]      m3cnt                   ;	

input   wire                clk                     ;			// 10MHz
input   wire                nRst                    ;		

reg             [11:0]      pwmCNT                  ;	
wire                        pwmCNTreload1           ;
wire                        pwmCNTreload3           ;

reg             [15:0]      pwmPOScnt               ;	

reg             [15:0]      posRemain1              ;	
wire            [15:0]      posSum1                 ;	
wire            [15:0]      posSum2                 ;	
reg             [2:0]       posSkip1                ;
reg             [15:0]      posACCwant1             ;	
reg             [15:0]      posACCwant2             ;	
reg             [15:0]      posACCwant3             ;	
reg             [15:0]      posACCwant4             ;	
reg             [15:0]      posACCreal1             ;	
reg             [15:0]      posACCreal2             ;	
reg             [15:0]      posACCreal3             ;	
reg             [15:0]      posACCreal4             ;	

wire            [15:0]      pwmMinNow               ;	
reg             [15:0]      posLost1                ;	
wire            [15:0]      posLost2                ;	
reg             [15:0]      posLost3                ;	
wire            [15:0]      posLost4                ;	
reg             [15:0]      posStep                 ;	
reg                         pwmH1L0                 ;	

reg                         m3cntLast3              ;		
reg                         m3cntFirst3              ;		

// // // clk freq : 10Mhz , 100ns , 0.1us
// // // max period   : 0xfff : 4095 * 0.1us == 410us --> 2.44kHz
// // // min MOS open : 0x10  : 16   * 0.1us == 1.6us  (min set to 16: mosDriver2003/2007 raise/failing time 150ns )
// // // min MOS open : 0x20  : 32   * 0.1us == 3.2us  (min set to 32: mosDriver2003/2007 raise/failing time 150ns )
// // 
// // //`define pwmTest      12'h10 //   16(0x10) of 511(0x1ff) * 0.1us == 1.6us // test , failed , MOS can not work. none wave in the MOSFET
// // `define pwmTest      12'h20 //   32(0x20) of 511(0x1ff) * 0.1us == 3.1us // so , this is the min can be used.
// // //`define pwmTest      12'h40 //   64(0x40) of 511(0x1ff) * 0.1us == 6.4us
// // //`define pwmTest      12'h80 // 
// // //`define pwmTest      12'h100 // 
// // //`define pwmTest      12'h110 //  half of 511(0x1ff) * 0.1us == 26us
// // //`define pwmTest      5'h10 // 1.56us // lost... the FPGA output lost... so, the MOSFET must be lost.

assign pwmCNTreload1 = (pwmCNT == 16'd1 ) ;
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        pwmCNT                  <= m3r_pwmLenWant ;
    end
    else begin
        if ( ! pwmActive1 ) begin
            pwmCNT              <= m3r_pwmLenWant ;
        end
        else begin
            if ( m3cntLast1 ) begin
                pwmCNT          <= m3r_pwmLenWant ;
            end
            else begin
                if ( pwmCNTreload1 ) begin
                    pwmCNT      <= m3r_pwmLenWant ;
                end
                else begin
                    pwmCNT      <= pwmCNT  - 9'd1 ;
                end
            end
        end
    end
end

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        posACCreal1             <= 12'd0 ;
    end
    else begin
        if ( m3cntLast2 == 1'd1 ) begin
            posACCreal1         <= 16'd0    ;
        end
        else begin
            if ( pwm == 1'd1 ) begin
                posACCreal1     <=  posACCreal1+ 16'd1 ;
            end
        end
    end
end
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        posACCwant2             <= 16'd0    ;
        posACCreal2             <= 16'd0    ;
    end
    else begin
        if ( m3cntLast2 ) begin
            posACCwant2         <= posACCwant1 ;
            posACCreal2         <= posACCreal1 ;
        end
    end
end
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        posACCwant3             <= 16'd0    ;
        posACCreal3             <= 16'd0    ;
    end
    else begin
        if ( m3cntLast2 ) begin
            case ( sgStep )
                4'd0, 4'd3, 4'd6, 4'd9  : posACCwant3         <= posACCwant1 ;
                default                 : posACCwant3         <= posACCwant3 + posACCwant1 ;
            endcase
            case ( sgStep )
                4'd0, 4'd3, 4'd6, 4'd9  : posACCreal3         <= posACCreal1 ;
                default                 : posACCreal3         <= posACCreal3 + posACCreal1 ;
            endcase
        end
    end
end
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        posACCwant4             <= 16'd0    ;
        posACCreal4             <= 16'd0    ;
    end
    else begin
        if ( m3cntLast2 ) begin
            case ( sgStep )
                4'd0, 4'd6              : posACCwant4         <= posACCwant1 ;
                default                 : posACCwant4         <= posACCwant4 + posACCwant1 ;
            endcase
            case ( sgStep )
                4'd0, 4'd6              : posACCreal4         <= posACCreal1 ;
                default                 : posACCreal4         <= posACCreal4 + posACCreal1 ;
            endcase
        end
    end
end

//assign pwmMinNow    = (m3r_pwmLenWant[11] == 1'b1 ) ? ({4'd0,m3r_pwmMinMask}) : (16'h8000);
//assign pwmMinNow    = ({4'd0,m3r_pwmMinMask}) ;
assign pwmMinNow    = 12'd256;
//assign pwmMinNow    = 12'd32;
//assign pwmMinNow    = 12'd16;
`define skipReason1noActive    3'd7 
`define skipReason0loadPOSnow1 3'd0 
`define skipReason2noHighPull  3'd2 
`define skipReason3minLimit    3'd1 
`define skipReason4loadPOSlast 3'd4 
always @( posSum1 or pwmMinNow or sgStep or posSumExtB or posSumExtC or m3cnt or posSum2 ) begin
    case ( sgStep )
        4'd11 : begin /* C  */
            if      ( posSum1    < pwmMinNow )          begin posSkip1  = `skipReason3minLimit ;        end 
            else begin
                if  ( posSumExtC < posSum1   )          begin posSkip1  = `skipReason2noHighPull ;      end 
                else if  ( m3cnt < posSum2   )          begin posSkip1  = `skipReason4loadPOSlast ;     end 
                else                                    begin posSkip1  = `skipReason0loadPOSnow1 ;     end
            end
        end
        4'd6 : begin // B 
            if      ( posSum1    < pwmMinNow )          begin posSkip1  = `skipReason3minLimit ;        end 
            else begin
                if  ( posSumExtB < posSum1   )          begin posSkip1  = `skipReason2noHighPull ;      end 
                else if  ( m3cnt < posSum2   )          begin posSkip1  = `skipReason4loadPOSlast ;     end 
                else                                    begin posSkip1  = `skipReason0loadPOSnow1 ;     end
            end
        end
        4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5,
        4'd7, 4'd8, 4'd9, 4'd10: begin
            if  ( m3cnt < posSum2 && pwmLastStep1 )     begin posSkip1  = `skipReason4loadPOSlast ;     end 
            else if ( posSum1 < pwmMinNow )             begin posSkip1  = `skipReason3minLimit ;        end
            else                                        begin posSkip1  = `skipReason0loadPOSnow1 ;     end
        end
        default :                                       begin posSkip1  = `skipReason1noActive ;        end   
    endcase
end
assign posSum1 = posRemain1   + pwmLENpos ;
assign posSum2 = posSum1 + pwmLENpos + m3r_pwmLenWant ;

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        posACCwant1             <= 16'd0    ;
    end
    else begin
        if ( ! pwmActive1 ) begin
            posACCwant1             <= 16'd0    ;
        end
        else if ( m3cntFirst2 ) begin
            posACCwant1         <= pwmLENpos;
        end
        else if ( m3cntFirst1 ) begin
            posACCwant1         <=  posACCwant1 + pwmLENpos;
        end
        else if ( pwmCNTreload1 ) begin
            posACCwant1         <=  posACCwant1 + pwmLENpos;
        end
    end
end
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        posRemain1              <= 16'd0 ;
    end
    else begin
        if ( ! pwmActive1 ) begin
            posRemain1          <= 16'd0    ;
        end
        else if ( m3cntFirst2 ) begin
            posRemain1          <= pwmLENpos ;
        end
        else if ( m3cntFirst1 ) begin
            posRemain1         <=  posRemain1 + pwmLENpos;
        end
        else if ( pwmCNTreload1 ) begin
            posRemain1      <= posSum1;
            if ( posSkip1 == `skipReason0loadPOSnow1 )      begin posRemain1      <= pwmLENpos ;    end
            if ( posSkip1 == `skipReason4loadPOSlast )      begin posRemain1      <= pwmLENpos ;    end
        end
    end
end
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        pwmPOScnt               <= 16'd0 ;
    end
    else begin
        if ( m3cntLast2 ) begin
            pwmPOScnt           <= 16'd0 ;
        end
        else begin
            if ( pwmCNTreload1 ) begin
                if ( posSkip1 == `skipReason0loadPOSnow1 ) begin 
                    if ( pwmCNT < m3r_pwmLenWant ) begin 
                        pwmPOScnt  <= posSum1 + pwmLENpos ; 
                    end
                    else begin
                        pwmPOScnt  <= posSum1 ; 
                    end
                end 
                if ( posSkip1 == `skipReason4loadPOSlast ) begin 
                        pwmPOScnt  <= posSum1 ; 
                end 
            end
            else begin
                if ( pwmPOScnt ) begin
                    pwmPOScnt       <=  pwmPOScnt - 16'd1 ;
                end
            end
        end
    end
end
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        posLost1                <= 16'd0 ;
        posLost3                <= 16'd0 ;
    end
    else begin
        if ( m3cntFirst2 ) begin
            posLost1        <= posACCwant2 - posACCreal2 ;
            posLost3        <= posACCwant4 - posACCreal4 ;
        end
    end
end
assign posLost2 = (posLost1[15])?(posLost1^16'hFFFF):posLost1;
assign posLost4 = (posLost3[15])?(posLost3^16'hFFFF):posLost3;

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        posStep                 <= 16'hFF ;
    end
    else begin
        if ( m3cntLast2 ) begin
            posStep         <= sgStep ;
        end
    end
end

always @( sgStep ) begin
    case ( sgStep )
        4'd0 , 4'd1 , 4'd2 , 4'd3 , 4'd4 , 4'd5    :    begin   pwmH1L0 = 1'b1 ; end
        default :                                       begin   pwmH1L0 = 1'b0 ; end
    endcase
end
always @( sgStep or m3cntLast2 ) begin
    case ( sgStep )
        4'd5 , 4'd11    :   begin   m3cntLast3 = m3cntLast2 ; end
        default :           begin   m3cntLast3 = 1'b0 ; end
    endcase
end
always @( sgStep or m3cntFirst2 ) begin
    case ( sgStep )
        4'd0 , 4'd6    :    begin   m3cntFirst3 = m3cntFirst2  ; end
        default :           begin   m3cntFirst3 = 1'b0 ; end
    endcase
end

assign posSumExtA   = posSum1   ;

wire                        pwm01 ;
assign pwm01    = (pwmPOScnt)? 1'b1 : 1'b0 ;
assign pwm      = pwm01 ;


endmodule
