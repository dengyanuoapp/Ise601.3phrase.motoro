module motoro301_top(

    tp01,
    tp02,
    rs232_tx,

    led4,
    nReset,
    clk50mhz

);

output  wire                tp01;	
output  wire                tp02;	
output  wire                rs232_tx;	

output  wire    [3:0]       led4;	
input   wire                clk50mhz;			// 50MHz
input   wire                nReset;		// reset button on the core board
                           
wire                        clk_rs232_tx ;

//assign {tp01 , tp02 } = { nReset , ~nReset };
assign {tp01 , tp02 } = { clk_rs232_tx , ~clk_rs232_tx };

led4
led4x01(
    .led        (   led4        ),

    .nrst       (   nReset      ),
    .clk        (   clk50mhz    )
);

uart_block_19_top
uart_block_19_top__01(
    .rs232_tx   (   rs232_tx    ),
    .clk_rs232_tx  (   clk_rs232_tx   ),

    .nrst       (   nReset      ),
    .clk_in     (   clk50mhz    )
);

endmodule
