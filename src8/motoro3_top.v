module motoro3_top(
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

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        { aH , aL , bH , bL , cH , cL  } <= 6'd0 ;
    end
    else begin
    end
end

endmodule
