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

output  reg                 aH ;	
output  reg                 aL ;	
output  reg                 bH ;	
output  reg                 bL ;	
output  reg                 cH ;	
output  reg                 cL ;	

input   wire                m3start;	
input   wire                m3invOrStop;	 
input   wire    [9:0]       m3freq;	

input   wire                clkHI;
input   wire                clk;			// 10MHz
input   wire                nRst;		

reg                         m3start_clked1       ;	
reg                         m3invOrStop_clked1   ;	 
reg             [9:0]       m3freq_clked1        ;	

//reg                         m3start_clked2       ;	
//reg                         m3invOrStop_clked2   ;	 
//reg             [9:0]       m3freq_clked2        ;	

wire                        aH_ii       ;	
wire                        aL_ii       ;	
wire                        bH_ii       ;	
wire                        bL_ii       ;	
wire                        cH_ii       ;	
wire                        cL_ii       ;	

always @ (posedge clk or negedge nRst) begin
    if(!nRst) begin
        m3start_clked1              <= 0                ;
        m3freq_clked1               <= 0                ;
        m3invOrStop_clked1          <= 0                ;
    end
    else begin
        m3start_clked1              <= m3start          ;
        m3invOrStop_clked1          <= m3invOrStop      ;
        if ( m3freq > 10'd1000) begin
            m3freq_clked1           <= m3freq           ;
        end
        else begin
            m3freq_clked1           <= 10'd1000         ;
        end
    end
end

always @ (posedge clk or negedge nRst) begin
    if(!nRst) begin
        aH                          <= 0                ;
        aL                          <= 0                ;
        bH                          <= 0                ;
        bL                          <= 0                ;
        cH                          <= 0                ;
        cL                          <= 0                ;
    end
    else begin
        aH                          <= aH_ii            ;
        aL                          <= aL_ii            ;
        bH                          <= bH_ii            ;
        bL                          <= bL_ii            ;
        cH                          <= cH_ii            ;
        cL                          <= cL_ii            ;
    end
end


//always @ (negedge clk or negedge nRst) begin
//    if(!nRst) begin
//        m3start_clked2              <= 0                   ;
//        m3freq_clked2               <= 0                   ;
//        m3invOrStop_clked2          <= 0                   ;
//    end
//    else begin
//        m3start_clked2              <= m3start_clked1      ;
//        m3invOrStop_clked2          <= m3invOrStop_clked1  ;
//        m3freq_clked2               <= m3freq_clked1       ;
//    end
//end

motoro3_real
r
(
    .aH                     (   aH_ii                   ),
    .aL                     (   aL_ii                   ),
    .bH                     (   bH_ii                   ),
    .bL                     (   bL_ii                   ),
    .cH                     (   cH_ii                   ),
    .cL                     (   cL_ii                   ),
                                               
//    .m3start                (   m3start_clked2           ),
//    .m3freq                 (   m3freq_clked2            ),
//    .m3invOrStop            (   m3invOrStop_clked2       ),
    .m3start                (   m3start_clked1           ),
    .m3freq                 (   m3freq_clked1            ),
    .m3invOrStop            (   m3invOrStop_clked1       ),
                           
    .nRst                   (   nRst                    ),
    .clk                    (   clk                     )
);

endmodule
