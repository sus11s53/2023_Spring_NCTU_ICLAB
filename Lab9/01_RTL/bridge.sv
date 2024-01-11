module bridge(input clk, INF.bridge_inf inf);
//================================================================
// FSM 
//================================================================
typedef enum logic  [2:0] { ZERO				,
                            INPUT	            ,
							READ_ADDR			,
							READ_DATA	  		, 
							WRITE_ADDR			,
							WRITE_DATA			,
							WRITE_WAIT  		,
							OUT			    
						   } fsm_state ;
//================================================================
// logic 
//================================================================
fsm_state STATE, NEXT;
logic reg_mode;
logic [7:0]  reg_addr;
logic [63:0] reg_data;

//================================================================
// Design 
//================================================================

always_ff@(posedge clk or negedge inf.rst_n)begin
	if(!inf.rst_n) 
		STATE <= ZERO;
	else 
		STATE <= NEXT;
end

always_comb begin
	if(!inf.rst_n) 
		NEXT = ZERO;
	else begin
		case(STATE)
			ZERO:begin 
				if(inf.C_in_valid) NEXT = INPUT;
			 	else               NEXT = ZERO;
			end

			INPUT:begin
				if(reg_mode) NEXT = READ_ADDR;
				else         NEXT = WRITE_ADDR;
			end

			READ_ADDR:begin
				if(inf.AR_READY) NEXT = READ_DATA;
				else NEXT = READ_ADDR;
			end

			WRITE_ADDR:begin
				if(inf.AW_READY) NEXT = WRITE_DATA;
				else NEXT = WRITE_ADDR;
				
			end

			READ_DATA:begin
				if(inf.R_VALID) NEXT = OUT;
				else NEXT = READ_DATA;
				
			end

			WRITE_DATA:begin
				if(inf.W_READY) NEXT = WRITE_WAIT;
				else NEXT = WRITE_DATA;
				
			end

			WRITE_WAIT:begin
				if(inf.B_VALID && (inf.B_RESP == 2'b00)) NEXT = OUT;
				else NEXT = WRITE_WAIT;
			end

			OUT:begin 
					NEXT = ZERO;
			end
			
			default : NEXT = STATE;
		endcase
	end
end

always_ff@(posedge clk or negedge inf.rst_n)begin
	if(!inf.rst_n) 
		reg_mode <= 0;
	else 
		reg_mode <= inf.C_r_wb;
end

always_ff@(posedge clk or negedge inf.rst_n)begin
	if(!inf.rst_n) 
		reg_addr <= 0;
	else 
		reg_addr <= inf.C_addr;
end

always_ff@(posedge clk or negedge inf.rst_n) begin
	if(!inf.rst_n) 
		reg_data <= 0;
	else begin
		if(inf.C_in_valid && !inf.C_r_wb)begin 
			reg_data[ 7:0]  <= inf.C_data_w[63:56];
			reg_data[15:8]  <= inf.C_data_w[55:48];
			reg_data[23:16] <= inf.C_data_w[47:40];
			reg_data[31:24] <= inf.C_data_w[39:32];
			reg_data[39:32] <= inf.C_data_w[31:24];
			reg_data[47:40] <= inf.C_data_w[23:16];
			reg_data[55:48] <= inf.C_data_w[15:8];
			reg_data[63:56] <= inf.C_data_w[7:0];
		end
		else if((STATE == READ_DATA) && inf.R_VALID)begin
			reg_data[63:56] <= inf.R_DATA[7:0];
			reg_data[55:48] <= inf.R_DATA[15:8];
			reg_data[47:40] <= inf.R_DATA[23:16];
			reg_data[39:32] <= inf.R_DATA[31:24];
			reg_data[31:24] <= inf.R_DATA[39:32];
			reg_data[23:16] <= inf.R_DATA[47:40];
			reg_data[15:8]  <= inf.R_DATA[55:48];
			reg_data[7:0]   <= inf.R_DATA[63:56];
		end
	end
end

always_ff@(posedge clk or negedge inf.rst_n) begin
	if(!inf.rst_n) 
		inf.C_out_valid <= 0;
	else if(inf.C_out_valid == 1) 
		inf.C_out_valid <= 0;
	else if(NEXT == OUT) 
		inf.C_out_valid <= 1;
	else 
		inf.C_out_valid <= inf.C_out_valid;
end

assign inf.C_data_r = (inf.C_out_valid == 1) ? reg_data : 0;	
assign inf.W_DATA = reg_data;


assign inf.AR_VALID = (STATE == READ_ADDR)  ? 1 : 0;
assign inf.R_READY = (STATE == READ_DATA) ? 1 : 0;

assign inf.AW_VALID = (STATE == WRITE_ADDR) ? 1 : 0;
assign inf.W_VALID = (STATE == WRITE_DATA) ? 1 : 0;

assign inf.B_READY = (STATE == ZERO) ? 0 : 1;

always_ff@(posedge clk or negedge inf.rst_n)begin
	if(!inf.rst_n)begin
		inf.AR_ADDR <= 0;
	end
	else if(NEXT == READ_ADDR) 
		inf.AR_ADDR <= {6'b100000 , reg_addr , 3'b000};
	else 
		inf.AR_ADDR <= inf.AR_ADDR;
end

always_ff@(posedge clk or negedge inf.rst_n)begin
	if(!inf.rst_n)begin
		inf.AW_ADDR <= 0;
	end
	else if(NEXT == WRITE_ADDR) 
		inf.AW_ADDR <= {6'b100000 , reg_addr , 3'b000};
	else 
		inf.AW_ADDR <= inf.AW_ADDR;
end

endmodule