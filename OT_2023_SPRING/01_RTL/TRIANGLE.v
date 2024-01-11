//synopsys translate_off
`include "DW_div.v"
`include "DW_div_seq.v"
`include "DW_div_pipe.v"
//synopsys translate_on

module TRIANGLE(
    clk,
    rst_n,
    in_valid,
    in_length,
    out_cos,
    out_valid,
    out_tri
);
input wire clk, rst_n, in_valid;
input wire [7:0] in_length;

output reg out_valid;
output reg [15:0] out_cos;
output reg [1:0] out_tri;

reg [7:0] cnt_side, cnt_div;
reg [10:0] cnt_fra;
reg [2:0] cnt_out;
reg [7:0] a_reg , b_reg , c_reg;
wire signed [30:0] theta_a_upper , theta_b_upper , theta_c_upper;
wire [30:0] theta_a_lower , theta_b_lower , theta_c_lower;
wire [15:0] a_square , b_square , c_square;
wire en_div;
reg [30:0] b1_div;
reg [30:0] b2_div;
reg [30:0] b3_div;

wire signed [30:0] test_1 , test_2 , test_3;
wire signed [30:0] quo4_div , rem4_div;
wire signed [30:0] quo5_div , rem5_div;
wire signed [30:0] quo6_div , rem6_div;


wire [30:0] frac_1 , frac_2 , frac_3;

wire [12:0] ans_1 , ans_2 , ans_3;
wire [15:0] res_1 , res_2 , res_3;

wire  div_0_or_not_test_1 , div_0_or_not_test_2 , div_0_or_not_test_3 ;
wire [2:0] integer_part_1 , integer_part_2 , integer_part_3;
reg [1:0] tri_ans;

reg [5:0] STATE , NEXT;
parameter ZERO = 5'd0;
parameter STORE = 5'd1;
parameter COMP_1 = 5'd2;
parameter COMP_2 = 5'd3;
parameter OUT = 5'd20;

parameter inst_a_width = 31;
parameter inst_b_width = 31;
parameter inst_tc_mode = 1;
parameter inst_rem_mode = 0;
parameter inst_num_stages = 10;
parameter inst_stall_mode = 1;
parameter inst_rst_mode = 1;
parameter inst_op_iso_mode = 0;
integer i ;



always@(posedge clk or negedge rst_n) begin
            if(!rst_n) STATE <= ZERO;
            else STATE <= NEXT;
end


always@(*)begin
        case(STATE)
                ZERO:begin
                        if(in_valid)NEXT = STORE;
                        else NEXT = ZERO;
                end
                STORE:begin
                        if(!in_valid) NEXT = COMP_1;
                        else NEXT = STORE;
                end
                COMP_1:begin
                        if(cnt_div == 11) NEXT = COMP_2;
			else NEXT = COMP_1;
                end

                COMP_2:begin
                        if(cnt_fra == 11) NEXT = OUT;
			else NEXT = COMP_2;
                end
                

		OUT:begin
			if(cnt_out == 3) NEXT = ZERO;
                        else NEXT = OUT;
		end

                default: NEXT = ZERO;
        endcase
end


always@(posedge clk or negedge rst_n)begin
        if(!rst_n) a_reg <= 0;
        else if(NEXT  == STORE && cnt_side == 0 ) a_reg <= in_length;
        else a_reg <= a_reg;
end


always@(posedge clk or negedge rst_n)begin
        if(!rst_n) b_reg <= 0;
        else if(NEXT  == STORE && cnt_side == 1) b_reg <= in_length;
        else b_reg <= b_reg;
end

always@(posedge clk or negedge rst_n)begin
        if(!rst_n) c_reg <= 0;
        else if(NEXT == STORE && cnt_side == 2) c_reg <= in_length;
        else c_reg <= c_reg;
end

always@(posedge clk or negedge rst_n)begin
	if(!rst_n) cnt_side  <= 0;
	else if(NEXT == STORE && cnt_side < 3) cnt_side <= cnt_side + 1 ;
	else cnt_side <= 0;
end
   

assign a_square = a_reg*a_reg;
assign b_square = b_reg*b_reg;
assign c_square = c_reg*c_reg;


assign theta_a_upper = (b_square) + (c_square) - (a_square);
assign theta_b_upper = (a_square) + (c_square) - (b_square);
assign theta_c_upper = (a_square) + (b_square) - (c_square);

assign theta_a_lower = (b_reg*c_reg) << 1;
assign theta_b_lower = (a_reg*c_reg) << 1;
assign theta_c_lower = (a_reg*b_reg) << 1;

assign en_div = 1'b1;

assign integer_part_1 = (theta_a_upper >= 0) ? 3'b000: 3'b111;
assign integer_part_2 = (theta_b_upper >= 0) ? 3'b000: 3'b111;
assign integer_part_3 = (theta_c_upper >= 0) ? 3'b000: 3'b111;

always@(*)begin
        if((theta_a_upper < 0) || (theta_b_upper < 0) || (theta_c_upper < 0))
                tri_ans = 2'b01;
        else if((theta_a_upper == 0) || (theta_b_upper == 0) || (theta_c_upper == 0))
                tri_ans = 2'b11;
        else tri_ans = 2'b00;
end

assign test_1 = theta_a_upper << 13 ;
assign test_2 = theta_b_upper << 13 ;
assign test_3 = theta_c_upper << 13 ;


always@(*)begin
	b1_div = theta_a_lower;
end

always@(*)begin
	b2_div = theta_b_lower;
end

always@(*)begin
	b3_div = theta_c_lower;
end


always@(posedge clk or negedge rst_n)begin
        if(!rst_n) cnt_div  <= 0;
        else if(NEXT == COMP_1 && cnt_div < 11) cnt_div <= cnt_div + 1 ;
        else cnt_div <= 0;
end

always@(posedge clk or negedge rst_n)begin
        if(!rst_n) cnt_fra  <= 0;
        else if(NEXT == COMP_2 && cnt_fra < 11) cnt_fra <= cnt_fra + 1 ;
        else cnt_fra <= 0;
end


//DIV
DW_div_pipe #(inst_a_width , inst_b_width, inst_tc_mode , inst_rem_mode , inst_num_stages , inst_stall_mode , inst_rst_mode , inst_op_iso_mode )
test1(.clk(clk),.rst_n(rst_n),.en(en_div),.a(test_1),.b(b1_div),.quotient(quo4_div),.remainder(rem4_div),.divide_by_0(div_0_or_not_test_1));
DW_div_pipe #(inst_a_width , inst_b_width, inst_tc_mode , inst_rem_mode , inst_num_stages , inst_stall_mode , inst_rst_mode , inst_op_iso_mode )
test2(.clk(clk),.rst_n(rst_n),.en(en_div),.a(test_2),.b(b2_div),.quotient(quo5_div),.remainder(rem5_div),.divide_by_0(div_0_or_not_test_2));
DW_div_pipe #(inst_a_width , inst_b_width, inst_tc_mode , inst_rem_mode , inst_num_stages , inst_stall_mode , inst_rst_mode , inst_op_iso_mode )
test3(.clk(clk),.rst_n(rst_n),.en(en_div),.a(test_3),.b(b3_div),.quotient(quo6_div),.remainder(rem6_div),.divide_by_0(div_0_or_not_test_3));

assign frac_1 = quo4_div;
assign frac_2 = quo5_div;
assign frac_3 = quo6_div;

assign ans_1 = frac_1[12:0] ;
assign ans_2 = frac_2[12:0] ;
assign ans_3 = frac_3[12:0] ;

assign res_1 = {integer_part_1 , ans_1};
assign res_2 = {integer_part_2 , ans_2};
assign res_3 = {integer_part_3 , ans_3};



always@(posedge clk or negedge rst_n)begin
        if(!rst_n) cnt_out  <= 0;
        else if(NEXT == OUT && cnt_out < 3) cnt_out <= cnt_out + 1 ;
        else cnt_out <= 0;
end


always@(*)begin
        out_valid = (STATE == OUT) ? 1:0;
end


always@(posedge clk or negedge rst_n) begin
            if(!rst_n) out_cos <= 0;
            else if(cnt_out == 0 && NEXT == OUT) out_cos <= res_1;
            else if(cnt_out == 1 && NEXT == OUT) out_cos <= res_2;
            else if(cnt_out == 2 && NEXT == OUT) out_cos <= res_3;
            else out_cos <= 0;
end


always@(posedge clk or negedge rst_n) begin
            if(!rst_n) out_tri <= 0;
            else if(cnt_out == 0 && NEXT == OUT) out_tri <= tri_ans;
            else out_tri <= 0;
end



endmodule
