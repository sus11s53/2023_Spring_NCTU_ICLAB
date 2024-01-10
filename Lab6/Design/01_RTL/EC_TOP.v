//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    (C) Copyright Optimum Application-Specific Integrated System Laboratory
//    All Right Reserved
//		Date		: 2023/03
//		Version		: v1.0
//   	File Name   : EC_TOP.v
//   	Module Name : EC_TOP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

//synopsys translate_off
`include "INV_IP.v"
//synopsys translate_on

module EC_TOP(
    // Input signals
    clk, rst_n, in_valid,
    in_Px, in_Py, in_Qx, in_Qy, in_prime, in_a,
    // Output signals
    out_valid, out_Rx, out_Ry
);

// ===============================================================
// Input & Output Declaration
// ===============================================================
input clk, rst_n, in_valid;
input [6-1:0] in_Px, in_Py, in_Qx, in_Qy, in_prime, in_a;
output reg out_valid;
output reg [6-1:0] out_Rx, out_Ry;

// ===============================================================
// Wire & Reg Declaration
// ===============================================================
reg [5:0] STATE , NEXT;
reg [5:0] Px_reg , Py_reg , Qx_reg , Qy_reg , prime_reg , a_reg;
reg [5:0] cnt_reg ;
wire same_x, same_y , mode_choose;
wire signed [11:0] addition_upper , addition_lower;
wire [20:0] doubling_lower , doubling_upper;
reg signed [11:0] addition_upper_reg , addition_lower_reg;
reg [20:0] doubling_lower_reg , doubling_upper_reg;
wire [5:0] inverse_fin;
wire [11:0] inverse_IP;
wire [5:0] prime_IP;
reg [11:0] inverse_fin_reg;
wire [11:0] s_param;
wire [20:0] s_param_b;
reg [11:0] s_param_reg;
wire[22:0] s_param_square;
wire signed [22:0] x_neg_poss_1 , x_neg_poss_2;
wire [5:0] inverse_IP_mod , inverse_IP_in;
reg [11:0] inverse_IP_mod_reg;
wire [5:0] x_out;
reg [5:0] x_out_reg;
wire [16:0] y_multi;
wire signed[11:0] y_neg_poss_1 , y_neg_poss_2;
wire [5:0] y_out;
 
//---------------------------------------------------------------------
//   FSM
//---------------------------------------------------------------------
parameter IP_WIDTH = 6;
parameter ZERO = 'd0;
parameter STORE_POSITION = 'd1;
parameter STANDBY = 'd2;
parameter POINT_DOUBLING = 'd3;
parameter POINT_ADDITION = 'd4;
parameter OUT = 'd5;


// ===============================================================
// Design
// ===============================================================
always@(posedge clk or negedge rst_n) begin
	    if(!rst_n) STATE <= ZERO;
	    else STATE <= NEXT;
end

always@(*)begin
    case(STATE)
        ZERO:begin
            if(in_valid) NEXT = STORE_POSITION;
            else NEXT = ZERO;
        end
        
		STORE_POSITION:begin
    		if(!in_valid) NEXT = STANDBY;
            else NEXT = STORE_POSITION;
        end

        STANDBY:begin
            if(cnt_reg >= 1 && mode_choose == 1) NEXT = POINT_DOUBLING;
            else if(cnt_reg >= 1 && mode_choose == 0) NEXT = POINT_ADDITION;
            else NEXT = STANDBY;
        end

        POINT_DOUBLING:begin
            if(cnt_reg == 6) NEXT = OUT;
            else NEXT = POINT_DOUBLING;
            
        end

        POINT_ADDITION:begin
            if(cnt_reg == 6) NEXT = OUT;
            else NEXT = POINT_ADDITION;
        end

        OUT:begin
            if(cnt_reg == 7) NEXT = ZERO;
            else NEXT = OUT;
        end
        default: NEXT = ZERO;
    endcase
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        cnt_reg <= 0;
    else if(STATE != ZERO && STATE != STORE_POSITION )
        cnt_reg <= cnt_reg + 1;
    else 
        cnt_reg <= 0;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        Px_reg <= 0;
    else if(NEXT == STORE_POSITION) 
        Px_reg <= in_Px;
    else if(NEXT == ZERO)
        Px_reg <= 0;
    else 
        Px_reg <= Px_reg;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        Py_reg <= 0;
    else if(NEXT == STORE_POSITION) 
        Py_reg <= in_Py;
    else if(NEXT == ZERO)
        Py_reg <= 0;
    else 
        Py_reg <= Py_reg;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        Qx_reg <= 0;
    else if(NEXT == STORE_POSITION) 
        Qx_reg <= in_Qx;
    else if(NEXT == ZERO)
        Qx_reg <= 0;
    else 
        Qx_reg <= Qx_reg;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        Qy_reg <= 0;
    else if(NEXT == STORE_POSITION) 
        Qy_reg <= in_Qy;
    else if(NEXT == ZERO)
        Qy_reg <= 0;
    else 
        Qy_reg <= Qy_reg;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        prime_reg <= 0;
    else if(NEXT == STORE_POSITION) 
        prime_reg <= in_prime;
    else if(NEXT == ZERO)
        prime_reg <= 0;
    else 
        prime_reg <= prime_reg;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        a_reg <= 0;
    else if(NEXT == STORE_POSITION) 
        a_reg <= in_a;
    else if(NEXT == ZERO)
        a_reg <= 0;
    else 
        a_reg <= a_reg;
end

assign same_x = (Px_reg == Qx_reg) ? 1 : 0;
assign same_y = (Py_reg == Qy_reg) ? 1 : 0; 

assign mode_choose = (same_x == 1 && same_y == 1) ? 1 : 0;

assign addition_upper = (Qy_reg > Py_reg) ? Qy_reg - Py_reg : Qy_reg - Py_reg + prime_reg;
assign addition_lower = (Qx_reg > Px_reg) ? Qx_reg - Px_reg : Qx_reg - Px_reg + prime_reg;

assign doubling_upper = ((Px_reg * Px_reg)*3) + a_reg ;
assign doubling_lower = (Py_reg) << 1;

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        addition_upper_reg <= 0;
    else if(NEXT == POINT_ADDITION) 
        addition_upper_reg <= addition_upper;
    else if(NEXT == ZERO)
        addition_upper_reg <= 0;
    else 
        addition_upper_reg <= addition_upper_reg;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        addition_lower_reg <= 0;
    else if(NEXT == POINT_ADDITION) 
        addition_lower_reg <= addition_lower;
    else if(NEXT == ZERO)
        addition_lower_reg <= 0;
    else 
        addition_lower_reg <= addition_lower_reg;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        doubling_upper_reg <= 0;
    else if(NEXT == POINT_DOUBLING) 
        doubling_upper_reg <= doubling_upper;
    else if(NEXT == ZERO)
        doubling_upper_reg <= 0;
    else 
        doubling_upper_reg <= doubling_upper_reg;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        doubling_lower_reg <= 0;
    else if(NEXT == POINT_DOUBLING) 
        doubling_lower_reg <= doubling_lower;
    else if(NEXT == ZERO)
        doubling_lower_reg <= 0;
    else 
        doubling_lower_reg <= doubling_lower_reg;
end
assign prime_IP = prime_reg; 
assign inverse_IP = (mode_choose == 1) ? doubling_lower_reg : addition_lower_reg;
assign inverse_IP_mod = inverse_IP % prime_reg;

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        inverse_IP_mod_reg <= 0;
    else if(NEXT == POINT_DOUBLING || NEXT == POINT_ADDITION) 
        inverse_IP_mod_reg <= inverse_IP_mod;
    else if(NEXT == ZERO)
        inverse_IP_mod_reg <= 0;
    else 
        inverse_IP_mod_reg <= inverse_IP_mod_reg;
end
assign inverse_IP_in = inverse_IP_mod_reg;

INV_IP #(.IP_WIDTH(IP_WIDTH)) IV1 (.IN_1(prime_IP) , .IN_2(inverse_IP_in) , .OUT_INV(inverse_fin));

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        inverse_fin_reg <= 0;
    else if(NEXT == POINT_DOUBLING || NEXT == POINT_ADDITION ) 
        inverse_fin_reg <= inverse_fin;
    else if(NEXT == ZERO)
        inverse_fin_reg <= 0;
    else 
        inverse_fin_reg <= inverse_fin_reg;
end

assign s_param_b = (mode_choose == 1 ) ? (doubling_upper_reg * inverse_fin_reg ) : (addition_upper_reg * inverse_fin_reg);
assign s_param = s_param_b % prime_reg;

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        s_param_reg <= 0;
    else if(NEXT == POINT_DOUBLING || NEXT == POINT_ADDITION ) 
        s_param_reg <= s_param;
    else if(NEXT == ZERO)
        s_param_reg <= 0;
    else 
        s_param_reg <= s_param_reg;
end

assign s_param_square = s_param_reg * s_param_reg;
assign x_neg_poss_1 = (s_param_square > Qx_reg) ?  (s_param_square - Qx_reg) : (s_param_square - Qx_reg + prime_reg);
assign x_neg_poss_2 = (x_neg_poss_1 > Px_reg) ? (x_neg_poss_1 - Px_reg) : (x_neg_poss_1 - Px_reg + prime_reg);
assign x_out = x_neg_poss_2 % prime_reg;



always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        x_out_reg <= 0;
    else if(NEXT == POINT_DOUBLING || NEXT == POINT_ADDITION ) 
        x_out_reg <= x_out;
    else if(NEXT == ZERO)
        x_out_reg <= 0;
    else 
        x_out_reg <= x_out_reg;
end

assign y_neg_poss_1 = (Px_reg > x_out_reg) ? (Px_reg - x_out_reg) : (Px_reg - x_out_reg + prime_reg);
assign y_multi = s_param_reg * (y_neg_poss_1);
assign y_neg_poss_2 = (y_multi > Py_reg ) ? (y_multi - Py_reg) : (y_multi - Py_reg + prime_reg);
assign y_out = y_neg_poss_2 % prime_reg;



always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        out_Rx <= 0;
    else if(NEXT == OUT)
        out_Rx <= x_out;
    else 
        out_Rx <= 0;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        out_Ry <= 0;
    else if(NEXT == OUT)
        out_Ry <= y_out;
    else
        out_Ry <= 0;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        out_valid <= 0;
    else if(NEXT == OUT)
        out_valid <= 1;
    else 
        out_valid <= 0;
end

endmodule

