module motoro3_real(
    aH,
    aL,
    bH,
    bL,
    cH,
    cL,

    m3start         ,
    m3invOrStop     ,
    m3freq          ,

    nRst,
    clk

);

output  reg                 aH ;	
output  reg                 aL ;	
output  reg                 bH ;	
output  reg                 bL ;	
output  reg                 cH ;	
output  reg                 cL ;	

input   wire                m3start;	

// if 0 , normal . 
// if 1 -> force stop ,according to the m3freq : 0 -> forceStop ; or , inverse. 
input   wire                m3invOrStop;	 

// freq 1 - 1000, ==> 60 - 60,000 rpm(round per minutes)
input   wire    [9:0]       m3freq;	

input   wire                clk;			// 10MHz
input   wire                nRst;		

wire            [3:0]       m3step;	
wire            [16:0]      m3cnt;	


motoro3_state_machine
st
(
    .m3step                 ( m3step        ),
    .m3cnt                  ( m3cnt         ),
    .m3start                ( m3start       ),
    .m3freq                 ( m3freq        ),

    .nRst                   ( nRst ),
    .clk                    ( clk )
);

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        { aH , aL , bH , bL , cH , cL  } <= 6'd0 ;
    end
    else begin
    end
end


endmodule
