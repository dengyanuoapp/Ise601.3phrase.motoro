module motoro3_pwm_generator(

    pwm             ,		

    aE              ,		
    bE              ,		
    cE              ,		

    m3cnt           ,
    m3cntLast1      ,

    nRst,
    clk

);

output  reg                 pwm             ;		

input   wire                aE              ;		
input   wire                bE              ;		
input   wire                cE              ;		

input   wire                m3cntLast1      ;		
input   wire    [24:0]      m3cnt;	

input   wire                clk;			// 10MHz
input   wire                nRst;		

reg             [12:0]       pwmCNT                  ;	
wire                        pwmCNTlast = (pwmCNT[12:1] == 12'd0)? 1'd1 : 1'd0  ;
wire            [12:0]       pwmCNTload1             ;	
wire            [12:0]       pwmCNTload2             ;	
wire            [12:0]       pwmCNTinput             ;	
reg             [12:0]       pwmCNTinput_clked1      ;	
wire                        pwmCNTreload            ;

//`define pwmTest     12'hf00
//`define pwmTest     11'h400
//`define pwmTest     10'h200  // 50us
//`define pwmTest      9'h100 // 25us
//`define pwmTest      8'h80 // 12.5us
//`define pwmTest      7'h40 // 6.25us
//`define pwmTest      6'h20 // 3.125us // and , when less than 3us , MOSFET lost
//`define pwmTest      12'h40 // 
//`define pwmTest      12'h80 // 
//`define pwmTest      12'h100 // 
`define pwmTest      12'h110 // 
//`define pwmTest      5'h10 // 1.56us // lost... the FPGA output lost... so, the MOSFET must be lost.

assign pwmCNTinput = { 1'b0 , `pwmTest                        }   ;
assign pwmCNTload1 = pwmCNTinput_clked1                          ; // MOS on  time
//assign pwmCNTload2 = { 1'b0 , pwmCNTinput_clked1[11:0] ^ 12'hfff }  ; // MOS off time
assign pwmCNTload2 = { ( pwmCNTinput_clked1[11:0] ^ 12'hFFF ) & 12'h1ff }  ; // MOS off time
always @ (posedge clk or negedge nRst) begin
    if(!nRst) begin
        pwmCNTinput_clked1       <= pwmCNTinput ;
    end
    else begin
        if ( m3cntLast1 == 1'd1 || { aE , bE , cE } == 3'b000 ) begin
            pwmCNTinput_clked1   <= pwmCNTinput ;
        end
    end
end

assign pwmCNTreload = ( m3cntLast1 == 1'd1 || { aE , bE , cE } == 3'b000 ) ;
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
