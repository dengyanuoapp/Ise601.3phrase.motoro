module clkGenForMotoro3(
    clkM3,
    nRst,
    clk50mhz

);

output  reg                 clkM3 ;	
input   wire                nRst;		
input   wire                clk50mhz;

reg     [2:0]               cnt ;	

always @ (negedge clk50mhz or negedge nRst) begin
    if(!nRst) begin
        clkM3           <= 1'b0 ;
        cnt             <= 3'd4 ;
    end
    else begin
        if ( cnt == 3'd0 ) begin
            clkM3       <= ~clkM3 ;
            cnt         <= 3'd4 ;
        end 
        else begin
            cnt         <= cnt - 3'd1 ;
        end
    end
end

endmodule
