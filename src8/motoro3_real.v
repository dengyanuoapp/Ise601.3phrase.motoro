module motoro3_real(
    aHp,
    aLp,
    bHp,
    bLp,
    cHp,
    cLp,

    m3start         ,
    m3invOrStop     ,
    m3freq          ,

    nRst,
    clk

);

output  wire                aHp             ;	
output  wire                aLp             ;	
output  wire                bHp             ;	
output  wire                bLp             ;	
output  wire                cHp             ;	
output  wire                cLp             ;	

input   wire                m3start         ;	

// if 0 , normal . 
// if 1 -> force stop ,according to the m3freq : 0 -> forceStop ; or , inverse. 
input   wire                m3invOrStop     ;	 

// freq 1 - 1000, ==> 60 - 60,000 rpm(round per minutes)
input   wire    [9:0]       m3freq          ;	

input   wire                clk             ;			// 10MHz
input   wire                nRst            ;		

wire            [3:0]       m3stepA         ;	
wire            [3:0]       m3stepB         ;	
wire            [3:0]       m3stepC         ;	
wire            [24:0]      m3cnt           ;	
wire                        m3cntLast1      ;

motoro3_state_machine
st
(
    .m3stepA                ( m3stepA       ),
    .m3stepB                ( m3stepB       ),
    .m3stepC                ( m3stepC       ),

    .m3cnt                  ( m3cnt         ),
    .m3cntLast1             ( m3cntLast1    ),
    .m3start                ( m3start       ),
    .m3freq                 ( m3freq        ),

    .nRst                   ( nRst          ),
    .clk                    ( clk           )
);// motoro3_state_machine

motoro3_sine_generator
sgA
(
    .sgStep                 ( m3stepA       ),
    .sgHp                   ( aHp           ),
    .sgLp                   ( aLp           ),

    .m3cnt                  ( m3cnt         ),
    .m3cntLast1             ( m3cntLast1    ),

    .nRst                   ( nRst          ),
    .clk                    ( clk           )  
);// motoro3_sine_generator sgA
motoro3_sine_generator
sgB
(
    .sgStep                 ( m3stepB       ),
    .sgHp                   ( bHp           ),
    .sgLp                   ( bLp           ),

    .m3cnt                  ( m3cnt         ),
    .m3cntLast1             ( m3cntLast1    ),

    .nRst                   ( nRst          ),
    .clk                    ( clk           )  
);// motoro3_sine_generator sgB
motoro3_sine_generator
sgC
(
    .sgStep                 ( m3stepC       ),
    .sgHp                   ( bHp           ),
    .sgLp                   ( bLp           ),

    .m3cnt                  ( m3cnt         ),
    .m3cntLast1             ( m3cntLast1    ),

    .nRst                   ( nRst          ),
    .clk                    ( clk           )  
);// motoro3_sine_generator sgC

endmodule
