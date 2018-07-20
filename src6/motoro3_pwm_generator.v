module motoro3_pwm_generator(

    pwmLenWant          ,
    pwmMinMask          ,
    pwm             ,		

    m3cnt           ,
    m3cntLast1      ,

    nRst,
    clk

);

input   wire    [7:0]       pwmLenWant          ;	
input   wire    [7:0]       pwmMinMask          ;	
output  reg                 pwm             ;		

input   wire                m3cntLast1      ;		
input   wire    [24:0]      m3cnt;	

input   wire                clk;			// 10MHz
input   wire                nRst;		

reg             [12:0]      pwmCNT                  ;	
wire                        pwmCNTlast = (pwmCNT[12:1] == 12'd0)? 1'd1 : 1'd0  ;
wire            [12:0]      pwmCNTload1             ;	
wire            [12:0]      pwmCNTload2             ;	
wire            [12:0]      pwmCNTinput             ;	
reg             [12:0]      pwmCNTinput_clked1      ;	
wire                        pwmCNTreload            ;

// clk freq : 10Mhz , 100ns , 0.1us
// max period   : 0xfff : 4095 * 0.1us == 410us --> 2.44kHz
// min MOS open : 0x10  : 16   * 0.1us == 1.6us  (min set to 16: mosDriver2003/2007 raise/failing time 150ns )
// min MOS open : 0x20  : 32   * 0.1us == 3.2us  (min set to 32: mosDriver2003/2007 raise/failing time 150ns )

//`define pwmTest      12'h10 //   16(0x10) of 511(0x1ff) * 0.1us == 1.6us // test , failed , MOS can not work. none wave in the MOSFET
`define pwmTest      12'h20 //   32(0x20) of 511(0x1ff) * 0.1us == 3.1us // so , this is the min can be used.
//`define pwmTest      12'h40 //   64(0x40) of 511(0x1ff) * 0.1us == 6.4us
//`define pwmTest      12'h80 // 
//`define pwmTest      12'h100 // 
//`define pwmTest      12'h110 //  half of 511(0x1ff) * 0.1us == 26us
//`define pwmTest      5'h10 // 1.56us // lost... the FPGA output lost... so, the MOSFET must be lost.

assign pwmCNTinput = { 1'b0 , `pwmTest                        }   ;
assign pwmCNTload1 = pwmCNTinput_clked1                          ; // MOS on  time
//assign pwmCNTload2 = { 1'b0 , pwmCNTinput_clked1[11:0] ^ 12'hfff }  ; // MOS off time
assign pwmCNTload2 = { 1'b0 , (( pwmCNTinput_clked1[11:0] ^ 12'hFFF ) & 12'h1ff) }  ; // MOS off time
always @ (posedge clk or negedge nRst) begin
    if(!nRst) begin
        pwmCNTinput_clked1       <= pwmCNTinput ;
    end
    else begin
        if ( m3cntLast1 == 1'd1 ) begin
            pwmCNTinput_clked1   <= pwmCNTinput ;
        end
    end
end

assign pwmCNTreload = ( m3cntLast1 == 1'd1 ) ;
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        pwmCNT                  <= pwmCNTload2 ;
        pwm                     <= 1'b0 ;
    end
    else begin
        if ( pwmCNTreload == 1'd1 ) begin
            pwm                 <= 1'b0 ;
            pwmCNT              <= pwmCNTload2 ;
            if ( pwmCNTinput == 9'hff ) begin
                pwm             <= 1'b1 ;
            end
        end
        else begin
            if ( pwmCNTinput_clked1 == 9'hff ) begin
                pwm             <= 1'b1 ;
            end
            else begin
                if ( pwmCNTlast == 1'd1 ) begin
                    if ( pwm == 1'b1 ) begin
                        pwmCNT  <= pwmCNTload2 ;
                    end
                    else begin
                        pwmCNT  <= pwmCNTload1 ;
                    end
                    pwm         <= ~pwm ;
                end
                else begin
                    pwmCNT      <= pwmCNT  - 9'd1 ;
                end
            end
        end
    end
end



endmodule
