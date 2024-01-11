module SUBWAY(
    //Input Port
    clk,
    rst_n,
    in_valid,
    init,
    in0,
    in1,
    in2,
    in3,
    //Output Port
    out_valid,
    out
);


input clk, rst_n;
input in_valid;
input [1:0] init;
input [1:0] in0, in1, in2, in3; 
output reg       out_valid;
output reg [1:0] out;


//==============================================//
//       parameter & integer declaration        //
//==============================================//
parameter ZERO = 5'd0;
parameter STORE_MAP = 5'd1;
parameter SUSUME = 5'd2;
parameter OUT = 5'd3;

integer i , j;
//==============================================//
//           reg & wire declaration             //
//==============================================//
reg [6:0] cnt;
reg [5:0] STATE , NEXT;
reg [1:0]  decision_1 , decision_2 , decision_3 , decision_4 , decision_5 , decision_6 , decision_7;
wire signed [5:0] direction_1 , direction_2 , direction_3 , direction_4 , direction_5 , direction_6 , direction_7 , direction_8;
reg signed [4:0] map_design [0:3][0:63];
wire [1:0] jump_forward_1 , jump_forward_3 , jump_forward_9 , jump_forward_11 , jump_forward_17 , jump_forward_19 , jump_forward_25 , jump_forward_27 , jump_forward_33 , jump_forward_35 , jump_forward_41 ,jump_forward_43 , jump_forward_49 , jump_forward_51 , jump_forward_57 , jump_forward_59 , jump_forward_61;
reg [1:0] direction_forward_4 , direction_forward_5 , direction_forward_6 , direction_forward_7 , direction_forward_12 , direction_forward_13 , direction_forward_14 , direction_forward_15 , direction_forward_20 , direction_forward_21 , direction_forward_22 , direction_forward_23 , direction_forward_28 , direction_forward_29 , direction_forward_30 , direction_forward_31 ,direction_forward_36, direction_forward_37 , direction_forward_38 , direction_forward_39 , direction_forward_44 , direction_forward_45 , direction_forward_46 , direction_forward_47 , direction_forward_52 , direction_forward_53 , direction_forward_54 ,direction_forward_55;
reg [1:0] movement [0:62];
reg [1:0] initial_position_design;
//==============================================//
//                  design                      //
//==============================================//
always@(posedge clk or negedge rst_n) begin
	    if(!rst_n) STATE <= ZERO;
	    else STATE <= NEXT;
end

always@(*)begin
    if(map_design[0][8] == 0) decision_1 = 0;
    else if(map_design[1][8] == 0) decision_1 = 1;
    else if(map_design[2][8] == 0) decision_1 = 2;
    else decision_1 = 3;
end

always@(*)begin
    if(map_design[0][16] == 0) decision_2 = 0;
    else if(map_design[1][16] == 0) decision_2 = 1;
    else if(map_design[2][16] == 0) decision_2 = 2;
    else decision_2 = 3;
end

always@(*)begin
    if(map_design[0][24] == 0) decision_3 = 0;
    else if(map_design[1][24] == 0) decision_3 = 1;
    else if(map_design[2][24] == 0) decision_3 = 2;
    else decision_3 = 3;
end

always@(*)begin
    if(map_design[0][32] == 0) decision_4 = 0;
    else if(map_design[1][32] == 0) decision_4 = 1;
    else if(map_design[2][32] == 0) decision_4 = 2;
    else decision_4 = 3;
end

always@(*)begin
    if(map_design[0][40] == 0) decision_5 = 0;
    else if(map_design[1][40] == 0) decision_5 = 1;
    else if(map_design[2][40] == 0) decision_5 = 2;
    else decision_5 = 3;
end

always@(*)begin
    if(map_design[0][48] == 0) decision_6 = 0;
    else if(map_design[1][48] == 0) decision_6 = 1;
    else if(map_design[2][48] == 0) decision_6 = 2;
    else decision_6 = 3;
end

always@(*)begin
    if(map_design[0][56] == 0) decision_7 = 0;
    else if(map_design[1][56] == 0) decision_7 = 1;
    else if(map_design[2][56] == 0) decision_7 = 2;
    else decision_7 = 3;
end


assign direction_1 = decision_1 - initial_position_design;
assign direction_2 = decision_2 - decision_1;
assign direction_3 = decision_3 - decision_2;
assign direction_4 = decision_4 - decision_3;
assign direction_5 = decision_5 - decision_4;
assign direction_6 = decision_6 - decision_5;
assign direction_7 = decision_7 - decision_6;
assign direction_8 = 0;

always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
            for(j= 0; j < 64; j = j + 1)begin
                movement[i][j] <= 0;
            end
    end
    else begin
            case(NEXT)
            ZERO : begin
                for(j= 0; j < 64; j = j + 1)begin
                    movement[i][j] <= 0;
                end
            end
            SUSUME : begin
                //forward
                movement[0] <= 0;
                movement[2] <= 0;
                movement[8] <= 0;
                movement[10] <= 0;
                movement[16] <= 0;
                movement[18] <= 0;
                movement[24] <= 0;
                movement[26] <= 0;
                movement[32] <= 0;
                movement[34] <= 0;
                movement[40] <= 0;
                movement[42] <= 0;
                movement[48] <= 0;
                movement[50] <= 0;
                movement[56] <= 0;
                movement[58] <= 0;
                movement[60] <= 0;
                movement[62] <= 0;
                
                // choose jump or forward
                movement[1] <= jump_forward_1;
                movement[3] <= jump_forward_3;
                movement[9] <= jump_forward_9;
                movement[11] <= jump_forward_11;
                movement[17] <= jump_forward_17;
                movement[19] <= jump_forward_19;
                movement[25] <= jump_forward_25;
                movement[27] <= jump_forward_27;
                movement[33] <= jump_forward_33;
                movement[35] <= jump_forward_35;
                movement[41] <= jump_forward_41;
                movement[43] <= jump_forward_43;
                movement[49] <= jump_forward_49;
                movement[51] <= jump_forward_51;
                movement[57] <= jump_forward_57;
                movement[59] <= jump_forward_59;
                movement[61] <= jump_forward_61;

                //choose direction or forward
                movement[4] <= direction_forward_4;
                movement[5] <= direction_forward_5;
                movement[6] <= direction_forward_6;
                movement[7] <= direction_forward_7;
                movement[12] <= direction_forward_12;
                movement[13] <= direction_forward_13;
                movement[14] <= direction_forward_14;
                movement[15] <= direction_forward_15;
                movement[20] <= direction_forward_20;
                movement[21] <= direction_forward_21;
                movement[22] <= direction_forward_22;
                movement[23] <= direction_forward_23;
                movement[28] <= direction_forward_28;
                movement[29] <= direction_forward_29;
                movement[30] <= direction_forward_30;
                movement[31] <= direction_forward_31;
                movement[36] <= direction_forward_36;
                movement[37] <= direction_forward_37;
                movement[38] <= direction_forward_38;
                movement[39] <= direction_forward_39;
                movement[44] <= direction_forward_44;
                movement[45] <= direction_forward_45;
                movement[46] <= direction_forward_46;
                movement[47] <= direction_forward_47;
                movement[52] <= direction_forward_52;
                movement[53] <= direction_forward_53;
                movement[54] <= direction_forward_54;
                movement[55] <= direction_forward_55;
            end
            
            endcase
    end
end

assign jump_forward_1 = (map_design[initial_position_design][2] == 1) ? 3 : 0;
assign jump_forward_3 = (map_design[initial_position_design][4] == 1) ? 3 : 0;
assign jump_forward_9 = (map_design[decision_1][10] == 1) ? 3 : 0;
assign jump_forward_11 = (map_design[decision_1][12] == 1) ? 3 : 0;
assign jump_forward_17 = (map_design[decision_2][18] == 1) ? 3 : 0;
assign jump_forward_19 = (map_design[decision_2][20] == 1) ? 3 : 0;
assign jump_forward_25 = (map_design[decision_3][26] == 1) ? 3 : 0;
assign jump_forward_27 = (map_design[decision_3][28] == 1) ? 3 : 0;
assign jump_forward_33 = (map_design[decision_4][34] == 1) ? 3 : 0;
assign jump_forward_35 = (map_design[decision_4][36] == 1) ? 3 : 0;
assign jump_forward_41 = (map_design[decision_5][42] == 1) ? 3 : 0;
assign jump_forward_43 = (map_design[decision_5][44] == 1) ? 3 : 0;
assign jump_forward_49 = (map_design[decision_6][50] == 1) ? 3 : 0;
assign jump_forward_51 = (map_design[decision_6][52] == 1) ? 3 : 0;
assign jump_forward_57 = (map_design[decision_7][58] == 1) ? 3 : 0;
assign jump_forward_59 = (map_design[decision_7][60] == 1) ? 3 : 0;
assign jump_forward_61 = (map_design[decision_7][62] == 1) ? 3 : 0;

always@(*)begin
    case(direction_1)
    -3: begin 
            direction_forward_4 = 2;
            direction_forward_5 = (map_design[initial_position_design - 1][6] == 1) ? 3 : 0;
            direction_forward_6 = 2;
            direction_forward_7 = 2;
        end

    -2: begin 
            direction_forward_4 = 2;
            direction_forward_5 = (map_design[initial_position_design - 1][6] == 1) ? 3 : 0;
            direction_forward_6 = 2;
            direction_forward_7 = 0;
        end

    -1: begin 
            direction_forward_4 = 2;
            direction_forward_5 = (map_design[initial_position_design - 1][6] == 1) ? 3 : 0;
            direction_forward_6 = 0;
            direction_forward_7 = 0;
        end

    0: begin 
            direction_forward_4 = 0;
            direction_forward_5 = (map_design[initial_position_design][6] == 1) ? 3 : 0;
            direction_forward_6 = 0;
            direction_forward_7 = 0;
        end
    
    1: begin 
            direction_forward_4 = 1;
            direction_forward_5 = (map_design[initial_position_design + 1][6] == 1) ? 3 : 0;
            direction_forward_6 = 0;
            direction_forward_7 = 0;
        end

    2: begin 
            direction_forward_4 = 1;
            direction_forward_5 = (map_design[initial_position_design + 1][6] == 1) ? 3 : 0;
            direction_forward_6 = 1;
            direction_forward_7 = 0;
        end

    3: begin 
            direction_forward_4 = 1;
            direction_forward_5 = (map_design[initial_position_design + 1][6] == 1) ? 3 : 0;
            direction_forward_6 = 1;
            direction_forward_7 = 1;
        end
    default:begin
        direction_forward_4 = 0;
        direction_forward_5 = 0;
        direction_forward_6 = 0;
        direction_forward_7 = 0;
        end
    endcase
end 

always@(*)begin
    case(direction_2)
    -3: begin 
            direction_forward_12 = 2;
            direction_forward_13 = (map_design[decision_1 - 1][14] == 1) ? 3 : 0;
            direction_forward_14 = 2;
            direction_forward_15 = 2;
        end

    -2: begin 
            direction_forward_12 = 2;
            direction_forward_13 = (map_design[decision_1 - 1][14] == 1) ? 3 : 0;
            direction_forward_14 = 2;
            direction_forward_15 = 0;
        end

    -1: begin 
            direction_forward_12 = 2;
            direction_forward_13 = (map_design[decision_1 - 1][14] == 1) ? 3 : 0;
            direction_forward_14 = 0;
            direction_forward_15 = 0;
        end

    0: begin 
            direction_forward_12 = 0;
            direction_forward_13 = (map_design[decision_1][14] == 1) ? 3 : 0;
            direction_forward_14 = 0;
            direction_forward_15 = 0;
        end
    
    1: begin 
            direction_forward_12 = 1;
            direction_forward_13 = (map_design[decision_1 + 1][14] == 1) ? 3 : 0;
            direction_forward_14 = 0;
            direction_forward_15 = 0;
        end

    2: begin 
            direction_forward_12 = 1;
            direction_forward_13 = (map_design[decision_1 + 1][14] == 1) ? 3 : 0;
            direction_forward_14 = 1;
            direction_forward_15 = 0;
        end

    3: begin 
            direction_forward_12 = 1;
            direction_forward_13 = (map_design[decision_1 + 1][14] == 1) ? 3 : 0;
            direction_forward_14 = 1;
            direction_forward_15 = 1;
        end
    default:begin
        direction_forward_12 = 0;
        direction_forward_13 = 0;
        direction_forward_14 = 0;
        direction_forward_15 = 0;
        end
    endcase
end 

always@(*)begin
    case(direction_3)
    -3: begin 
            direction_forward_20 = 2;
            direction_forward_21 = (map_design[decision_2 - 1][22] == 1) ? 3 : 0;
            direction_forward_22 = 2;
            direction_forward_23 = 2;
        end

    -2: begin 
            direction_forward_20 = 2;
            direction_forward_21 = (map_design[decision_2 - 1][22] == 1) ? 3 : 0;
            direction_forward_22 = 2;
            direction_forward_23 = 0;
        end

    -1: begin 
            direction_forward_20 = 2;
            direction_forward_21 = (map_design[decision_2 - 1][22] == 1) ? 3 : 0;
            direction_forward_22 = 0;
            direction_forward_23 = 0;
        end

    0: begin 
            direction_forward_20 = 0;
            direction_forward_21 = (map_design[decision_2][22] == 1) ? 3 : 0;
            direction_forward_22 = 0;
            direction_forward_23 = 0;
        end
    
    1: begin 
            direction_forward_20 = 1;
            direction_forward_21 = (map_design[decision_2 + 1][22] == 1) ? 3 : 0;
            direction_forward_22 = 0;
            direction_forward_23 = 0;
        end

    2: begin 
            direction_forward_20 = 1;
            direction_forward_21 = (map_design[decision_2 + 1][22] == 1) ? 3 : 0;
            direction_forward_22 = 1;
            direction_forward_23 = 0;
        end

    3: begin 
            direction_forward_20 = 1;
            direction_forward_21 = (map_design[decision_2 + 1][22] == 1) ? 3 : 0;
            direction_forward_22 = 1;
            direction_forward_23 = 1;
        end
    default:begin
        direction_forward_20 = 0;
        direction_forward_21 = 0;
        direction_forward_22 = 0;
        direction_forward_23 = 0;
        end
    endcase
end 

always@(*)begin
    case(direction_4)
    -3: begin 
            direction_forward_28 = 2;
            direction_forward_29 = (map_design[decision_3 - 1][30] == 1) ? 3 : 0;
            direction_forward_30 = 2;
            direction_forward_31 = 2;
        end

    -2: begin 
            direction_forward_28 = 2;
            direction_forward_29 = (map_design[decision_3 - 1][30] == 1) ? 3 : 0;
            direction_forward_30 = 2;
            direction_forward_31 = 0;
        end

    -1: begin 
            direction_forward_28 = 2;
            direction_forward_29 = (map_design[decision_3 - 1][30] == 1) ? 3 : 0;
            direction_forward_30 = 0;
            direction_forward_31 = 0;
        end

    0: begin 
            direction_forward_28 = 0;
            direction_forward_29 = (map_design[decision_3][30] == 1) ? 3 : 0;
            direction_forward_30 = 0;
            direction_forward_31 = 0;
        end
    
    1: begin 
            direction_forward_28 = 1;
            direction_forward_29 = (map_design[decision_3 + 1][30] == 1) ? 3 : 0;
            direction_forward_30 = 0;
            direction_forward_31 = 0;
        end

    2: begin 
            direction_forward_28 = 1;
            direction_forward_29 = (map_design[decision_3 + 1][30] == 1) ? 3 : 0;
            direction_forward_30 = 1;
            direction_forward_31 = 0;
        end

    3: begin 
            direction_forward_28 = 1;
            direction_forward_29 = (map_design[decision_3 + 1][30] == 1) ? 3 : 0;
            direction_forward_30 = 1;
            direction_forward_31 = 1;
        end
    default:begin
        direction_forward_28 = 0;
        direction_forward_29 = 0;
        direction_forward_30 = 0;
        direction_forward_31 = 0;
        end
    endcase
end 

always@(*)begin
    case(direction_5)
    -3: begin 
            direction_forward_36 = 2;
            direction_forward_37 = (map_design[decision_4 - 1][38] == 1) ? 3 : 0;
            direction_forward_38 = 2;
            direction_forward_39 = 2;
        end

    -2: begin 
            direction_forward_36 = 2;
            direction_forward_37 = (map_design[decision_4 - 1][38] == 1) ? 3 : 0;
            direction_forward_38 = 2;
            direction_forward_39 = 0;
        end

    -1: begin 
            direction_forward_36 = 2;
            direction_forward_37 = (map_design[decision_4 - 1][38] == 1) ? 3 : 0;
            direction_forward_38 = 0;
            direction_forward_39 = 0;
        end

    0: begin 
            direction_forward_36 = 0;
            direction_forward_37 = (map_design[decision_4][38] == 1) ? 3 : 0;
            direction_forward_38 = 0;
            direction_forward_39 = 0;
        end
    
    1: begin 
            direction_forward_36 = 1;
            direction_forward_37 = (map_design[decision_4 + 1][38] == 1) ? 3 : 0;
            direction_forward_38 = 0;
            direction_forward_39 = 0;
        end

    2: begin 
            direction_forward_36 = 1;
            direction_forward_37 = (map_design[decision_4 + 1][38] == 1) ? 3 : 0;
            direction_forward_38 = 1;
            direction_forward_39 = 0;
        end

    3: begin 
            direction_forward_36 = 1;
            direction_forward_37 = (map_design[decision_4 + 1][38] == 1) ? 3 : 0;
            direction_forward_38 = 1;
            direction_forward_39 = 1;
        end
    default:begin
        direction_forward_36 = 0;
        direction_forward_37 = 0;
        direction_forward_38 = 0;
        direction_forward_39 = 0;
        end
    endcase
end 

always@(*)begin
    case(direction_6)
    -3: begin 
            direction_forward_44 = 2;
            direction_forward_45 = (map_design[decision_5 - 1][46] == 1) ? 3 : 0;
            direction_forward_46 = 2;
            direction_forward_47 = 2;
        end

    -2: begin 
            direction_forward_44 = 2;
            direction_forward_45 = (map_design[decision_5 - 1][46] == 1) ? 3 : 0;
            direction_forward_46 = 2;
            direction_forward_47 = 0;
        end

    -1: begin 
            direction_forward_44 = 2;
            direction_forward_45 = (map_design[decision_5 - 1][46] == 1) ? 3 : 0;
            direction_forward_46 = 0;
            direction_forward_47 = 0;
        end

    0: begin 
            direction_forward_44 = 0;
            direction_forward_45 = (map_design[decision_5][46] == 1) ? 3 : 0;
            direction_forward_46 = 0;
            direction_forward_47 = 0;
        end
    
    1: begin 
            direction_forward_44 = 1;
            direction_forward_45 = (map_design[decision_5 + 1][46] == 1) ? 3 : 0;
            direction_forward_46 = 0;
            direction_forward_47 = 0;
        end

    2: begin 
            direction_forward_44 = 1;
            direction_forward_45 = (map_design[decision_5 + 1][46] == 1) ? 3 : 0;
            direction_forward_46 = 1;
            direction_forward_47 = 0;
        end

    3: begin 
            direction_forward_44 = 1;
            direction_forward_45 = (map_design[decision_5 + 1][46] == 1) ? 3 : 0;
            direction_forward_46 = 1;
            direction_forward_47 = 1;
        end
    default:begin
        direction_forward_44 = 0;
        direction_forward_45 = 0;
        direction_forward_46 = 0;
        direction_forward_47 = 0;
        end
    endcase
end 

always@(*)begin
    case(direction_7)
    -3: begin 
            direction_forward_52 = 2;
            direction_forward_53 = (map_design[decision_6 - 1][54] == 1) ? 3 : 0;
            direction_forward_54 = 2;
            direction_forward_55 = 2;
        end

    -2: begin 
            direction_forward_52 = 2;
            direction_forward_53 = (map_design[decision_6 - 1][54] == 1) ? 3 : 0;
            direction_forward_54 = 2;
            direction_forward_55 = 0;
        end

    -1: begin 
            direction_forward_52 = 2;
            direction_forward_53 = (map_design[decision_6 - 1][54] == 1) ? 3 : 0;
            direction_forward_54 = 0;
            direction_forward_55 = 0;
        end

    0: begin 
            direction_forward_52 = 0;
            direction_forward_53 = (map_design[decision_6][54] == 1) ? 3 : 0;
            direction_forward_54 = 0;
            direction_forward_55 = 0;
        end
    
    1: begin 
            direction_forward_52 = 1;
            direction_forward_53 = (map_design[decision_6 + 1][54] == 1) ? 3 : 0;
            direction_forward_54 = 0;
            direction_forward_55 = 0;
        end

    2: begin 
            direction_forward_52 = 1;
            direction_forward_53 = (map_design[decision_6 + 1][54] == 1) ? 3 : 0;
            direction_forward_54 = 1;
            direction_forward_55 = 0;
        end

    3: begin 
            direction_forward_52 = 1;
            direction_forward_53 = (map_design[decision_6 + 1][54] == 1) ? 3 : 0;
            direction_forward_54 = 1;
            direction_forward_55 = 1;
        end
    default:begin
        direction_forward_52 = 0;
        direction_forward_53 = 0;
        direction_forward_54 = 0;
        direction_forward_55 = 0;
    end
    endcase
end 

//map 
always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        for(i = 0; i < 4; i = i + 1)begin
            for(j= 0; j < 64; j = j + 1)begin
                map_design[i][j] <= 0;
            end
        end
    end
    else begin
            case(NEXT)
                ZERO:begin
                    for(i = 0; i < 4; i = i + 1)begin
                        for(j= 0; j < 64; j = j + 1)begin
                            map_design[i][j] <= 0;
                        end
                    end
                end
                STORE_MAP:begin
                    map_design [0][cnt] <= in0;
                    map_design [1][cnt] <= in1;
                    map_design [2][cnt] <= in2;
                    map_design [3][cnt] <= in3;
                end
            endcase

    end
end

//FSM STATE
always@(*)begin
    case(STATE)
        ZERO:begin
            if(in_valid) NEXT = STORE_MAP;
            else NEXT = ZERO;
        end
        STORE_MAP:begin
            if(cnt >= 64) NEXT = SUSUME;
            else NEXT = STORE_MAP;
        end

        SUSUME:begin
            if(cnt == 0) NEXT = OUT;
            else NEXT = SUSUME;     
        end

        OUT:begin
            if(cnt >= 63) NEXT = ZERO;
            else NEXT = OUT;
        end
        default: NEXT = ZERO;
    endcase
end

//initial_position
always@(posedge clk or negedge rst_n)begin
    if(!rst_n) 
        initial_position_design <= 0;
    else begin
        case(NEXT)
            ZERO:initial_position_design <= 0;
            STORE_MAP:if(in_valid && STATE == 0)initial_position_design <= init;
                      else  initial_position_design <= initial_position_design;

        endcase
    end
end



always@(posedge clk or negedge rst_n)begin
    if(!rst_n) 
        cnt <= 0;
    else if(NEXT == ZERO) cnt <= 0;
    else if(NEXT == STORE_MAP) cnt <= cnt + 1;
    else if(NEXT == SUSUME) cnt <= 0;
    else if(NEXT == OUT) cnt <= cnt + 1;
    else cnt <= cnt;
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        out <= 0;
    else if(NEXT == OUT)
        out <= movement[cnt];
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

