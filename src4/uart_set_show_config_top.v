module uart_set_show_config_top(
    uTx,
    clkUtx ,

    nrst,
    clk10mhz

);

input   wire                clk10mhz;			// 50MHz
input   wire                nrst;		// reset button on the core board
                           
output  wire                clkUtx;	
output  wire                uTx;	


wire bps_start2;	
wire[7:0] txData8;	
wire txBusy;		

assign txData8 = 'h08;

uart_clkgen_10mhz_115200		
ucg01(	
    .clk10mhz(clk10mhz),	//
    .rst_n(nrst),
    .clkUtx(clkUtx)
);

uart_tx			
tx01(		
    .uTx(uTx),

    .txBusy(txBusy),
    .txData8(txData8),
    .txStart(txStart),

    .rst_n(nrst),
    .clkUtx(clkUtx)
);

endmodule
