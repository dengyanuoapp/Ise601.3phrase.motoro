module motoro3_top(
    aHP,
    aLN,
    bHP,
    bLN,
    cHP,
    cLN,

    m3start         ,
    m3invOrStop     ,
    m3freq          ,

    nRst,
    clkHI,
    clk

);

output  reg                 aHP ;	
output  reg                 aLN ;	
output  reg                 bHP ;	
output  reg                 bLN ;	
output  reg                 cHP ;	
output  reg                 cLN ;	

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

`define LOWmosINV    ^ 1'b1
//`define LOWmosINV    

`define Aenable     1'b1
`define Benable     1'b1
`define Cenable     1'b1

always @ (posedge clk or negedge nRst) begin
    if(!nRst) begin
        aHP                         <= 0                ;
        bHP                         <= 0                ;
        cHP                         <= 0                ;
        aLN                         <= 0 `LOWmosINV     ;
        bLN                         <= 0 `LOWmosINV     ;
        cLN                         <= 0 `LOWmosINV     ;
    end
    else begin
        aHP                         <= ( aH_ii & `Aenable )       ;
        bHP                         <= ( bH_ii & `Benable )       ;
        cHP                         <= ( cH_ii & `Cenable )       ;

        aLN                         <= ( aL_ii & `Aenable )  `LOWmosINV          ;
        bLN                         <= ( bL_ii & `Benable )  `LOWmosINV          ;
        cLN                         <= ( cL_ii & `Cenable )  `LOWmosINV          ;
    end
end


motoro3_real
r
(
    .aHp                    (   aH_ii                   ),
    .aLp                    (   aL_ii                   ),
    .bHp                    (   bH_ii                   ),
    .bLp                    (   bL_ii                   ),
    .cHp                    (   cH_ii                   ),
    .cLp                    (   cL_ii                   ),
                                               
    .m3start                (   m3start_clked1           ),
    .m3freq                 (   m3freq_clked1            ),
    .m3invOrStop            (   m3invOrStop_clked1       ),
                           
    .nRst                   (   nRst                    ),
    .clk                    (   clk                     )
);

endmodule
