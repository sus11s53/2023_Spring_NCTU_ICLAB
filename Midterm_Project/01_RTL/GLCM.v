//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Si2 LAB @NCTU ED415
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2023 spring
//   Midterm Proejct            : GLCM 
//   Author                     : Hsi-Hao Huang
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : GLCM.v
//   Module Name : GLCM
//   Release version : V1.0 (Release Date: 2023-04)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module GLCM(
				clk,	
			  rst_n,	
	
			in_addr_M,
			in_addr_G,
			in_dir,
			in_dis,
			in_valid,
			out_valid,
	

         awid_m_inf,
       awaddr_m_inf,
       awsize_m_inf,
      awburst_m_inf,
        awlen_m_inf,
      awvalid_m_inf,
      awready_m_inf,
                    
        wdata_m_inf,
        wlast_m_inf,
       wvalid_m_inf,
       wready_m_inf,
                    
          bid_m_inf,
        bresp_m_inf,
       bvalid_m_inf,
       bready_m_inf,
                    
         arid_m_inf,
       araddr_m_inf,
        arlen_m_inf,
       arsize_m_inf,
      arburst_m_inf,
      arvalid_m_inf,
                    
      arready_m_inf, 
          rid_m_inf,
        rdata_m_inf,
        rresp_m_inf,
        rlast_m_inf,
       rvalid_m_inf,
       rready_m_inf 
);
parameter ID_WIDTH = 4 , ADDR_WIDTH = 32, DATA_WIDTH = 32;
input			  clk,rst_n;



// AXI Interface wire connecttion for pseudo DRAM read/write
/* Hint:
       your AXI-4 interface could be designed as convertor in submodule(which used reg for output signal),
	   therefore I declared output of AXI as wire in Poly_Ring
*/
   
// -----------------------------
// IO port
input [ADDR_WIDTH-1:0]      in_addr_M;
input [ADDR_WIDTH-1:0]      in_addr_G;
input [1:0]  	  		in_dir;
input [3:0]	    		in_dis;
input 			    	in_valid;
output reg 	              out_valid;
// -----------------------------


// axi write address channel 
output  wire [ID_WIDTH-1:0]        awid_m_inf;
output  wire [ADDR_WIDTH-1:0]    awaddr_m_inf;
output  wire [2:0]            awsize_m_inf;
output  wire [1:0]           awburst_m_inf;
output  wire [3:0]             awlen_m_inf;
output  reg                 awvalid_m_inf;
input   wire                 awready_m_inf;
// axi write data channel 
output  wire [ DATA_WIDTH-1:0]     wdata_m_inf;
output  wire                   wlast_m_inf;
output  wire                  wvalid_m_inf;
input   wire                  wready_m_inf;
// axi write response channel
input   wire [ID_WIDTH-1:0]         bid_m_inf;
input   wire [1:0]             bresp_m_inf;
input   wire              	   bvalid_m_inf;
output  wire                  bready_m_inf;
// -----------------------------
// axi read address channel 
output  wire [ID_WIDTH-1:0]       arid_m_inf;
output  wire [ADDR_WIDTH-1:0]   araddr_m_inf;
output  wire [3:0]            arlen_m_inf;
output  wire [2:0]           arsize_m_inf;
output  wire [1:0]          arburst_m_inf;
output  wire                arvalid_m_inf;
input   wire               arready_m_inf;
// -----------------------------
// axi read data channel 
input   wire [ID_WIDTH-1:0]         rid_m_inf;
input   wire [DATA_WIDTH-1:0]     rdata_m_inf;
input   wire [1:0]             rresp_m_inf;
input   wire                   rlast_m_inf;
input   wire                  rvalid_m_inf;
output  wire                  rready_m_inf;
//---------------------------------------------------------------------
//   FSM
//---------------------------------------------------------------------
parameter ZERO = 'd0;
parameter STORE = 'd1;
parameter DRAM_ADDR_0 = 'd2;
parameter DRAM_data_0 = 'd3;
parameter DRAM_ADDR_1 = 'd4;
parameter DRAM_data_1 = 'd5;
parameter DRAM_ADDR_2 = 'd6;
parameter DRAM_data_2 = 'd7;
parameter DRAM_ADDR_3 = 'd8;
parameter DRAM_data_3 = 'd9;
parameter SRAM_STORE = 'd10;
parameter SRAM_READ = 'd11;
parameter COMPUTATION = 'd12;
parameter DRAM_WRITE_ADDR = 'd13;
parameter DRAM_WRITE_DATA = 'd14;
parameter OUT = 'd15;

genvar gen_col , gen_row;
integer i , j;
// ===============================================================
// Wire & Reg Declaration
// ===============================================================
reg [5:0] STATE , NEXT;

reg [ADDR_WIDTH-1:0]      in_addr_M_reg;
reg [ADDR_WIDTH-1:0]      in_addr_G_reg;
reg [1:0] in_dir_reg;
reg [3:0]	in_dis_reg;
reg [4:0] input_matrix[0:15][0:15];
reg [2:0] cnt_col;
reg [4:0] cnt_row;

reg [4:0] w_cnt_col;
reg [4:0] w_cnt_row_times;

wire [7:0] input_0 , input_1 , input_2 ,input_3;

reg [ADDR_WIDTH-1:0]in_addr_M_reg_change;
reg [ADDR_WIDTH-1:0]in_addr_M_reg_change_reg;
wire MEM_cen, MEM_oen;
wire [7:0]  MEM_in[0:15];
wire [7:0]  MEM_out[0:15];
wire  MEM_wen[0:15];
wire [11:0]  MEM_adr[0:15];
reg [3:0] cnt_sram_col ,delay_dff;
wire [4:0] dff_data [0:15];
reg [4:0] row_offset , col_offset;
reg [4:0] cnt_times;
reg [7:0] input_matrix_sram[0:15][0:15];
reg [4:0] target_col , target_row;
wire [1:0] stp_bool [0:15][0:15];
reg [1:0] edp_bool [0:15][0:15];
reg [1:0] end_point_bool [0:15][0:15];
wire [1:0] final_map [0:15][0:15];
wire [7:0] GLCM_sum [0:15];
wire [7:0] total_sum;
reg [7:0] GLCM_map[0:31][0:31];
reg [4:0] cnt_waddr , cnt_waddr_count;
reg [13:0] glcm_addr;

wire [5:0] out_col_0 , out_col_1 , out_col_2, out_col_3;
wire [5:0] out_row;

wire [7:0] output_0 , output_1 , output_2 , output_3;
wire [31:0] out_res;

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
            if(in_valid) NEXT = STORE;
            else NEXT = ZERO;
        end
        
		    STORE:begin
            if(!in_valid) NEXT = DRAM_ADDR_0;
            else NEXT = STORE;
        end

        DRAM_ADDR_0:begin
            if(arready_m_inf == 1 && arvalid_m_inf == 1) NEXT = DRAM_data_0;
            else NEXT = DRAM_ADDR_0;
        end

        DRAM_data_0:begin
            if(cnt_row == 3 && cnt_col == 3)NEXT = DRAM_ADDR_1;
            else NEXT = DRAM_data_0;
        end

        DRAM_ADDR_1:begin
            if(arready_m_inf == 1 && arvalid_m_inf == 1) NEXT = DRAM_data_1;
            else NEXT = DRAM_ADDR_1;
        end

        DRAM_data_1:begin
            if(cnt_row == 7 && cnt_col == 3)NEXT = DRAM_ADDR_2;
            else NEXT = DRAM_data_1;
        end

        DRAM_ADDR_2:begin
            if(arready_m_inf == 1 && arvalid_m_inf == 1) NEXT = DRAM_data_2;
            else NEXT = DRAM_ADDR_2;
        end

        DRAM_data_2:begin
            if(cnt_row == 11 && cnt_col == 3)NEXT = DRAM_ADDR_3;
            else NEXT = DRAM_data_2;
        end

        DRAM_ADDR_3:begin
            if(arready_m_inf == 1 && arvalid_m_inf == 1) NEXT = DRAM_data_3;
            else NEXT = DRAM_ADDR_3;
        end

        DRAM_data_3:begin
            if(cnt_row == 15 && cnt_col == 3)NEXT = SRAM_STORE;
            else NEXT = DRAM_data_3;
        end

        SRAM_STORE:begin
            if(cnt_times == 20) NEXT = SRAM_READ;
            else NEXT = SRAM_STORE;
        end

        SRAM_READ:begin
            if(cnt_times == 20) NEXT = COMPUTATION;
            else NEXT = SRAM_READ;
        end

        COMPUTATION:begin 
            if(target_col == 31 && target_row == 31) NEXT = DRAM_WRITE_ADDR;
            else NEXT = COMPUTATION;
        end

        DRAM_WRITE_ADDR:begin
            if(awready_m_inf == 1 && awvalid_m_inf == 1) NEXT = DRAM_WRITE_DATA;
            else NEXT = DRAM_WRITE_ADDR;
        end

        DRAM_WRITE_DATA:begin
            if(cnt_waddr == 15 && cnt_waddr_count == 15) NEXT = OUT;
            else if(cnt_waddr == 15) NEXT = DRAM_WRITE_ADDR;
            else NEXT = DRAM_WRITE_DATA;
        end

        OUT:begin
            NEXT = ZERO;
        end


        default: NEXT = ZERO;
    endcase
end


always@(posedge clk or negedge rst_n)begin
  if(!rst_n)  in_addr_M_reg <= 0;
  else if(NEXT == STORE) in_addr_M_reg <= in_addr_M; 
  else in_addr_M_reg <= in_addr_M_reg;
end


always@(posedge clk or negedge rst_n)begin
  if(!rst_n)  in_addr_G_reg <= 0;
  else if(NEXT == STORE) in_addr_G_reg <= in_addr_G;
  else in_addr_G_reg <= in_addr_G_reg;
end

always@(posedge clk or negedge rst_n)begin
  if(!rst_n)  in_dir_reg <= 0;
  else if(NEXT == STORE) in_dir_reg <= in_dir;
  else in_dir_reg <= in_dir_reg;
end

always@(posedge clk or negedge rst_n)begin
  if(!rst_n)  in_dis_reg <= 0;
  else if(NEXT == STORE) in_dis_reg <= in_dis;
  else in_dis_reg <= in_dis_reg;
end


always@(posedge clk or negedge rst_n)begin
  if(!rst_n) cnt_col <= 0;
  else if((NEXT == DRAM_data_0 || NEXT == DRAM_data_1 || NEXT == DRAM_data_2 || NEXT == DRAM_data_3) && cnt_col < 3 && rvalid_m_inf == 1 ) cnt_col <= cnt_col + 1;
  else cnt_col <= 0;
end

always@(posedge clk or negedge rst_n)begin
  if(!rst_n) cnt_row <= 0;
  else if(cnt_col == 3) cnt_row <= cnt_row + 1;
  else if(STATE == ZERO) cnt_row <= 0;
  else cnt_row <= cnt_row;
end


assign input_0 = rdata_m_inf[7:0];
assign input_1 = rdata_m_inf[15:8];
assign input_2 = rdata_m_inf[23:16];
assign input_3 = rdata_m_inf[31:24];

always@(posedge clk or negedge rst_n)begin
  if(!rst_n) begin 
      for(i = 0 ; i < 16; i = i + 1)begin
          for(j = 0 ; j < 16; j = j + 1)begin
              input_matrix [i][j] <= 0;
          end
      end
  end
  else if(STATE == DRAM_data_0 || STATE == DRAM_data_1 || STATE == DRAM_data_2 || STATE == DRAM_data_3 )begin
     input_matrix[cnt_row][4*cnt_col] <= input_0;
     input_matrix[cnt_row][4*cnt_col + 1] <= input_1;
     input_matrix[cnt_row][4*cnt_col + 2] <= input_2;
     input_matrix[cnt_row][4*cnt_col + 3] <= input_3;
  end
  else begin
    for(i = 0 ; i < 16; i = i + 1)begin
          for(j = 0 ; j < 16; j = j + 1)begin
              input_matrix [i][j] <= input_matrix [i][j];
          end
      end
  end
end

always@(*)begin
  case(STATE)
    DRAM_ADDR_0:in_addr_M_reg_change = in_addr_M_reg;
    DRAM_data_0:in_addr_M_reg_change = in_addr_M_reg + 64;
    DRAM_ADDR_1:in_addr_M_reg_change = in_addr_M_reg + 64;
    DRAM_data_1:in_addr_M_reg_change = in_addr_M_reg + 128;
    DRAM_ADDR_2:in_addr_M_reg_change = in_addr_M_reg + 128;
    DRAM_data_2:in_addr_M_reg_change = in_addr_M_reg + 192;
    DRAM_ADDR_3:in_addr_M_reg_change = in_addr_M_reg + 192;
    DRAM_data_3:in_addr_M_reg_change = in_addr_M_reg + 192;
  default: in_addr_M_reg_change = in_addr_M_reg;
  endcase
end

always@(posedge clk or negedge rst_n)begin
  if(!rst_n)  in_addr_M_reg_change_reg <= 0;
  else if(NEXT == DRAM_ADDR_0 || NEXT == DRAM_ADDR_1 || NEXT == DRAM_ADDR_2 || NEXT == DRAM_ADDR_3 ) in_addr_M_reg_change_reg <= in_addr_M_reg_change; 
  else in_addr_M_reg_change_reg <= in_addr_M_reg_change_reg;
end

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

always@(posedge clk or negedge rst_n)begin
  if(!rst_n) cnt_sram_col <= 0;
  else if((STATE == SRAM_STORE && cnt_sram_col < 15)) cnt_sram_col <= cnt_sram_col + 1;
  else if((STATE == SRAM_READ && cnt_sram_col < 15)) cnt_sram_col <= cnt_sram_col + 1;
  else if(NEXT == SRAM_READ && STATE == SRAM_STORE) cnt_sram_col <= 0;
  else if(STATE == ZERO)cnt_sram_col <= 0;
  else cnt_sram_col <= cnt_sram_col;
end

always@(posedge clk or negedge rst_n)begin
  if(!rst_n) delay_dff <= 0;
  else if (STATE != SRAM_READ) delay_dff <= 0;
  else delay_dff <= cnt_sram_col;
end

assign dff_data[ 0] = (STATE == SRAM_STORE) ? input_matrix[ 0][cnt_sram_col] : 0;
assign dff_data[ 1] = (STATE == SRAM_STORE) ? input_matrix[ 1][cnt_sram_col] : 0;
assign dff_data[ 2] = (STATE == SRAM_STORE) ? input_matrix[ 2][cnt_sram_col] : 0;
assign dff_data[ 3] = (STATE == SRAM_STORE) ? input_matrix[ 3][cnt_sram_col] : 0;
assign dff_data[ 4] = (STATE == SRAM_STORE) ? input_matrix[ 4][cnt_sram_col] : 0;
assign dff_data[ 5] = (STATE == SRAM_STORE) ? input_matrix[ 5][cnt_sram_col] : 0;
assign dff_data[ 6] = (STATE == SRAM_STORE) ? input_matrix[ 6][cnt_sram_col] : 0;
assign dff_data[ 7] = (STATE == SRAM_STORE) ? input_matrix[ 7][cnt_sram_col] : 0;
assign dff_data[ 8] = (STATE == SRAM_STORE) ? input_matrix[ 8][cnt_sram_col] : 0;
assign dff_data[ 9] = (STATE == SRAM_STORE) ? input_matrix[ 9][cnt_sram_col] : 0;
assign dff_data[10] = (STATE == SRAM_STORE) ? input_matrix[10][cnt_sram_col] : 0;
assign dff_data[11] = (STATE == SRAM_STORE) ? input_matrix[11][cnt_sram_col] : 0;
assign dff_data[12] = (STATE == SRAM_STORE) ? input_matrix[12][cnt_sram_col] : 0;
assign dff_data[13] = (STATE == SRAM_STORE) ? input_matrix[13][cnt_sram_col] : 0;
assign dff_data[14] = (STATE == SRAM_STORE) ? input_matrix[14][cnt_sram_col] : 0;
assign dff_data[15] = (STATE == SRAM_STORE) ? input_matrix[15][cnt_sram_col] : 0;


assign MEM_in[ 0] = (STATE == SRAM_STORE) ? dff_data[ 0] : 0;
assign MEM_in[ 1] = (STATE == SRAM_STORE) ? dff_data[ 1] : 0;
assign MEM_in[ 2] = (STATE == SRAM_STORE) ? dff_data[ 2] : 0;
assign MEM_in[ 3] = (STATE == SRAM_STORE) ? dff_data[ 3] : 0;
assign MEM_in[ 4] = (STATE == SRAM_STORE) ? dff_data[ 4] : 0;
assign MEM_in[ 5] = (STATE == SRAM_STORE) ? dff_data[ 5] : 0;
assign MEM_in[ 6] = (STATE == SRAM_STORE) ? dff_data[ 6] : 0;
assign MEM_in[ 7] = (STATE == SRAM_STORE) ? dff_data[ 7] : 0;
assign MEM_in[ 8] = (STATE == SRAM_STORE) ? dff_data[ 8] : 0;
assign MEM_in[ 9] = (STATE == SRAM_STORE) ? dff_data[ 9] : 0;
assign MEM_in[10] = (STATE == SRAM_STORE) ? dff_data[10] : 0;
assign MEM_in[11] = (STATE == SRAM_STORE) ? dff_data[11] : 0;
assign MEM_in[12] = (STATE == SRAM_STORE) ? dff_data[12] : 0;
assign MEM_in[13] = (STATE == SRAM_STORE) ? dff_data[13] : 0;
assign MEM_in[14] = (STATE == SRAM_STORE) ? dff_data[14] : 0;
assign MEM_in[15] = (STATE == SRAM_STORE) ? dff_data[15] : 0;

assign MEM_adr[ 0] = (STATE == SRAM_STORE || STATE == SRAM_READ) ? cnt_sram_col : 0;
assign MEM_adr[ 1] = (STATE == SRAM_STORE || STATE == SRAM_READ) ? cnt_sram_col : 0;
assign MEM_adr[ 2] = (STATE == SRAM_STORE || STATE == SRAM_READ) ? cnt_sram_col : 0;
assign MEM_adr[ 3] = (STATE == SRAM_STORE || STATE == SRAM_READ) ? cnt_sram_col : 0;
assign MEM_adr[ 4] = (STATE == SRAM_STORE || STATE == SRAM_READ) ? cnt_sram_col : 0;
assign MEM_adr[ 5] = (STATE == SRAM_STORE || STATE == SRAM_READ) ? cnt_sram_col : 0;
assign MEM_adr[ 6] = (STATE == SRAM_STORE || STATE == SRAM_READ) ? cnt_sram_col : 0;
assign MEM_adr[ 7] = (STATE == SRAM_STORE || STATE == SRAM_READ) ? cnt_sram_col : 0;
assign MEM_adr[ 8] = (STATE == SRAM_STORE || STATE == SRAM_READ) ? cnt_sram_col : 0;
assign MEM_adr[ 9] = (STATE == SRAM_STORE || STATE == SRAM_READ) ? cnt_sram_col : 0;
assign MEM_adr[10] = (STATE == SRAM_STORE || STATE == SRAM_READ) ? cnt_sram_col : 0;
assign MEM_adr[11] = (STATE == SRAM_STORE || STATE == SRAM_READ) ? cnt_sram_col : 0;
assign MEM_adr[12] = (STATE == SRAM_STORE || STATE == SRAM_READ) ? cnt_sram_col : 0;
assign MEM_adr[13] = (STATE == SRAM_STORE || STATE == SRAM_READ) ? cnt_sram_col : 0;
assign MEM_adr[14] = (STATE == SRAM_STORE || STATE == SRAM_READ) ? cnt_sram_col : 0;
assign MEM_adr[15] = (STATE == SRAM_STORE || STATE == SRAM_READ) ? cnt_sram_col : 0;

assign MEM_wen[ 0] = (STATE == SRAM_STORE) ? 0 : 1;
assign MEM_wen[ 1] = (STATE == SRAM_STORE) ? 0 : 1;
assign MEM_wen[ 2] = (STATE == SRAM_STORE) ? 0 : 1;
assign MEM_wen[ 3] = (STATE == SRAM_STORE) ? 0 : 1;
assign MEM_wen[ 4] = (STATE == SRAM_STORE) ? 0 : 1;
assign MEM_wen[ 5] = (STATE == SRAM_STORE) ? 0 : 1;
assign MEM_wen[ 6] = (STATE == SRAM_STORE) ? 0 : 1;
assign MEM_wen[ 7] = (STATE == SRAM_STORE) ? 0 : 1;
assign MEM_wen[ 8] = (STATE == SRAM_STORE) ? 0 : 1;
assign MEM_wen[ 9] = (STATE == SRAM_STORE) ? 0 : 1;
assign MEM_wen[10] = (STATE == SRAM_STORE) ? 0 : 1;
assign MEM_wen[11] = (STATE == SRAM_STORE) ? 0 : 1;
assign MEM_wen[12] = (STATE == SRAM_STORE) ? 0 : 1;
assign MEM_wen[13] = (STATE == SRAM_STORE) ? 0 : 1;
assign MEM_wen[14] = (STATE == SRAM_STORE) ? 0 : 1;
assign MEM_wen[15] = (STATE == SRAM_STORE) ? 0 : 1;


always@(*)begin
  case(in_dir_reg)
      1:row_offset = in_dis_reg;
      2:row_offset = 0;
      default:row_offset = in_dis_reg;
  endcase
end

always@(*)begin
  case(in_dir_reg)
      1:col_offset = 0;
      2:col_offset = in_dis_reg;
      default:col_offset = in_dis_reg;
  endcase
end

always@(posedge clk or negedge rst_n)begin
  if(!rst_n) cnt_times <= 0;
  else if((STATE == SRAM_STORE && cnt_times < 20)||(STATE == SRAM_READ && cnt_times < 20)) cnt_times <= cnt_times + 1;
  else cnt_times <= 0;
end

always@(posedge clk or negedge rst_n)begin
  if(!rst_n) begin 
      for(i = 0 ; i < 16; i = i + 1)begin
          for(j = 0 ; j < 16; j = j + 1)begin
              input_matrix_sram [i][j] <= 0;
          end
      end
  end
  else if(STATE == SRAM_READ)begin
              input_matrix_sram [ 0][delay_dff] <= MEM_out [ 0];
              input_matrix_sram [ 1][delay_dff] <= MEM_out [ 1];
              input_matrix_sram [ 2][delay_dff] <= MEM_out [ 2];
              input_matrix_sram [ 3][delay_dff] <= MEM_out [ 3];
              input_matrix_sram [ 4][delay_dff] <= MEM_out [ 4];
              input_matrix_sram [ 5][delay_dff] <= MEM_out [ 5];
              input_matrix_sram [ 6][delay_dff] <= MEM_out [ 6];
              input_matrix_sram [ 7][delay_dff] <= MEM_out [ 7];
              input_matrix_sram [ 8][delay_dff] <= MEM_out [ 8];
              input_matrix_sram [ 9][delay_dff] <= MEM_out [ 9];
              input_matrix_sram [10][delay_dff] <= MEM_out [10];
              input_matrix_sram [11][delay_dff] <= MEM_out [11];
              input_matrix_sram [12][delay_dff] <= MEM_out [12];
              input_matrix_sram [13][delay_dff] <= MEM_out [13];
              input_matrix_sram [14][delay_dff] <= MEM_out [14];
              input_matrix_sram [15][delay_dff] <= MEM_out [15];
  end
  else begin
      for(i = 0 ; i < 16; i = i + 1)begin
          for(j = 0 ; j < 16; j = j + 1)begin
              input_matrix_sram [i][j] <= input_matrix_sram [i][j];
          end
      end
  end
end

always@(posedge clk or negedge rst_n)begin
  if(!rst_n) target_col <= 0;
  else if(STATE == COMPUTATION && target_col < 31)  target_col <= target_col + 1;
  else target_col <= 0;
end

always@(posedge clk or negedge rst_n)begin
  if(!rst_n) target_row <= 0;
  else if(target_col == 31)  target_row <= target_row + 1;
  else if(STATE == ZERO) target_row <= 0;
  else target_row <= target_row;
end


generate
  for( gen_row = 0; gen_row < 16; gen_row = gen_row + 1)begin:bool_row_stp
      for(gen_col = 0; gen_col < 16; gen_col = gen_col + 1)begin:bool_col_stp
        assign stp_bool [gen_row][gen_col] = ((input_matrix_sram[gen_row][gen_col] == target_row)&& STATE == COMPUTATION) ? 1:0;
      end
  end
endgenerate

generate
  for( gen_row = 0; gen_row < 16; gen_row = gen_row + 1)begin:bool_row_edp_bool
      for(gen_col = 0; gen_col < 16; gen_col = gen_col + 1)begin:bool_col_edp_bool
        always@(*)begin
          if(in_dir_reg == 1)  end_point_bool [gen_row][gen_col] = ((gen_row + row_offset <= 15) && STATE == COMPUTATION) ? 1:0;
          else if(in_dir_reg == 2) end_point_bool [gen_row][gen_col] = ((gen_col + col_offset <= 15) && STATE == COMPUTATION) ? 1:0;
          else end_point_bool [gen_row][gen_col] = (((gen_row + row_offset <= 15) && (gen_col + col_offset <= 15)) && STATE == COMPUTATION) ? 1:0;
        end 
      end
  end
endgenerate

generate
  for( gen_row = 0; gen_row < 16; gen_row = gen_row + 1)begin:bool_row_edp
      for(gen_col = 0; gen_col < 16; gen_col = gen_col + 1)begin:bool_col_edp
        always@(*)begin
          if(in_dir_reg == 1)  edp_bool [gen_row][gen_col] = ((input_matrix_sram[gen_row + row_offset][gen_col] == target_col) && end_point_bool [gen_row][gen_col] == 1) ? 1:0;
          else if(in_dir_reg == 2) edp_bool [gen_row][gen_col] = ((input_matrix_sram[gen_row][gen_col + col_offset] == target_col) && end_point_bool [gen_row][gen_col] == 1) ? 1:0;
          else edp_bool [gen_row][gen_col] = ((input_matrix_sram[gen_row + row_offset][gen_col + col_offset] == target_col) && end_point_bool [gen_row][gen_col] == 1) ? 1:0;
        end
      end
  end
endgenerate

generate
  for( gen_row = 0; gen_row < 16;gen_row = gen_row + 1 )begin:final_map_row
      for(gen_col = 0; gen_col < 16; gen_col = gen_col + 1)begin:final_map_col
          assign final_map[gen_row][gen_col] = stp_bool[gen_row][gen_col] & edp_bool [gen_row][gen_col];
      end
  end
endgenerate

generate
    for(gen_row = 0; gen_row < 16;gen_row = gen_row + 1)begin:sum_map
        assign GLCM_sum[gen_row] = final_map[gen_row][0] + final_map[gen_row][1] + final_map[gen_row][2] + final_map[gen_row][3] + final_map[gen_row][4] + final_map[gen_row][5] + final_map[gen_row][6] + final_map[gen_row][7] + final_map[gen_row][8] + final_map[gen_row][9] + final_map[gen_row][10] + final_map[gen_row][11] + final_map[gen_row][12] + final_map[gen_row][13] + final_map[gen_row][14] + final_map[gen_row][15];
    end
endgenerate

assign total_sum = GLCM_sum[0] + GLCM_sum[1] + GLCM_sum[2] + GLCM_sum[3] + GLCM_sum[4] + GLCM_sum[5] + GLCM_sum[6] + GLCM_sum[7] + GLCM_sum[8] + GLCM_sum[9] + GLCM_sum[10] + GLCM_sum[11] + GLCM_sum[12] + GLCM_sum[13] + GLCM_sum[14] + GLCM_sum[15] ;

always@(posedge clk or negedge rst_n)begin
   if(!rst_n)begin
      for(i = 0; i < 32; i = i + 1)begin
          for(j = 0; j < 32; j = j + 1)begin
              GLCM_map[i][j] <= 0;
          end
      end
   end
   else if(STATE == COMPUTATION)begin
      GLCM_map[target_row][target_col] <= total_sum;
   end
end

// << Burst & ID >>
assign awid_m_inf =  4'd0000;
assign awburst_m_inf = 2'b01;
assign awsize_m_inf = 3'b010;

assign awlen_m_inf = 15;


always@(*)begin
	if(STATE == DRAM_WRITE_ADDR) awvalid_m_inf = 1;
	else awvalid_m_inf = 0;
end

always@(posedge clk or negedge rst_n)begin
  if(!rst_n) cnt_waddr <= 0;
  else if(STATE == DRAM_WRITE_DATA && cnt_waddr < 15 && wready_m_inf == 1)  cnt_waddr <= cnt_waddr + 1;
  else cnt_waddr <= 0;
end

always@(posedge clk or negedge rst_n)begin
  if(!rst_n) cnt_waddr_count <= 0;
  else if(cnt_waddr == 15 )  cnt_waddr_count <= cnt_waddr_count + 1;
  else if(STATE == ZERO ) cnt_waddr_count <= 0;
  else cnt_waddr_count <= cnt_waddr_count;
end


always@(*)begin
    case(cnt_waddr_count)
        0:glcm_addr = in_addr_G_reg;
        1:glcm_addr = in_addr_G_reg + 64;
        2:glcm_addr = in_addr_G_reg + 128;
        3:glcm_addr = in_addr_G_reg + 192;
        4:glcm_addr = in_addr_G_reg + 256;
        5:glcm_addr = in_addr_G_reg + 320;
        6:glcm_addr = in_addr_G_reg + 384;
        7:glcm_addr = in_addr_G_reg + 448;
        8:glcm_addr = in_addr_G_reg + 512;
        9:glcm_addr = in_addr_G_reg + 576;
        10:glcm_addr = in_addr_G_reg + 640;
        11:glcm_addr = in_addr_G_reg + 704;
        12:glcm_addr = in_addr_G_reg + 768;
        13:glcm_addr = in_addr_G_reg + 832;
        14:glcm_addr = in_addr_G_reg + 896;
        default : glcm_addr = in_addr_G_reg + 960;
    endcase
end

assign awaddr_m_inf = glcm_addr;


assign bready_m_inf = 4'b0001;
assign wvalid_m_inf = (STATE == DRAM_WRITE_DATA && cnt_waddr <= 15) ? 1 : 0;
assign wlast_m_inf = (cnt_waddr == 15) ? 1 : 0;

always@(posedge clk or negedge rst_n)begin
  if(!rst_n) w_cnt_col <= 0;
  else if((NEXT == DRAM_WRITE_DATA) && w_cnt_col < 7 && wready_m_inf == 1 ) w_cnt_col <= w_cnt_col + 1;
  else w_cnt_col <= 0;
end

always@(posedge clk or negedge rst_n)begin
  if(!rst_n) w_cnt_row_times <= 0;
  else if(w_cnt_col == 7) w_cnt_row_times <= w_cnt_row_times + 1;
  else if(STATE == ZERO ) w_cnt_row_times <= 0;
  else w_cnt_row_times <= w_cnt_row_times;
end

assign out_col_0 = (w_cnt_col << 2) + 0;
assign out_col_1 = (w_cnt_col << 2) + 1;
assign out_col_2 = (w_cnt_col << 2) + 2;
assign out_col_3 = (w_cnt_col << 2) + 3;

assign out_row = w_cnt_row_times;

assign output_0 = GLCM_map[out_row][out_col_0];
assign output_1 = GLCM_map[out_row][out_col_1];
assign output_2 = GLCM_map[out_row][out_col_2];
assign output_3 = GLCM_map[out_row][out_col_3];

assign out_res[7:0] = output_0;
assign out_res[15:8] = output_1;
assign out_res[23:16] = output_2;
assign out_res[31:24] = output_3;

assign wdata_m_inf = out_res;

always@(posedge clk or negedge rst_n)begin
  if(!rst_n)  out_valid <= 0;
  else if(NEXT == OUT ) out_valid <= 1;
  else out_valid <= 0;
end

//================================================================
//  AXI 4 READ
//================================================================
AXI4_READ INF_AXI4_READ(
	.clk(clk),.rst_n(rst_n),.NEXT(NEXT),.STATE(STATE),.in_addr_M(in_addr_M_reg_change_reg),.in_addr_G(in_addr_G_reg),
	.arid_m_inf(arid_m_inf),
	.arburst_m_inf(arburst_m_inf), .arsize_m_inf(arsize_m_inf), .arlen_m_inf(arlen_m_inf), 
	.arvalid_m_inf(arvalid_m_inf), .arready_m_inf(arready_m_inf), .araddr_m_inf(araddr_m_inf),
	.rid_m_inf(rid_m_inf),
	.rvalid_m_inf(rvalid_m_inf), .rready_m_inf(rready_m_inf), .rdata_m_inf(rdata_m_inf),
	.rlast_m_inf(rlast_m_inf), .rresp_m_inf(rresp_m_inf)

);

endmodule

// ############################################################################
//  					AXI4 Interfaces Module
// ############################################################################
// =========================================
// Read Data from DRAM 
// =========================================
module AXI4_READ(
	clk,rst_n,STATE, in_addr_M, in_addr_G,NEXT,
	
  arid_m_inf,arburst_m_inf, arsize_m_inf, arlen_m_inf, 
	arvalid_m_inf, arready_m_inf, araddr_m_inf,
	
  rid_m_inf,rvalid_m_inf, rready_m_inf, rdata_m_inf,
	rlast_m_inf, rresp_m_inf
);
parameter ID_WIDTH = 4 , ADDR_WIDTH = 32, DATA_WIDTH = 32;

// (0)	CHIP IO
input clk,rst_n;
input [5:0] NEXT ,STATE;
input [ADDR_WIDTH-1:0] in_addr_M;
input [ADDR_WIDTH-1:0] in_addr_G;

// ------------------------
// (1)	axi read address channel 
output wire [ID_WIDTH-1:0]      arid_m_inf;
output wire [ADDR_WIDTH-1:0]  araddr_m_inf;
output  wire [3:0]            arlen_m_inf;
output  wire [2:0]           arsize_m_inf;
output  wire [1:0]          arburst_m_inf;
output  reg                arvalid_m_inf;
input   wire               arready_m_inf;
// ------------------------
// (2)	axi read data channel 
input  wire [ID_WIDTH-1:0]       rid_m_inf;
input  wire [DATA_WIDTH-1:0]   rdata_m_inf;
input  wire [1:0]              rresp_m_inf;
input  wire                    rlast_m_inf;
input  wire                   rvalid_m_inf;
output reg                    rready_m_inf;


//---------------------------------------------------------------------
//   FSM
//---------------------------------------------------------------------
parameter ZERO = 'd0;
parameter STORE = 'd1;
parameter DRAM_ADDR_0 = 'd2;
parameter DRAM_data_0 = 'd3;
parameter DRAM_ADDR_1 = 'd4;
parameter DRAM_data_1 = 'd5;
parameter DRAM_ADDR_2 = 'd6;
parameter DRAM_data_2 = 'd7;
parameter DRAM_ADDR_3 = 'd8;
parameter DRAM_data_3 = 'd9;
parameter SRAM_STORE = 'd10;
parameter SRAM_READ = 'd11;
parameter COMPUTATION = 'd12;
parameter DRAM_WRITE_ADDR = 'd13;
parameter DRAM_WRITE_DATA = 'd14;
parameter OUT = 'd15;

//arvalid_m_inf
always@(*)begin
	if(STATE == DRAM_ADDR_0 || STATE == DRAM_ADDR_1 || STATE == DRAM_ADDR_2 || STATE == DRAM_ADDR_3) arvalid_m_inf = 1;
	else arvalid_m_inf = 0;
end

assign arlen_m_inf = 15;
assign araddr_m_inf = in_addr_M;

//rready_m_inf
always@(*)begin
	if(STATE == DRAM_data_0 || STATE == DRAM_data_1 || STATE == DRAM_data_2 || STATE == DRAM_data_3) rready_m_inf = 1;
	else rready_m_inf = 0;
end

// << Burst & ID >>
assign arid_m_inf = 4'd0;
assign arburst_m_inf = 2'b01;
assign arsize_m_inf = 3'b010;




endmodule