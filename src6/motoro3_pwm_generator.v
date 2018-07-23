module motoro3_pwm_generator(
    plLen                   ,

    m3r_pwmLenWant          ,
    m3r_pwmMinMask          ,
    m3r_stepSplitMax        ,	
    pwm                     ,		

    m3cnt                   ,
    m3cntLast1              ,

    nRst                    ,
    clk

);

input   wire    [15:0]      plLen                   ;	

input   wire    [11:0]      m3r_pwmLenWant          ;	
input   wire    [11:0]      m3r_pwmMinMask          ;	
input   wire    [1:0]       m3r_stepSplitMax        ;	
output  wire                pwm                     ;		

input   wire                m3cntLast1              ;		
input   wire    [24:0]      m3cnt                   ;	

input   wire                clk                     ;			// 10MHz
input   wire                nRst                    ;		

reg             [11:0]      pwmCNT                  ;	
wire                        pwmCNTreload1           ;
wire                        pwmCNTreload2           ;
wire                        pwmCNTreload3           ;
wire                        pwmCNTreload9           ;
reg                         pwmCNTreload_clked1     ;

wire                        pwmACCreload1           ;
reg             [15:0]      pwmPOScnt               ;	

reg             [15:0]      posRemain               ;	
wire            [15:0]      posSum1                 ;	
wire            [15:0]      posSum2                 ;	
wire            [15:0]      posSum3                 ;	
wire                        posLess                 ;
reg             [15:0]      posACCwant              ;	
reg             [15:0]      posACCreal              ;	

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

assign pwmACCreload1    = (~pwmCNTreload9) & pwmCNTreload_clked1 ;
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        pwmCNTreload_clked1     <= 1'd0             ;
    end
    else begin
        pwmCNTreload_clked1     <= pwmCNTreload9    ;
    end
end

assign pwmCNTreload1 = m3cntLast1 ;
assign pwmCNTreload2 = (pwmCNT == 12'd1 ) ;
assign pwmCNTreload3 = (plLen == 16'd0);
assign pwmCNTreload9 = ( pwmCNTreload1 | pwmCNTreload2 | pwmCNTreload3 );
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        pwmCNT                  <= m3r_pwmLenWant ;
    end
    else begin
        if ( pwmCNTreload9 == 1'd1 ) begin
            pwmCNT              <= m3r_pwmLenWant ;
        end
        else begin
                    pwmCNT      <= pwmCNT  - 9'd1 ;
        end
    end
end

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        posACCwant              <= 16'd0 ;
    end
    else begin
    end
end
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        posACCreal              <= 12'd0 ;
    end
    else begin
    end
end

assign posSum1 = posRemain    + plLen ;
assign posLess = ( posSum1 < m3r_pwmMinMask ) ;
assign posSum2 = ( posLess )? 0 : posSum1 ;
assign posSum3 = ( posLess )? posSum1 : 0 ;
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        posRemain               <= 16'd0 ;
    end
    else begin
        if ( pwmCNTreload1 ) begin
                posRemain       <= posSum3 ;
        end
    end
end
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        pwmPOScnt               <= 16'd0 ;
    end
    else begin
        if ( pwmACCreload1 ) begin
                    pwmPOScnt   <=  posSum2 ;
        end
        else begin
            if ( posLess ) begin
                pwmPOScnt           <= 16'd0 ;
            end
            else begin
                if ( pwmPOScnt ) begin
                    pwmPOScnt   <=  pwmPOScnt - 16'd1 ;
                end
            end
        end
    end
end

assign pwm  = (pwmPOScnt)? 1'b1 : 1'b0 ;


endmodule
