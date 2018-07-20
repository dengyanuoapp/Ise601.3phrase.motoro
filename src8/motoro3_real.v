module motoro3_real(
    aHp,
    aLp,
    bHp,
    bLp,
    cHp,
    cLp,

    m3start         ,
    m3forceStop     ,
    m3invRotate     ,
    m3freqINC       ,
    m3freqDEC       ,

    nRst,
    clk

);

output  wire                aHp                     ;	
output  wire                aLp                     ;	
output  wire                bHp                     ;	
output  wire                bLp                     ;	
output  wire                cHp                     ;	
output  wire                cLp                     ;	

input   wire                m3start                 ;	

// if 0 , normal . 
// if 1 -> force stop ,according to the m3freq : 0 -> forceStop ; or , inverse. 
input   wire                m3forceStop             ;	 
input   wire                m3invRotate             ;	 

// freq 1 - 1000, ==> 60 - 60,000 rpm(round per minutes)
input   wire                m3freqINC               ;	 
input   wire                m3freqDEC               ;	 

input   wire                clk                     ;			// 10MHz
input   wire                nRst                    ;		
                                                   
wire            [3:0]       m3LstepA                ;	
wire            [3:0]       m3LstepB                ;	
wire            [3:0]       m3LstepC                ;	
wire            [24:0]      m3cnt                   ;	
wire                        m3cntLast1              ;
wire            [24:0]      m3reg_step_cnt_reload1  ;	
wire            [7:0]       m3reg_power_percent     ;	
wire            [7:0]       pwmLenWant              ;	
wire            [7:0]       pwmMinMask              ;	

motoro3_regs
m3reg
(
    .m3reg_step_cnt_reload1 ( m3reg_step_cnt_reload1    ),
    .m3reg_power_percent    ( m3reg_power_percent       ),
    .pwmLenWant             ( pwmLenWant                ),
    .pwmMinMask             ( pwmMinMask                ),

    .nRst                   ( nRst                      ),
    .clk                    ( clk                       )
);// motoro3_state_machine

motoro3_step_generator
sg
(
    .m3stepA                ( m3LstepA                  ),
    .m3stepB                ( m3LstepB                  ),
    .m3stepC                ( m3LstepC                  ),
                                                       
    .m3cnt                  ( m3cnt                     ),
    .m3cntLast1             ( m3cntLast1                ),
    .m3start                ( m3start                   ),
    .m3freqINC              ( m3freqINC                 ),
    .m3freqDEC              ( m3freqDEC                 ),

    .m3reg_step_cnt_reload1 ( m3reg_step_cnt_reload1    ),

    .nRst                   ( nRst                      ),
    .clk                    ( clk                       )
);// motoro3_state_machine

motoro3_line_generator
lgA
(
    .lgStep                 ( m3LstepA                  ),
    .lgHp                   ( aHp                       ),
    .lgLp                   ( aLp                       ),

    .m3cnt                  ( m3cnt                     ),
    .m3cntLast1             ( m3cntLast1                ),

    .m3reg_power_percent    ( m3reg_power_percent       ),
    .m3reg_step_cnt_reload1 ( m3reg_step_cnt_reload1    ),
    .pwmLenWant             ( pwmLenWant                ),
    .pwmMinMask             ( pwmMinMask                ),

    .nRst                   ( nRst                      ),
    .clk                    ( clk                       )  
);// motoro3_line_generator lgA
motoro3_line_generator
lgB
(
    .lgStep                 ( m3LstepB                  ),
    .lgHp                   ( bHp                       ),
    .lgLp                   ( bLp                       ),

    .m3cnt                  ( m3cnt                     ),
    .m3cntLast1             ( m3cntLast1                ),

    .m3reg_power_percent    ( m3reg_power_percent       ),
    .m3reg_step_cnt_reload1 ( m3reg_step_cnt_reload1    ),
    .pwmLenWant             ( pwmLenWant                ),
    .pwmMinMask             ( pwmMinMask                ),

    .nRst                   ( nRst                      ),
    .clk                    ( clk                       )  
);// motoro3_line_generator lgB
motoro3_line_generator
lgC
(
    .lgStep                 ( m3LstepC                  ),
    .lgHp                   ( cHp                       ),
    .lgLp                   ( cLp                       ),

    .m3cnt                  ( m3cnt                     ),
    .m3cntLast1             ( m3cntLast1                ),

    .m3reg_power_percent    ( m3reg_power_percent       ),
    .m3reg_step_cnt_reload1 ( m3reg_step_cnt_reload1    ),
    .pwmLenWant             ( pwmLenWant                ),
    .pwmMinMask             ( pwmMinMask                ),

    .nRst                   ( nRst                      ),
    .clk                    ( clk                       )  
);// motoro3_line_generator lgC

endmodule
