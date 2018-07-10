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

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        mosH                    <= 1'b0 ;
        mosL                    <= 1'b0 ;
    end
    else begin
        if ( mosEnable == 1'b1 ) begin
            if ( h1_L0 == 1'b1 ) begin
                mosH            <= 1'b1 ;
                mosL            <= 1'b0 ;
                if ( mosL == 1'b1 ) begin mosH <= 1'b0 ; end 
            end
            else begin
                mosH            <= 1'b0 ;
                mosL            <= 1'b1 ;
                if ( mosH == 1'b1 ) begin mosL <= 1'b0 ; end 
            end
        end
        else begin
                mosH            <= 1'b0 ;
                mosL            <= 1'b0 ;
        end
    end
end

endmodule
