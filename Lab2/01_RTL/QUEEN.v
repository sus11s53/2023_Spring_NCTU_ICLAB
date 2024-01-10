module QUEEN(
    //Input Port
    clk,
    rst_n,

    in_valid,
    col,
    row,

    in_valid_num,
    in_num,

    out_valid,
    out,

    );

input               clk, rst_n, in_valid,in_valid_num;
input       [3:0]   col,row;
input       [2:0]   in_num;

output reg          out_valid;
output reg  [3:0]   out;

//==============================================//
//             Parameter and Integer            //
//==============================================//

//==============================================//
//                 reg declaration              //
//==============================================//
reg [3:0] STATE, NEXT;
reg [1:0] map[0:11][0:11];
wire signed [3:0] minus;
reg row_empty_flag;
reg [11:0] row_empty;
reg col_empty_flag;
reg [11:0] col_empty;


//==============================================//
//            FSM State Declaration             //
//==============================================//
integer i , j;
parameter ZERO = 4'd0;
parameter STORE_MAP = 4'd1;
parameter Forward_Find = 4'd2;

//==============================================//
//            Design                            //
//==============================================//
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)	STATE <= ZERO;
	else 		STATE <= NEXT;
end

always@(*)begin
    case(STATE)
		ZERO: begin
			if (in_valid == 1) NEXT = STORE_MAP;
			else NEXT = ZERO;
		end
        STORE_MAP:begin
            if(!in_valid) NEXT = Forward_Find;
            else NEXT = STORE_MAP;
        end
    endcase
end
assign minus = row - col;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)begin 
        for(i = 0; i < 12; i = i + 1)begin
            for(j = 0; j < 12; j = j + 1)begin
                map[i][j] <= 0;
            end
        end
    end

    else if(in_valid)begin
        // row col mark
        for(i = 0; i < 12; i = i + 1)begin
            map[row][i] <= 2;
            map[i][col] <= 2;
        end

        for(i = 0; i < 12; i = i + 1)begin
            for(j = 0; j < 12; j = j + 1)begin
                if((i + j) == (row + col))
                    map[i][j] <= 2;
                else if((i - j) == (minus))
                    map[i][j] <= 2;
            end
        end

        map[row][col] <= 1;
    end

	else begin	
        for(i = 0; i < 12; i = i + 1)begin
            for(j = 0; j < 12; j = j + 1)begin
                map[i][j] <= map[i][j];
            end
        end
    end
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n)begin	
        for(i = 0; i < 12; i = i + 1)
            row_empty [i] <= 0;
    end
    else if()begin
        
    end
	else begin		
        for(i = 0; i < 12; i = i + 1)
            row_empty [i] <= row_empty [i];
    end
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n)begin	
        for(i = 0; i < 12; i = i + 1)
            col_empty [i] <= 0;
    end
	else begin		
        for(i = 0; i < 12; i = i + 1)
            col_empty [i] <= col_empty [i];
    end
end


always@(posedge clk or negedge rst_n) begin
	if(!rst_n)	out <= 0;
	else 		out <= 0;
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n)	out_valid <= 0;
	else 		out_valid <= 0;
end

endmodule 

