module clkGenForMotoro3(
    clkM3,
    nRst,
    clk50mhz

);

output  reg                 clkM3 ;	
input   wire                nRst;		
input   wire                clk50mhz;

reg     [3:0]               cnt ;	

always @ (negedge clk50mhz or negedge nRst) begin
    if(!nRst) begin
        cnt             <= 4'd4 ;
        clkM3           <= 1'b0 ;
    end
    else begin
        if ( cnt == 4'd0 ) begin
            cnt         <= 4'd4 ;
            clkM3       <= 1'b0 ;
        end 
        else begin
            if ( cnt == 4'd2 ) begin
                clkM3   <= 1'b1 ;
            end 
            cnt         <= cnt - 4'd1 ;
        end
    end
end

endmodule
