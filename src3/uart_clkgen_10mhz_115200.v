
module uart_clkgen_10mhz_115200(
    bps_start,
    clkUtx,

    rst_n,
    clk10mhz
);

input   wire                clk10mhz;	// 50MHz
input   wire                rst_n;	//
input   wire                bps_start;	//
output  wire                clkUtx;	// clkUtx 

/*
parameter 		bps9600 	= 5207,	//9600bps
bps19200 	= 2603,	//19200bps
bps38400 	= 1301,	//38400bps
bps57600 	= 867,	//57600bps
bps115200	= 433;	//115200bps

parameter 		bps9600_2 	= 2603,
bps19200_2	= 1301,
bps38400_2	= 650,
bps57600_2	= 433,
bps115200_2 = 216;  
*/

//
`define		BPS_PARA		5207	//9600
`define 	BPS_PARA_2		2603	//9600

reg[12:0] cnt;			//
reg clk_tx_reg;			//

//----------------------------------------------------------
reg[2:0] uart_ctrl;	// uart
//----------------------------------------------------------

always @ (posedge clk10mhz or negedge rst_n) begin
    if(!rst_n) cnt <= 13'd0;
    else if((cnt == `BPS_PARA) || !bps_start) cnt <= 13'd0;	//
    else cnt <= cnt+1'b1;			//
end

always @ (posedge clk10mhz or negedge rst_n) begin
    if(!rst_n) clk_tx_reg <= 1'b0;
    //&& bps_start
    else if(cnt == `BPS_PARA_2 && bps_start) clk_tx_reg <= 1'b1;	// clk_tx_reg,
    else clk_tx_reg <= 1'b0;

end

assign clkUtx = clk_tx_reg;

endmodule
