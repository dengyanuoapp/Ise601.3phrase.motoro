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

reg             [8:0]       pwmCNT                  ;	
wire                        pwmCNTlast = pwmCNT[8]  ;
wire            [8:0]       pwmCNTload1             ;	
wire            [8:0]       pwmCNTload2             ;	
wire            [8:0]       pwmCNTinput             ;	
reg             [8:0]       pwmCNTinput_clked1       ;	

`define pwmTest     8'h10

assign pwmCNTinput = { 1'b0 , `pwmTest                        }   ;
assign pwmCNTload1 = pwmCNTinput_clked1                          ; // MOS on  time
assign pwmCNTload2 = { 1'b0 , pwmCNTinput_clked1[7:0] ^ 8'hff }  ; // MOS off time
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
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        pwmCNT                  <= pwmCNTload2 ;
        pwm                     <= 1'b0 ;
    end
    else begin
        if ( m3cntLast1 == 1'd1 || { aE , bE , cE } == 3'b000 ) begin
            pwm                  <= 1'b0 ;
            pwmCNT               <= pwmCNTload2 ;
            if ( pwmCNTinput == 9'hff ) begin
                pwm              <= 1'b1 ;
            end
        end
        else begin
            if ( pwmCNTinput_clked1 == 9'hff ) begin
                pwm         <= 1'b1 ;
            end
            else begin
            end
        end
    end
end



endmodule
