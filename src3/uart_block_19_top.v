module uart_block_19_top(
    rs232_tx,
    clk_rs232_tx ,

    nrst,
    clk_in

);

input   wire                clk_in;			// 50MHz
input   wire                nrst;		// reset button on the core board
                           
output  wire                clk_rs232_tx;	
output  wire                rs232_tx;	


wire bps_start2;	
wire[7:0] rx_data;	
wire rx_int;		

assign rx_data = 'h08;

uart_clkgen		
uart_clkgen01(	
    .clk_in(clk_in),	//
    .rst_n(nrst),
    .bps_start(bps_start2),
    .clk_rs232_tx(clk_rs232_tx)
);

uart_tx			
uart_tx01(		
    .clk_in(clk_in),	//
    .rst_n(nrst),
    .rx_data(rx_data),
    .rx_int(rx_int),
    .rs232_tx(rs232_tx),
    .clk_rs232_tx(clk_rs232_tx),
    .bps_start(bps_start2)
);

endmodule
