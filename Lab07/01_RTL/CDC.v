`include "AFIFO.v"

module CDC #(parameter DSIZE = 8,
			   parameter ASIZE = 4)(
	//Input Port
	rst_n,
	clk1,
    clk2,
	in_valid,
    doraemon_id,
    size,
    iq_score,
    eq_score,
    size_weight,
    iq_weight,
    eq_weight,
    //Output Port
	ready,
    out_valid,
	out,
    
); 
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION
//---------------------------------------------------------------------
output reg  [7:0] out;
output reg 	out_valid;
output reg ready;

input rst_n, clk1, clk2, in_valid;
input  [4:0]doraemon_id;
input  [7:0]size;
input  [7:0]iq_score;
input  [7:0]eq_score;
input [2:0]size_weight,iq_weight,eq_weight;
//---------------------------------------------------------------------
//   WIRE AND REG DECLARATION
//---------------------------------------------------------------------

reg  [4:0]doraemon_id_reg [0:4];
reg  [7:0]size_reg [0:4];
reg  [7:0]iq_score_reg [0:4];
reg  [7:0]eq_score_reg [0:4];
reg [2:0]size_weight_reg, iq_weight_reg , eq_weight_reg ;
reg [15:0] cnt_in_valid_total;
wire [13:0] score [0:4];
wire [18:0] id_score [0:4];
reg [18:0] prefer_dora; 
reg [2:0] door_out;
wire [4:0] id_out;
wire [7:0] result;
wire [7:0] rdata;
reg ready_reg;
wire wfull , rempty;
reg winc;
wire rinc;
reg rinc_reg , in_valid_reg;
reg [15:0] cnt_in_valid;

always@(posedge clk1 or negedge rst_n)begin
    if(!rst_n) begin
        doraemon_id_reg [0] <= 0;
        doraemon_id_reg [1] <= 0;
        doraemon_id_reg [2] <= 0;
        doraemon_id_reg [3] <= 0;
        doraemon_id_reg [4] <= 0;
    end
    else if(in_valid && cnt_in_valid_total < 5) begin
        case(cnt_in_valid_total)
            0:doraemon_id_reg [0] <= doraemon_id;
            1:doraemon_id_reg [1] <= doraemon_id;
            2:doraemon_id_reg [2] <= doraemon_id;
            3:doraemon_id_reg [3] <= doraemon_id;
            4:doraemon_id_reg [4] <= doraemon_id;
            default:;
        endcase
    end
    else if(in_valid && cnt_in_valid_total >= 5) begin
        case(door_out)
            0:doraemon_id_reg [0] <= doraemon_id;
            1:doraemon_id_reg [1] <= doraemon_id;
            2:doraemon_id_reg [2] <= doraemon_id;
            3:doraemon_id_reg [3] <= doraemon_id;
            4:doraemon_id_reg [4] <= doraemon_id;
            default:;
        endcase
    end
    else begin
        doraemon_id_reg [0] <= doraemon_id_reg [0];
        doraemon_id_reg [1] <= doraemon_id_reg [1];
        doraemon_id_reg [2] <= doraemon_id_reg [2];
        doraemon_id_reg [3] <= doraemon_id_reg [3];
        doraemon_id_reg [4] <= doraemon_id_reg [4];
    end
end

always@(posedge clk1 or negedge rst_n)begin
    if(!rst_n) begin
        size_reg [0] <= 0;
        size_reg [1] <= 0;
        size_reg [2] <= 0;
        size_reg [3] <= 0;
        size_reg [4] <= 0;
    end
    else if(in_valid && cnt_in_valid_total < 5) begin
        case(cnt_in_valid_total)
            0:size_reg [0] <= size;
            1:size_reg [1] <= size;
            2:size_reg [2] <= size;
            3:size_reg [3] <= size;
            4:size_reg [4] <= size;
            default:;
        endcase
    end
    else if(in_valid && cnt_in_valid_total >= 5) begin
        case(door_out)
            0:size_reg [0] <= size;
            1:size_reg [1] <= size;
            2:size_reg [2] <= size;
            3:size_reg [3] <= size;
            4:size_reg [4] <= size;
            default:;
        endcase
    end
    else begin
        size_reg [0] <= size_reg [0];
        size_reg [1] <= size_reg [1];
        size_reg [2] <= size_reg [2];
        size_reg [3] <= size_reg [3];
        size_reg [4] <= size_reg [4];
    end
end

always@(posedge clk1 or negedge rst_n)begin
    if(!rst_n) begin
        iq_score_reg [0] <= 0;
        iq_score_reg [1] <= 0;
        iq_score_reg [2] <= 0;
        iq_score_reg [3] <= 0;
        iq_score_reg [4] <= 0;
    end
    else if(in_valid && cnt_in_valid_total < 5) begin
        case(cnt_in_valid_total)
            0:iq_score_reg [0] <= iq_score;
            1:iq_score_reg [1] <= iq_score;
            2:iq_score_reg [2] <= iq_score;
            3:iq_score_reg [3] <= iq_score;
            4:iq_score_reg [4] <= iq_score;
            default:;
        endcase
    end
    else if(in_valid && cnt_in_valid_total >= 5) begin
        case(door_out)
            0:iq_score_reg [0] <= iq_score;
            1:iq_score_reg [1] <= iq_score;
            2:iq_score_reg [2] <= iq_score;
            3:iq_score_reg [3] <= iq_score;
            4:iq_score_reg [4] <= iq_score;
            default:;
        endcase
    end
    else begin
        iq_score_reg [0] <= iq_score_reg [0];
        iq_score_reg [1] <= iq_score_reg [1];
        iq_score_reg [2] <= iq_score_reg [2];
        iq_score_reg [3] <= iq_score_reg [3];
        iq_score_reg [4] <= iq_score_reg [4];
    end
end

always@(posedge clk1 or negedge rst_n)begin
    if(!rst_n) begin
        eq_score_reg [0] <= 0;
        eq_score_reg [1] <= 0;
        eq_score_reg [2] <= 0;
        eq_score_reg [3] <= 0;
        eq_score_reg [4] <= 0;
    end
    else if(in_valid && cnt_in_valid_total < 5) begin
        case(cnt_in_valid_total)
            0:eq_score_reg [0] <= eq_score;
            1:eq_score_reg [1] <= eq_score;
            2:eq_score_reg [2] <= eq_score;
            3:eq_score_reg [3] <= eq_score;
            4:eq_score_reg [4] <= eq_score;
            default:;
        endcase
    end
    else if(in_valid && cnt_in_valid_total >= 5) begin
        case(door_out)
            0:eq_score_reg [0] <= eq_score;
            1:eq_score_reg [1] <= eq_score;
            2:eq_score_reg [2] <= eq_score;
            3:eq_score_reg [3] <= eq_score;
            4:eq_score_reg [4] <= eq_score;
            default:;
        endcase
    end
    else begin
        eq_score_reg [0] <= eq_score_reg [0];
        eq_score_reg [1] <= eq_score_reg [1];
        eq_score_reg [2] <= eq_score_reg [2];
        eq_score_reg [3] <= eq_score_reg [3];
        eq_score_reg [4] <= eq_score_reg [4];
    end
end

always@(posedge clk1 or negedge rst_n)begin
    if(!rst_n) 
        size_weight_reg <= 0;
    else if(in_valid && cnt_in_valid_total > 3) 
        size_weight_reg <= size_weight;
    else 
        size_weight_reg <= size_weight_reg;
end

always@(posedge clk1 or negedge rst_n)begin
    if(!rst_n) 
        iq_weight_reg <= 0;
    else if(in_valid && cnt_in_valid_total > 3 ) 
        iq_weight_reg <= iq_weight;
    else 
        iq_weight_reg <= iq_weight_reg;
end

always@(posedge clk1 or negedge rst_n)begin
    if(!rst_n) 
        eq_weight_reg <= 0;
    else if(in_valid && cnt_in_valid_total > 3 ) 
        eq_weight_reg <= eq_weight;
    else 
        eq_weight_reg <= eq_weight_reg;
end

always@(posedge clk1 or negedge rst_n)begin
    if(!rst_n) 
        cnt_in_valid_total <= 0;
    else if(in_valid) 
        cnt_in_valid_total <= cnt_in_valid_total + 1;
    else 
        cnt_in_valid_total <= cnt_in_valid_total;
end

//always@(posedge clk1 or negedge rst_n)begin
//    if(!rst_n) 
//        cnt_in_valid <= 0;
//    else if(in_valid) 
//        cnt_in_valid <= cnt_in_valid + 1;
//    else 
//        cnt_in_valid <= 0;
//end

// always@(*)begin 
//     if(cnt_in_valid_total == 6000 ) ready = in_valid;
//     //if(cnt_in_valid_total == 21) ready = 0;
//     else if(cnt_in_valid_total > 3 ) ready = ~wfull;
//     else ready = 0;
// end

always@(*)begin 
    if(!rst_n) ready = 0;
    else if(cnt_in_valid_total == 6000 ) ready = 0;
    //if(cnt_in_valid_total == 21) ready = 0;
    else if(!wfull) ready = 1;
    else ready = 0;
end

//always@(posedge clk1 or negedge rst_n) begin
//    if(!rst_n) 
//        ready_reg <= 0;
//    else 
//        ready_reg <= ready;
//end

always@(posedge clk1 or negedge rst_n) begin
    if(!rst_n) 
        in_valid_reg <= 0;
    else 
        in_valid_reg <= in_valid;
end

always@(*)begin
    if(wfull == 1) winc = 0;
    else if (cnt_in_valid_total == 6000 ) winc = in_valid_reg;
    else if (cnt_in_valid_total > 4 ) winc = in_valid;
    else winc = 0;
end

assign score[0] = size_reg[0]*size_weight_reg + eq_score_reg[0]*eq_weight_reg + iq_score_reg[0]*iq_weight_reg;
assign score[1] = size_reg[1]*size_weight_reg + eq_score_reg[1]*eq_weight_reg + iq_score_reg[1]*iq_weight_reg;
assign score[2] = size_reg[2]*size_weight_reg + eq_score_reg[2]*eq_weight_reg + iq_score_reg[2]*iq_weight_reg;
assign score[3] = size_reg[3]*size_weight_reg + eq_score_reg[3]*eq_weight_reg + iq_score_reg[3]*iq_weight_reg;
assign score[4] = size_reg[4]*size_weight_reg + eq_score_reg[4]*eq_weight_reg + iq_score_reg[4]*iq_weight_reg;

assign id_score[0] = {doraemon_id_reg[0],score[0]};
assign id_score[1] = {doraemon_id_reg[1],score[1]};
assign id_score[2] = {doraemon_id_reg[2],score[2]};
assign id_score[3] = {doraemon_id_reg[3],score[3]};
assign id_score[4] = {doraemon_id_reg[4],score[4]};

always@(*)begin
    if((score[0] >= score[1]) && (score[0] >= score[2]) && (score[0] >= score[3]) && (score[0] >= score[4])) prefer_dora = id_score[0];
    else if((score[1] >= score[2]) && (score[1] >= score[3]) && (score[1] >= score[4])) prefer_dora = id_score[1];
    else if((score[2] >= score[3]) && (score[2] >= score[4] )) prefer_dora = id_score[2];
    else if(score[3] >= score[4]) prefer_dora = id_score[3];
    else prefer_dora = id_score[4];
end

always@(*)begin
    case(prefer_dora)
        id_score[0]:door_out = 0;
        id_score[1]:door_out = 1;
        id_score[2]:door_out = 2;
        id_score[3]:door_out = 3;
        default:door_out = 4;
    endcase
end

assign id_out = prefer_dora [18:14];
assign result = {door_out , id_out};



AFIFO #(.DSIZE(DSIZE) , .ASIZE(ASIZE)) AF_1 (.rst_n(rst_n) , .rclk(clk2) , .rinc(rinc) , .wclk(clk1) , .winc(winc) , .wdata(result) ,.rempty(rempty) ,.rdata(rdata) ,.wfull(wfull));


assign rinc = ~rempty;

//always@(posedge clk2 or negedge rst_n)begin
//    if(!rst_n) 
//        rinc_reg <= 0;
//    else 
//        rinc_reg <= rinc;
//end

always@(posedge clk2 or negedge rst_n)begin
    if(!rst_n) 
        out <= 0;
    else if(rinc)
        out <= rdata;
    else 
        out <= 0;
end

always@(posedge clk2 or negedge rst_n)begin
    if(!rst_n) 
        out_valid <= 0;
    else 
        out_valid <= rinc;
end

endmodule