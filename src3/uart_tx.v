
module uart_tx(
    uTx,

    txBusy,
    txData8,
    txStart,

    clkUtx,

    rst_n,
);

output                          uTx;	// RS232

output                          txBusy;	//
input   [7:0]                   txData8;	//
input                           txStart;		//,,

input                           rst_n;		//
input                           clkUtx;		// clk_bps_r,


endmodule
