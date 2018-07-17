module motoro3_mos_driver(


    mosHp            ,
    mosLp            ,

    mosEnable       ,		
    h1_L0           ,		

    nRst,
    clk

);

output  reg                 mosHp            ;		
output  reg                 mosLp            ;		

input   wire                mosEnable       ;		
input   wire                h1_L0           ;		

input   wire                clk             ;			// 10MHz
input   wire                nRst            ;		

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        mosHp                    <= 1'b0 ;
        mosLp                    <= 1'b1 ;
    end
    else begin
        if ( mosEnable == 1'b1 ) begin
            if ( h1_L0 == 1'b1 ) begin
                mosHp            <= 1'b1 ;
                mosLp            <= 1'b0 ;
                if ( mosLp == 1'b1 ) begin mosHp <= 1'b0 ; end 
            end
            else begin
                mosHp            <= 1'b0 ;
                mosLp            <= 1'b1 ;
                if ( mosHp == 1'b1 ) begin mosLp <= 1'b0 ; end 
            end
        end
        else begin
                mosHp            <= 1'b0 ;
                mosLp            <= 1'b0 ;
        end
    end
end

endmodule
