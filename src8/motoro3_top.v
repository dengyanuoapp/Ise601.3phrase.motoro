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

output  wire                aH ;	
output  wire                aL ;	
output  wire                bH ;	
output  wire                bL ;	
output  wire                cH ;	
output  wire                cL ;	

input   wire                m3start;	
input   wire                m3invOrStop;	 
input   wire    [9:0]       m3freq;	

input   wire                clk;			// 10MHz
input   wire                nRst;		

reg                         m3start_clked       ;	
reg                         m3invOrStop_clked   ;	 
reg             [9:0]       m3freq_clked        ;	

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        m3start_clked           <= 0                ;
        m3freq_clked            <= 0                ;
        m3invOrStop_clked       <= 0                ;
    end
    else begin
        m3start_clked           <= m3start          ;
        m3freq_clked            <= m3freq           ;
        m3invOrStop_clked       <= m3invOrStop      ;
    end
end

motoro3_real
r
(
    .aH                     (   aH                      ),
    .aL                     (   aL                      ),
    .bH                     (   bH                      ),
    .bL                     (   bL                      ),
    .cH                     (   cH                      ),
    .cL                     (   cL                      ),
                                               
    .m3start                (   m3start_clked           ),
    .m3freq                 (   m3freq_clked            ),
    .m3invOrStop            (   m3invOrStop_clked       ),
                           
    .nRst                   (   nRst                    ),
    .clk                    (   clkM3                   )
);

endmodule
