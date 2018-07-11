module uart_set_show_config_top(
    busDefault,
    busNow,

    uTx,
    clkUtx ,

    nRst,
    clk10mhz

);

input   wire    [7:0]       busDefault ;
output  wire    [7:0]       busNow ;
input   wire                clk10mhz;			// 50MHz
input   wire                nRst;		// reset button on the core board
                           
output  wire                clkUtx;	
output  wire                uTx;	

wire            [7:0]       o8;
wire            [7:0]       i8;
wire            [7:0]       addr8;
wire                        r1_w0;


wire                        bps_start2;	
wire            [7:0]       txData8;	
wire                        txBusy;		

assign txData8  =   'h08;
assign busNow   =   0 ;

uart_clkgen_10mhz_115200		
ucg01(	
    .clk10mhz(clk10mhz),	//
    .nRst(nRst),
    .clkUtx(clkUtx)
);

uart_tx			
tx01(		
    .uTx(uTx),

    .txBusy(txBusy),
    .txData8(txData8),
    .txStart(1'b0),

    .nRst(nRst),
    .clk(clkUtx)
);

endmodule
