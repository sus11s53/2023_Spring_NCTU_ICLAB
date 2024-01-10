module MMT(
// input signals
    clk,
    rst_n,
    in_valid,
	in_valid2,
    matrix,
	matrix_size,
    matrix_idx,
    mode,
	
// output signals
    out_valid,
    out_value
);
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION
//---------------------------------------------------------------------
input        clk, rst_n, in_valid, in_valid2;
input [7:0] matrix;
input [1:0]  matrix_size,mode;
input [4:0]  matrix_idx;

output reg       	     out_valid;
output reg signed [49:0] out_value;
//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------
integer i , j;
//---------------------------------------------------------------------
//   WIRE AND REG DECLARATION
//---------------------------------------------------------------------
reg [5:0] STATE , NEXT;
reg  MEM_wen[0:31];
reg signed[7:0]  MEM_in[0:31];
wire signed[7:0]  MEM_out[0:31];
reg [7:0]  MEM_adr[0:31];
reg [7:0]  cnt_word , cnt_store_word;
reg [5:0]  cnt_matrix;
reg [1:0] matrix_size_reg;
reg [4:0] r_matrix_size;
wire [8:0] matrix_size_square;
reg [5:0] matrix_idx_reg_0 , matrix_idx_reg_1 , matrix_idx_reg_2; 
reg [2:0] cnt_idx;
reg [8:0] cnt_store_choose;
reg [3:0] cnt_col , cnt_row , cnt_delay , cnt_delay_2 , cnt_trace , cnt_pattern;
reg [1:0] mode_reg;
reg signed[8:0] choose_matrix_0 [0:15][0:15];
reg signed[8:0] choose_matrix_1 [0:15][0:15];
reg signed[8:0] choose_matrix_2 [0:15][0:15];
reg [4:0] compute_col , compute_row;
wire[8:0] stop_position;
reg [3:0] word_idx;
wire signed [20:0] m0[0:15];
wire signed [20:0] m1_0[0:15];
wire signed [20:0] m1_1[0:15];
wire signed [20:0] m1_2[0:15];
wire signed [20:0] m1_3[0:15];
wire signed [20:0] m1_4[0:15];
wire signed [20:0] m1_5[0:15];
wire signed [20:0] m1_6[0:15];
wire signed [20:0] m1_7[0:15];
wire signed [20:0] m1_8[0:15];
wire signed [20:0] m1_9[0:15];
wire signed [20:0] m1_10[0:15];
wire signed [20:0] m1_11[0:15];
wire signed [20:0] m1_12[0:15];
wire signed [20:0] m1_13[0:15];
wire signed [20:0] m1_14[0:15];
wire signed [20:0] m1_15[0:15];
wire signed [49:0] m1_out[0:15];
reg signed[40:0] temp_matrix_0 [0:15][0:15];
wire [40:0] trace[0:15];
wire [49:0] gold_trace;
reg [49:0] store_trace;
wire MEM_cen, MEM_oen;
//---------------------------------------------------------------------
//   FSM
//---------------------------------------------------------------------
parameter ZERO = 'd0;
parameter STORE_MATRIX = 'd1;
parameter STANDBY_1 = 'd2;
parameter CHOOSE_MATRIX_1 = 'd3;
parameter STORE_CHOOSE_1 = 'd4;
parameter COMPUTE_1_1 = 'd5;
parameter COMPUTE_1_2 = 'd6;
parameter COMPUTE_TRACE = 'd7;
parameter OUT = 'd8;

//---------------------------------------------------------------------
//   DESIGN
//---------------------------------------------------------------------
assign MEM_cen = 0;
assign MEM_oen = 0;
RA1SH M_0 (.Q(MEM_out[0 ]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[0 ]) , .A(MEM_adr[0 ]) , .D(MEM_in[0 ]), .OEN(MEM_oen));
RA1SH M_1 (.Q(MEM_out[1 ]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[1 ]) , .A(MEM_adr[1 ]) , .D(MEM_in[1 ]), .OEN(MEM_oen));
RA1SH M_2 (.Q(MEM_out[2 ]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[2 ]) , .A(MEM_adr[2 ]) , .D(MEM_in[2 ]), .OEN(MEM_oen));
RA1SH M_3 (.Q(MEM_out[3 ]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[3 ]) , .A(MEM_adr[3 ]) , .D(MEM_in[3 ]), .OEN(MEM_oen));
RA1SH M_4 (.Q(MEM_out[4 ]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[4 ]) , .A(MEM_adr[4 ]) , .D(MEM_in[4 ]), .OEN(MEM_oen));
RA1SH M_5 (.Q(MEM_out[5 ]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[5 ]) , .A(MEM_adr[5 ]) , .D(MEM_in[5 ]), .OEN(MEM_oen));
RA1SH M_6 (.Q(MEM_out[6 ]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[6 ]) , .A(MEM_adr[6 ]) , .D(MEM_in[6 ]), .OEN(MEM_oen));
RA1SH M_7 (.Q(MEM_out[7 ]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[7 ]) , .A(MEM_adr[7 ]) , .D(MEM_in[7 ]), .OEN(MEM_oen));
RA1SH M_8 (.Q(MEM_out[8 ]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[8 ]) , .A(MEM_adr[8 ]) , .D(MEM_in[8 ]), .OEN(MEM_oen));
RA1SH M_9 (.Q(MEM_out[9 ]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[9 ]) , .A(MEM_adr[9 ]) , .D(MEM_in[9 ]), .OEN(MEM_oen));
RA1SH M_10(.Q(MEM_out[10]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[10]) , .A(MEM_adr[10]) , .D(MEM_in[10]), .OEN(MEM_oen));
RA1SH M_11(.Q(MEM_out[11]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[11]) , .A(MEM_adr[11]) , .D(MEM_in[11]), .OEN(MEM_oen));
RA1SH M_12(.Q(MEM_out[12]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[12]) , .A(MEM_adr[12]) , .D(MEM_in[12]), .OEN(MEM_oen));
RA1SH M_13(.Q(MEM_out[13]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[13]) , .A(MEM_adr[13]) , .D(MEM_in[13]), .OEN(MEM_oen));
RA1SH M_14(.Q(MEM_out[14]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[14]) , .A(MEM_adr[14]) , .D(MEM_in[14]), .OEN(MEM_oen));
RA1SH M_15(.Q(MEM_out[15]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[15]) , .A(MEM_adr[15]) , .D(MEM_in[15]), .OEN(MEM_oen));

RA1SH M_16(.Q(MEM_out[16]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[16]) , .A(MEM_adr[16]) , .D(MEM_in[16]), .OEN(MEM_oen));
RA1SH M_17(.Q(MEM_out[17]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[17]) , .A(MEM_adr[17]) , .D(MEM_in[17]), .OEN(MEM_oen));
RA1SH M_18(.Q(MEM_out[18]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[18]) , .A(MEM_adr[18]) , .D(MEM_in[18]), .OEN(MEM_oen));
RA1SH M_19(.Q(MEM_out[19]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[19]) , .A(MEM_adr[19]) , .D(MEM_in[19]), .OEN(MEM_oen));
RA1SH M_20(.Q(MEM_out[20]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[20]) , .A(MEM_adr[20]) , .D(MEM_in[20]), .OEN(MEM_oen));
RA1SH M_21(.Q(MEM_out[21]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[21]) , .A(MEM_adr[21]) , .D(MEM_in[21]), .OEN(MEM_oen));
RA1SH M_22(.Q(MEM_out[22]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[22]) , .A(MEM_adr[22]) , .D(MEM_in[22]), .OEN(MEM_oen));
RA1SH M_23(.Q(MEM_out[23]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[23]) , .A(MEM_adr[23]) , .D(MEM_in[23]), .OEN(MEM_oen));
RA1SH M_24(.Q(MEM_out[24]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[24]) , .A(MEM_adr[24]) , .D(MEM_in[24]), .OEN(MEM_oen));
RA1SH M_25(.Q(MEM_out[25]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[25]) , .A(MEM_adr[25]) , .D(MEM_in[25]), .OEN(MEM_oen));
RA1SH M_26(.Q(MEM_out[26]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[26]) , .A(MEM_adr[26]) , .D(MEM_in[26]), .OEN(MEM_oen));
RA1SH M_27(.Q(MEM_out[27]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[27]) , .A(MEM_adr[27]) , .D(MEM_in[27]), .OEN(MEM_oen));
RA1SH M_28(.Q(MEM_out[28]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[28]) , .A(MEM_adr[28]) , .D(MEM_in[28]), .OEN(MEM_oen));
RA1SH M_29(.Q(MEM_out[29]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[29]) , .A(MEM_adr[29]) , .D(MEM_in[29]), .OEN(MEM_oen));
RA1SH M_30(.Q(MEM_out[30]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[30]) , .A(MEM_adr[30]) , .D(MEM_in[30]), .OEN(MEM_oen));
RA1SH M_31(.Q(MEM_out[31]) , .CLK(clk), .CEN(MEM_cen), .WEN(MEM_wen[31]) , .A(MEM_adr[31]) , .D(MEM_in[31]), .OEN(MEM_oen));


always@(posedge clk or negedge rst_n) begin
	    if(!rst_n) matrix_size_reg <= 0;
	    else if(NEXT == STORE_MATRIX && STATE != STORE_MATRIX) matrix_size_reg <= matrix_size;
		else matrix_size_reg <= matrix_size_reg;
end

always@(*)begin
	case(matrix_size_reg)
	0:r_matrix_size = 2;
	1:r_matrix_size = 4;
	2:r_matrix_size = 8;
	3:r_matrix_size = 16;
	default:r_matrix_size = 2;
	endcase
end

assign matrix_size_square = r_matrix_size * r_matrix_size;

always@(posedge clk or negedge rst_n) begin
	    if(!rst_n) STATE <= ZERO;
	    else STATE <= NEXT;
end

always@(*)begin
    case(STATE)
        ZERO:begin
            if(in_valid) NEXT = STORE_MATRIX;
            else NEXT = ZERO;
        end
        
		STORE_MATRIX:begin
    		if(!in_valid) NEXT = STANDBY_1;
            else NEXT = STORE_MATRIX;
        end

		STANDBY_1:begin
			if(in_valid2) NEXT = CHOOSE_MATRIX_1;
			else NEXT =STANDBY_1;
		end
		
		CHOOSE_MATRIX_1:begin
			if(cnt_idx == 3) NEXT = STORE_CHOOSE_1;
            else NEXT = CHOOSE_MATRIX_1;
		end

		STORE_CHOOSE_1:begin
			if(cnt_store_choose == stop_position) NEXT = COMPUTE_1_1;
			else NEXT = STORE_CHOOSE_1;
		end

        COMPUTE_1_1:begin
			if(cnt_delay_2 == 15 && cnt_col == 0) NEXT = COMPUTE_1_2;
			else NEXT = COMPUTE_1_1;
		end

		COMPUTE_1_2:begin
			if(cnt_delay_2 == 15 && cnt_col == 0) NEXT = COMPUTE_TRACE;
			else NEXT = COMPUTE_1_2;
		end

		COMPUTE_TRACE:begin
			if(cnt_trace == 3) NEXT = OUT;
			else NEXT = COMPUTE_TRACE;
		end
		
		OUT:begin
			if(cnt_pattern == 10) NEXT = ZERO;
			else NEXT = STANDBY_1;
		end

        default: NEXT = ZERO;
    endcase
end

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		cnt_word <= 0;
	else if((NEXT == STORE_MATRIX && cnt_word < matrix_size_square - 1)||(STATE == STORE_CHOOSE_1 && cnt_word < matrix_size_square - 1))
		cnt_word <= cnt_word + 1;
	else 
		cnt_word <= 0;
end

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		cnt_matrix <= 0;
	else if(cnt_word == matrix_size_square - 1 && NEXT == STORE_MATRIX && cnt_matrix < 31)
		cnt_matrix <= cnt_matrix + 1;
	else if(NEXT != STORE_MATRIX)
		cnt_matrix <= 0;
	else 
		cnt_matrix <= cnt_matrix;
end

always@(*)begin
	case(STATE)
		ZERO:begin if(in_valid) MEM_in [0] = matrix;
			       else MEM_in[0] = 0;
			 end
		STORE_MATRIX:begin  if(cnt_matrix == 0) MEM_in [0] = matrix;
					 		else MEM_in[0] = 0;
					 end
		default:MEM_in[0] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[1] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 1) MEM_in [1] = matrix;
					 		else MEM_in[1] = 0;
					 end
		default:MEM_in[1] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[2] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 2) MEM_in [2] = matrix;
					 		else MEM_in[2] = 0;
					 end
		default:MEM_in[2] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[3] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 3) MEM_in [3] = matrix;
					 		else MEM_in[3] = 0;
					 end
		default:MEM_in[3] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[4] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 4) MEM_in [4] = matrix;
					 		else MEM_in[4] = 0;
					 end
		default:MEM_in[4] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[5] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 5) MEM_in [5] = matrix;
					 		else MEM_in[5] = 0;
					 end
		default:MEM_in[5] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[6] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 6) MEM_in [6] = matrix;
					 		else MEM_in[6] = 0;
					 end
		default:MEM_in[6] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[7] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 7) MEM_in [7] = matrix;
					 		else MEM_in[7] = 0;
					 end
		default:MEM_in[7] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[8] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 8) MEM_in [8] = matrix;
					 		else MEM_in[8] = 0;
					 end
		default:MEM_in[8] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[9] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 9) MEM_in [9] = matrix;
					 		else MEM_in[9] = 0;
					 end
		default:MEM_in[9] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[10] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 10) MEM_in [10] = matrix;
					 		else MEM_in[10] = 0;
					 end
		default:MEM_in[10] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[11] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 11) MEM_in [11] = matrix;
					 		else MEM_in[11] = 0;
					 end
		default:MEM_in[11] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[12] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 12) MEM_in [12] = matrix;
					 		else MEM_in[12] = 0;
					 end
		default:MEM_in[12] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[13] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 13) MEM_in [13] = matrix;
					 		else MEM_in[13] = 0;
					 end
		default:MEM_in[13] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[14] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 14) MEM_in [14] = matrix;
					 		else MEM_in[14] = 0;
					 end
		default:MEM_in[14] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[15] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 15) MEM_in [15] = matrix;
					 		else MEM_in[15] = 0;
					 end
		default:MEM_in[15] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[16] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 16) MEM_in [16] = matrix;
					 		else MEM_in[16] = 0;
					 end
		default:MEM_in[16] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[17] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 17) MEM_in [17] = matrix;
					 		else MEM_in[17] = 0;
					 end
		default:MEM_in[17] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[18] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 18) MEM_in [18] = matrix;
					 		else MEM_in[18] = 0;
					 end
		default:MEM_in[18] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[19] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 19) MEM_in [19] = matrix;
					 		else MEM_in[19] = 0;
					 end
		default:MEM_in[19] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[20] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 20) MEM_in [20] = matrix;
					 		else MEM_in[20] = 0;
					 end
		default:MEM_in[20] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[21] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 21) MEM_in [21] = matrix;
					 		else MEM_in[21] = 0;
					 end
		default:MEM_in[21] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[22] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 22) MEM_in [22] = matrix;
					 		else MEM_in[22] = 0;
					 end
		default:MEM_in[22] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[23] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 23) MEM_in [23] = matrix;
					 		else MEM_in[23] = 0;
					 end
		default:MEM_in[23] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[24] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 24) MEM_in [24] = matrix;
					 		else MEM_in[24] = 0;
					 end
		default:MEM_in[24] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[25] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 25) MEM_in [25] = matrix;
					 		else MEM_in[25] = 0;
					 end
		default:MEM_in[25] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[26] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 26) MEM_in [26] = matrix;
					 		else MEM_in[26] = 0;
					 end
		default:MEM_in[26] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[27] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 27) MEM_in [27] = matrix;
					 		else MEM_in[27] = 0;
					 end
		default:MEM_in[27] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[28] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 28) MEM_in [28] = matrix;
					 		else MEM_in[28] = 0;
					 end
		default:MEM_in[28] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[29] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 29) MEM_in [29] = matrix;
					 		else MEM_in[29] = 0;
					 end
		default:MEM_in[29] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[30] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 30) MEM_in [30] = matrix;
					 		else MEM_in[30] = 0;
					 end
		default:MEM_in[30] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		ZERO:MEM_in[31] = 0;
		STORE_MATRIX:begin  if(cnt_matrix == 31) MEM_in [31] = matrix;
					 		else MEM_in[31] = 0;
					 end
		default:MEM_in[31] = 0;
	endcase
end


always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 0) MEM_adr[0] = cnt_word;
					 	else MEM_adr[0] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 0) MEM_adr[0] = cnt_word;
						else if(matrix_idx_reg_1 == 0) MEM_adr[0] = cnt_word;
						else if(matrix_idx_reg_2 == 0) MEM_adr[0] = cnt_word;
						else MEM_adr[0] = 0;
					   end
		default:MEM_adr[0] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 1) MEM_adr[1] = cnt_word;
					 	else MEM_adr[1] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 1) MEM_adr[1] = cnt_word;
						else if(matrix_idx_reg_1 == 1) MEM_adr[1] = cnt_word;
						else if(matrix_idx_reg_2 == 1) MEM_adr[1] = cnt_word;
						else MEM_adr[1] = 0;
					   end
		default:MEM_adr[1] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 2) MEM_adr[2] = cnt_word;
					 	else MEM_adr[2] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 2) MEM_adr[2] = cnt_word;
						else if(matrix_idx_reg_1 == 2) MEM_adr[2] = cnt_word;
						else if(matrix_idx_reg_2 == 2) MEM_adr[2] = cnt_word;
						else MEM_adr[2] = 0;
					   end
		default:MEM_adr[2] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 3) MEM_adr[3] = cnt_word;
					 	else MEM_adr[3] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 3) MEM_adr[3] = cnt_word;
						else if(matrix_idx_reg_1 == 3) MEM_adr[3] = cnt_word;
						else if(matrix_idx_reg_2 == 3) MEM_adr[3] = cnt_word;
						else MEM_adr[3] = 0;
					   end
		default:MEM_adr[3] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 4) MEM_adr[4] = cnt_word;
					 	else MEM_adr[4] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 4) MEM_adr[4] = cnt_word;
						else if(matrix_idx_reg_1 == 4) MEM_adr[4] = cnt_word;
						else if(matrix_idx_reg_2 == 4) MEM_adr[4] = cnt_word;
						else MEM_adr[4] = 0;
					   end
		default:MEM_adr[4] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 5) MEM_adr[5] = cnt_word;
					 	else MEM_adr[5] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 5) MEM_adr[5] = cnt_word;
						else if(matrix_idx_reg_1 == 5) MEM_adr[5] = cnt_word;
						else if(matrix_idx_reg_2 == 5) MEM_adr[5] = cnt_word;
						else MEM_adr[5] = 0;
					   end
		default:MEM_adr[5] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 6) MEM_adr[6] = cnt_word;
					 	else MEM_adr[6] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 6) MEM_adr[6] = cnt_word;
						else if(matrix_idx_reg_1 == 6) MEM_adr[6] = cnt_word;
						else if(matrix_idx_reg_2 == 6) MEM_adr[6] = cnt_word;
						else MEM_adr[6] = 0;
					   end
		default:MEM_adr[6] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 7) MEM_adr[7] = cnt_word;
					 	else MEM_adr[7] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 7) MEM_adr[7] = cnt_word;
						else if(matrix_idx_reg_1 == 7) MEM_adr[7] = cnt_word;
						else if(matrix_idx_reg_2 == 7) MEM_adr[7] = cnt_word;
						else MEM_adr[7] = 0;
					   end
		default:MEM_adr[7] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 8) MEM_adr[8] = cnt_word;
					 	else MEM_adr[8] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 8) MEM_adr[8] = cnt_word;
						else if(matrix_idx_reg_1 == 8) MEM_adr[8] = cnt_word;
						else if(matrix_idx_reg_2 == 8) MEM_adr[8] = cnt_word;
						else MEM_adr[8] = 0;
					   end
		default:MEM_adr[8] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 9) MEM_adr[9] = cnt_word;
					 	else MEM_adr[9] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 9) MEM_adr[9] = cnt_word;
						else if(matrix_idx_reg_1 == 9) MEM_adr[9] = cnt_word;
						else if(matrix_idx_reg_2 == 9) MEM_adr[9] = cnt_word;
						else MEM_adr[9] = 0;
					   end
		default:MEM_adr[9] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 10) MEM_adr[10] = cnt_word;
					 	else MEM_adr[10] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 10) MEM_adr[10] = cnt_word;
						else if(matrix_idx_reg_1 == 10) MEM_adr[10] = cnt_word;
						else if(matrix_idx_reg_2 == 10) MEM_adr[10] = cnt_word;
						else MEM_adr[10] = 0;
					   end
		default:MEM_adr[10] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 11) MEM_adr[11] = cnt_word;
					 	else MEM_adr[11] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 11) MEM_adr[11] = cnt_word;
						else if(matrix_idx_reg_1 == 11) MEM_adr[11] = cnt_word;
						else if(matrix_idx_reg_2 == 11) MEM_adr[11] = cnt_word;
						else MEM_adr[11] = 0;
					   end
		default:MEM_adr[11] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 12) MEM_adr[12] = cnt_word;
					 	else MEM_adr[12] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 12) MEM_adr[12] = cnt_word;
						else if(matrix_idx_reg_1 == 12) MEM_adr[12] = cnt_word;
						else if(matrix_idx_reg_2 == 12) MEM_adr[12] = cnt_word;
						else MEM_adr[12] = 0;
					   end
		default:MEM_adr[12] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 13) MEM_adr[13] = cnt_word;
					 	else MEM_adr[13] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 13) MEM_adr[13] = cnt_word;
						else if(matrix_idx_reg_1 == 13) MEM_adr[13] = cnt_word;
						else if(matrix_idx_reg_2 == 13) MEM_adr[13] = cnt_word;
						else MEM_adr[13] = 0;
					   end
		default:MEM_adr[13] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 14) MEM_adr[14] = cnt_word;
					 	else MEM_adr[14] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 14) MEM_adr[14] = cnt_word;
						else if(matrix_idx_reg_1 == 14) MEM_adr[14] = cnt_word;
						else if(matrix_idx_reg_2 == 14) MEM_adr[14] = cnt_word;
						else MEM_adr[14] = 0;
					   end
		default:MEM_adr[14] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 15) MEM_adr[15] = cnt_word;
					 	else MEM_adr[15] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 15) MEM_adr[15] = cnt_word;
						else if(matrix_idx_reg_1 == 15) MEM_adr[15] = cnt_word;
						else if(matrix_idx_reg_2 == 15) MEM_adr[15] = cnt_word;
						else MEM_adr[15] = 0;
					   end
		default:MEM_adr[15] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 16) MEM_adr[16] = cnt_word;
					 	else MEM_adr[16] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 16) MEM_adr[16] = cnt_word;
						else if(matrix_idx_reg_1 == 16) MEM_adr[16] = cnt_word;
						else if(matrix_idx_reg_2 == 16) MEM_adr[16] = cnt_word;
						else MEM_adr[16] = 0;
					   end
		default:MEM_adr[16] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 17) MEM_adr[17] = cnt_word;
					 	else MEM_adr[17] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 17) MEM_adr[17] = cnt_word;
						else if(matrix_idx_reg_1 == 17) MEM_adr[17] = cnt_word;
						else if(matrix_idx_reg_2 == 17) MEM_adr[17] = cnt_word;
						else MEM_adr[17] = 0;
					   end
		default:MEM_adr[17] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 18) MEM_adr[18] = cnt_word;
					 	else MEM_adr[18] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 18) MEM_adr[18] = cnt_word;
						else if(matrix_idx_reg_1 == 18) MEM_adr[18] = cnt_word;
						else if(matrix_idx_reg_2 == 18) MEM_adr[18] = cnt_word;
						else MEM_adr[18] = 0;
					   end
		default:MEM_adr[18] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 19) MEM_adr[19] = cnt_word;
					 	else MEM_adr[19] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 19) MEM_adr[19] = cnt_word;
						else if(matrix_idx_reg_1 == 19) MEM_adr[19] = cnt_word;
						else if(matrix_idx_reg_2 == 19) MEM_adr[19] = cnt_word;
						else MEM_adr[19] = 0;
					   end
		default:MEM_adr[19] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 20) MEM_adr[20] = cnt_word;
					 	else MEM_adr[20] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 20) MEM_adr[20] = cnt_word;
						else if(matrix_idx_reg_1 == 20) MEM_adr[20] = cnt_word;
						else if(matrix_idx_reg_2 == 20) MEM_adr[20] = cnt_word;
						else MEM_adr[20] = 0;
					   end
		default:MEM_adr[20] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 21) MEM_adr[21] = cnt_word;
					 	else MEM_adr[21] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 21) MEM_adr[21] = cnt_word;
						else if(matrix_idx_reg_1 == 21) MEM_adr[21] = cnt_word;
						else if(matrix_idx_reg_2 == 21) MEM_adr[21] = cnt_word;
						else MEM_adr[21] = 0;
					   end
		default:MEM_adr[21] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 22) MEM_adr[22] = cnt_word;
					 	else MEM_adr[22] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 22) MEM_adr[22] = cnt_word;
						else if(matrix_idx_reg_1 == 22) MEM_adr[22] = cnt_word;
						else if(matrix_idx_reg_2 == 22) MEM_adr[22] = cnt_word;
						else MEM_adr[22] = 0;
					   end
		default:MEM_adr[22] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 23) MEM_adr[23] = cnt_word;
					 	else MEM_adr[23] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 23) MEM_adr[23] = cnt_word;
						else if(matrix_idx_reg_1 == 23) MEM_adr[23] = cnt_word;
						else if(matrix_idx_reg_2 == 23) MEM_adr[23] = cnt_word;
						else MEM_adr[23] = 0;
					   end
		default:MEM_adr[23] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 24) MEM_adr[24] = cnt_word;
					 	else MEM_adr[24] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 24) MEM_adr[24] = cnt_word;
						else if(matrix_idx_reg_1 == 24) MEM_adr[24] = cnt_word;
						else if(matrix_idx_reg_2 == 24) MEM_adr[24] = cnt_word;
						else MEM_adr[24] = 0;
					   end
		default:MEM_adr[24] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 25) MEM_adr[25] = cnt_word;
					 	else MEM_adr[25] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 25) MEM_adr[25] = cnt_word;
						else if(matrix_idx_reg_1 == 25) MEM_adr[25] = cnt_word;
						else if(matrix_idx_reg_2 == 25) MEM_adr[25] = cnt_word;
						else MEM_adr[25] = 0;
					   end
		default:MEM_adr[25] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 26) MEM_adr[26] = cnt_word;
					 	else MEM_adr[26] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 26) MEM_adr[26] = cnt_word;
						else if(matrix_idx_reg_1 == 26) MEM_adr[26] = cnt_word;
						else if(matrix_idx_reg_2 == 26) MEM_adr[26] = cnt_word;
						else MEM_adr[26] = 0;
					   end
		default:MEM_adr[26] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 27) MEM_adr[27] = cnt_word;
					 	else MEM_adr[27] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 27) MEM_adr[27] = cnt_word;
						else if(matrix_idx_reg_1 == 27) MEM_adr[27] = cnt_word;
						else if(matrix_idx_reg_2 == 27) MEM_adr[27] = cnt_word;
						else MEM_adr[27] = 0;
					   end
		default:MEM_adr[27] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 28) MEM_adr[28] = cnt_word;
					 	else MEM_adr[28] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 28) MEM_adr[28] = cnt_word;
						else if(matrix_idx_reg_1 == 28) MEM_adr[28] = cnt_word;
						else if(matrix_idx_reg_2 == 28) MEM_adr[28] = cnt_word;
						else MEM_adr[28] = 0;
					   end
		default:MEM_adr[28] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 29) MEM_adr[29] = cnt_word;
					 	else MEM_adr[29] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 29) MEM_adr[29] = cnt_word;
						else if(matrix_idx_reg_1 == 29) MEM_adr[29] = cnt_word;
						else if(matrix_idx_reg_2 == 29) MEM_adr[29] = cnt_word;
						else MEM_adr[29] = 0;
					   end
		default:MEM_adr[29] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 30) MEM_adr[30] = cnt_word;
					 	else MEM_adr[30] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 30) MEM_adr[30] = cnt_word;
						else if(matrix_idx_reg_1 == 30) MEM_adr[30] = cnt_word;
						else if(matrix_idx_reg_2 == 30) MEM_adr[30] = cnt_word;
						else MEM_adr[30] = 0;
					   end
		default:MEM_adr[30] = 0;
	endcase
end

always@(*)begin
	case(STATE)
		STORE_MATRIX:begin 
						if(cnt_matrix == 31) MEM_adr[31] = cnt_word;
					 	else MEM_adr[31] = 0;
					 end
		STORE_CHOOSE_1:begin
					    if(matrix_idx_reg_0 == 31) MEM_adr[31] = cnt_word;
						else if(matrix_idx_reg_1 == 31) MEM_adr[31] = cnt_word;
						else if(matrix_idx_reg_2 == 31) MEM_adr[31] = cnt_word;
						else MEM_adr[31] = 0;
					   end
		default:MEM_adr[31] = 0;
	endcase
end


always@(*)begin
	for(j = 0; j < 32; j = j + 1)begin
		MEM_wen[j] = 1;
	end

	case(STATE)
	ZERO:begin
			if(in_valid) MEM_wen[0] = 0;
			else MEM_wen[0] = 1;
	end

	STORE_MATRIX:begin
			case(cnt_matrix)
				0:MEM_wen[0] = 0;
				1:MEM_wen[1] = 0;
				2:MEM_wen[2] = 0;
				3:MEM_wen[3] = 0;
				4:MEM_wen[4] = 0;
				5:MEM_wen[5] = 0;
				6:MEM_wen[6] = 0;
				7:MEM_wen[7] = 0;
				8:MEM_wen[8] = 0;
				9:MEM_wen[9] = 0;
				10:MEM_wen[10] = 0;
				11:MEM_wen[11] = 0;
				12:MEM_wen[12] = 0;
				13:MEM_wen[13] = 0;
				14:MEM_wen[14] = 0;
				15:MEM_wen[15] = 0;
				16:MEM_wen[16] = 0;
				17:MEM_wen[17] = 0;
				18:MEM_wen[18] = 0;
				19:MEM_wen[19] = 0;
				20:MEM_wen[20] = 0;
				21:MEM_wen[21] = 0;
				22:MEM_wen[22] = 0;
				23:MEM_wen[23] = 0;
				24:MEM_wen[24] = 0;
				25:MEM_wen[25] = 0;
				26:MEM_wen[26] = 0;
				27:MEM_wen[27] = 0;
				28:MEM_wen[28] = 0;
				29:MEM_wen[29] = 0;
				30:MEM_wen[30] = 0;
				31:MEM_wen[31] = (in_valid) ? 0 : 1;
            	default:MEM_wen[0] = 0;
			endcase
	end
	default:begin
		for(j = 0; j < 32; j = j + 1)begin
			MEM_wen[j] = 1;
		end
	end
	endcase
end

always@(posedge clk or negedge rst_n) begin
	    if(!rst_n) matrix_idx_reg_0 <= 0;
	    else if(NEXT == CHOOSE_MATRIX_1  && cnt_idx == 0) matrix_idx_reg_0 <= matrix_idx;
		else if(STATE == ZERO) matrix_idx_reg_0 <= 0;
		else matrix_idx_reg_0 <= matrix_idx_reg_0;
end

always@(posedge clk or negedge rst_n) begin
	    if(!rst_n) matrix_idx_reg_1 <= 0;
	    else if(NEXT == CHOOSE_MATRIX_1 && cnt_idx == 1) matrix_idx_reg_1 <= matrix_idx;
		else if(STATE == ZERO) matrix_idx_reg_1 <= 0;
		else matrix_idx_reg_1 <= matrix_idx_reg_1;
end

always@(posedge clk or negedge rst_n) begin
	    if(!rst_n) matrix_idx_reg_2 <= 0;
	    else if(NEXT == CHOOSE_MATRIX_1 && cnt_idx == 2) matrix_idx_reg_2 <= matrix_idx;
		else if(STATE == ZERO) matrix_idx_reg_2 <= 0;
		else matrix_idx_reg_2 <= matrix_idx_reg_2;
end

always@(posedge clk or negedge rst_n) begin
	    if(!rst_n) mode_reg <= 0;
	    else if(NEXT == CHOOSE_MATRIX_1 && cnt_idx == 0) mode_reg <= mode;
		else if(STATE == ZERO) mode_reg <= 0;
		else mode_reg <= mode_reg;
end

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		cnt_idx <= 0;
	else if(NEXT == CHOOSE_MATRIX_1 && cnt_idx < 3)
		cnt_idx <= cnt_idx + 1;
	else 
		cnt_idx <= 0;
end

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		cnt_store_word <= 0;
	else 
		cnt_store_word <= cnt_word;
end

always@(*)begin
	case(r_matrix_size)
		2:compute_col = cnt_store_word % 2;
		4:compute_col = cnt_store_word % 4;
		8:compute_col = cnt_store_word % 8;
		default: compute_col = cnt_store_word % 16;
	endcase
end

always@(*)begin
	case(r_matrix_size)
		2:compute_row = cnt_store_word >> 1;
		4:compute_row = cnt_store_word >> 2;
		8:compute_row = cnt_store_word >> 3;
		default: compute_row = cnt_store_word >> 4;
	endcase
end


always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		for(i = 0; i < 16; i = i + 1)begin
			for(j = 0; j < 16; j = j + 1)
					choose_matrix_0 [i][j] <= 0;
		end
	end
	else if(NEXT == STORE_CHOOSE_1)begin
	    if(mode_reg == 1)
			choose_matrix_0 [compute_col][compute_row] <= MEM_out[matrix_idx_reg_0];
		else
			choose_matrix_0 [compute_row][compute_col] <= MEM_out[matrix_idx_reg_0];
	end
	else if(STATE == ZERO)begin
		for(i = 0; i < 16; i = i + 1)begin
			for(j = 0; j < 16; j = j + 1)
					choose_matrix_0 [i][j] <= 0;
		end
	end
end

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		for(i = 0; i < 16; i = i + 1)begin
			for(j = 0; j < 16; j = j + 1)
					choose_matrix_1 [i][j] <= 0;
		end
	end
	else if(NEXT == STORE_CHOOSE_1)begin
	    if(mode_reg == 2)
			choose_matrix_1 [compute_col][compute_row] <= MEM_out[matrix_idx_reg_1];
		else
			choose_matrix_1 [compute_row][compute_col] <= MEM_out[matrix_idx_reg_1];
	end
	else if(STATE == ZERO)begin
		for(i = 0; i < 16; i = i + 1)begin
			for(j = 0; j < 16; j = j + 1)
					choose_matrix_1 [i][j] <= 0;
		end
	end
end


always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		for(i = 0; i < 16; i = i + 1)begin
			for(j = 0; j < 16; j = j + 1)
					choose_matrix_2 [i][j] <= 0;
		end
	end
	else if(NEXT == STORE_CHOOSE_1)begin
	    if(mode_reg == 3)
			choose_matrix_2 [compute_col][compute_row] <= MEM_out[matrix_idx_reg_2];
		else
			choose_matrix_2 [compute_row][compute_col] <= MEM_out[matrix_idx_reg_2];
	end
	else if(STATE == ZERO)begin
		for(i = 0; i < 16; i = i + 1)begin
			for(j = 0; j < 16; j = j + 1)
					choose_matrix_2 [i][j] <= 0;
		end
	end
end

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		cnt_store_choose <= 0;
	else if(NEXT == STORE_CHOOSE_1)
		cnt_store_choose <= cnt_store_choose + 1;
	else 
		cnt_store_choose <= 0;
end

assign stop_position = matrix_size_square + 3;

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		cnt_col <= 0;
	else if((STATE == COMPUTE_1_1 && cnt_col < 2) || (STATE == COMPUTE_1_2 && cnt_col < 2))
		cnt_col <= cnt_col + 1;
	else 
		cnt_col <= 0;
end

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		cnt_row <= 0;
	else if((STATE == COMPUTE_1_1 && cnt_col == 2) || (STATE == COMPUTE_1_2 && cnt_col == 2))
		cnt_row <= cnt_row + 1;
	else if(NEXT != COMPUTE_1_1 && NEXT != COMPUTE_1_2)
		cnt_row <= 0;
	else 
		cnt_row <= cnt_row;
end


assign  m0[0] = (NEXT == COMPUTE_1_2) ? temp_matrix_0 [cnt_row][0] :choose_matrix_0[cnt_row][0];
assign  m0[1] = (NEXT == COMPUTE_1_2) ? temp_matrix_0 [cnt_row][1] :choose_matrix_0[cnt_row][1];
assign  m0[2] = (NEXT == COMPUTE_1_2) ? temp_matrix_0 [cnt_row][2] :choose_matrix_0[cnt_row][2];
assign  m0[3] = (NEXT == COMPUTE_1_2) ? temp_matrix_0 [cnt_row][3] :choose_matrix_0[cnt_row][3];
assign  m0[4] = (NEXT == COMPUTE_1_2) ? temp_matrix_0 [cnt_row][4] :choose_matrix_0[cnt_row][4];
assign  m0[5] = (NEXT == COMPUTE_1_2) ? temp_matrix_0 [cnt_row][5] :choose_matrix_0[cnt_row][5];
assign  m0[6] = (NEXT == COMPUTE_1_2) ? temp_matrix_0 [cnt_row][6] :choose_matrix_0[cnt_row][6];
assign  m0[7] = (NEXT == COMPUTE_1_2) ? temp_matrix_0 [cnt_row][7] :choose_matrix_0[cnt_row][7];
assign  m0[8] = (NEXT == COMPUTE_1_2) ? temp_matrix_0 [cnt_row][8] :choose_matrix_0[cnt_row][8];
assign  m0[9] = (NEXT == COMPUTE_1_2) ? temp_matrix_0 [cnt_row][9] :choose_matrix_0[cnt_row][9];
assign  m0[10] = (NEXT == COMPUTE_1_2) ? temp_matrix_0 [cnt_row][10] :choose_matrix_0[cnt_row][10];
assign  m0[11] = (NEXT == COMPUTE_1_2) ? temp_matrix_0 [cnt_row][11] :choose_matrix_0[cnt_row][11];
assign  m0[12] = (NEXT == COMPUTE_1_2) ? temp_matrix_0 [cnt_row][12] :choose_matrix_0[cnt_row][12];
assign  m0[13] = (NEXT == COMPUTE_1_2) ? temp_matrix_0 [cnt_row][13] :choose_matrix_0[cnt_row][13];
assign  m0[14] = (NEXT == COMPUTE_1_2) ? temp_matrix_0 [cnt_row][14] :choose_matrix_0[cnt_row][14];
assign  m0[15] = (NEXT == COMPUTE_1_2) ? temp_matrix_0 [cnt_row][15] :choose_matrix_0[cnt_row][15];

assign  m1_0[0] =  (NEXT == COMPUTE_1_2) ? choose_matrix_2 [0][0] : choose_matrix_1[0][0];
assign  m1_0[1] =  (NEXT == COMPUTE_1_2) ? choose_matrix_2 [1][0] : choose_matrix_1[1][0];
assign  m1_0[2] =  (NEXT == COMPUTE_1_2) ? choose_matrix_2 [2][0] : choose_matrix_1[2][0];
assign  m1_0[3] =  (NEXT == COMPUTE_1_2) ? choose_matrix_2 [3][0] : choose_matrix_1[3][0];
assign  m1_0[4] =  (NEXT == COMPUTE_1_2) ? choose_matrix_2 [4][0] : choose_matrix_1[4][0];
assign  m1_0[5] =  (NEXT == COMPUTE_1_2) ? choose_matrix_2 [5][0] : choose_matrix_1[5][0];
assign  m1_0[6] =  (NEXT == COMPUTE_1_2) ? choose_matrix_2 [6][0] : choose_matrix_1[6][0];
assign  m1_0[7] =  (NEXT == COMPUTE_1_2) ? choose_matrix_2 [7][0] : choose_matrix_1[7][0];
assign  m1_0[8] =  (NEXT == COMPUTE_1_2) ? choose_matrix_2 [8][0] : choose_matrix_1[8][0];
assign  m1_0[9] =  (NEXT == COMPUTE_1_2) ? choose_matrix_2 [9][0] : choose_matrix_1[9][0];
assign  m1_0[10] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [10][0] :choose_matrix_1[10][0];
assign  m1_0[11] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [11][0] :choose_matrix_1[11][0];
assign  m1_0[12] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [12][0] :choose_matrix_1[12][0];
assign  m1_0[13] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [13][0] :choose_matrix_1[13][0];
assign  m1_0[14] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [14][0] :choose_matrix_1[14][0];
assign  m1_0[15] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [15][0] :choose_matrix_1[15][0];

assign  m1_1[0] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [0][1] : choose_matrix_1[0][1];
assign  m1_1[1] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [1][1] : choose_matrix_1[1][1];
assign  m1_1[2] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [2][1] : choose_matrix_1[2][1];
assign  m1_1[3] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [3][1] : choose_matrix_1[3][1];
assign  m1_1[4] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [4][1] : choose_matrix_1[4][1];
assign  m1_1[5] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [5][1] : choose_matrix_1[5][1];
assign  m1_1[6] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [6][1] : choose_matrix_1[6][1];
assign  m1_1[7] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [7][1] : choose_matrix_1[7][1];
assign  m1_1[8] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [8][1] : choose_matrix_1[8][1];
assign  m1_1[9] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [9][1] : choose_matrix_1[9][1];
assign  m1_1[10] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [10][1] :choose_matrix_1[10][1];
assign  m1_1[11] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [11][1] :choose_matrix_1[11][1];
assign  m1_1[12] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [12][1] :choose_matrix_1[12][1];
assign  m1_1[13] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [13][1] :choose_matrix_1[13][1];
assign  m1_1[14] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [14][1] :choose_matrix_1[14][1];
assign  m1_1[15] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [15][1] :choose_matrix_1[15][1];

assign  m1_2[0] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [0][2] : choose_matrix_1[0][2];
assign  m1_2[1] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [1][2] : choose_matrix_1[1][2];
assign  m1_2[2] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [2][2] : choose_matrix_1[2][2];
assign  m1_2[3] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [3][2] : choose_matrix_1[3][2];
assign  m1_2[4] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [4][2] : choose_matrix_1[4][2];
assign  m1_2[5] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [5][2] : choose_matrix_1[5][2];
assign  m1_2[6] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [6][2] : choose_matrix_1[6][2];
assign  m1_2[7] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [7][2] : choose_matrix_1[7][2];
assign  m1_2[8] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [8][2] : choose_matrix_1[8][2];
assign  m1_2[9] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [9][2] : choose_matrix_1[9][2];
assign  m1_2[10] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [10][2] :choose_matrix_1[10][2];
assign  m1_2[11] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [11][2] :choose_matrix_1[11][2];
assign  m1_2[12] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [12][2] :choose_matrix_1[12][2];
assign  m1_2[13] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [13][2] :choose_matrix_1[13][2];
assign  m1_2[14] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [14][2] :choose_matrix_1[14][2];
assign  m1_2[15] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [15][2] :choose_matrix_1[15][2];

assign  m1_3[0] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [0][3] : choose_matrix_1[0][3];
assign  m1_3[1] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [1][3] : choose_matrix_1[1][3];
assign  m1_3[2] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [2][3] : choose_matrix_1[2][3];
assign  m1_3[3] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [3][3] : choose_matrix_1[3][3];
assign  m1_3[4] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [4][3] : choose_matrix_1[4][3];
assign  m1_3[5] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [5][3] : choose_matrix_1[5][3];
assign  m1_3[6] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [6][3] : choose_matrix_1[6][3];
assign  m1_3[7] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [7][3] : choose_matrix_1[7][3];
assign  m1_3[8] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [8][3] : choose_matrix_1[8][3];
assign  m1_3[9] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [9][3] : choose_matrix_1[9][3];
assign  m1_3[10] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [10][3] :choose_matrix_1[10][3];
assign  m1_3[11] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [11][3] :choose_matrix_1[11][3];
assign  m1_3[12] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [12][3] :choose_matrix_1[12][3];
assign  m1_3[13] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [13][3] :choose_matrix_1[13][3];
assign  m1_3[14] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [14][3] :choose_matrix_1[14][3];
assign  m1_3[15] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [15][3] :choose_matrix_1[15][3];

assign  m1_4[0] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [0][4] : choose_matrix_1[0][4];
assign  m1_4[1] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [1][4] : choose_matrix_1[1][4];
assign  m1_4[2] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [2][4] : choose_matrix_1[2][4];
assign  m1_4[3] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [3][4] : choose_matrix_1[3][4];
assign  m1_4[4] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [4][4] : choose_matrix_1[4][4];
assign  m1_4[5] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [5][4] : choose_matrix_1[5][4];
assign  m1_4[6] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [6][4] : choose_matrix_1[6][4];
assign  m1_4[7] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [7][4] : choose_matrix_1[7][4];
assign  m1_4[8] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [8][4] : choose_matrix_1[8][4];
assign  m1_4[9] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [9][4] : choose_matrix_1[9][4];
assign  m1_4[10] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [10][4] :choose_matrix_1[10][4];
assign  m1_4[11] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [11][4] :choose_matrix_1[11][4];
assign  m1_4[12] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [12][4] :choose_matrix_1[12][4];
assign  m1_4[13] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [13][4] :choose_matrix_1[13][4];
assign  m1_4[14] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [14][4] :choose_matrix_1[14][4];
assign  m1_4[15] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [15][4] :choose_matrix_1[15][4];

assign  m1_5[0] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [0][5] : choose_matrix_1[0][5];
assign  m1_5[1] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [1][5] : choose_matrix_1[1][5];
assign  m1_5[2] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [2][5] : choose_matrix_1[2][5];
assign  m1_5[3] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [3][5] : choose_matrix_1[3][5];
assign  m1_5[4] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [4][5] : choose_matrix_1[4][5];
assign  m1_5[5] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [5][5] : choose_matrix_1[5][5];
assign  m1_5[6] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [6][5] : choose_matrix_1[6][5];
assign  m1_5[7] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [7][5] : choose_matrix_1[7][5];
assign  m1_5[8] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [8][5] : choose_matrix_1[8][5];
assign  m1_5[9] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [9][5] : choose_matrix_1[9][5];
assign  m1_5[10] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [10][5] :choose_matrix_1[10][5];
assign  m1_5[11] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [11][5] :choose_matrix_1[11][5];
assign  m1_5[12] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [12][5] :choose_matrix_1[12][5];
assign  m1_5[13] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [13][5] :choose_matrix_1[13][5];
assign  m1_5[14] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [14][5] :choose_matrix_1[14][5];
assign  m1_5[15] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [15][5] :choose_matrix_1[15][5];

assign  m1_6[0] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [0][6] : choose_matrix_1[0][6];
assign  m1_6[1] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [1][6] : choose_matrix_1[1][6];
assign  m1_6[2] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [2][6] : choose_matrix_1[2][6];
assign  m1_6[3] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [3][6] : choose_matrix_1[3][6];
assign  m1_6[4] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [4][6] : choose_matrix_1[4][6];
assign  m1_6[5] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [5][6] : choose_matrix_1[5][6];
assign  m1_6[6] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [6][6] : choose_matrix_1[6][6];
assign  m1_6[7] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [7][6] : choose_matrix_1[7][6];
assign  m1_6[8] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [8][6] : choose_matrix_1[8][6];
assign  m1_6[9] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [9][6] : choose_matrix_1[9][6];
assign  m1_6[10] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [10][6] :choose_matrix_1[10][6];
assign  m1_6[11] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [11][6] :choose_matrix_1[11][6];
assign  m1_6[12] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [12][6] :choose_matrix_1[12][6];
assign  m1_6[13] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [13][6] :choose_matrix_1[13][6];
assign  m1_6[14] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [14][6] :choose_matrix_1[14][6];
assign  m1_6[15] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [15][6] :choose_matrix_1[15][6];

assign  m1_7[0] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [0][7] : choose_matrix_1[0][7];
assign  m1_7[1] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [1][7] : choose_matrix_1[1][7];
assign  m1_7[2] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [2][7] : choose_matrix_1[2][7];
assign  m1_7[3] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [3][7] : choose_matrix_1[3][7];
assign  m1_7[4] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [4][7] : choose_matrix_1[4][7];
assign  m1_7[5] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [5][7] : choose_matrix_1[5][7];
assign  m1_7[6] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [6][7] : choose_matrix_1[6][7];
assign  m1_7[7] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [7][7] : choose_matrix_1[7][7];
assign  m1_7[8] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [8][7] : choose_matrix_1[8][7];
assign  m1_7[9] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [9][7] : choose_matrix_1[9][7];
assign  m1_7[10] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [10][7] :choose_matrix_1[10][7];
assign  m1_7[11] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [11][7] :choose_matrix_1[11][7];
assign  m1_7[12] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [12][7] :choose_matrix_1[12][7];
assign  m1_7[13] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [13][7] :choose_matrix_1[13][7];
assign  m1_7[14] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [14][7] :choose_matrix_1[14][7];
assign  m1_7[15] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [15][7] :choose_matrix_1[15][7];

assign  m1_8[0] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [0][8] : choose_matrix_1[0][8];
assign  m1_8[1] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [1][8] : choose_matrix_1[1][8];
assign  m1_8[2] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [2][8] : choose_matrix_1[2][8];
assign  m1_8[3] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [3][8] : choose_matrix_1[3][8];
assign  m1_8[4] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [4][8] : choose_matrix_1[4][8];
assign  m1_8[5] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [5][8] : choose_matrix_1[5][8];
assign  m1_8[6] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [6][8] : choose_matrix_1[6][8];
assign  m1_8[7] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [7][8] : choose_matrix_1[7][8];
assign  m1_8[8] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [8][8] : choose_matrix_1[8][8];
assign  m1_8[9] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [9][8] : choose_matrix_1[9][8];
assign  m1_8[10] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [10][8] :choose_matrix_1[10][8];
assign  m1_8[11] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [11][8] :choose_matrix_1[11][8];
assign  m1_8[12] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [12][8] :choose_matrix_1[12][8];
assign  m1_8[13] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [13][8] :choose_matrix_1[13][8];
assign  m1_8[14] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [14][8] :choose_matrix_1[14][8];
assign  m1_8[15] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [15][8] :choose_matrix_1[15][8];

assign  m1_9[0] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [0][9] : choose_matrix_1[0][9];
assign  m1_9[1] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [1][9] : choose_matrix_1[1][9];
assign  m1_9[2] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [2][9] : choose_matrix_1[2][9];
assign  m1_9[3] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [3][9] : choose_matrix_1[3][9];
assign  m1_9[4] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [4][9] : choose_matrix_1[4][9];
assign  m1_9[5] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [5][9] : choose_matrix_1[5][9];
assign  m1_9[6] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [6][9] : choose_matrix_1[6][9];
assign  m1_9[7] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [7][9] : choose_matrix_1[7][9];
assign  m1_9[8] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [8][9] : choose_matrix_1[8][9];
assign  m1_9[9] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [9][9] : choose_matrix_1[9][9];
assign  m1_9[10] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [10][9] :choose_matrix_1[10][9];
assign  m1_9[11] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [11][9] :choose_matrix_1[11][9];
assign  m1_9[12] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [12][9] :choose_matrix_1[12][9];
assign  m1_9[13] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [13][9] :choose_matrix_1[13][9];
assign  m1_9[14] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [14][9] :choose_matrix_1[14][9];
assign  m1_9[15] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [15][9] :choose_matrix_1[15][9];

assign  m1_10[0] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [0][10] : choose_matrix_1[0][10];
assign  m1_10[1] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [1][10] : choose_matrix_1[1][10];
assign  m1_10[2] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [2][10] : choose_matrix_1[2][10];
assign  m1_10[3] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [3][10] : choose_matrix_1[3][10];
assign  m1_10[4] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [4][10] : choose_matrix_1[4][10];
assign  m1_10[5] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [5][10] : choose_matrix_1[5][10];
assign  m1_10[6] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [6][10] : choose_matrix_1[6][10];
assign  m1_10[7] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [7][10] : choose_matrix_1[7][10];
assign  m1_10[8] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [8][10] : choose_matrix_1[8][10];
assign  m1_10[9] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [9][10] : choose_matrix_1[9][10];
assign  m1_10[10] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [10][10] :choose_matrix_1[10][10];
assign  m1_10[11] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [11][10] :choose_matrix_1[11][10];
assign  m1_10[12] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [12][10] :choose_matrix_1[12][10];
assign  m1_10[13] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [13][10] :choose_matrix_1[13][10];
assign  m1_10[14] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [14][10] :choose_matrix_1[14][10];
assign  m1_10[15] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [15][10] :choose_matrix_1[15][10];

assign  m1_11[0] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [0][11] : choose_matrix_1[0][11];
assign  m1_11[1] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [1][11] : choose_matrix_1[1][11];
assign  m1_11[2] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [2][11] : choose_matrix_1[2][11];
assign  m1_11[3] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [3][11] : choose_matrix_1[3][11];
assign  m1_11[4] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [4][11] : choose_matrix_1[4][11];
assign  m1_11[5] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [5][11] : choose_matrix_1[5][11];
assign  m1_11[6] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [6][11] : choose_matrix_1[6][11];
assign  m1_11[7] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [7][11] : choose_matrix_1[7][11];
assign  m1_11[8] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [8][11] : choose_matrix_1[8][11];
assign  m1_11[9] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [9][11] : choose_matrix_1[9][11];
assign  m1_11[10] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [10][11] :choose_matrix_1[10][11];
assign  m1_11[11] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [11][11] :choose_matrix_1[11][11];
assign  m1_11[12] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [12][11] :choose_matrix_1[12][11];
assign  m1_11[13] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [13][11] :choose_matrix_1[13][11];
assign  m1_11[14] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [14][11] :choose_matrix_1[14][11];
assign  m1_11[15] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [15][11] :choose_matrix_1[15][11];

assign  m1_12[0] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [0][12] : choose_matrix_1[0][12];
assign  m1_12[1] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [1][12] : choose_matrix_1[1][12];
assign  m1_12[2] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [2][12] : choose_matrix_1[2][12];
assign  m1_12[3] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [3][12] : choose_matrix_1[3][12];
assign  m1_12[4] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [4][12] : choose_matrix_1[4][12];
assign  m1_12[5] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [5][12] : choose_matrix_1[5][12];
assign  m1_12[6] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [6][12] : choose_matrix_1[6][12];
assign  m1_12[7] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [7][12] : choose_matrix_1[7][12];
assign  m1_12[8] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [8][12] : choose_matrix_1[8][12];
assign  m1_12[9] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [9][12] : choose_matrix_1[9][12];
assign  m1_12[10] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [10][12] :choose_matrix_1[10][12];
assign  m1_12[11] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [11][12] :choose_matrix_1[11][12];
assign  m1_12[12] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [12][12] :choose_matrix_1[12][12];
assign  m1_12[13] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [13][12] :choose_matrix_1[13][12];
assign  m1_12[14] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [14][12] :choose_matrix_1[14][12];
assign  m1_12[15] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [15][12] :choose_matrix_1[15][12];

assign  m1_13[0] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [0][13] : choose_matrix_1[0][13];
assign  m1_13[1] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [1][13] : choose_matrix_1[1][13];
assign  m1_13[2] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [2][13] : choose_matrix_1[2][13];
assign  m1_13[3] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [3][13] : choose_matrix_1[3][13];
assign  m1_13[4] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [4][13] : choose_matrix_1[4][13];
assign  m1_13[5] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [5][13] : choose_matrix_1[5][13];
assign  m1_13[6] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [6][13] : choose_matrix_1[6][13];
assign  m1_13[7] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [7][13] : choose_matrix_1[7][13];
assign  m1_13[8] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [8][13] : choose_matrix_1[8][13];
assign  m1_13[9] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [9][13] : choose_matrix_1[9][13];
assign  m1_13[10] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [10][13] :choose_matrix_1[10][13];
assign  m1_13[11] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [11][13] :choose_matrix_1[11][13];
assign  m1_13[12] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [12][13] :choose_matrix_1[12][13];
assign  m1_13[13] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [13][13] :choose_matrix_1[13][13];
assign  m1_13[14] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [14][13] :choose_matrix_1[14][13];
assign  m1_13[15] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [15][13] :choose_matrix_1[15][13];

assign  m1_14[0] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [0][14] : choose_matrix_1[0][14];
assign  m1_14[1] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [1][14] : choose_matrix_1[1][14];
assign  m1_14[2] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [2][14] : choose_matrix_1[2][14];
assign  m1_14[3] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [3][14] : choose_matrix_1[3][14];
assign  m1_14[4] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [4][14] : choose_matrix_1[4][14];
assign  m1_14[5] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [5][14] : choose_matrix_1[5][14];
assign  m1_14[6] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [6][14] : choose_matrix_1[6][14];
assign  m1_14[7] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [7][14] : choose_matrix_1[7][14];
assign  m1_14[8] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [8][14] : choose_matrix_1[8][14];
assign  m1_14[9] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [9][14] : choose_matrix_1[9][14];
assign  m1_14[10] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [10][14] :choose_matrix_1[10][14];
assign  m1_14[11] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [11][14] :choose_matrix_1[11][14];
assign  m1_14[12] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [12][14] :choose_matrix_1[12][14];
assign  m1_14[13] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [13][14] :choose_matrix_1[13][14];
assign  m1_14[14] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [14][14] :choose_matrix_1[14][14];
assign  m1_14[15] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [15][14] :choose_matrix_1[15][14];

assign  m1_15[0] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [0][15] : choose_matrix_1[0][15];
assign  m1_15[1] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [1][15] : choose_matrix_1[1][15];
assign  m1_15[2] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [2][15] : choose_matrix_1[2][15];
assign  m1_15[3] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [3][15] : choose_matrix_1[3][15];
assign  m1_15[4] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [4][15] : choose_matrix_1[4][15];
assign  m1_15[5] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [5][15] : choose_matrix_1[5][15];
assign  m1_15[6] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [6][15] : choose_matrix_1[6][15];
assign  m1_15[7] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [7][15] : choose_matrix_1[7][15];
assign  m1_15[8] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [8][15] : choose_matrix_1[8][15];
assign  m1_15[9] =  (NEXT == COMPUTE_1_2) ?  choose_matrix_2 [9][15] : choose_matrix_1[9][15];
assign  m1_15[10] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [10][15] :choose_matrix_1[10][15];
assign  m1_15[11] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [11][15] :choose_matrix_1[11][15];
assign  m1_15[12] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [12][15] :choose_matrix_1[12][15];
assign  m1_15[13] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [13][15] :choose_matrix_1[13][15];
assign  m1_15[14] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [14][15] :choose_matrix_1[14][15];
assign  m1_15[15] = (NEXT == COMPUTE_1_2) ? choose_matrix_2 [15][15] :choose_matrix_1[15][15];


dot_16 D0 (.m_0(m0[0]) ,.m_1(m0[1]) ,.m_2(m0[2]),.m_3(m0[3]),.m_4(m0[4]),.m_5(m0[5]) ,.m_6(m0[6]),.m_7(m0[7]),.m_8(m0[8]),
		   .m_9(m0[9]),.m_10(m0[10]),.m_11(m0[11]),.m_12(m0[12]),.m_13(m0[13]),.m_14(m0[14]),.m_15(m0[15]),
		   .m_16(m1_0[0]) ,.m_17(m1_0[1]) ,.m_18(m1_0[2]),.m_19(m1_0[3]),.m_20(m1_0[4]),.m_21(m1_0[5]) ,.m_22(m1_0[6]),.m_23(m1_0[7]),.m_24(m1_0[8]),
		   .m_25(m1_0[9]),.m_26(m1_0[10]),.m_27(m1_0[11]),.m_28(m1_0[12]),.m_29(m1_0[13]),.m_30(m1_0[14]),.m_31(m1_0[15]),
		   .clk(clk), .dot_out(m1_out[0]));

dot_16 D1 (.m_0(m0[0]) ,.m_1(m0[1]) ,.m_2(m0[2]),.m_3(m0[3]),.m_4(m0[4]),.m_5(m0[5]) ,.m_6(m0[6]),.m_7(m0[7]),.m_8(m0[8]),
		   .m_9(m0[9]),.m_10(m0[10]),.m_11(m0[11]),.m_12(m0[12]),.m_13(m0[13]),.m_14(m0[14]),.m_15(m0[15]),
		   .m_16(m1_1[0]) ,.m_17(m1_1[1]) ,.m_18(m1_1[2]),.m_19(m1_1[3]),.m_20(m1_1[4]),.m_21(m1_1[5]) ,.m_22(m1_1[6]),.m_23(m1_1[7]),.m_24(m1_1[8]),
		   .m_25(m1_1[9]),.m_26(m1_1[10]),.m_27(m1_1[11]),.m_28(m1_1[12]),.m_29(m1_1[13]),.m_30(m1_1[14]),.m_31(m1_1[15]),
		   .clk(clk), .dot_out(m1_out[1]));

dot_16 D2 (.m_0(m0[0]) ,.m_1(m0[1]) ,.m_2(m0[2]),.m_3(m0[3]),.m_4(m0[4]),.m_5(m0[5]) ,.m_6(m0[6]),.m_7(m0[7]),.m_8(m0[8]),
		   .m_9(m0[9]),.m_10(m0[10]),.m_11(m0[11]),.m_12(m0[12]),.m_13(m0[13]),.m_14(m0[14]),.m_15(m0[15]),
		   .m_16(m1_2[0]) ,.m_17(m1_2[1]) ,.m_18(m1_2[2]),.m_19(m1_2[3]),.m_20(m1_2[4]),.m_21(m1_2[5]) ,.m_22(m1_2[6]),.m_23(m1_2[7]),.m_24(m1_2[8]),
		   .m_25(m1_2[9]),.m_26(m1_2[10]),.m_27(m1_2[11]),.m_28(m1_2[12]),.m_29(m1_2[13]),.m_30(m1_2[14]),.m_31(m1_2[15]),
		   .clk(clk), .dot_out(m1_out[2]));


dot_16 D3 (.m_0(m0[0]) ,.m_1(m0[1]) ,.m_2(m0[2]),.m_3(m0[3]),.m_4(m0[4]),.m_5(m0[5]) ,.m_6(m0[6]),.m_7(m0[7]),.m_8(m0[8]),
		   .m_9(m0[9]),.m_10(m0[10]),.m_11(m0[11]),.m_12(m0[12]),.m_13(m0[13]),.m_14(m0[14]),.m_15(m0[15]),
		   .m_16(m1_3[0]) ,.m_17(m1_3[1]) ,.m_18(m1_3[2]),.m_19(m1_3[3]),.m_20(m1_3[4]),.m_21(m1_3[5]) ,.m_22(m1_3[6]),.m_23(m1_3[7]),.m_24(m1_3[8]),
		   .m_25(m1_3[9]),.m_26(m1_3[10]),.m_27(m1_3[11]),.m_28(m1_3[12]),.m_29(m1_3[13]),.m_30(m1_3[14]),.m_31(m1_3[15]),
		   .clk(clk), .dot_out(m1_out[3]));

dot_16 D4 (.m_0(m0[0]) ,.m_1(m0[1]) ,.m_2(m0[2]),.m_3(m0[3]),.m_4(m0[4]),.m_5(m0[5]) ,.m_6(m0[6]),.m_7(m0[7]),.m_8(m0[8]),
		   .m_9(m0[9]),.m_10(m0[10]),.m_11(m0[11]),.m_12(m0[12]),.m_13(m0[13]),.m_14(m0[14]),.m_15(m0[15]),
		   .m_16(m1_4[0]) ,.m_17(m1_4[1]) ,.m_18(m1_4[2]),.m_19(m1_4[3]),.m_20(m1_4[4]),.m_21(m1_4[5]) ,.m_22(m1_4[6]),.m_23(m1_4[7]),.m_24(m1_4[8]),
		   .m_25(m1_4[9]),.m_26(m1_4[10]),.m_27(m1_4[11]),.m_28(m1_4[12]),.m_29(m1_4[13]),.m_30(m1_4[14]),.m_31(m1_4[15]),
		   .clk(clk), .dot_out(m1_out[4]));

dot_16 D5 (.m_0(m0[0]) ,.m_1(m0[1]) ,.m_2(m0[2]),.m_3(m0[3]),.m_4(m0[4]),.m_5(m0[5]) ,.m_6(m0[6]),.m_7(m0[7]),.m_8(m0[8]),
		   .m_9(m0[9]),.m_10(m0[10]),.m_11(m0[11]),.m_12(m0[12]),.m_13(m0[13]),.m_14(m0[14]),.m_15(m0[15]),
		   .m_16(m1_5[0]) ,.m_17(m1_5[1]) ,.m_18(m1_5[2]),.m_19(m1_5[3]),.m_20(m1_5[4]),.m_21(m1_5[5]) ,.m_22(m1_5[6]),.m_23(m1_5[7]),.m_24(m1_5[8]),
		   .m_25(m1_5[9]),.m_26(m1_5[10]),.m_27(m1_5[11]),.m_28(m1_5[12]),.m_29(m1_5[13]),.m_30(m1_5[14]),.m_31(m1_5[15]),
		   .clk(clk), .dot_out(m1_out[5]));

dot_16 D6 (.m_0(m0[0]) ,.m_1(m0[1]) ,.m_2(m0[2]),.m_3(m0[3]),.m_4(m0[4]),.m_5(m0[5]) ,.m_6(m0[6]),.m_7(m0[7]),.m_8(m0[8]),
		   .m_9(m0[9]),.m_10(m0[10]),.m_11(m0[11]),.m_12(m0[12]),.m_13(m0[13]),.m_14(m0[14]),.m_15(m0[15]),
		   .m_16(m1_6[0]) ,.m_17(m1_6[1]) ,.m_18(m1_6[2]),.m_19(m1_6[3]),.m_20(m1_6[4]),.m_21(m1_6[5]) ,.m_22(m1_6[6]),.m_23(m1_6[7]),.m_24(m1_6[8]),
		   .m_25(m1_6[9]),.m_26(m1_6[10]),.m_27(m1_6[11]),.m_28(m1_6[12]),.m_29(m1_6[13]),.m_30(m1_6[14]),.m_31(m1_6[15]),
		   .clk(clk), .dot_out(m1_out[6]));

dot_16 D7 (.m_0(m0[0]) ,.m_1(m0[1]) ,.m_2(m0[2]),.m_3(m0[3]),.m_4(m0[4]),.m_5(m0[5]) ,.m_6(m0[6]),.m_7(m0[7]),.m_8(m0[8]),
		   .m_9(m0[9]),.m_10(m0[10]),.m_11(m0[11]),.m_12(m0[12]),.m_13(m0[13]),.m_14(m0[14]),.m_15(m0[15]),
		   .m_16(m1_7[0]) ,.m_17(m1_7[1]) ,.m_18(m1_7[2]),.m_19(m1_7[3]),.m_20(m1_7[4]),.m_21(m1_7[5]) ,.m_22(m1_7[6]),.m_23(m1_7[7]),.m_24(m1_7[8]),
		   .m_25(m1_7[9]),.m_26(m1_7[10]),.m_27(m1_7[11]),.m_28(m1_7[12]),.m_29(m1_7[13]),.m_30(m1_7[14]),.m_31(m1_7[15]),
		   .clk(clk), .dot_out(m1_out[7]));

dot_16 D8 (.m_0(m0[0]) ,.m_1(m0[1]) ,.m_2(m0[2]),.m_3(m0[3]),.m_4(m0[4]),.m_5(m0[5]) ,.m_6(m0[6]),.m_7(m0[7]),.m_8(m0[8]),
		   .m_9(m0[9]),.m_10(m0[10]),.m_11(m0[11]),.m_12(m0[12]),.m_13(m0[13]),.m_14(m0[14]),.m_15(m0[15]),
		   .m_16(m1_8[0]) ,.m_17(m1_8[1]) ,.m_18(m1_8[2]),.m_19(m1_8[3]),.m_20(m1_8[4]),.m_21(m1_8[5]) ,.m_22(m1_8[6]),.m_23(m1_8[7]),.m_24(m1_8[8]),
		   .m_25(m1_8[9]),.m_26(m1_8[10]),.m_27(m1_8[11]),.m_28(m1_8[12]),.m_29(m1_8[13]),.m_30(m1_8[14]),.m_31(m1_8[15]),
		   .clk(clk), .dot_out(m1_out[8]));

dot_16 D9 (.m_0(m0[0]) ,.m_1(m0[1]) ,.m_2(m0[2]),.m_3(m0[3]),.m_4(m0[4]),.m_5(m0[5]) ,.m_6(m0[6]),.m_7(m0[7]),.m_8(m0[8]),
		   .m_9(m0[9]),.m_10(m0[10]),.m_11(m0[11]),.m_12(m0[12]),.m_13(m0[13]),.m_14(m0[14]),.m_15(m0[15]),
		   .m_16(m1_9[0]) ,.m_17(m1_9[1]) ,.m_18(m1_9[2]),.m_19(m1_9[3]),.m_20(m1_9[4]),.m_21(m1_9[5]) ,.m_22(m1_9[6]),.m_23(m1_9[7]),.m_24(m1_9[8]),
		   .m_25(m1_9[9]),.m_26(m1_9[10]),.m_27(m1_9[11]),.m_28(m1_9[12]),.m_29(m1_9[13]),.m_30(m1_9[14]),.m_31(m1_9[15]),
		   .clk(clk), .dot_out(m1_out[9]));

dot_16 D10 (.m_0(m0[0]) ,.m_1(m0[1]) ,.m_2(m0[2]),.m_3(m0[3]),.m_4(m0[4]),.m_5(m0[5]) ,.m_6(m0[6]),.m_7(m0[7]),.m_8(m0[8]),
		   .m_9(m0[9]),.m_10(m0[10]),.m_11(m0[11]),.m_12(m0[12]),.m_13(m0[13]),.m_14(m0[14]),.m_15(m0[15]),
		   .m_16(m1_10[0]) ,.m_17(m1_10[1]) ,.m_18(m1_10[2]),.m_19(m1_10[3]),.m_20(m1_10[4]),.m_21(m1_10[5]) ,.m_22(m1_10[6]),.m_23(m1_10[7]),.m_24(m1_10[8]),
		   .m_25(m1_10[9]),.m_26(m1_10[10]),.m_27(m1_10[11]),.m_28(m1_10[12]),.m_29(m1_10[13]),.m_30(m1_10[14]),.m_31(m1_10[15]),
		   .clk(clk), .dot_out(m1_out[10]));

dot_16 D11 (.m_0(m0[0]) ,.m_1(m0[1]) ,.m_2(m0[2]),.m_3(m0[3]),.m_4(m0[4]),.m_5(m0[5]) ,.m_6(m0[6]),.m_7(m0[7]),.m_8(m0[8]),
		   .m_9(m0[9]),.m_10(m0[10]),.m_11(m0[11]),.m_12(m0[12]),.m_13(m0[13]),.m_14(m0[14]),.m_15(m0[15]),
		   .m_16(m1_11[0]) ,.m_17(m1_11[1]) ,.m_18(m1_11[2]),.m_19(m1_11[3]),.m_20(m1_11[4]),.m_21(m1_11[5]) ,.m_22(m1_11[6]),.m_23(m1_11[7]),.m_24(m1_11[8]),
		   .m_25(m1_11[9]),.m_26(m1_11[10]),.m_27(m1_11[11]),.m_28(m1_11[12]),.m_29(m1_11[13]),.m_30(m1_11[14]),.m_31(m1_11[15]),
		   .clk(clk), .dot_out(m1_out[11]));

dot_16 D12 (.m_0(m0[0]) ,.m_1(m0[1]) ,.m_2(m0[2]),.m_3(m0[3]),.m_4(m0[4]),.m_5(m0[5]) ,.m_6(m0[6]),.m_7(m0[7]),.m_8(m0[8]),
		   .m_9(m0[9]),.m_10(m0[10]),.m_11(m0[11]),.m_12(m0[12]),.m_13(m0[13]),.m_14(m0[14]),.m_15(m0[15]),
		   .m_16(m1_12[0]) ,.m_17(m1_12[1]) ,.m_18(m1_12[2]),.m_19(m1_12[3]),.m_20(m1_12[4]),.m_21(m1_12[5]) ,.m_22(m1_12[6]),.m_23(m1_12[7]),.m_24(m1_12[8]),
		   .m_25(m1_12[9]),.m_26(m1_12[10]),.m_27(m1_12[11]),.m_28(m1_12[12]),.m_29(m1_12[13]),.m_30(m1_12[14]),.m_31(m1_12[15]),
		   .clk(clk), .dot_out(m1_out[12]));

dot_16 D13 (.m_0(m0[0]) ,.m_1(m0[1]) ,.m_2(m0[2]),.m_3(m0[3]),.m_4(m0[4]),.m_5(m0[5]) ,.m_6(m0[6]),.m_7(m0[7]),.m_8(m0[8]),
		   .m_9(m0[9]),.m_10(m0[10]),.m_11(m0[11]),.m_12(m0[12]),.m_13(m0[13]),.m_14(m0[14]),.m_15(m0[15]),
		   .m_16(m1_13[0]) ,.m_17(m1_13[1]) ,.m_18(m1_13[2]),.m_19(m1_13[3]),.m_20(m1_13[4]),.m_21(m1_13[5]) ,.m_22(m1_13[6]),.m_23(m1_13[7]),.m_24(m1_13[8]),
		   .m_25(m1_13[9]),.m_26(m1_13[10]),.m_27(m1_13[11]),.m_28(m1_13[12]),.m_29(m1_13[13]),.m_30(m1_13[14]),.m_31(m1_13[15]),
		   .clk(clk), .dot_out(m1_out[13]));

dot_16 D14 (.m_0(m0[0]) ,.m_1(m0[1]) ,.m_2(m0[2]),.m_3(m0[3]),.m_4(m0[4]),.m_5(m0[5]) ,.m_6(m0[6]),.m_7(m0[7]),.m_8(m0[8]),
		   .m_9(m0[9]),.m_10(m0[10]),.m_11(m0[11]),.m_12(m0[12]),.m_13(m0[13]),.m_14(m0[14]),.m_15(m0[15]),
		   .m_16(m1_14[0]) ,.m_17(m1_14[1]) ,.m_18(m1_14[2]),.m_19(m1_14[3]),.m_20(m1_14[4]),.m_21(m1_14[5]) ,.m_22(m1_14[6]),.m_23(m1_14[7]),.m_24(m1_14[8]),
		   .m_25(m1_14[9]),.m_26(m1_14[10]),.m_27(m1_14[11]),.m_28(m1_14[12]),.m_29(m1_14[13]),.m_30(m1_14[14]),.m_31(m1_14[15]),
		   .clk(clk), .dot_out(m1_out[14]));

dot_16 D15 (.m_0(m0[0]) ,.m_1(m0[1]) ,.m_2(m0[2]),.m_3(m0[3]),.m_4(m0[4]),.m_5(m0[5]) ,.m_6(m0[6]),.m_7(m0[7]),.m_8(m0[8]),
		   .m_9(m0[9]),.m_10(m0[10]),.m_11(m0[11]),.m_12(m0[12]),.m_13(m0[13]),.m_14(m0[14]),.m_15(m0[15]),
		   .m_16(m1_15[0]) ,.m_17(m1_15[1]) ,.m_18(m1_15[2]),.m_19(m1_15[3]),.m_20(m1_15[4]),.m_21(m1_15[5]) ,.m_22(m1_15[6]),.m_23(m1_15[7]),.m_24(m1_15[8]),
		   .m_25(m1_15[9]),.m_26(m1_15[10]),.m_27(m1_15[11]),.m_28(m1_15[12]),.m_29(m1_15[13]),.m_30(m1_15[14]),.m_31(m1_15[15]),
		   .clk(clk), .dot_out(m1_out[15]));

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		cnt_delay <= 0;
	else 
		cnt_delay <= cnt_row;
end

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		cnt_delay_2 <= 0;
	else 
		cnt_delay_2 <= cnt_delay;
end



always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		for(i = 0; i < 16; i = i + 1)begin
			for(j = 0; j < 16; j = j + 1)
					temp_matrix_0 [i][j] <= 0;
		end
	end
	else if(NEXT == COMPUTE_1_1 || NEXT == COMPUTE_1_2)begin
			temp_matrix_0 [cnt_delay_2][0] <= m1_out[0];
			temp_matrix_0 [cnt_delay_2][1] <= m1_out[1];
			temp_matrix_0 [cnt_delay_2][2] <= m1_out[2];
			temp_matrix_0 [cnt_delay_2][3] <= m1_out[3];
			temp_matrix_0 [cnt_delay_2][4] <= m1_out[4];
			temp_matrix_0 [cnt_delay_2][5] <= m1_out[5];
			temp_matrix_0 [cnt_delay_2][6] <= m1_out[6];
			temp_matrix_0 [cnt_delay_2][7] <= m1_out[7];
			temp_matrix_0 [cnt_delay_2][8] <= m1_out[8];
			temp_matrix_0 [cnt_delay_2][9] <= m1_out[9];
			temp_matrix_0 [cnt_delay_2][10] <= m1_out[10];
			temp_matrix_0 [cnt_delay_2][11] <= m1_out[11];
			temp_matrix_0 [cnt_delay_2][12] <= m1_out[12];
			temp_matrix_0 [cnt_delay_2][13] <= m1_out[13];
			temp_matrix_0 [cnt_delay_2][14] <= m1_out[14];
			temp_matrix_0 [cnt_delay_2][15] <= m1_out[15];
	end
	else if(STATE == ZERO)begin
		for(i = 0; i < 16; i = i + 1)begin
			for(j = 0; j < 16; j = j + 1)
					temp_matrix_0 [i][j] <= 0;
		end
	end
end


assign trace[0] = temp_matrix_0[0][0];
assign trace[1] = temp_matrix_0[1][1];
assign trace[2] = temp_matrix_0[2][2];
assign trace[3] = temp_matrix_0[3][3];
assign trace[4] = temp_matrix_0[4][4];
assign trace[5] = temp_matrix_0[5][5];
assign trace[6] = temp_matrix_0[6][6];
assign trace[7] = temp_matrix_0[7][7];
assign trace[8] = temp_matrix_0[8][8];
assign trace[9] = temp_matrix_0[9][9];
assign trace[10] = temp_matrix_0[10][10];
assign trace[11] = temp_matrix_0[11][11];
assign trace[12] = temp_matrix_0[12][12];
assign trace[13] = temp_matrix_0[13][13];
assign trace[14] = temp_matrix_0[14][14];
assign trace[15] = temp_matrix_0[15][15];


add_16 A_0(   .e_in_0(trace[0]),.e_in_1(trace[1]),.e_in_2(trace[2]), .e_in_3(trace[3]),.e_in_4(trace[4]),.e_in_5 (trace[5]),.e_in_6(trace[6]),.e_in_7(trace[7])
			 ,.e_in_8(trace[8]),.e_in_9(trace[9]),.e_in_10(trace[10]),.e_in_11(trace[11]),.e_in_12(trace[12]),.e_in_13(trace[13]),.e_in_14(trace[14]),.e_in_15(trace[15])
			 ,.gold(gold_trace),.clk(clk));

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		cnt_trace <= 0;
	else if(NEXT == COMPUTE_TRACE)
		cnt_trace <= cnt_trace + 1;
	else 
		cnt_trace <= 0;
end

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		store_trace <= 0;
	else
		store_trace <= gold_trace;
end

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		cnt_pattern <= 0;
	else if(NEXT == OUT && cnt_pattern < 10)
		cnt_pattern <= cnt_pattern + 1;
	else if(NEXT == ZERO )
		cnt_pattern <= 0;
	else
		cnt_pattern <= cnt_pattern;
end


always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		out_valid <= 0;
	else if(NEXT == OUT)
	    out_valid <= 1;
	else 
		out_valid <= 0;
end


always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		out_value <= 0;
	else if(NEXT == OUT)
	    out_value <= store_trace;
	else 
	    out_value <= 0;
end

endmodule


module dot_16 (m_0 , m_1 , m_2 , m_3 , m_4 , m_5 , m_6 , m_7 , m_8 , m_9 , m_10 , m_11 , m_12 , m_13 , m_14 , m_15 ,
			   m_16 , m_17 , m_18 , m_19 , m_20 , m_21 , m_22 , m_23 , m_24 , m_25 , m_26 , m_27 , m_28 , m_29 , m_30 , m_31 ,
			   clk, dot_out);
input clk;
input signed  [20:0] m_0 , m_1 , m_2 , m_3 , m_4 , m_5 , m_6 , m_7 , m_8 , m_9 , m_10 , m_11 , m_12 , m_13 , m_14 , m_15;
input signed  [20:0] m_16 , m_17 , m_18 , m_19 , m_20 , m_21 , m_22 , m_23 , m_24 , m_25 , m_26 , m_27 , m_28 , m_29 , m_30 , m_31;
output signed [49:0] dot_out;

reg signed  [20:0] m_0_r , m_1_r , m_2_r , m_3_r , m_4_r , m_5_r , m_6_r , m_7_r , m_8_r , m_9_r , m_10_r , m_11_r , m_12_r , m_13_r , m_14_r , m_15_r;
reg signed  [20:0] m_16_r , m_17_r , m_18_r , m_19_r , m_20_r , m_21_r , m_22_r , m_23_r , m_24_r , m_25_r , m_26_r , m_27_r , m_28_r , m_29_r , m_30_r , m_31_r;

wire signed [40:0] m_m_0, m_m_1 , m_m_2 , m_m_3 , m_m_4 , m_m_5 , m_m_6 , m_m_7;                             
wire signed [40:0] m_m_8, m_m_9 , m_m_10 , m_m_11 , m_m_12 , m_m_13 , m_m_14 , m_m_15;

reg	 signed [40:0] m_m_0_r , m_m_1_r , m_m_2_r , m_m_3_r , m_m_4_r , m_m_5_r , m_m_6_r , m_m_7_r,    
				   m_m_8_r , m_m_9_r , m_m_10_r , m_m_11_r , m_m_12_r , m_m_13_r , m_m_14_r , m_m_15_r;


wire signed [45:0] m_p1_0 , m_p1_1 , m_p1_2 , m_p1_3 , m_p1_4 , m_p1_5 , m_p1_6 , m_p1_7;
wire signed [46:0] m_p2_0 , m_p2_1 , m_p2_2 , m_p2_3;				  
wire signed [47:0] m_p3_0 , m_p3_1;				  

always @(posedge clk)
begin
		//matrix 1
        m_0_r   <= m_0 ;
		m_1_r   <= m_1 ;
		m_2_r   <= m_2 ;
		m_3_r   <= m_3 ;
		m_4_r   <= m_4 ;
		m_5_r   <= m_5 ;
		m_6_r   <= m_6 ;
		m_7_r   <= m_7 ;
		m_8_r   <= m_8 ;
		m_9_r   <= m_9 ;
		m_10_r  <= m_10;
		m_11_r  <= m_11;
		m_12_r  <= m_12;
		m_13_r  <= m_13;
		m_14_r  <= m_14;
		m_15_r  <= m_15;
		
        //matrix 2
        m_16_r  <= m_16;
		m_17_r  <= m_17;
		m_18_r  <= m_18;
		m_19_r  <= m_19;
		m_20_r  <= m_20;
		m_21_r  <= m_21;
		m_22_r  <= m_22;
		m_23_r  <= m_23;
		m_24_r  <= m_24;
		m_25_r  <= m_25;
		m_26_r  <= m_26;
		m_27_r  <= m_27;
		m_28_r  <= m_28;
		m_29_r  <= m_29;
		m_30_r  <= m_30;
		m_31_r  <= m_31;

end				   
				   				   		
assign m_m_0  = m_0_r  * m_16_r ;
assign m_m_1  = m_1_r  * m_17_r ;
assign m_m_2  = m_2_r  * m_18_r ;
assign m_m_3  = m_3_r  * m_19_r ;
assign m_m_4  = m_4_r  * m_20_r ;
assign m_m_5  = m_5_r  * m_21_r ;
assign m_m_6  = m_6_r  * m_22_r ;
assign m_m_7  = m_7_r  * m_23_r ;
assign m_m_8  = m_8_r  * m_24_r ;
assign m_m_9  = m_9_r  * m_25_r ;
assign m_m_10 = m_10_r * m_26_r ;
assign m_m_11 = m_11_r * m_27_r ;
assign m_m_12 = m_12_r * m_28_r ;
assign m_m_13 = m_13_r * m_29_r ;
assign m_m_14 = m_14_r * m_30_r ;
assign m_m_15 = m_15_r * m_31_r ;

always @(posedge clk)
begin
	m_m_0_r      <=  m_m_0;
	m_m_1_r      <=  m_m_1;
	m_m_2_r      <=  m_m_2;
	m_m_3_r      <=  m_m_3;
	m_m_4_r      <=  m_m_4;
	m_m_5_r      <=  m_m_5;
	m_m_6_r      <=  m_m_6;
	m_m_7_r      <=  m_m_7;
	m_m_8_r      <=  m_m_8;
	m_m_9_r      <=  m_m_9;
	m_m_10_r     <=  m_m_10;
	m_m_11_r     <=  m_m_11;
	m_m_12_r     <=  m_m_12;
	m_m_13_r     <=  m_m_13;
	m_m_14_r 	 <=  m_m_14;   
	m_m_15_r 	 <=  m_m_15;	   
				   				   
end			  

assign m_p1_0 = m_m_0_r  + m_m_1_r  ;
assign m_p1_1 = m_m_2_r  + m_m_3_r  ;
assign m_p1_2 = m_m_4_r  + m_m_5_r  ;
assign m_p1_3 = m_m_6_r  + m_m_7_r  ;
assign m_p1_4 = m_m_8_r  + m_m_9_r  ;
assign m_p1_5 = m_m_10_r + m_m_11_r ;
assign m_p1_6 = m_m_12_r + m_m_13_r ;
assign m_p1_7 = m_m_14_r + m_m_15_r ;

assign m_p2_0 = m_p1_0  + m_p1_1;
assign m_p2_1 = m_p1_2  + m_p1_3;
assign m_p2_2 = m_p1_4  + m_p1_5;
assign m_p2_3 = m_p1_6  + m_p1_7;

assign m_p3_0 = m_p2_0 + m_p2_1;
assign m_p3_1 = m_p2_2 + m_p2_3;

assign dot_out = m_p3_0 + m_p3_1;
endmodule

module add_16(e_in_0, e_in_1, e_in_2, e_in_3 ,e_in_4 , e_in_5, e_in_6, e_in_7, 
			  e_in_8, e_in_9, e_in_10 , e_in_11 , e_in_12 , e_in_13 , e_in_14 , e_in_15 , gold , clk); 
input clk;
input signed [40:0] e_in_0 , e_in_1 , e_in_2 , e_in_3 , e_in_4 , e_in_5, e_in_6 , e_in_7, 			 
			 e_in_8 , e_in_9 , e_in_10 , e_in_11 , e_in_12 , e_in_13 , e_in_14 , e_in_15;
output signed [49:0] gold;			  

wire signed [41:0] add_0 , add_1 , add_2 , add_3 , add_4 , add_5 , add_6 , add_7 ;  
wire signed [42:0] add_0_1, add_1_1, add_2_1 ,add_3_1 ;
wire signed [43:0] add_0_2, add_1_2;
reg  signed [44:0] add_0_r, add_1_r, add_2_r ,add_3_r , add_4_r, add_5_r , add_6_r ,add_7_r ;				 

assign add_0 = e_in_0  + e_in_1;
assign add_1 = e_in_2  + e_in_3;
assign add_2 = e_in_4  + e_in_5;
assign add_3 = e_in_6  + e_in_7;
assign add_4 = e_in_8  + e_in_9;				 
assign add_5 = e_in_10 + e_in_11;				  
assign add_6 = e_in_12 + e_in_13;				 
assign add_7 = e_in_14 + e_in_15;				  


always @(posedge clk)begin
			
			add_0_r <= add_0;
			add_1_r <= add_1;
			add_2_r <= add_2;
            add_3_r <= add_3;
            add_4_r <= add_4;
            add_5_r <= add_5;
            add_6_r <= add_6;
            add_7_r <= add_7;

end

assign add_0_1 = add_0_r + add_1_r;
assign add_1_1 = add_2_r + add_3_r;
assign add_2_1 = add_4_r + add_5_r;
assign add_3_1 = add_6_r + add_7_r;

assign add_0_2 = add_0_1 + add_1_1;			 
assign add_1_2 = add_2_1 + add_3_1;

assign gold = add_0_2 + add_1_2;			  
endmodule