module motoro3_mos_driver(

    mosH            ,
    mosL            ,

    mosEnable       ,		
    h1_L0           ,		

    nRst,
    clk

);

output  reg                 mosH            ;		
output  reg                 mosL            ;		

input   wire                mosEnable       ;		
input   wire                h1_L0           ;		

input   wire                clk             ;			// 10MHz
input   wire                nRst            ;		

reg                         mosEnable_clked1;	
wire                        mosEnable_up1;	
wire                        mosEnable_down1;	

assign  mosEnable_up1       = (mosEnable) && (~mosEnable_clked1) ;
assign  mosEnable_down1     = (~mosEnable) && (mosEnable_clked1) ;
always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        mosEnable_clked1      <= 0 ;
    end
    else begin
        mosEnable_clked1      <= mosEnable ;
    end
end

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        mosH                    <= 1'b0 ;
        mosL                    <= 1'b0 ;
    end
    else begin
        if ( mosEnable_up1 ) begin
            if ( h1_L0 == 1 ) begin
                mosH            <= 1'b1 ;
                mosL            <= 1'b0 ;
            end
            else begin
                mosH            <= 1'b0 ;
                mosL            <= 1'b1 ;
            end
        end
        if ( mosEnable_down1 ) begin
            if ( h1_L0 == 1 ) begin
                mosH            <= 1'b1 ;
                mosL            <= 1'b0 ;
            end
            else begin
                mosH            <= 1'b0 ;
                mosL            <= 1'b1 ;
            end
        end
    end
end

endmodule
