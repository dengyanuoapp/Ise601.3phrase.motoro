module motoro3_state_machine(

    m3stepA         ,
    m3stepB         ,
    m3stepC         ,
    m3cnt           ,
    m3cntLast1      ,

    m3start         ,
    m3freq          ,

    nRst,
    clk

);

output  wire    [3:0]       m3stepA         ;	
output  wire    [3:0]       m3stepB         ;	
output  wire    [3:0]       m3stepC         ;	

output  wire    [24:0]      m3cnt           ;	
output  wire                m3cntLast1      ;

input   wire                m3start         ;	
input   wire    [9:0]       m3freq          ;	

input   wire                clk             ;			// 10MHz
input   wire                nRst            ;		




motoro3_step_generator
stepgen
(
    .m3start            ( m3start       ),
    .m3freq             ( m3freq        ),
                                       
    .m3stepA            ( m3stepA       ),
    .m3stepB            ( m3stepB       ),
    .m3stepC            ( m3stepC       ),
    .m3cnt              ( m3cnt         ),
    .m3cntLast1         ( m3cntLast1    ),
                                       
    .nRst               ( nRst          ),
    .clk                ( clk           ) 
);

endmodule
