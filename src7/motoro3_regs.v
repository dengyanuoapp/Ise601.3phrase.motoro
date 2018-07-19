module motoro3_regs(
    m3reg_step_cnt_reload1  ,	
    m3reg_power_percent     ,	
    pwmLen                  ,	
    pwmMin                  ,	

    nRst,
    clk
);


output  wire    [24:0]      m3reg_step_cnt_reload1  ;	 // to control the speed
output  wire    [7:0]       m3reg_power_percent     ;	// to control the percent of power , max 255 % , min 1 %.
output  wire    [7:0]       pwmLen                  ;	
output  wire    [7:0]       pwmMin                  ;	

input   wire                clk                     ;			// 10MHz
input   wire                nRst                    ;		


//( per pwmSTEP 511clk, 51us )
`ifndef m3cnt_reload1_now 
`ifdef synthesising
//`define m3cnt_reload1_now    25'd666_666
`define m3cnt_reload1_now    25'd1_666_667  
`endif
`ifdef simulating
`define m3cnt_reload1_now    25'd16_667   // 1_666.7us * 12 == 20_000 us == 20ms == 50Hz , 16667/511==32pwmSTEP
//`define m3cnt_reload1_now    25'd166_667
`endif
`endif

`ifndef m3cnt_reload1_now 
always begin
$error( "you should define synthesising/simulatingVERIDI , or m3cnt_reload1_now, then run again" );
$finish;
end
`endif

//assign m3reg_step_cnt_reload1 = { 1'd0, m3freq , 6'd0 };
//assign m3reg_step_cnt_reload1 = 25'd1_667      ; // 6*1_667        == 1,000.2 us       == 1000Hz
//assign m3reg_step_cnt_reload1 = 25'd16_667     ; // 6*16_667       == 10,000.2 us      == 100Hz
//assign m3reg_step_cnt_reload1 = 25'd166_667    ; // 6*166_667      == 100,000.2 us     == 10Hz
//assign m3reg_step_cnt_reload1 = 25'd333_333    ; // 6*333_333      == 200,000.4 us     == 5Hz
//assign m3reg_step_cnt_reload1 = 25'd666_666    ; // 6*666_666      == 400,000.8 us     == 2.5Hz
//assign m3reg_step_cnt_reload1 = 25'd1_666_667  ; // 6*1_666_667    == 1,000,000.2 us   == 1Hz
assign m3reg_step_cnt_reload1 = `m3cnt_reload1_now ;

assign m3reg_power_percent      = 8'h10 ;

assign pwmLen      = 8'd9 ;
assign pwmMin      = 8'd9 ;


endmodule
