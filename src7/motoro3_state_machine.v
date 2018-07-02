module motoro3_state_machine(

    m3step          ,
    m3cnt           ,

    m3start         ,
    m3freq          ,

    nRst,
    clk

);

// 0: idle
// 1,2,3,4,5,6:nomal
// 7:force stop
output  reg     [3:0]       m3step;	

output  reg     [16:0]       m3cnt;	

input   wire                m3start;	
input   wire    [9:0]      m3freq;	

input   wire                clk;			// 10MHz
input   wire                nRst;		

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        m3cnt               <= { 1'd0, m3freq , 6'd0 };
        m3cnt               <= 17'd32;
    end
    else begin
        if ( m3start == 0 ) begin
            m3cnt           <= { 1'd0, m3freq , 6'd0 };
            m3cnt           <= 17'd32;
        end
        else begin
            if ( m3cnt[16] == 0 ) begin
                m3cnt       <= m3cnt - 17'd1 ;
            end
        end
    end
end

always @ (negedge clk or negedge nRst) begin
    if(!nRst) begin
        m3step               <= 0               ;
    end
    else begin
        if ( m3start == 0 ) begin
            m3step           <= 0               ;
        end
        else begin
            if ( m3cnt == 0 ) begin
                if ( m3step == 4'd6 ) begin
                    m3step       <= 4'd1            ;
                end
                else begin
                    m3step       <= m3step + 4'd1   ;
                end
            end
        end
    end
end


endmodule