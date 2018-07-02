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
    clkHI,
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

input   wire                clkHI;
input   wire                clk;			// 10MHz
input   wire                nRst;		

reg                         m3start_clked       ;	
reg                         m3invOrStop_clked   ;	 
reg             [9:0]       m3freq_clked        ;	

always @ (negedge clkHI or negedge nRst) begin
    if(!nRst) begin
        m3start_clked           <= 0                ;
        m3freq_clked            <= 0                ;
        m3invOrStop_clked       <= 0                ;
    end
    else begin
        m3start_clked           <= m3start          ;
        m3invOrStop_clked       <= m3invOrStop      ;
        if ( m3freq > 10'd1000) begin
            m3freq_clked        <= m3freq           ;
        end
        else begin
            m3freq_clked        <= 10'd1000         ;
        end
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
    .clk                    (   clk                     )
);

endmodule
