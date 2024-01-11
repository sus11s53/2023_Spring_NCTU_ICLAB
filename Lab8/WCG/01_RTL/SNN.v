// synopsys translate_off
`ifdef RTL
	`include "GATED_OR.v"
`else
	`include "Netlist/GATED_OR_SYN.v"
`endif
// synopsys translate_on

module SNN(
	// Input signals
	clk,
	rst_n,
	cg_en,
	in_valid,
	img,
	ker,
	weight,

	// Output signals
	out_valid,
	out_data
);

input clk;
input rst_n;
input in_valid;
input cg_en;
input [7:0] img;
input [7:0] ker;
input [7:0] weight;

output reg out_valid;
output reg [9:0] out_data;

//==============================================//
//       parameter & integer declaration        //
//==============================================//
integer i , j;

//==============================================//
//           reg & wire declaration             //
//==============================================//
reg [5:0] STATE , NEXT;
reg [7:0] image_reg_1 [0:5][0:5];
reg [7:0] image_reg_2 [0:5][0:5];
reg [7:0] ker_reg [0:2][0:2];
reg [7:0] weight_reg [0:1][0:1];

reg [8:0] cnt_in_valid;
reg [8:0] cnt_in_col_image;
reg [8:0] cnt_in_row_image;
reg [8:0] cnt_in_col_ker;
reg [8:0] cnt_in_row_ker;
reg [8:0] cnt_in_col_weight;
reg [8:0] cnt_in_row_weight;

wire [20:0] convolution_00_1 , convolution_01_1, convolution_02_1 , convolution_03_1;
wire [20:0] convolution_10_1 , convolution_11_1, convolution_12_1 , convolution_13_1;
wire [20:0] convolution_20_1 , convolution_21_1, convolution_22_1 , convolution_23_1;
wire [20:0] convolution_30_1 , convolution_31_1, convolution_32_1 , convolution_33_1;

wire [20:0] convolution_00_2 , convolution_01_2, convolution_02_2 , convolution_03_2;
wire [20:0] convolution_10_2 , convolution_11_2, convolution_12_2 , convolution_13_2;
wire [20:0] convolution_20_2 , convolution_21_2, convolution_22_2 , convolution_23_2;
wire [20:0] convolution_30_2 , convolution_31_2, convolution_32_2 , convolution_33_2;

reg [20:0] feature_map_1 [0:3][0:3];
reg [20:0] feature_map_2 [0:3][0:3];

wire [7:0] quantization_00_1 , quantization_01_1 , quantization_02_1 , quantization_03_1;
wire [7:0] quantization_10_1 , quantization_11_1 , quantization_12_1 , quantization_13_1;
wire [7:0] quantization_20_1 , quantization_21_1 , quantization_22_1 , quantization_23_1;
wire [7:0] quantization_30_1 , quantization_31_1 , quantization_32_1 , quantization_33_1;

wire [7:0] quantization_00_2 , quantization_01_2 , quantization_02_2 , quantization_03_2;
wire [7:0] quantization_10_2 , quantization_11_2 , quantization_12_2 , quantization_13_2;
wire [7:0] quantization_20_2 , quantization_21_2 , quantization_22_2 , quantization_23_2;
wire [7:0] quantization_30_2 , quantization_31_2 , quantization_32_2 , quantization_33_2;

reg [7:0] feature_map_1_quantize [0:3][0:3];
reg [7:0] feature_map_2_quantize [0:3][0:3];

wire [7:0] compare_0_1 , compare_1_1;
wire [7:0] compare_last_00;

wire [7:0] compare_0_2 , compare_0_3;
wire [7:0] compare_last_01;

wire [7:0] compare_2_0 , compare_2_1;
wire [7:0] compare_last_21;

wire [7:0] compare_3_0 , compare_3_1;
wire [7:0] compare_last_31;

wire [7:0] max_pool_00_1 , max_pool_01_1;
wire [7:0] max_pool_10_1 , max_pool_11_1;

wire [7:0] compare_0_1_next , compare_1_1_next;
wire [7:0] compare_last_00_next;

wire [7:0] compare_0_2_next , compare_0_3_next;
wire [7:0] compare_last_01_next;

wire [7:0] compare_2_0_next , compare_2_1_next;
wire [7:0] compare_last_21_next;

wire [7:0] compare_3_0_next, compare_3_1_next;
wire [7:0] compare_last_31_next;

wire [7:0] max_pool_00_2 , max_pool_01_2;
wire [7:0] max_pool_10_2 , max_pool_11_2;

reg [7:0] max_pool_reg1 [0:1][0:1];
reg [7:0] max_pool_reg2 [0:1][0:1];

wire [16:0] fully_connected_0_1 , fully_connected_1_1 , fully_connected_2_1 , fully_connected_3_1 ;
wire [16:0] fully_connected_0_2 , fully_connected_1_2 , fully_connected_2_2 , fully_connected_3_2 ;

reg [16:0] fully_connected_reg1 [0:3];
reg [16:0] fully_connected_reg2 [0:3];

wire [7:0] fully_connected_quantize_0_1 , fully_connected_quantize_1_1 , fully_connected_quantize_2_1 , fully_connected_quantize_3_1 ;
wire [7:0] fully_connected_quantize_0_2 , fully_connected_quantize_1_2 , fully_connected_quantize_2_2 , fully_connected_quantize_3_2 ;

reg [7:0] fully_connected_quantize_reg1 [0:3];
reg [7:0] fully_connected_quantize_reg2 [0:3];

wire [7:0] L_distance_0 ,  L_distance_1 , L_distance_2 , L_distance_3;
wire [9:0] L_total;

reg [9:0] L_total_reg;

wire [9:0] fake_relu;
reg [9:0] fake_relu_reg;

reg [8:0] cnt_in_valid_off;
reg [9:0] fake_out;


//---------------------------------------------------------------------
//   FSM
//---------------------------------------------------------------------
parameter ZERO = 'd0;
parameter STORE = 'd1;
parameter STANDBY = 'd2;
parameter OUT = 'd3;

wire invalid_off , outvalid_off;
wire gclk_invalid, gclk_outvalid;

assign invalid_off = cg_en && ((STATE == STANDBY) || (STATE == OUT));
assign outvalid_off = cg_en && ((STATE == ZERO) || (STATE == STORE));

GATED_OR GATED_invalid(.CLOCK(clk) , .SLEEP_CTRL(invalid_off) , .RST_N(rst_n) , .CLOCK_GATED(gclk_invalid));
GATED_OR GATED_outvalid(.CLOCK(clk) , .SLEEP_CTRL(outvalid_off) , .RST_N(rst_n) , .CLOCK_GATED(gclk_outvalid));

//==============================================//
//                  design                      //
//==============================================//
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
    		if(!in_valid) NEXT = STANDBY;
            else NEXT = STORE;
        end

        STANDBY:begin
			if(cnt_in_valid_off == 7) NEXT = OUT;
            else NEXT = STANDBY;
        end

        OUT:begin
            if(!out_valid) NEXT = ZERO;
            else NEXT = OUT;
        end

        default: NEXT = STATE;
    endcase
end

always@(posedge gclk_invalid or negedge rst_n)begin
	if(!rst_n)begin
		for(i = 0; i < 6 ; i = i + 1)begin
			for(j = 0; j < 6; j = j + 1)begin
				image_reg_1[i][j] <= 0;
			end
		end
	end
	else if(in_valid && cnt_in_valid < 36) begin
		image_reg_1[cnt_in_row_image][cnt_in_col_image] <= img;
	end
	else begin
		for(i = 0; i < 6 ; i = i + 1)begin
			for(j = 0; j < 6; j = j + 1)begin
				image_reg_1[i][j] <= image_reg_1[i][j];
			end
		end
	end
end 

always@(posedge gclk_invalid or negedge rst_n)begin
	if(!rst_n)begin
		for(i = 0; i < 6 ; i = i + 1)begin
			for(j = 0; j < 6; j = j + 1)begin
				image_reg_2[i][j] <= 0;
			end
		end
	end
	else if(in_valid) begin
		image_reg_2[cnt_in_row_image][cnt_in_col_image] <= img;
	end
	else begin
		for(i = 0; i < 6 ; i = i + 1)begin
			for(j = 0; j < 6; j = j + 1)begin
				image_reg_2[i][j] <= image_reg_2[i][j];
			end
		end
	end
end 

always@(posedge gclk_invalid or negedge rst_n)begin
	if(!rst_n)begin
		for(i = 0; i < 3 ; i = i + 1)begin
			for(j = 0; j < 3; j = j + 1)begin
				ker_reg[i][j] <= 0;
			end
		end
	end
	else if(in_valid && cnt_in_valid < 9) begin
		ker_reg[cnt_in_row_ker][cnt_in_col_ker] <= ker;
	end
	else begin
		for(i = 0; i < 3 ; i = i + 1)begin
			for(j = 0; j < 3; j = j + 1)begin
				ker_reg[i][j] <= ker_reg[i][j];
			end
		end
	end
end 

always@(posedge gclk_invalid or negedge rst_n)begin
	if(!rst_n)begin
		for(i = 0; i < 2 ; i = i + 1)begin
			for(j = 0; j < 2; j = j + 1)begin
				weight_reg[i][j] <= 0;
			end
		end
	end
	else if(in_valid && cnt_in_valid < 4) begin
		weight_reg[cnt_in_row_weight][cnt_in_col_weight] <= weight;
	end
	else begin
		for(i = 0; i < 2; i = i + 1)begin
			for(j = 0; j < 2; j = j + 1)begin
				weight_reg[i][j] <= weight_reg[i][j];
			end
		end
	end
end 

always@(posedge gclk_invalid or negedge rst_n)begin
	if(!rst_n)begin
		cnt_in_valid <= 0;
	end
	else if(in_valid) cnt_in_valid <= cnt_in_valid + 1;
	else cnt_in_valid <= 0;
end 

always@(posedge gclk_invalid or negedge rst_n)begin
	if(!rst_n)begin
		cnt_in_col_image <= 0;
	end
	else if(in_valid && cnt_in_col_image < 5) cnt_in_col_image <= cnt_in_col_image + 1;
	else cnt_in_col_image <= 0;
end 

always@(posedge gclk_invalid or negedge rst_n)begin
	if(!rst_n)begin
		cnt_in_row_image <= 0;
	end
	else if(in_valid && cnt_in_col_image == 5 && cnt_in_row_image < 5) cnt_in_row_image <= cnt_in_row_image + 1;
	else if(cnt_in_col_image == 5 && cnt_in_row_image == 5) cnt_in_row_image <= 0;
	else cnt_in_row_image <= cnt_in_row_image;
end 

always@(posedge gclk_invalid or negedge rst_n)begin
	if(!rst_n)begin
		cnt_in_col_ker <= 0;
	end
	else if(cnt_in_valid >= 9) cnt_in_col_ker <= 0;
	else if(in_valid && cnt_in_col_ker < 2) cnt_in_col_ker <= cnt_in_col_ker + 1;
	else cnt_in_col_ker <= 0;
end 

always@(posedge gclk_invalid or negedge rst_n)begin
	if(!rst_n)begin
		cnt_in_row_ker <= 0;
	end
	else if(cnt_in_valid >= 9) cnt_in_row_ker <= 0;
	else if(in_valid && cnt_in_col_ker == 2 && cnt_in_row_ker < 2) cnt_in_row_ker <= cnt_in_row_ker + 1;
	else if(cnt_in_col_ker == 2 && cnt_in_row_ker == 2) cnt_in_row_ker <= 0;
	else cnt_in_row_ker <= cnt_in_row_ker;
end 

always@(posedge gclk_invalid or negedge rst_n)begin
	if(!rst_n)begin
		cnt_in_col_weight <= 0;
	end
	else if(cnt_in_valid >= 4) cnt_in_col_weight <= 0;
	else if(in_valid && cnt_in_col_weight < 1) cnt_in_col_weight <= cnt_in_col_weight + 1;
	else cnt_in_col_weight <= 0;
end 

always@(posedge gclk_invalid or negedge rst_n)begin
	if(!rst_n)begin
		cnt_in_row_weight <= 0;
	
	end
	else if(cnt_in_valid >= 4) cnt_in_row_weight <= 0;
	else if(in_valid && cnt_in_col_weight == 1 && cnt_in_row_weight < 1) cnt_in_row_weight <= cnt_in_row_weight + 1;
	else if(cnt_in_col_weight == 1 && cnt_in_row_weight == 1) cnt_in_row_weight <= 0;
	else cnt_in_row_weight <= cnt_in_row_weight;
end

// convolution 1
//-----------------------------------------------------------------------------------------------------------------------------------------

assign convolution_00_1 =  image_reg_1[0][0] * ker_reg [0][0] + image_reg_1[0][1] * ker_reg [0][1] + image_reg_1[0][2] * ker_reg [0][2]
						  +image_reg_1[1][0] * ker_reg [1][0] + image_reg_1[1][1] * ker_reg [1][1] + image_reg_1[1][2] * ker_reg [1][2]
						  +image_reg_1[2][0] * ker_reg [2][0] + image_reg_1[2][1] * ker_reg [2][1] + image_reg_1[2][2] * ker_reg [2][2];

assign convolution_01_1 =  image_reg_1[0][1] * ker_reg [0][0] + image_reg_1[0][2] * ker_reg [0][1] + image_reg_1[0][3] * ker_reg [0][2]
						  +image_reg_1[1][1] * ker_reg [1][0] + image_reg_1[1][2] * ker_reg [1][1] + image_reg_1[1][3] * ker_reg [1][2]
						  +image_reg_1[2][1] * ker_reg [2][0] + image_reg_1[2][2] * ker_reg [2][1] + image_reg_1[2][3] * ker_reg [2][2];

assign convolution_02_1 =  image_reg_1[0][2] * ker_reg [0][0] + image_reg_1[0][3] * ker_reg [0][1] + image_reg_1[0][4] * ker_reg [0][2]
						  +image_reg_1[1][2] * ker_reg [1][0] + image_reg_1[1][3] * ker_reg [1][1] + image_reg_1[1][4] * ker_reg [1][2]
						  +image_reg_1[2][2] * ker_reg [2][0] + image_reg_1[2][3] * ker_reg [2][1] + image_reg_1[2][4] * ker_reg [2][2];

assign convolution_03_1 =  image_reg_1[0][3] * ker_reg [0][0] + image_reg_1[0][4] * ker_reg [0][1] + image_reg_1[0][5] * ker_reg [0][2]
						  +image_reg_1[1][3] * ker_reg [1][0] + image_reg_1[1][4] * ker_reg [1][1] + image_reg_1[1][5] * ker_reg [1][2]
						  +image_reg_1[2][3] * ker_reg [2][0] + image_reg_1[2][4] * ker_reg [2][1] + image_reg_1[2][5] * ker_reg [2][2];

//-----------------------------------------------------------------------------------------------------------------------------------------

assign convolution_10_1 =  image_reg_1[1][0] * ker_reg [0][0] + image_reg_1[1][1] * ker_reg [0][1] + image_reg_1[1][2] * ker_reg [0][2]
						  +image_reg_1[2][0] * ker_reg [1][0] + image_reg_1[2][1] * ker_reg [1][1] + image_reg_1[2][2] * ker_reg [1][2]
						  +image_reg_1[3][0] * ker_reg [2][0] + image_reg_1[3][1] * ker_reg [2][1] + image_reg_1[3][2] * ker_reg [2][2];

assign convolution_11_1 =  image_reg_1[1][1] * ker_reg [0][0] + image_reg_1[1][2] * ker_reg [0][1] + image_reg_1[1][3] * ker_reg [0][2]
						  +image_reg_1[2][1] * ker_reg [1][0] + image_reg_1[2][2] * ker_reg [1][1] + image_reg_1[2][3] * ker_reg [1][2]
						  +image_reg_1[3][1] * ker_reg [2][0] + image_reg_1[3][2] * ker_reg [2][1] + image_reg_1[3][3] * ker_reg [2][2];

assign convolution_12_1 =  image_reg_1[1][2] * ker_reg [0][0] + image_reg_1[1][3] * ker_reg [0][1] + image_reg_1[1][4] * ker_reg [0][2]
						  +image_reg_1[2][2] * ker_reg [1][0] + image_reg_1[2][3] * ker_reg [1][1] + image_reg_1[2][4] * ker_reg [1][2]
						  +image_reg_1[3][2] * ker_reg [2][0] + image_reg_1[3][3] * ker_reg [2][1] + image_reg_1[3][4] * ker_reg [2][2];

assign convolution_13_1 =  image_reg_1[1][3] * ker_reg [0][0] + image_reg_1[1][4] * ker_reg [0][1] + image_reg_1[1][5] * ker_reg [0][2]
						  +image_reg_1[2][3] * ker_reg [1][0] + image_reg_1[2][4] * ker_reg [1][1] + image_reg_1[2][5] * ker_reg [1][2]
						  +image_reg_1[3][3] * ker_reg [2][0] + image_reg_1[3][4] * ker_reg [2][1] + image_reg_1[3][5] * ker_reg [2][2];

//-----------------------------------------------------------------------------------------------------------------------------------------

assign convolution_20_1 =  image_reg_1[2][0] * ker_reg [0][0] + image_reg_1[2][1] * ker_reg [0][1] + image_reg_1[2][2] * ker_reg [0][2]
						  +image_reg_1[3][0] * ker_reg [1][0] + image_reg_1[3][1] * ker_reg [1][1] + image_reg_1[3][2] * ker_reg [1][2]
						  +image_reg_1[4][0] * ker_reg [2][0] + image_reg_1[4][1] * ker_reg [2][1] + image_reg_1[4][2] * ker_reg [2][2];

assign convolution_21_1 =  image_reg_1[2][1] * ker_reg [0][0] + image_reg_1[2][2] * ker_reg [0][1] + image_reg_1[2][3] * ker_reg [0][2]
						  +image_reg_1[3][1] * ker_reg [1][0] + image_reg_1[3][2] * ker_reg [1][1] + image_reg_1[3][3] * ker_reg [1][2]
						  +image_reg_1[4][1] * ker_reg [2][0] + image_reg_1[4][2] * ker_reg [2][1] + image_reg_1[4][3] * ker_reg [2][2];

assign convolution_22_1 =  image_reg_1[2][2] * ker_reg [0][0] + image_reg_1[2][3] * ker_reg [0][1] + image_reg_1[2][4] * ker_reg [0][2]
						  +image_reg_1[3][2] * ker_reg [1][0] + image_reg_1[3][3] * ker_reg [1][1] + image_reg_1[3][4] * ker_reg [1][2]
						  +image_reg_1[4][2] * ker_reg [2][0] + image_reg_1[4][3] * ker_reg [2][1] + image_reg_1[4][4] * ker_reg [2][2];

assign convolution_23_1 =  image_reg_1[2][3] * ker_reg [0][0] + image_reg_1[2][4] * ker_reg [0][1] + image_reg_1[2][5] * ker_reg [0][2]
						  +image_reg_1[3][3] * ker_reg [1][0] + image_reg_1[3][4] * ker_reg [1][1] + image_reg_1[3][5] * ker_reg [1][2]
						  +image_reg_1[4][3] * ker_reg [2][0] + image_reg_1[4][4] * ker_reg [2][1] + image_reg_1[4][5] * ker_reg [2][2];

//-----------------------------------------------------------------------------------------------------------------------------------------

assign convolution_30_1 =  image_reg_1[3][0] * ker_reg [0][0] + image_reg_1[3][1] * ker_reg [0][1] + image_reg_1[3][2] * ker_reg [0][2]
						  +image_reg_1[4][0] * ker_reg [1][0] + image_reg_1[4][1] * ker_reg [1][1] + image_reg_1[4][2] * ker_reg [1][2]
						  +image_reg_1[5][0] * ker_reg [2][0] + image_reg_1[5][1] * ker_reg [2][1] + image_reg_1[5][2] * ker_reg [2][2];

assign convolution_31_1 =  image_reg_1[3][1] * ker_reg [0][0] + image_reg_1[3][2] * ker_reg [0][1] + image_reg_1[3][3] * ker_reg [0][2]
						  +image_reg_1[4][1] * ker_reg [1][0] + image_reg_1[4][2] * ker_reg [1][1] + image_reg_1[4][3] * ker_reg [1][2]
						  +image_reg_1[5][1] * ker_reg [2][0] + image_reg_1[5][2] * ker_reg [2][1] + image_reg_1[5][3] * ker_reg [2][2];

assign convolution_32_1 =  image_reg_1[3][2] * ker_reg [0][0] + image_reg_1[3][3] * ker_reg [0][1] + image_reg_1[3][4] * ker_reg [0][2]
						  +image_reg_1[4][2] * ker_reg [1][0] + image_reg_1[4][3] * ker_reg [1][1] + image_reg_1[4][4] * ker_reg [1][2]
						  +image_reg_1[5][2] * ker_reg [2][0] + image_reg_1[5][3] * ker_reg [2][1] + image_reg_1[5][4] * ker_reg [2][2];

assign convolution_33_1 =  image_reg_1[3][3] * ker_reg [0][0] + image_reg_1[3][4] * ker_reg [0][1] + image_reg_1[3][5] * ker_reg [0][2]
						  +image_reg_1[4][3] * ker_reg [1][0] + image_reg_1[4][4] * ker_reg [1][1] + image_reg_1[4][5] * ker_reg [1][2]
						  +image_reg_1[5][3] * ker_reg [2][0] + image_reg_1[5][4] * ker_reg [2][1] + image_reg_1[5][5] * ker_reg [2][2];

//-----------------------------------------------------------------------------------------------------------------------------------------
// convolution 2
//-----------------------------------------------------------------------------------------------------------------------------------------

assign convolution_00_2 =  image_reg_2[0][0] * ker_reg [0][0] + image_reg_2[0][1] * ker_reg [0][1] + image_reg_2[0][2] * ker_reg [0][2]
						  +image_reg_2[1][0] * ker_reg [1][0] + image_reg_2[1][1] * ker_reg [1][1] + image_reg_2[1][2] * ker_reg [1][2]
						  +image_reg_2[2][0] * ker_reg [2][0] + image_reg_2[2][1] * ker_reg [2][1] + image_reg_2[2][2] * ker_reg [2][2];

assign convolution_01_2 =  image_reg_2[0][1] * ker_reg [0][0] + image_reg_2[0][2] * ker_reg [0][1] + image_reg_2[0][3] * ker_reg [0][2]
						  +image_reg_2[1][1] * ker_reg [1][0] + image_reg_2[1][2] * ker_reg [1][1] + image_reg_2[1][3] * ker_reg [1][2]
						  +image_reg_2[2][1] * ker_reg [2][0] + image_reg_2[2][2] * ker_reg [2][1] + image_reg_2[2][3] * ker_reg [2][2];

assign convolution_02_2 =  image_reg_2[0][2] * ker_reg [0][0] + image_reg_2[0][3] * ker_reg [0][1] + image_reg_2[0][4] * ker_reg [0][2]
						  +image_reg_2[1][2] * ker_reg [1][0] + image_reg_2[1][3] * ker_reg [1][1] + image_reg_2[1][4] * ker_reg [1][2]
						  +image_reg_2[2][2] * ker_reg [2][0] + image_reg_2[2][3] * ker_reg [2][1] + image_reg_2[2][4] * ker_reg [2][2];

assign convolution_03_2 =  image_reg_2[0][3] * ker_reg [0][0] + image_reg_2[0][4] * ker_reg [0][1] + image_reg_2[0][5] * ker_reg [0][2]
						  +image_reg_2[1][3] * ker_reg [1][0] + image_reg_2[1][4] * ker_reg [1][1] + image_reg_2[1][5] * ker_reg [1][2]
						  +image_reg_2[2][3] * ker_reg [2][0] + image_reg_2[2][4] * ker_reg [2][1] + image_reg_2[2][5] * ker_reg [2][2];

//-----------------------------------------------------------------------------------------------------------------------------------------

assign convolution_10_2 =  image_reg_2[1][0] * ker_reg [0][0] + image_reg_2[1][1] * ker_reg [0][1] + image_reg_2[1][2] * ker_reg [0][2]
						  +image_reg_2[2][0] * ker_reg [1][0] + image_reg_2[2][1] * ker_reg [1][1] + image_reg_2[2][2] * ker_reg [1][2]
						  +image_reg_2[3][0] * ker_reg [2][0] + image_reg_2[3][1] * ker_reg [2][1] + image_reg_2[3][2] * ker_reg [2][2];

assign convolution_11_2 =  image_reg_2[1][1] * ker_reg [0][0] + image_reg_2[1][2] * ker_reg [0][1] + image_reg_2[1][3] * ker_reg [0][2]
						  +image_reg_2[2][1] * ker_reg [1][0] + image_reg_2[2][2] * ker_reg [1][1] + image_reg_2[2][3] * ker_reg [1][2]
						  +image_reg_2[3][1] * ker_reg [2][0] + image_reg_2[3][2] * ker_reg [2][1] + image_reg_2[3][3] * ker_reg [2][2];

assign convolution_12_2 =  image_reg_2[1][2] * ker_reg [0][0] + image_reg_2[1][3] * ker_reg [0][1] + image_reg_2[1][4] * ker_reg [0][2]
						  +image_reg_2[2][2] * ker_reg [1][0] + image_reg_2[2][3] * ker_reg [1][1] + image_reg_2[2][4] * ker_reg [1][2]
						  +image_reg_2[3][2] * ker_reg [2][0] + image_reg_2[3][3] * ker_reg [2][1] + image_reg_2[3][4] * ker_reg [2][2];

assign convolution_13_2 =  image_reg_2[1][3] * ker_reg [0][0] + image_reg_2[1][4] * ker_reg [0][1] + image_reg_2[1][5] * ker_reg [0][2]
						  +image_reg_2[2][3] * ker_reg [1][0] + image_reg_2[2][4] * ker_reg [1][1] + image_reg_2[2][5] * ker_reg [1][2]
						  +image_reg_2[3][3] * ker_reg [2][0] + image_reg_2[3][4] * ker_reg [2][1] + image_reg_2[3][5] * ker_reg [2][2];

//-----------------------------------------------------------------------------------------------------------------------------------------

assign convolution_20_2 =  image_reg_2[2][0] * ker_reg [0][0] + image_reg_2[2][1] * ker_reg [0][1] + image_reg_2[2][2] * ker_reg [0][2]
						  +image_reg_2[3][0] * ker_reg [1][0] + image_reg_2[3][1] * ker_reg [1][1] + image_reg_2[3][2] * ker_reg [1][2]
						  +image_reg_2[4][0] * ker_reg [2][0] + image_reg_2[4][1] * ker_reg [2][1] + image_reg_2[4][2] * ker_reg [2][2];

assign convolution_21_2 =  image_reg_2[2][1] * ker_reg [0][0] + image_reg_2[2][2] * ker_reg [0][1] + image_reg_2[2][3] * ker_reg [0][2]
						  +image_reg_2[3][1] * ker_reg [1][0] + image_reg_2[3][2] * ker_reg [1][1] + image_reg_2[3][3] * ker_reg [1][2]
						  +image_reg_2[4][1] * ker_reg [2][0] + image_reg_2[4][2] * ker_reg [2][1] + image_reg_2[4][3] * ker_reg [2][2];

assign convolution_22_2 =  image_reg_2[2][2] * ker_reg [0][0] + image_reg_2[2][3] * ker_reg [0][1] + image_reg_2[2][4] * ker_reg [0][2]
						  +image_reg_2[3][2] * ker_reg [1][0] + image_reg_2[3][3] * ker_reg [1][1] + image_reg_2[3][4] * ker_reg [1][2]
						  +image_reg_2[4][2] * ker_reg [2][0] + image_reg_2[4][3] * ker_reg [2][1] + image_reg_2[4][4] * ker_reg [2][2];

assign convolution_23_2 =  image_reg_2[2][3] * ker_reg [0][0] + image_reg_2[2][4] * ker_reg [0][1] + image_reg_2[2][5] * ker_reg [0][2]
						  +image_reg_2[3][3] * ker_reg [1][0] + image_reg_2[3][4] * ker_reg [1][1] + image_reg_2[3][5] * ker_reg [1][2]
						  +image_reg_2[4][3] * ker_reg [2][0] + image_reg_2[4][4] * ker_reg [2][1] + image_reg_2[4][5] * ker_reg [2][2];

//-----------------------------------------------------------------------------------------------------------------------------------------

assign convolution_30_2 =  image_reg_2[3][0] * ker_reg [0][0] + image_reg_2[3][1] * ker_reg [0][1] + image_reg_2[3][2] * ker_reg [0][2]
						  +image_reg_2[4][0] * ker_reg [1][0] + image_reg_2[4][1] * ker_reg [1][1] + image_reg_2[4][2] * ker_reg [1][2]
						  +image_reg_2[5][0] * ker_reg [2][0] + image_reg_2[5][1] * ker_reg [2][1] + image_reg_2[5][2] * ker_reg [2][2];

assign convolution_31_2 =  image_reg_2[3][1] * ker_reg [0][0] + image_reg_2[3][2] * ker_reg [0][1] + image_reg_2[3][3] * ker_reg [0][2]
						  +image_reg_2[4][1] * ker_reg [1][0] + image_reg_2[4][2] * ker_reg [1][1] + image_reg_2[4][3] * ker_reg [1][2]
						  +image_reg_2[5][1] * ker_reg [2][0] + image_reg_2[5][2] * ker_reg [2][1] + image_reg_2[5][3] * ker_reg [2][2];

assign convolution_32_2 =  image_reg_2[3][2] * ker_reg [0][0] + image_reg_2[3][3] * ker_reg [0][1] + image_reg_2[3][4] * ker_reg [0][2]
						  +image_reg_2[4][2] * ker_reg [1][0] + image_reg_2[4][3] * ker_reg [1][1] + image_reg_2[4][4] * ker_reg [1][2]
						  +image_reg_2[5][2] * ker_reg [2][0] + image_reg_2[5][3] * ker_reg [2][1] + image_reg_2[5][4] * ker_reg [2][2];

assign convolution_33_2 =  image_reg_2[3][3] * ker_reg [0][0] + image_reg_2[3][4] * ker_reg [0][1] + image_reg_2[3][5] * ker_reg [0][2]
						  +image_reg_2[4][3] * ker_reg [1][0] + image_reg_2[4][4] * ker_reg [1][1] + image_reg_2[4][5] * ker_reg [1][2]
						  +image_reg_2[5][3] * ker_reg [2][0] + image_reg_2[5][4] * ker_reg [2][1] + image_reg_2[5][5] * ker_reg [2][2];

//-----------------------------------------------------------------------------------------------------------------------------------------

always@(posedge gclk_outvalid or negedge rst_n)begin
	if(!rst_n)begin
		for(i = 0; i < 4 ; i = i + 1)begin
			for(j = 0; j < 4; j = j + 1)begin
				feature_map_1[i][j] <= 0;
			end
		end
	end
	else begin
		feature_map_1[0][0] <= convolution_00_1;
		feature_map_1[0][1] <= convolution_01_1;
		feature_map_1[0][2] <= convolution_02_1;
		feature_map_1[0][3] <= convolution_03_1;

		feature_map_1[1][0] <= convolution_10_1;
		feature_map_1[1][1] <= convolution_11_1;
		feature_map_1[1][2] <= convolution_12_1;
		feature_map_1[1][3] <= convolution_13_1;

		feature_map_1[2][0] <= convolution_20_1;
		feature_map_1[2][1] <= convolution_21_1;
		feature_map_1[2][2] <= convolution_22_1;
		feature_map_1[2][3] <= convolution_23_1;

		feature_map_1[3][0] <= convolution_30_1;
		feature_map_1[3][1] <= convolution_31_1;
		feature_map_1[3][2] <= convolution_32_1;
		feature_map_1[3][3] <= convolution_33_1;
	end
end 

always@(posedge gclk_outvalid or negedge rst_n)begin
	if(!rst_n)begin
		for(i = 0; i < 4 ; i = i + 1)begin
			for(j = 0; j < 4; j = j + 1)begin
				feature_map_2[i][j] <= 0;
			end
		end
	end
	else begin
		feature_map_2[0][0] <= convolution_00_2;
		feature_map_2[0][1] <= convolution_01_2;
		feature_map_2[0][2] <= convolution_02_2;
		feature_map_2[0][3] <= convolution_03_2;

		feature_map_2[1][0] <= convolution_10_2;
		feature_map_2[1][1] <= convolution_11_2;
		feature_map_2[1][2] <= convolution_12_2;
		feature_map_2[1][3] <= convolution_13_2;

		feature_map_2[2][0] <= convolution_20_2;
		feature_map_2[2][1] <= convolution_21_2;
		feature_map_2[2][2] <= convolution_22_2;
		feature_map_2[2][3] <= convolution_23_2;

		feature_map_2[3][0] <= convolution_30_2;
		feature_map_2[3][1] <= convolution_31_2;
		feature_map_2[3][2] <= convolution_32_2;
		feature_map_2[3][3] <= convolution_33_2;
	end
end 

//-----------------------------------------------------------------------------------------------------------------------------------------

assign quantization_00_1 = feature_map_1[0][0] / 2295;
assign quantization_01_1 = feature_map_1[0][1] / 2295;
assign quantization_02_1 = feature_map_1[0][2] / 2295;
assign quantization_03_1 = feature_map_1[0][3] / 2295;

assign quantization_10_1 = feature_map_1[1][0] / 2295;
assign quantization_11_1 = feature_map_1[1][1] / 2295;
assign quantization_12_1 = feature_map_1[1][2] / 2295;
assign quantization_13_1 = feature_map_1[1][3] / 2295;

assign quantization_20_1 = feature_map_1[2][0] / 2295;
assign quantization_21_1 = feature_map_1[2][1] / 2295;
assign quantization_22_1 = feature_map_1[2][2] / 2295;
assign quantization_23_1 = feature_map_1[2][3] / 2295;

assign quantization_30_1 = feature_map_1[3][0] / 2295;
assign quantization_31_1 = feature_map_1[3][1] / 2295;
assign quantization_32_1 = feature_map_1[3][2] / 2295;
assign quantization_33_1 = feature_map_1[3][3] / 2295;

//-----------------------------------------------------------------------------------------------------------------------------------------

assign quantization_00_2 = feature_map_2[0][0] / 2295;
assign quantization_01_2 = feature_map_2[0][1] / 2295;
assign quantization_02_2 = feature_map_2[0][2] / 2295;
assign quantization_03_2 = feature_map_2[0][3] / 2295;

assign quantization_10_2 = feature_map_2[1][0] / 2295;
assign quantization_11_2 = feature_map_2[1][1] / 2295;
assign quantization_12_2 = feature_map_2[1][2] / 2295;
assign quantization_13_2 = feature_map_2[1][3] / 2295;

assign quantization_20_2 = feature_map_2[2][0] / 2295;
assign quantization_21_2 = feature_map_2[2][1] / 2295;
assign quantization_22_2 = feature_map_2[2][2] / 2295;
assign quantization_23_2 = feature_map_2[2][3] / 2295;

assign quantization_30_2 = feature_map_2[3][0] / 2295;
assign quantization_31_2 = feature_map_2[3][1] / 2295;
assign quantization_32_2 = feature_map_2[3][2] / 2295;
assign quantization_33_2 = feature_map_2[3][3] / 2295;

//-----------------------------------------------------------------------------------------------------------------------------------------

always@(posedge gclk_outvalid or negedge rst_n)begin
	if(!rst_n)begin
		for(i = 0; i < 4 ; i = i + 1)begin
			for(j = 0; j < 4; j = j + 1)begin
				feature_map_1_quantize[i][j] <= 0;
			end
		end
	end
	else begin
		feature_map_1_quantize[0][0] <= quantization_00_1;
		feature_map_1_quantize[0][1] <= quantization_01_1;
		feature_map_1_quantize[0][2] <= quantization_02_1;
		feature_map_1_quantize[0][3] <= quantization_03_1;

		feature_map_1_quantize[1][0] <= quantization_10_1;
		feature_map_1_quantize[1][1] <= quantization_11_1;
		feature_map_1_quantize[1][2] <= quantization_12_1;
		feature_map_1_quantize[1][3] <= quantization_13_1;

		feature_map_1_quantize[2][0] <= quantization_20_1;
		feature_map_1_quantize[2][1] <= quantization_21_1;
		feature_map_1_quantize[2][2] <= quantization_22_1;
		feature_map_1_quantize[2][3] <= quantization_23_1;

		feature_map_1_quantize[3][0] <= quantization_30_1;
		feature_map_1_quantize[3][1] <= quantization_31_1;
		feature_map_1_quantize[3][2] <= quantization_32_1;
		feature_map_1_quantize[3][3] <= quantization_33_1;
	end
end 

always@(posedge gclk_outvalid or negedge rst_n)begin
	if(!rst_n)begin
		for(i = 0; i < 4 ; i = i + 1)begin
			for(j = 0; j < 4; j = j + 1)begin
				feature_map_2_quantize[i][j] <= 0;
			end
		end
	end
	else begin
		feature_map_2_quantize[0][0] <= quantization_00_2;
		feature_map_2_quantize[0][1] <= quantization_01_2;
		feature_map_2_quantize[0][2] <= quantization_02_2;
		feature_map_2_quantize[0][3] <= quantization_03_2;

		feature_map_2_quantize[1][0] <= quantization_10_2;
		feature_map_2_quantize[1][1] <= quantization_11_2;
		feature_map_2_quantize[1][2] <= quantization_12_2;
		feature_map_2_quantize[1][3] <= quantization_13_2;

		feature_map_2_quantize[2][0] <= quantization_20_2;
		feature_map_2_quantize[2][1] <= quantization_21_2;
		feature_map_2_quantize[2][2] <= quantization_22_2;
		feature_map_2_quantize[2][3] <= quantization_23_2;

		feature_map_2_quantize[3][0] <= quantization_30_2;
		feature_map_2_quantize[3][1] <= quantization_31_2;
		feature_map_2_quantize[3][2] <= quantization_32_2;
		feature_map_2_quantize[3][3] <= quantization_33_2;
	end
end 

//-----------------------------------------------------------------------------------------------------------------------------------------

assign compare_0_1 = (feature_map_1_quantize[0][0] > feature_map_1_quantize[0][1]) ? feature_map_1_quantize[0][0] : feature_map_1_quantize[0][1];
assign compare_1_1 = (feature_map_1_quantize[1][0] > feature_map_1_quantize[1][1]) ? feature_map_1_quantize[1][0] : feature_map_1_quantize[1][1];

assign compare_last_00 = (compare_0_1 > compare_1_1) ? compare_0_1 : compare_1_1;

assign compare_0_2 = (feature_map_1_quantize[0][2] > feature_map_1_quantize[0][3]) ? feature_map_1_quantize[0][2] : feature_map_1_quantize[0][3];
assign compare_0_3 = (feature_map_1_quantize[1][2] > feature_map_1_quantize[1][3]) ? feature_map_1_quantize[1][2] : feature_map_1_quantize[1][3];

assign compare_last_01 = (compare_0_2 > compare_0_3) ? compare_0_2 : compare_0_3;

assign compare_2_0 = (feature_map_1_quantize[2][0] > feature_map_1_quantize[2][1]) ? feature_map_1_quantize[2][0] : feature_map_1_quantize[2][1];
assign compare_2_1 = (feature_map_1_quantize[3][0] > feature_map_1_quantize[3][1]) ? feature_map_1_quantize[3][0] : feature_map_1_quantize[3][1];

assign compare_last_21 = (compare_2_0 > compare_2_1) ? compare_2_0 : compare_2_1;

assign compare_3_0 = (feature_map_1_quantize[2][2] > feature_map_1_quantize[2][3]) ? feature_map_1_quantize[2][2] : feature_map_1_quantize[2][3];
assign compare_3_1 = (feature_map_1_quantize[3][2] > feature_map_1_quantize[3][3]) ? feature_map_1_quantize[3][2] : feature_map_1_quantize[3][3];

assign compare_last_31 = (compare_3_0 > compare_3_1) ? compare_3_0 : compare_3_1;

assign max_pool_00_1 = compare_last_00;
assign max_pool_01_1 = compare_last_01;
assign max_pool_10_1 = compare_last_21;
assign max_pool_11_1 = compare_last_31;

//-----------------------------------------------------------------------------------------------------------------------------------------

assign compare_0_1_next = (feature_map_2_quantize[0][0] > feature_map_2_quantize[0][1]) ? feature_map_2_quantize[0][0] : feature_map_2_quantize[0][1];
assign compare_1_1_next = (feature_map_2_quantize[1][0] > feature_map_2_quantize[1][1]) ? feature_map_2_quantize[1][0] : feature_map_2_quantize[1][1];

assign compare_last_00_next = (compare_0_1_next > compare_1_1_next) ? compare_0_1_next : compare_1_1_next;

assign compare_0_2_next = (feature_map_2_quantize[0][2] > feature_map_2_quantize[0][3]) ? feature_map_2_quantize[0][2] : feature_map_2_quantize[0][3];
assign compare_0_3_next = (feature_map_2_quantize[1][2] > feature_map_2_quantize[1][3]) ? feature_map_2_quantize[1][2] : feature_map_2_quantize[1][3];

assign compare_last_01_next = (compare_0_2_next > compare_0_3_next) ? compare_0_2_next : compare_0_3_next;

assign compare_2_0_next = (feature_map_2_quantize[2][0] > feature_map_2_quantize[2][1]) ? feature_map_2_quantize[2][0] : feature_map_2_quantize[2][1];
assign compare_2_1_next = (feature_map_2_quantize[3][0] > feature_map_2_quantize[3][1]) ? feature_map_2_quantize[3][0] : feature_map_2_quantize[3][1];

assign compare_last_21_next = (compare_2_0_next > compare_2_1_next) ? compare_2_0_next : compare_2_1_next;

assign compare_3_0_next = (feature_map_2_quantize[2][2] > feature_map_2_quantize[2][3]) ? feature_map_2_quantize[2][2] : feature_map_2_quantize[2][3];
assign compare_3_1_next = (feature_map_2_quantize[3][2] > feature_map_2_quantize[3][3]) ? feature_map_2_quantize[3][2] : feature_map_2_quantize[3][3];

assign compare_last_31_next= (compare_3_0_next > compare_3_1_next) ? compare_3_0_next : compare_3_1_next;

assign max_pool_00_2 = compare_last_00_next;
assign max_pool_01_2 = compare_last_01_next;
assign max_pool_10_2 = compare_last_21_next;
assign max_pool_11_2 = compare_last_31_next;

//-----------------------------------------------------------------------------------------------------------------------------------------

always@(posedge gclk_outvalid or negedge rst_n)begin
	if(!rst_n)begin
		for(i = 0; i < 2 ; i = i + 1)begin
			for(j = 0; j < 2; j = j + 1)begin
				max_pool_reg1[i][j] <= 0;
			end
		end
	end
	else begin
		max_pool_reg1[0][0] <= max_pool_00_1;
		max_pool_reg1[0][1] <= max_pool_01_1;
		max_pool_reg1[1][0] <= max_pool_10_1;
		max_pool_reg1[1][1] <= max_pool_11_1;
	end
end 

always@(posedge gclk_outvalid or negedge rst_n)begin
	if(!rst_n)begin
		for(i = 0; i < 2 ; i = i + 1)begin
			for(j = 0; j < 2; j = j + 1)begin
				max_pool_reg2[i][j] <= 0;
			end
		end
	end
	else begin
		max_pool_reg2[0][0] <= max_pool_00_2;
		max_pool_reg2[0][1] <= max_pool_01_2;
		max_pool_reg2[1][0] <= max_pool_10_2;
		max_pool_reg2[1][1] <= max_pool_11_2;
	end
end 

//-----------------------------------------------------------------------------------------------------------------------------------------

assign fully_connected_0_1 = max_pool_reg1[0][0] * weight_reg[0][0] + max_pool_reg1[0][1] * weight_reg[1][0];
assign fully_connected_1_1 = max_pool_reg1[0][0] * weight_reg[0][1] + max_pool_reg1[0][1] * weight_reg[1][1];
assign fully_connected_2_1 = max_pool_reg1[1][0] * weight_reg[0][0] + max_pool_reg1[1][1] * weight_reg[1][0];
assign fully_connected_3_1 = max_pool_reg1[1][0] * weight_reg[0][1] + max_pool_reg1[1][1] * weight_reg[1][1];

assign fully_connected_0_2 = max_pool_reg2[0][0] * weight_reg[0][0] + max_pool_reg2[0][1] * weight_reg[1][0];
assign fully_connected_1_2 = max_pool_reg2[0][0] * weight_reg[0][1] + max_pool_reg2[0][1] * weight_reg[1][1];
assign fully_connected_2_2 = max_pool_reg2[1][0] * weight_reg[0][0] + max_pool_reg2[1][1] * weight_reg[1][0];
assign fully_connected_3_2 = max_pool_reg2[1][0] * weight_reg[0][1] + max_pool_reg2[1][1] * weight_reg[1][1];

always@(posedge gclk_outvalid or negedge rst_n)begin
	if(!rst_n)begin
		fully_connected_reg1[0] <= 0;
		fully_connected_reg1[1] <= 0;
		fully_connected_reg1[2] <= 0;
		fully_connected_reg1[3] <= 0;
	end
	else begin 
		fully_connected_reg1[0] <= fully_connected_0_1;
		fully_connected_reg1[1] <= fully_connected_1_1;
		fully_connected_reg1[2] <= fully_connected_2_1;
		fully_connected_reg1[3] <= fully_connected_3_1;
	end
end 

always@(posedge gclk_outvalid or negedge rst_n)begin
	if(!rst_n)begin
		fully_connected_reg2[0] <= 0;
		fully_connected_reg2[1] <= 0;
		fully_connected_reg2[2] <= 0;
		fully_connected_reg2[3] <= 0;
	end
	else begin 
		fully_connected_reg2[0] <= fully_connected_0_2;
		fully_connected_reg2[1] <= fully_connected_1_2;
		fully_connected_reg2[2] <= fully_connected_2_2;
		fully_connected_reg2[3] <= fully_connected_3_2;
	end
end 

//-----------------------------------------------------------------------------------------------------------------------------------------

assign fully_connected_quantize_0_1 = fully_connected_reg1[0] / 510;
assign fully_connected_quantize_1_1 = fully_connected_reg1[1] / 510;
assign fully_connected_quantize_2_1 = fully_connected_reg1[2] / 510;
assign fully_connected_quantize_3_1 = fully_connected_reg1[3] / 510;

assign fully_connected_quantize_0_2 = fully_connected_reg2[0] / 510;
assign fully_connected_quantize_1_2 = fully_connected_reg2[1] / 510;
assign fully_connected_quantize_2_2 = fully_connected_reg2[2] / 510;
assign fully_connected_quantize_3_2 = fully_connected_reg2[3] / 510;

always@(posedge gclk_outvalid or negedge rst_n)begin
	if(!rst_n)begin
		fully_connected_quantize_reg1 [0] <= 0;
		fully_connected_quantize_reg1 [1] <= 0;
		fully_connected_quantize_reg1 [2] <= 0;
		fully_connected_quantize_reg1 [3] <= 0;
	end
	else begin 
		fully_connected_quantize_reg1 [0] <= fully_connected_quantize_0_1;
		fully_connected_quantize_reg1 [1] <= fully_connected_quantize_1_1;
		fully_connected_quantize_reg1 [2] <= fully_connected_quantize_2_1;
		fully_connected_quantize_reg1 [3] <= fully_connected_quantize_3_1;
	end
end 

always@(posedge gclk_outvalid or negedge rst_n)begin
	if(!rst_n)begin
		fully_connected_quantize_reg2 [0] <= 0;
		fully_connected_quantize_reg2 [1] <= 0;
		fully_connected_quantize_reg2 [2] <= 0;
		fully_connected_quantize_reg2 [3] <= 0;
	end
	else begin 
		fully_connected_quantize_reg2 [0] <= fully_connected_quantize_0_2;
		fully_connected_quantize_reg2 [1] <= fully_connected_quantize_1_2;
		fully_connected_quantize_reg2 [2] <= fully_connected_quantize_2_2;
		fully_connected_quantize_reg2 [3] <= fully_connected_quantize_3_2;
	end
end 

//-----------------------------------------------------------------------------------------------------------------------------------------

assign L_distance_0 = (fully_connected_quantize_reg1[0] > fully_connected_quantize_reg2[0]) ? fully_connected_quantize_reg1[0] - fully_connected_quantize_reg2[0] : fully_connected_quantize_reg2[0] - fully_connected_quantize_reg1[0];
assign L_distance_1 = (fully_connected_quantize_reg1[1] > fully_connected_quantize_reg2[1]) ? fully_connected_quantize_reg1[1] - fully_connected_quantize_reg2[1] : fully_connected_quantize_reg2[1] - fully_connected_quantize_reg1[1];
assign L_distance_2 = (fully_connected_quantize_reg1[2] > fully_connected_quantize_reg2[2]) ? fully_connected_quantize_reg1[2] - fully_connected_quantize_reg2[2] : fully_connected_quantize_reg2[2] - fully_connected_quantize_reg1[2];
assign L_distance_3 = (fully_connected_quantize_reg1[3] > fully_connected_quantize_reg2[3]) ? fully_connected_quantize_reg1[3] - fully_connected_quantize_reg2[3] : fully_connected_quantize_reg2[3] - fully_connected_quantize_reg1[3];

assign L_total = L_distance_0 + L_distance_1 + L_distance_2 + L_distance_3;

always@(posedge  gclk_outvalid or negedge rst_n)begin
	if(!rst_n)begin
		L_total_reg  <= 0;
	end
	else begin
		L_total_reg  <= L_total;
	end
end

//-----------------------------------------------------------------------------------------------------------------------------------------

assign fake_relu = (L_total_reg >= 16) ? L_total_reg : 0;

always@(posedge gclk_outvalid or negedge rst_n)begin
	if(!rst_n)begin
		fake_relu_reg <= 0;
	end
	else fake_relu_reg <= fake_relu;
end 

//-----------------------------------------------------------------------------------------------------------------------------------------

always@(posedge gclk_outvalid or negedge rst_n)begin
	if(!rst_n)begin
		cnt_in_valid_off <= 0;
	end
	else if(STATE == STANDBY) cnt_in_valid_off <= cnt_in_valid_off + 1;
	else if(NEXT == ZERO) cnt_in_valid_off <= 0;
	else cnt_in_valid_off <= cnt_in_valid_off;
end 



always@(posedge gclk_outvalid or negedge rst_n)begin
	if(!rst_n)begin
		out_valid <= 0;
	end
	else if (cnt_in_valid_off == 7) out_valid <= 1;
	else out_valid <= 0;
end 

always@(posedge gclk_outvalid or negedge rst_n)begin
	if(!rst_n)begin
		fake_out <= 0;
	end
	else if (cnt_in_valid_off == 7) fake_out <= fake_relu_reg;
	else fake_out <= 0;
end 

always@(*)begin	
	if(out_valid)begin
		out_data = fake_out;
	end
	else begin
		out_data = 0;
	end
end

endmodule