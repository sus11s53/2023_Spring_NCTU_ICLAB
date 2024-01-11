//synopsys translate_off
`include "/usr/synthesis/dw/sim_ver/DW_fp_dp3.v"
//synopsys translate_on

module NN(
	// Input signals
	clk,
	rst_n,
	in_valid,
	weight_u,
	weight_w,
	weight_v,
	data_x,
	data_h,
	// Output signals
	out_valid,
	out
);

//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------

// IEEE floating point paramenters
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch = 2;
parameter zero_point_one = 32'b0_01111011_10011001100110011001100;
parameter one = 32'b0_01111111_00000000000000000000000;

parameter ZERO = 5'd0;
parameter STORE = 5'd1;
parameter COMP_h1 = 5'd2;
parameter RELU_h1 = 5'd3;
parameter COMP_h2 = 5'd4;
parameter RELU_h2 = 5'd5;
parameter COMP_h3 = 5'd6;
parameter RELU_h3 = 5'd7;
parameter COMP_VH1 = 5'd8;
parameter COMP_VH2 = 5'd9;
parameter COMP_VH3 = 5'd10;
parameter REVERSE = 5'd11;
parameter EXP1 = 5'd12;
parameter EXP2 = 5'd13;
parameter EXP3 = 5'd14;
parameter ADD1 = 5'd15;
parameter ADD2 = 5'd16;
parameter ADD3 = 5'd17;
parameter RECIPROCAL1 = 5'd18;
parameter RECIPROCAL2 = 5'd19;
parameter RECIPROCAL3 = 5'd20;
parameter STORE_Y = 5'd21;
parameter OUT = 5'd22;
integer i , j;

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION
//---------------------------------------------------------------------
input  clk, rst_n, in_valid;
input [inst_sig_width+inst_exp_width:0] weight_u, weight_w, weight_v;
input [inst_sig_width+inst_exp_width:0] data_x,data_h;
output reg	out_valid;
output reg [inst_sig_width+inst_exp_width:0] out;

//---------------------------------------------------------------------
//   WIRE AND REG DECLARATION
//---------------------------------------------------------------------
reg [5:0] STATE , NEXT;
reg[31:0] U[0:8];
reg[31:0] W[0:8];
reg[31:0] V[0:8];
reg[31:0] X[0:8];
reg[31:0] H0[0:2];
reg[31:0] Y[0:8];
reg[31:0] bf_relu_h1[0:2];
reg[31:0] bf_relu_h2[0:2];
reg[31:0] bf_relu_h3[0:2];
reg[31:0] bf_sigmoid1[0:2];
reg[31:0] bf_sigmoid2[0:2];
reg[31:0] bf_sigmoid3[0:2];
reg[31:0] af_reverse1[0:2];
reg[31:0] af_reverse2[0:2];
reg[31:0] af_reverse3[0:2];
reg[31:0] af_exp1[0:2];
reg[31:0] af_exp2[0:2];
reg[31:0] af_exp3[0:2];
reg[31:0] af_add1[0:2];
reg[31:0] af_add2[0:2];
reg[31:0] af_add3[0:2];
reg[31:0] af_rec1[0:2];
reg[31:0] af_rec2[0:2];
reg[31:0] af_rec3[0:2];
reg[31:0] H1[0:2];
reg[31:0] H2[0:2];
reg[31:0] H3[0:2];
reg[3:0] cnt;
reg[5:0] cnt_comp;
reg[5:0] cnt_controlx;
reg[5:0] cnt_control;
reg[5:0] cnt_sig;
reg[5:0] cnt_m_a;
reg[5:0] cnt_relu;
reg[5:0] cnt_v_h;
reg[5:0] cnt_out;
wire reverse_10 , reverse_11 , reverse_12;
wire reverse_20 , reverse_21 , reverse_22;
wire reverse_30 , reverse_31 , reverse_32;

wire [4:0]dp30_a_signal , dp30_b_signal , dp30_c_signal , dp30_d_signal , dp30_e_signal ,dp30_f_signal;
wire [4:0]dp32_a_signal , dp32_c_signal , dp32_e_signal;


wire [inst_sig_width+inst_exp_width:0]dp30_a;
wire [inst_sig_width+inst_exp_width:0]dp30_b;
wire [inst_sig_width+inst_exp_width:0]dp30_c;
wire [inst_sig_width+inst_exp_width:0]dp30_d;
wire [inst_sig_width+inst_exp_width:0]dp30_e;
wire [inst_sig_width+inst_exp_width:0]dp30_f;
wire [inst_sig_width+inst_exp_width:0]z1;

wire [inst_sig_width+inst_exp_width:0]dp31_a;
reg [inst_sig_width+inst_exp_width:0]dp31_b;
wire [inst_sig_width+inst_exp_width:0]dp31_c;
reg [inst_sig_width+inst_exp_width:0]dp31_d;
wire [inst_sig_width+inst_exp_width:0]dp31_e;
reg [inst_sig_width+inst_exp_width:0]dp31_f;
wire [inst_sig_width+inst_exp_width:0]z2;

wire [inst_sig_width+inst_exp_width:0]z3;
wire [inst_sig_width+inst_exp_width:0]leaky_relu;
wire [inst_sig_width+inst_exp_width:0]relu_neg;
reg [inst_sig_width+inst_exp_width:0]relu_in;

wire [inst_sig_width+inst_exp_width:0]dp32_a;
reg [inst_sig_width+inst_exp_width:0]dp32_b;
wire [inst_sig_width+inst_exp_width:0]dp32_c;
reg [inst_sig_width+inst_exp_width:0]dp32_d;
wire [inst_sig_width+inst_exp_width:0]dp32_e;
reg [inst_sig_width+inst_exp_width:0]dp32_f;
wire [inst_sig_width+inst_exp_width:0]z4;

wire [inst_sig_width+inst_exp_width:0]reverse_signal_10;
wire [inst_sig_width+inst_exp_width:0]reverse_signal_11;
wire [inst_sig_width+inst_exp_width:0]reverse_signal_12;

wire [inst_sig_width+inst_exp_width:0]reverse_signal_20;
wire [inst_sig_width+inst_exp_width:0]reverse_signal_21;
wire [inst_sig_width+inst_exp_width:0]reverse_signal_22;

wire [inst_sig_width+inst_exp_width:0]reverse_signal_30;
wire [inst_sig_width+inst_exp_width:0]reverse_signal_31;
wire [inst_sig_width+inst_exp_width:0]reverse_signal_32;

wire [inst_sig_width+inst_exp_width:0]exp_10;
wire [inst_sig_width+inst_exp_width:0]exp_11;
wire [inst_sig_width+inst_exp_width:0]exp_12;

wire [inst_sig_width+inst_exp_width:0]exp_20;
wire [inst_sig_width+inst_exp_width:0]exp_21;
wire [inst_sig_width+inst_exp_width:0]exp_22;

wire [inst_sig_width+inst_exp_width:0]exp_30;
wire [inst_sig_width+inst_exp_width:0]exp_31;
wire [inst_sig_width+inst_exp_width:0]exp_32;

reg [inst_sig_width+inst_exp_width:0]exp_a;
wire [inst_sig_width+inst_exp_width:0]z5;

reg [inst_sig_width+inst_exp_width:0]add_one_a;
wire [inst_sig_width+inst_exp_width:0]z6;

reg [inst_sig_width+inst_exp_width:0]reciprocal_a;
wire [inst_sig_width+inst_exp_width:0]z7;
//=======================================================================//
//                  design                      					    //
//=====================================================================//
always@(posedge clk or negedge rst_n) begin
	    if(!rst_n) STATE <= ZERO;
	    else STATE <= NEXT;
end

always@(*)begin
    case(STATE)
        ZERO:begin
            if(in_valid) NEXT = STORE;
            else NEXT = ZERO;
        end
        STORE:begin
            if(!in_valid) NEXT = COMP_h1;
            else NEXT = STORE;
        end

        COMP_h1:begin
            if(cnt_control == 2) NEXT = RELU_h1;
			else NEXT = COMP_h1;     
        end

        RELU_h1:begin
            if(cnt_control == 5)NEXT = COMP_h2;
			else NEXT = RELU_h1;
        end

		COMP_h2:begin
            if(cnt_control == 8) NEXT = RELU_h2;
			else NEXT = COMP_h2;     
        end

        RELU_h2:begin
            if(cnt_control == 11)NEXT = COMP_h3;
			else NEXT = RELU_h2;
        end

		COMP_h3:begin
            if(cnt_control == 14) NEXT = RELU_h3;
			else NEXT = COMP_h3;     
        end

        RELU_h3:begin
            if(cnt_control == 17)NEXT = COMP_VH1;
			else NEXT = RELU_h3;
        end
		
		COMP_VH1:begin
			if(cnt_control == 20)NEXT = COMP_VH2;
			else NEXT = COMP_VH1;
		end

		COMP_VH2:begin
			if(cnt_control == 23)NEXT = COMP_VH3;
			else NEXT = COMP_VH2;
		end

		COMP_VH3:begin
			if(cnt_control == 26)NEXT = REVERSE;
			else NEXT = COMP_VH3;
		end

		REVERSE:begin
			if(cnt_control == 29)NEXT = EXP1;
			else NEXT = REVERSE;
		end

		EXP1:begin
			if(cnt_control == 32)NEXT = EXP2;
			else NEXT = EXP1;
		end

		EXP2:begin
			if(cnt_control == 35)NEXT = EXP3;
			else NEXT = EXP2;
		end

		EXP3:begin
			if(cnt_control == 38)NEXT = ADD1;
			else NEXT = EXP3;
		end

		ADD1:begin
			if(cnt_control == 41)NEXT = ADD2;
			else NEXT = ADD1;
		end

		ADD2:begin
			if(cnt_control == 44)NEXT = ADD3;
			else NEXT = ADD2;
		end

		ADD3:begin
			if(cnt_control == 47)NEXT = RECIPROCAL1;
			else NEXT = ADD3;
		end

		RECIPROCAL1:begin
			if(cnt_control == 50)NEXT = RECIPROCAL2;
			else NEXT = RECIPROCAL1;
		end

		RECIPROCAL2:begin
			if(cnt_control == 53)NEXT = RECIPROCAL3;
			else NEXT = RECIPROCAL2;
		end

		RECIPROCAL3:begin
			if(cnt_control == 56)NEXT = STORE_Y;
			else NEXT = RECIPROCAL3;
		end

		STORE_Y:begin
			if(cnt_control == 59)NEXT = OUT;
			else NEXT = STORE_Y;
		end

		OUT:begin
			if(cnt_out == 9)NEXT = ZERO;
			else NEXT = OUT;
		end

        default: NEXT = ZERO;
    endcase
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 9; i = i + 1)begin
				U[i] <= 0;
			end
	end
	else if(NEXT == STORE)begin
            U[cnt] <= weight_u;
	end
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 9; i = i + 1)begin
				W[i] <= 0;
			end
	end
	else if(NEXT == STORE)begin
            W[cnt] <= weight_w;
	end
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 9; i = i + 1)begin
				V[i] <= 0;
			end
	end
	else if(NEXT == STORE)begin
            V[cnt] <= weight_v;
	end
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 9; i = i + 1)begin
				X[i] <= 0;
			end
	end
	else if(NEXT == STORE)begin
            X[cnt] <= data_x;
	end
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				H0[i] <= 0;
			end
	end
	else if(NEXT == STORE)begin
        if(cnt < 3) H0[cnt] <= data_h;   
	end
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        cnt <= 0;
    else if(NEXT == STORE)
        cnt <= cnt + 1;
	else 
		cnt <= 0;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        cnt_comp <= 0;
    else if((NEXT == COMP_h1 && cnt_comp <= 1)|| (NEXT == COMP_h2 && cnt_comp <= 1) || (NEXT == COMP_h3 && cnt_comp <= 1))
        cnt_comp <= cnt_comp + 1;
	else 
		cnt_comp <= 0;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        cnt_control <= 0;
    else if(NEXT == COMP_h1 || NEXT == RELU_h1 || NEXT == COMP_h2 || NEXT == RELU_h2 || NEXT == COMP_h3 || NEXT == RELU_h3 ||NEXT == COMP_VH1 || NEXT == COMP_VH2 || NEXT == COMP_VH3 || NEXT == REVERSE || NEXT == EXP1 || NEXT == EXP2 || NEXT == EXP3 || NEXT == ADD1 || NEXT == ADD2 || NEXT == ADD3 || NEXT == RECIPROCAL1 || NEXT == RECIPROCAL2 || NEXT == RECIPROCAL3 || NEXT == STORE_Y)
        cnt_control <= cnt_control + 1;
	else 
		cnt_control <= 0;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        cnt_controlx <= 0;
    else if(NEXT == RELU_h1 || NEXT == RELU_h2)
        cnt_controlx <= cnt_controlx + 1;
	else if(NEXT == ZERO)
		cnt_controlx <= 0;
end

assign dp30_a_signal = 3*cnt_comp;
assign dp30_b_signal = cnt_controlx;
assign dp30_c_signal = 3*cnt_comp + 1;
assign dp30_d_signal = cnt_controlx + 1;
assign dp30_e_signal = 3*cnt_comp + 2;
assign dp30_f_signal = cnt_controlx + 2;



assign dp30_a = U[dp30_a_signal];
assign dp30_b = X[dp30_b_signal];
assign dp30_c = U[dp30_c_signal];
assign dp30_d = X[dp30_d_signal];
assign dp30_e = U[dp30_e_signal];
assign dp30_f = X[dp30_f_signal];

DW_fp_dp3 #(inst_sig_width, inst_exp_width, inst_ieee_compliance) DP30_Design (.a(dp30_a), .b(dp30_b), .c(dp30_c), .d(dp30_d), .e(dp30_e), .f(dp30_f), .rnd(3'b000), .z(z1));

assign dp31_a = W[dp30_a_signal];
assign dp31_c = W[dp30_c_signal];
assign dp31_e = W[dp30_e_signal];

always@(*)begin
	case(NEXT)
		COMP_h1:begin
					dp31_b = H0[0];
					dp31_d = H0[1];
					dp31_f = H0[2];
				end
		COMP_h2:begin
					dp31_b = H1[0];
					dp31_d = H1[1];
					dp31_f = H1[2];
				end
		COMP_h3:begin
					dp31_b = H2[0];
					dp31_d = H2[1];
					dp31_f = H2[2];
				end
		default:begin
					dp31_b = H0[0];
					dp31_d = H0[1];
					dp31_f = H0[2];
				end
	endcase
end

DW_fp_dp3 #(inst_sig_width, inst_exp_width, inst_ieee_compliance) DP31_Design (.a(dp31_a), .b(dp31_b), .c(dp31_c), .d(dp31_d), .e(dp31_e), .f(dp31_f), .rnd(3'b000), .z(z2));

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A0_Design (.a(z1), .b(z2), .rnd(3'b000), .z(z3));

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        cnt_m_a <= 0;
    else if(NEXT == COMP_h1 || NEXT == COMP_h2 || NEXT == COMP_h3)
        cnt_m_a <= cnt_m_a + 1;
	else 
		cnt_m_a <= 0;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				bf_relu_h1[i] <= 0;
			end
	end
	else if(NEXT == COMP_h1 || STATE == COMP_h1)
		bf_relu_h1[cnt_m_a] <= z3;   
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				bf_relu_h2[i] <= 0;
			end
	end
	else if(NEXT == COMP_h2 || STATE == COMP_h2)
		bf_relu_h2[cnt_m_a] <= z3;   
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				bf_relu_h3[i] <= 0;
			end
	end
	else if(NEXT == COMP_h3 || STATE == COMP_h3)
		bf_relu_h3[cnt_m_a] <= z3;   
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        cnt_relu <= 0;
    else if(NEXT == RELU_h1 && cnt_relu <= 1 || NEXT == RELU_h2 && cnt_relu <= 1 || NEXT == RELU_h3 && cnt_relu <= 1)
        cnt_relu <= cnt_relu + 1;
	else 
		cnt_relu <= 0;
end

always@(*)begin
	case(NEXT)
		RELU_h1: relu_in = bf_relu_h1[cnt_relu];
		RELU_h2: relu_in = bf_relu_h2[cnt_relu];
		RELU_h3: relu_in = bf_relu_h3[cnt_relu];
		default : relu_in = bf_relu_h1[cnt_relu];
	endcase
end 


//RELU

DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M0_Design(.a(relu_in) , .b(zero_point_one) , .rnd(3'b000), .z(relu_neg));

assign leaky_relu = (relu_in[31] == 0) ? relu_in : relu_neg;

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				H1[i] <= 0;
			end
	end
	else if(NEXT == RELU_h1)
		H1[cnt_relu] <= leaky_relu;   
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				H2[i] <= 0;
			end
	end
	else if(NEXT == RELU_h2)
		H2[cnt_relu] <= leaky_relu;   
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				H3[i] <= 0;
			end
	end
	else if(NEXT == RELU_h3)
		H3[cnt_relu] <= leaky_relu;   
end

// MULT V 

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        cnt_sig <= 0;
    else if(NEXT == COMP_VH1 && cnt_sig <= 1 || NEXT == COMP_VH2 && cnt_sig <= 1 || NEXT == COMP_VH3 && cnt_sig <= 1)
        cnt_sig <= cnt_sig + 1;
	else 
		cnt_sig <= 0;
end



assign dp32_a_signal = 3*cnt_sig;
assign dp32_c_signal = 3*cnt_sig + 1;
assign dp32_e_signal = 3*cnt_sig + 2;

always@(*)begin
	case(NEXT)
		COMP_VH1:begin
					dp32_b = H1[0];
					dp32_d = H1[1];
					dp32_f = H1[2];
				end
		COMP_VH2:begin
					dp32_b = H2[0];
					dp32_d = H2[1];
					dp32_f = H2[2];
				end
		COMP_VH3:begin
					dp32_b = H3[0];
					dp32_d = H3[1];
					dp32_f = H3[2];
				end
		default:begin
					dp32_b = H1[0];
					dp32_d = H1[1];
					dp32_f = H1[2];
				end
	endcase
end

assign dp32_a = V[dp32_a_signal];
assign dp32_c = V[dp32_c_signal];
assign dp32_e = V[dp32_e_signal];


DW_fp_dp3 #(inst_sig_width, inst_exp_width, inst_ieee_compliance) DP32_Design (.a(dp32_a), .b(dp32_b), .c(dp32_c), .d(dp32_d), .e(dp32_e), .f(dp32_f), .rnd(3'b000), .z(z4));


always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        cnt_v_h <= 0;
    else if((NEXT == COMP_VH1 && cnt_v_h <= 1) || (NEXT == COMP_VH2  && cnt_v_h <= 1) || (NEXT == COMP_VH3 && cnt_v_h <= 1)||(NEXT == EXP1 && cnt_v_h <= 1) ||(NEXT == EXP2 && cnt_v_h <= 1)||(NEXT == EXP3 && cnt_v_h <= 1)||(NEXT == ADD1 && cnt_v_h <= 1)||(NEXT == ADD2 && cnt_v_h <= 1)||(NEXT == ADD3 && cnt_v_h <= 1)||(NEXT == RECIPROCAL1 && cnt_v_h <= 1)||(NEXT == RECIPROCAL2 && cnt_v_h <= 1)||(NEXT == RECIPROCAL3 && cnt_v_h <= 1))
        cnt_v_h <= cnt_v_h + 1;
	else 
		cnt_v_h <= 0;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				bf_sigmoid1[i] <= 0;
			end
	end
	else if(NEXT == COMP_VH1 )
		bf_sigmoid1[cnt_v_h] <= z4;   
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				bf_sigmoid2[i] <= 0;
			end
	end
	else if(NEXT == COMP_VH2)
		bf_sigmoid2[cnt_v_h] <= z4;   
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				bf_sigmoid3[i] <= 0;
			end
	end
	else if(NEXT == COMP_VH3)
		bf_sigmoid3[cnt_v_h] <= z4;   
end

//REVERSE

assign reverse_signal_10 = bf_sigmoid1[0];
assign reverse_signal_11 = bf_sigmoid1[1];
assign reverse_signal_12 = bf_sigmoid1[2];

assign reverse_signal_20 = bf_sigmoid2[0];
assign reverse_signal_21 = bf_sigmoid2[1];
assign reverse_signal_22 = bf_sigmoid2[2];

assign reverse_signal_30 = bf_sigmoid3[0];
assign reverse_signal_31 = bf_sigmoid3[1];
assign reverse_signal_32 = bf_sigmoid3[2];

assign reverse_10 = (reverse_signal_10[31] == 0) ? 1:0;
assign reverse_11 = (reverse_signal_11[31] == 0) ? 1:0;
assign reverse_12 = (reverse_signal_12[31] == 0) ? 1:0;

assign reverse_20 = (reverse_signal_20[31] == 0) ? 1:0;
assign reverse_21 = (reverse_signal_21[31] == 0) ? 1:0;
assign reverse_22 = (reverse_signal_22[31] == 0) ? 1:0;

assign reverse_30 = (reverse_signal_30[31] == 0) ? 1:0;
assign reverse_31 = (reverse_signal_31[31] == 0) ? 1:0;
assign reverse_32 = (reverse_signal_32[31] == 0) ? 1:0;

assign exp_10 = {reverse_10 , reverse_signal_10[30:0]};
assign exp_11 = {reverse_11 , reverse_signal_11[30:0]};
assign exp_12 = {reverse_12 , reverse_signal_12[30:0]};

assign exp_20 = {reverse_20 , reverse_signal_20[30:0]};
assign exp_21 = {reverse_21 , reverse_signal_21[30:0]};
assign exp_22 = {reverse_22 , reverse_signal_22[30:0]};

assign exp_30 = {reverse_30 , reverse_signal_30[30:0]};
assign exp_31 = {reverse_31 , reverse_signal_31[30:0]};
assign exp_32 = {reverse_32 , reverse_signal_32[30:0]};

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				af_reverse1[i] <= 0;
			end
	end
	else if(STATE == REVERSE)begin
		af_reverse1[0] <= exp_10;
		af_reverse1[1] <= exp_11;
		af_reverse1[2] <= exp_12;
	end  
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				af_reverse2[i] <= 0;
			end
	end
	else if(STATE == REVERSE)begin
		af_reverse2[0] <= exp_20;
		af_reverse2[1] <= exp_21;
		af_reverse2[2] <= exp_22;
	end   
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				af_reverse3[i] <= 0;
			end
	end
	else if(STATE == REVERSE)begin
		af_reverse3[0] <= exp_30;
		af_reverse3[1] <= exp_31;
		af_reverse3[2] <= exp_32;
	end   
end

//EXP

always@(*)begin
	case(NEXT)
	EXP1:exp_a = af_reverse1[cnt_v_h];
	EXP2:exp_a = af_reverse2[cnt_v_h];
	EXP3:exp_a = af_reverse3[cnt_v_h];
	default:exp_a = af_reverse1[cnt_v_h];
	endcase
end

DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance)EXP0_Design (.a(exp_a), .z(z5));

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				af_exp1[i] <= 0;
			end
	end
	else if(NEXT == EXP1)
		af_exp1[cnt_v_h] <= z5;   
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				af_exp2[i] <= 0;
			end
	end
	else if(NEXT == EXP2)
		af_exp2[cnt_v_h] <= z5;   
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				af_exp3[i] <= 0;
			end
	end
	else if(NEXT == EXP3)
		af_exp3[cnt_v_h] <= z5;   
end

//ADD one

always@(*)begin
	case(NEXT)
	ADD1:add_one_a = af_exp1[cnt_v_h];
	ADD2:add_one_a = af_exp2[cnt_v_h];
	ADD3:add_one_a = af_exp3[cnt_v_h];
	default:add_one_a = af_exp1[cnt_v_h];
	endcase
end

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A1_Design (.a(add_one_a), .b(one), .rnd(3'b000), .z(z6));

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				af_add1[i] <= 0;
			end
	end
	else if(NEXT == ADD1)
		af_add1[cnt_v_h] <= z6;   
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				af_add2[i] <= 0;
			end
	end
	else if(NEXT == ADD2)
		af_add2[cnt_v_h] <= z6;   
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				af_add3[i] <= 0;
			end
	end
	else if(NEXT == ADD3)
		af_add3[cnt_v_h] <= z6;   
end

//RECIPROCAL

always@(*)begin
	case(NEXT)
	RECIPROCAL1:reciprocal_a = af_add1[cnt_v_h];
	RECIPROCAL2:reciprocal_a = af_add2[cnt_v_h];
	RECIPROCAL3:reciprocal_a = af_add3[cnt_v_h];
	default:reciprocal_a = af_add1[cnt_v_h];
	endcase
end

DW_fp_div #(inst_sig_width, inst_exp_width, inst_ieee_compliance) R0_Design (.a(one), .b(reciprocal_a), .rnd(3'b000), .z(z7));

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				af_rec1[i] <= 0;
			end
	end
	else if(NEXT == RECIPROCAL1)
		af_rec1[cnt_v_h] <= z7;   
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				af_rec2[i] <= 0;
			end
	end
	else if(NEXT == RECIPROCAL2)
		af_rec2[cnt_v_h] <= z7;   
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 3; i = i + 1)begin
				af_rec3[i] <= 0;
			end
	end
	else if(NEXT == RECIPROCAL3)
		af_rec3[cnt_v_h] <= z7;   
end

//STORE IN Y

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
			for(i = 0 ; i < 9; i = i + 1)begin
				Y[i] <= 0;
			end
	end
	else if(STATE == STORE_Y) begin 
		Y[0] <= af_rec1[0];
		Y[1] <= af_rec1[1];
		Y[2] <= af_rec1[2];
		Y[3] <= af_rec2[0];
		Y[4] <= af_rec2[1];
		Y[5] <= af_rec2[2];
		Y[6] <= af_rec3[0];
		Y[7] <= af_rec3[1];
		Y[8] <= af_rec3[2]; 
	end  
end

//OUT

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        cnt_out <= 0;
    else if(NEXT == OUT)
        cnt_out <= cnt_out + 1;
	else 
		cnt_out <= 0;
end


always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        out <= 0;
    else if(NEXT == OUT)
        out <= Y[cnt_out];
	else 
	 	out <= 0;
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