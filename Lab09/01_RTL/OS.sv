module OS(input clk, INF.OS_inf inf);
import usertype::*;
//================================================================
// logic 
//================================================================
logic [3:0] count_5;

logic [31:0] check_buyer_out;
logic [31:0] check_seller_out;

logic [15:0] deposit_or_not;
logic [15:0] deposit_result;
logic [31:0] deposit_out;

logic [5:0] buyer_L_or_not;
logic [5:0] buyer_M_or_not;
logic [5:0] buyer_S_or_not;

logic [15:0] seller_money_enough;
logic buyer_item_full;
logic seller_item_not_enough;
logic buyer_money_not_enough;
logic return_seller_wrong;
logic return_item_wrong;
logic return_item_num_wrong;
logic return_wrong_act_other;
logic return_wrong_buyer;

logic buy_unsuccess;
logic buy_success;
logic check_success;
logic deposit_success;
logic return_success;
logic return_unsuccess;
logic up_level_flag;
logic fee_not_enough;
logic [31:0] buy_out;
logic [31:0] return_out;
logic [7:0] count_invalid;

logic [1:0]other_operations_user [0:255];
logic [1:0]other_operations_seller [0:255];
logic [8:0] buyer_seller [0:255];
logic [1:0]reg_check;

Item_num   a_buyer_L_items;
Item_num   a_buyer_M_items;
Item_num   a_buyer_S_items;
Money      a_buyer_money , a_buyer_money_deal;
logic [12:0]       a_buyer_exp;
EXP  a_buyer_exp_deal;
User_Level a_buyer_level;
Item_id    a_buyer_item_id_history;
Item_num   a_buyer_item_num_history;
User_id    a_buyer_seller_id_history;

Money a_deposit_money;
Money total_cost;
Money buy_cost;
Money fee_cost;

Item_num   a_seller_L_items;
Item_num   a_seller_M_items;
Item_num   a_seller_S_items;
Money      a_seller_money;


User_id reg_ID_buyer;
User_id reg_ID_seller;
Money reg_money;
Item_num_ext  reg_num;
Action  reg_action;
Item_id reg_item_ID;
Total_info reg_buyer_info;
Total_info reg_seller_info;

Item_num   buyer_L_items;
Item_num   buyer_M_items;
Item_num   buyer_S_items;
User_Level buyer_level;
EXP        buyer_exp;
Money      buyer_money;
Item_id    buyer_item_id_history;
Item_num   buyer_item_num_history;
User_id    buyer_seller_id_history;

Item_num   seller_L_items;
Item_num   seller_M_items;
Item_num   seller_S_items;
User_Level seller_level;
EXP        seller_exp;
Money      seller_money;
Item_id    seller_item_id_history;
Item_num   seller_item_num_history;
User_id    seller_seller_id_history;

//================================================================
// FSM 
//================================================================
integer i;
genvar k;
typedef enum logic  [5:0] { ZERO,	
                            ACTION_CHOOSE,
                            ITEM_CHOOSE,	
                            ITEM_NUMBER_CHOOSE,
                            SELLER_ID,
                            DEPOSIT_BUYER,
                            CHECK_SELLER,
                            CHECK_BUYER,	
                            DRAM_BUYER_READ,
                            DRAM_SELLER_READ,
                            COMPUTE,
                            DRAM_BUYER_STORE,
                            DRAM_SELLER_STORE,
                            OUT
} fsm_state;
fsm_state STATE, NEXT;
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
    case(STATE)
        ZERO:begin
            if(inf.act_valid) NEXT = ACTION_CHOOSE;
            else NEXT = ZERO;
        end

        ACTION_CHOOSE:begin
            if(inf.item_valid) NEXT = ITEM_CHOOSE; // Buy & Return
            else if(reg_action == Check && inf.id_valid) NEXT = CHECK_SELLER; // Check seller
            else if(reg_action == Check && count_5 >= 5) NEXT = CHECK_BUYER; // Check buyer
            else if(reg_action == Deposit && inf.amnt_valid) NEXT = DEPOSIT_BUYER; //Deposit
            else NEXT = ACTION_CHOOSE;
        end

        ITEM_CHOOSE:begin
            if(inf.num_valid) NEXT = ITEM_NUMBER_CHOOSE;
            else NEXT = ITEM_CHOOSE;
        end

        ITEM_NUMBER_CHOOSE:begin
            if(inf.id_valid) NEXT = SELLER_ID;
            else NEXT = ITEM_NUMBER_CHOOSE;
        end

        SELLER_ID:begin
            if(!inf.id_valid) NEXT = DRAM_BUYER_READ;
            else NEXT = SELLER_ID;
        end

        DEPOSIT_BUYER:begin
            NEXT = DRAM_BUYER_READ;
        end

//---------------------------------------------------------------------------------------------------------------------------------

        // READ_DRAM
        DRAM_BUYER_READ:begin 
            if(inf.C_out_valid && reg_action == Deposit) NEXT = COMPUTE;
            else if(inf.C_out_valid ) NEXT = DRAM_SELLER_READ;
            else NEXT = DRAM_BUYER_READ;
        end

        // READ_DRAM
        DRAM_SELLER_READ:begin
            if(inf.C_out_valid) NEXT = COMPUTE;
            else NEXT = DRAM_SELLER_READ;
        end

        COMPUTE:begin
            NEXT = DRAM_BUYER_STORE;
        end

        // STORE_DRAM
        DRAM_BUYER_STORE:begin
            if(inf.C_out_valid && reg_action == Deposit) NEXT = OUT;
            else if(inf.C_out_valid) NEXT = DRAM_SELLER_STORE;
            else NEXT = DRAM_BUYER_STORE;
        end

        // STORE_DRAM
        DRAM_SELLER_STORE:begin
            if(inf.C_out_valid) NEXT = OUT;
            else NEXT = DRAM_SELLER_STORE;
        end

        CHECK_SELLER:begin
            if(inf.C_out_valid) NEXT = OUT;
            else NEXT = CHECK_SELLER;
        end

        CHECK_BUYER:begin
            if(inf.C_out_valid) NEXT = OUT;
            else NEXT = CHECK_BUYER;
        end

        OUT:begin
            NEXT = ZERO;
        end
        
    default : NEXT = STATE;
    endcase
end

always_ff@(posedge clk or negedge inf.rst_n)begin
    if(!inf.rst_n)
        reg_ID_buyer <= 0;
    else if(inf.id_valid && STATE == ZERO)
        reg_ID_buyer <= inf.D.d_id[0];
    else 
        reg_ID_buyer <= reg_ID_buyer;
end

//bits problem
//assign buyer_addr = reg_ID_buyer << 3  + 'h10000;

always_ff@(posedge clk or negedge inf.rst_n)begin
    if(!inf.rst_n)
        reg_ID_seller <= 0;
    else if(inf.id_valid && (NEXT == SELLER_ID || NEXT == CHECK_SELLER))
        reg_ID_seller <= inf.D.d_id[0];
    else 
        reg_ID_seller <= reg_ID_seller;
end

//bits problem
//assign seller_addr = reg_ID_seller << 3  + 'h10000;

always_ff@(posedge clk or negedge inf.rst_n)begin
    if(!inf.rst_n)
        reg_action <= 0;
    else if(inf.act_valid && NEXT == ACTION_CHOOSE)
        reg_action <= inf.D.d_act[0];
    else 
        reg_action <= reg_action;
end

always_ff@(posedge clk or negedge inf.rst_n)begin
    if(!inf.rst_n)
        reg_money <= 0;
    else if(inf.amnt_valid && NEXT == DEPOSIT_BUYER)
        reg_money <= inf.D.d_money;
    else 
        reg_money <= reg_money;
end

always_ff@(posedge clk or negedge inf.rst_n)begin
    if(!inf.rst_n)
        reg_item_ID <= 0;
    else if(inf.item_valid && NEXT == ITEM_CHOOSE)
        reg_item_ID <= inf.D.d_item[0];
    else 
        reg_item_ID <= reg_item_ID;
end

always_ff@(posedge clk or negedge inf.rst_n)begin
    if(!inf.rst_n)
        reg_num <= 0;
    else if(inf.num_valid && NEXT == ITEM_NUMBER_CHOOSE)
        reg_num <= inf.D.d_item_num;
    else 
        reg_num <= reg_num;
end

always_ff@(posedge clk or negedge inf.rst_n)begin
    if(!inf.rst_n)
        count_5 <= 0;
    else if(STATE == ACTION_CHOOSE)
        count_5 <= count_5 + 1;
    else 
        count_5 <= 0;
end

always_comb begin
    if(reg_action == Buy || reg_action == Return)begin  
        if(STATE == DRAM_BUYER_READ || STATE == DRAM_BUYER_STORE) 
            inf.C_addr = reg_ID_buyer;
        else if(STATE == DRAM_SELLER_READ || STATE == DRAM_SELLER_STORE || STATE == COMPUTE)
            inf.C_addr = reg_ID_seller;
        else 
            inf.C_addr = 0;
    end
    else if(reg_action == Deposit)begin
        if(STATE == DRAM_BUYER_READ || STATE == DRAM_BUYER_STORE || STATE == COMPUTE) 
            inf.C_addr = reg_ID_buyer;
        else if(STATE == DRAM_SELLER_READ || STATE == DRAM_SELLER_STORE)
            inf.C_addr = reg_ID_seller;
        else 
            inf.C_addr = 0;
    end
    else if(reg_action == Check)begin
        if(STATE == CHECK_BUYER)
            inf.C_addr = reg_ID_buyer;
        else if(STATE == CHECK_SELLER)
            inf.C_addr = reg_ID_seller;
        else 
            inf.C_addr = 0;
    end
    else 
        inf.C_addr = 0;
end

always_comb begin
    if(STATE == DRAM_BUYER_STORE)begin
        case(reg_action)
            Buy:inf.C_data_w = {a_buyer_L_items , a_buyer_M_items , a_buyer_S_items , a_buyer_level , a_buyer_exp_deal , a_buyer_money_deal , a_buyer_item_id_history , a_buyer_item_num_history , a_buyer_seller_id_history};
            Deposit:inf.C_data_w = {buyer_L_items , buyer_M_items , buyer_S_items , buyer_level ,buyer_exp,a_deposit_money,buyer_item_id_history, buyer_item_num_history ,buyer_seller_id_history};
            Return:inf.C_data_w = (return_unsuccess) ? reg_buyer_info : {a_buyer_L_items , a_buyer_M_items , a_buyer_S_items , buyer_level , buyer_exp , a_buyer_money , buyer_item_id_history , buyer_item_num_history , buyer_seller_id_history};
            default:inf.C_data_w = 0;
        endcase
    end
    else if(STATE == DRAM_SELLER_STORE)begin
        case(reg_action)
            Buy:inf.C_data_w = {a_seller_L_items , a_seller_M_items , a_seller_S_items , seller_level , seller_exp , a_seller_money , seller_item_id_history , seller_item_num_history , seller_seller_id_history};
            Deposit:inf.C_data_w = 0;
            Return:inf.C_data_w = (return_unsuccess) ? reg_seller_info : {a_seller_L_items , a_seller_M_items , a_seller_S_items , seller_level , seller_exp , a_seller_money , seller_item_id_history , seller_item_num_history , seller_seller_id_history};
            default:inf.C_data_w = 0;
        endcase
    end
    else 
        inf.C_data_w = 0;
end

always_comb begin
    if((STATE == DRAM_BUYER_READ  || STATE == DRAM_SELLER_READ  || STATE == DRAM_SELLER_STORE || STATE == DRAM_BUYER_STORE || STATE == CHECK_SELLER || STATE == CHECK_BUYER) && count_invalid == 1) 
        inf.C_in_valid = 1;
    else 
        inf.C_in_valid = 0;
end

always_ff@(posedge clk or negedge inf.rst_n)begin
    if(!inf.rst_n)
        count_invalid <= 0;
    else if(inf.C_out_valid == 1) count_invalid <= 0;
    else if((NEXT == DRAM_BUYER_READ ) || (NEXT == DRAM_SELLER_READ ) || (NEXT == DRAM_SELLER_STORE ) || (NEXT == DRAM_BUYER_STORE) || NEXT == CHECK_SELLER || NEXT == CHECK_BUYER )
        count_invalid <= count_invalid + 1;
    else 
        count_invalid <= 0;
end


always_comb begin
    if((STATE == DRAM_BUYER_READ ) || (STATE == DRAM_SELLER_READ )) 
        inf.C_r_wb = 1;
    else if((STATE == DRAM_SELLER_STORE ) || (STATE == DRAM_BUYER_STORE))
        inf.C_r_wb = 0;
    else if(STATE == ZERO)
        inf.C_r_wb = 0;
    else 
        inf.C_r_wb = 1;
end


always_ff@(posedge clk or negedge inf.rst_n)begin
    if(!inf.rst_n)
        reg_buyer_info <= 0;
    else if(inf.C_out_valid && (STATE == DRAM_BUYER_READ || STATE == CHECK_BUYER))
        reg_buyer_info <= inf.C_data_r;
    else 
        reg_buyer_info <= reg_buyer_info;
end

always_ff@(posedge clk or negedge inf.rst_n)begin
    if(!inf.rst_n)
        reg_seller_info <= 0;
    else if(inf.C_out_valid && (STATE == DRAM_SELLER_READ || STATE == CHECK_SELLER))
        reg_seller_info <= inf.C_data_r;
    else 
        reg_seller_info <= reg_seller_info;
end

assign buyer_L_items = reg_buyer_info.shop_info.large_num;
assign buyer_M_items = reg_buyer_info.shop_info.medium_num;
assign buyer_S_items = reg_buyer_info.shop_info.small_num;
assign buyer_level = reg_buyer_info.shop_info.level;
assign buyer_exp = reg_buyer_info.shop_info.exp;
assign buyer_money = reg_buyer_info.user_info.money;
assign buyer_item_id_history = reg_buyer_info.user_info.shop_history.item_ID;
assign buyer_item_num_history = reg_buyer_info.user_info.shop_history.item_num;
assign buyer_seller_id_history = reg_buyer_info.user_info.shop_history.seller_ID;

assign seller_L_items = reg_seller_info.shop_info.large_num;
assign seller_M_items = reg_seller_info.shop_info.medium_num;
assign seller_S_items = reg_seller_info.shop_info.small_num;
assign seller_level = reg_seller_info.shop_info.level;
assign seller_exp = reg_seller_info.shop_info.exp;
assign seller_money = reg_seller_info.user_info.money;
assign seller_item_id_history = reg_seller_info.user_info.shop_history.item_ID;
assign seller_item_num_history = reg_seller_info.user_info.shop_history.item_num;
assign seller_seller_id_history = reg_seller_info.user_info.shop_history.seller_ID;

//Buy_case01
always_comb begin
    if(reg_action == Buy && reg_item_ID == 2'b01 && buy_unsuccess == 0) begin
        a_buyer_L_items = buyer_L_items + reg_num;
    end
    else if(reg_action == Return && reg_item_ID == 2'b01 && return_unsuccess == 0) begin
        a_buyer_L_items = buyer_L_items - reg_num;
    end
    else begin
        a_buyer_L_items = buyer_L_items;
    end
end

always_comb begin
    if(reg_action == Buy && reg_item_ID == 2'b01 && buy_unsuccess == 0) begin
        a_seller_L_items = seller_L_items - reg_num;
    end
    else if(reg_action == Return && reg_item_ID == 2'b01 && return_unsuccess == 0) begin
        a_seller_L_items = seller_L_items + reg_num;
    end
    else begin
        a_seller_L_items = seller_L_items;
    end
end

always_comb begin
    if(reg_action == Buy && reg_item_ID == 2'b10 && buy_unsuccess == 0) begin
        a_buyer_M_items = buyer_M_items + reg_num;
    end
    else if(reg_action == Return && reg_item_ID == 2'b10 && return_unsuccess == 0) begin
        a_buyer_M_items = buyer_M_items - reg_num;
    end
    else begin
        a_buyer_M_items = buyer_M_items;
    end
end

always_comb begin
    if(reg_action == Buy && reg_item_ID == 2'b10 && buy_unsuccess == 0) begin
        a_seller_M_items = seller_M_items - reg_num;
    end
    else if(reg_action == Return && reg_item_ID == 2'b10 && return_unsuccess == 0) begin
        a_seller_M_items = seller_M_items + reg_num;
    end
    else begin
        a_seller_M_items = seller_M_items;
    end
end

always_comb begin
    if(reg_action == Buy && reg_item_ID == 2'b11 && buy_unsuccess == 0) begin
        a_buyer_S_items = buyer_S_items + reg_num;
    end
    else if(reg_action == Return && reg_item_ID == 2'b11 && return_unsuccess == 0) begin
        a_buyer_S_items = buyer_S_items - reg_num;
    end
    else begin
        a_buyer_S_items = buyer_S_items;
    end
end

always_comb begin
    if(reg_action == Buy && reg_item_ID == 2'b11 && buy_unsuccess == 0) begin
        a_seller_S_items = seller_S_items - reg_num;
    end
    else if(reg_action == Return && reg_item_ID == 2'b11 && return_unsuccess == 0) begin
        a_seller_S_items = seller_S_items + reg_num;
    end
    else begin
        a_seller_S_items = seller_S_items;
    end
end

assign a_buyer_item_id_history = (buy_unsuccess == 0 && reg_action == Buy) ? reg_item_ID : buyer_item_id_history;
assign a_buyer_item_num_history = (buy_unsuccess == 0 && reg_action == Buy) ? reg_num : buyer_item_num_history;
assign a_buyer_seller_id_history = (buy_unsuccess == 0 && reg_action == Buy) ? reg_ID_seller : buyer_seller_id_history;


always_comb begin
   if(reg_action == Buy && buy_unsuccess == 0) begin
        case(reg_item_ID)
            2'b01:a_buyer_money = buyer_money - reg_num *'d300;
            2'b10:a_buyer_money = buyer_money - reg_num *'d200;
            2'b11:a_buyer_money = buyer_money - reg_num *'d100;
            default:a_buyer_money = buyer_money;
        endcase
   end
   else if(reg_action == Return && return_unsuccess == 0) begin
        case(reg_item_ID)
            2'b01:a_buyer_money = buyer_money + reg_num *'d300;
            2'b10:a_buyer_money = buyer_money + reg_num *'d200;
            2'b11:a_buyer_money = buyer_money + reg_num *'d100;
            default:a_buyer_money = buyer_money;
        endcase
   end
   else a_buyer_money = buyer_money;
end

always_comb begin
   if(buy_unsuccess == 0) begin
        case(buyer_level)
            2'b00:a_buyer_money_deal = a_buyer_money - 'd10;
            2'b01:a_buyer_money_deal = a_buyer_money - 'd30;
            2'b10:a_buyer_money_deal = a_buyer_money - 'd50;
            default:a_buyer_money_deal = a_buyer_money - 'd70;
        endcase
   end
   else a_buyer_money_deal = a_buyer_money;
end



//Buy_case03
always_comb begin
    if(buy_unsuccess == 0) begin
        case(reg_item_ID)
            2'b01:a_buyer_exp = buyer_exp + reg_num *'d60;
            2'b10:a_buyer_exp = buyer_exp + reg_num *'d40;
            2'b11:a_buyer_exp = buyer_exp + reg_num *'d20;
            default:a_buyer_exp = buyer_exp;
        endcase
    end
    else a_buyer_exp = buyer_exp;
end

always_comb begin
    case(buyer_level)
            Platinum: a_buyer_exp_deal = 0;
            Gold:     a_buyer_exp_deal = (a_buyer_exp >= 4000) ? 0 : a_buyer_exp;
            Silver:   a_buyer_exp_deal = (a_buyer_exp >= 2500) ? 0 : a_buyer_exp;
        default:      a_buyer_exp_deal = (a_buyer_exp >= 1000) ? 0 : a_buyer_exp;
    endcase
end

always_comb begin
    case(buyer_level)
            Platinum: up_level_flag = 0;
            Gold:     up_level_flag = (a_buyer_exp >= 4000) ? 1 : 0;
            Silver:   up_level_flag = (a_buyer_exp >= 2500) ? 1 : 0;
        default:      up_level_flag = (a_buyer_exp >= 1000) ? 1 : 0;
    endcase
end

always_comb begin
    case(buyer_level)
            Platinum: a_buyer_level = Platinum;
            Gold:     a_buyer_level = (a_buyer_exp_deal == 0 && up_level_flag == 1 && buy_unsuccess == 0) ? Platinum : Gold;
            Silver:   a_buyer_level = (a_buyer_exp_deal == 0 && up_level_flag == 1 && buy_unsuccess == 0) ? Gold : Silver;
        default:      a_buyer_level = (a_buyer_exp_deal == 0 && up_level_flag == 1 && buy_unsuccess == 0) ? Silver : Copper;
    endcase
end

//Buy_case02
assign seller_money_enough = 65535 - seller_money;

always_comb begin
    if(reg_action == Buy && buy_unsuccess == 0) begin
        case(reg_item_ID)
            2'b01:a_seller_money = (reg_num *'d300 >= seller_money_enough) ? 65535 : seller_money + reg_num *'d300;
            2'b10:a_seller_money = (reg_num *'d200 >= seller_money_enough) ? 65535 : seller_money + reg_num *'d200;
            2'b11:a_seller_money = (reg_num *'d100 >= seller_money_enough) ? 65535 : seller_money + reg_num *'d100;
            default:a_seller_money = seller_money;
        endcase
    end
    else if(reg_action == Return && return_unsuccess == 0) begin
        case(reg_item_ID)
            2'b01:a_seller_money =  seller_money - reg_num *'d300;
            2'b10:a_seller_money =  seller_money - reg_num *'d200;
            2'b11:a_seller_money =  seller_money - reg_num *'d100;
            default:a_seller_money = seller_money;
        endcase
    end
    else a_seller_money = seller_money;
end

assign buyer_L_or_not = 63 - buyer_L_items;
assign buyer_M_or_not = 63 - buyer_M_items;
assign buyer_S_or_not = 63 - buyer_S_items;

//Buy_case08
always_comb begin
    case(reg_item_ID)
        2'b01:buyer_item_full = (reg_num > buyer_L_or_not) ? 1 : 0;
        2'b10:buyer_item_full = (reg_num > buyer_M_or_not) ? 1 : 0;
        2'b11:buyer_item_full = (reg_num > buyer_S_or_not) ? 1 : 0;
        default:buyer_item_full = 0;
    endcase
end

//Buy_case09
always_comb begin
    case(reg_item_ID)
        2'b01:seller_item_not_enough = (reg_num > seller_L_items) ? 1 : 0;
        2'b10:seller_item_not_enough = (reg_num > seller_M_items) ? 1 : 0;
        2'b11:seller_item_not_enough = (reg_num > seller_S_items) ? 1 : 0;
        default:seller_item_not_enough = 0;
    endcase
end

//Buy_case10
always_comb begin
    case(reg_item_ID)
        2'b01:buyer_money_not_enough = ((reg_num *'d300 > buyer_money) || (a_buyer_money == 0)) ? 1 : 0;
        2'b10:buyer_money_not_enough = ((reg_num *'d200 > buyer_money) || (a_buyer_money == 0)) ? 1 : 0;
        2'b11:buyer_money_not_enough = ((reg_num *'d100 > buyer_money) || (a_buyer_money == 0)) ? 1 : 0;
        default:buyer_money_not_enough = 0;
    endcase
end

always_comb begin
    case(reg_item_ID)
        2'b01:buy_cost = reg_num * 'd300;
        2'b10:buy_cost = reg_num * 'd200;
        2'b11:buy_cost = reg_num * 'd100;
        default:buy_cost = 0;
    endcase
end

always_comb begin
    case(buyer_level)
        2'b01:fee_cost = 'd30;
        2'b10:fee_cost = 'd50;
        2'b11:fee_cost = 'd70;
        default:fee_cost = 'd10;
    endcase
end

assign total_cost = fee_cost + buy_cost;

assign fee_not_enough = (total_cost > buyer_money ) ? 1:0;

assign buy_unsuccess = (reg_action == 4'b0001 && (buyer_item_full == 1 || seller_item_not_enough == 1 || buyer_money_not_enough == 1 || fee_not_enough == 1)) ? 1 : 0; 

always_comb begin
    if(buy_unsuccess == 0)
        buy_out = {a_buyer_money_deal , a_buyer_item_id_history , a_buyer_item_num_history , a_buyer_seller_id_history};
    else
        buy_out = 0;
end

generate   
    for(k = 0; k < 256; k = k + 1)begin
        always_ff@(posedge clk or negedge inf.rst_n)begin
            if(!inf.rst_n) begin
                other_operations_user [k] <= 0;
            end
            else begin
                if(inf.complete && reg_action == Buy && reg_ID_buyer == k)
                    other_operations_user [k] <= 1;
                else if(inf.complete && reg_action == Check && reg_ID_buyer == k)
                    other_operations_user [k] <= 0;
                else if(inf.complete && reg_action == Check && reg_check == 2 && reg_ID_seller == k)
                    other_operations_user [k] <= 0;
                else if(inf.complete && reg_action == Deposit && reg_ID_buyer == k)
                    other_operations_user [k] <= 0;
                else if(inf.complete && reg_action == Return && reg_ID_buyer == k)
                    other_operations_user [k] <= 0;
                else if(inf.complete && reg_action == Buy && reg_ID_seller == k)
                    other_operations_user [k] <= 0;
                else 
                    other_operations_user [k] <= other_operations_user [k];
            end
        end
    end
endgenerate

generate   
    for(k = 0; k < 256; k = k + 1)begin
        always_ff@(posedge clk or negedge inf.rst_n)begin
            if(!inf.rst_n) begin
                other_operations_seller [k] <= 0;
            end
            else begin
                if(inf.complete && reg_action == Buy && reg_ID_seller == k)
                    other_operations_seller [k] <= 1;
                else if(inf.complete && reg_action == Check && reg_check == 2 && reg_ID_seller == k)
                    other_operations_seller [k] <= 0;
                else if(inf.complete && reg_action == Return && reg_ID_seller == k)
                    other_operations_seller [k] <= 0;
                else if(inf.complete && reg_action == Buy && reg_ID_buyer == k)
                    other_operations_seller [k] <= 0;
                else if(inf.complete && reg_action == Check && reg_ID_buyer == k)
                    other_operations_seller [k] <= 0;
                else if(inf.complete && reg_action == Deposit && reg_ID_buyer == k)
                    other_operations_seller [k] <= 0;
                else 
                    other_operations_seller [k] <= other_operations_seller [k];
            end
        end
    end
endgenerate

always_ff@(posedge clk or negedge inf.rst_n)begin
    if(!inf.rst_n) begin
        for(i = 0; i < 256; i = i + 1) begin
                buyer_seller [i] <= 0;
        end
    end
    else begin 
        if(buy_success == 1)begin
            case(reg_ID_seller)
                0:buyer_seller[0] <= reg_ID_buyer;
                1:buyer_seller[1] <= reg_ID_buyer;
                2:buyer_seller[2] <= reg_ID_buyer;
                3:buyer_seller[3] <= reg_ID_buyer;
                4:buyer_seller[4] <= reg_ID_buyer;
                5:buyer_seller[5] <= reg_ID_buyer;
                6:buyer_seller[6] <= reg_ID_buyer;
                7:buyer_seller[7] <= reg_ID_buyer;
                8:buyer_seller[8] <= reg_ID_buyer;
                9:buyer_seller[9] <= reg_ID_buyer;

                10:buyer_seller[10] <= reg_ID_buyer;
                11:buyer_seller[11] <= reg_ID_buyer;
                12:buyer_seller[12] <= reg_ID_buyer;
                13:buyer_seller[13] <= reg_ID_buyer;
                14:buyer_seller[14] <= reg_ID_buyer;
                15:buyer_seller[15] <= reg_ID_buyer;
                16:buyer_seller[16] <= reg_ID_buyer;
                17:buyer_seller[17] <= reg_ID_buyer;
                18:buyer_seller[18] <= reg_ID_buyer;
                19:buyer_seller[19] <= reg_ID_buyer;

                20:buyer_seller[20] <= reg_ID_buyer;
                21:buyer_seller[21] <= reg_ID_buyer;
                22:buyer_seller[22] <= reg_ID_buyer;
                23:buyer_seller[23] <= reg_ID_buyer;
                24:buyer_seller[24] <= reg_ID_buyer;
                25:buyer_seller[25] <= reg_ID_buyer;
                26:buyer_seller[26] <= reg_ID_buyer;
                27:buyer_seller[27] <= reg_ID_buyer;
                28:buyer_seller[28] <= reg_ID_buyer;
                29:buyer_seller[29] <= reg_ID_buyer;

                30:buyer_seller[30] <= reg_ID_buyer;
                31:buyer_seller[31] <= reg_ID_buyer;
                32:buyer_seller[32] <= reg_ID_buyer;
                33:buyer_seller[33] <= reg_ID_buyer;
                34:buyer_seller[34] <= reg_ID_buyer;
                35:buyer_seller[35] <= reg_ID_buyer;
                36:buyer_seller[36] <= reg_ID_buyer;
                37:buyer_seller[37] <= reg_ID_buyer;
                38:buyer_seller[38] <= reg_ID_buyer;
                39:buyer_seller[39] <= reg_ID_buyer;

                40:buyer_seller[40] <= reg_ID_buyer;
                41:buyer_seller[41] <= reg_ID_buyer;
                42:buyer_seller[42] <= reg_ID_buyer;
                43:buyer_seller[43] <= reg_ID_buyer;
                44:buyer_seller[44] <= reg_ID_buyer;
                45:buyer_seller[45] <= reg_ID_buyer;
                46:buyer_seller[46] <= reg_ID_buyer;
                47:buyer_seller[47] <= reg_ID_buyer;
                48:buyer_seller[48] <= reg_ID_buyer;
                49:buyer_seller[49] <= reg_ID_buyer;

                50:buyer_seller[50] <= reg_ID_buyer;
                51:buyer_seller[51] <= reg_ID_buyer;
                52:buyer_seller[52] <= reg_ID_buyer;
                53:buyer_seller[53] <= reg_ID_buyer;
                54:buyer_seller[54] <= reg_ID_buyer;
                55:buyer_seller[55] <= reg_ID_buyer;
                56:buyer_seller[56] <= reg_ID_buyer;
                57:buyer_seller[57] <= reg_ID_buyer;
                58:buyer_seller[58] <= reg_ID_buyer;
                59:buyer_seller[59] <= reg_ID_buyer;

                60:buyer_seller[60] <= reg_ID_buyer;
                61:buyer_seller[61] <= reg_ID_buyer;
                62:buyer_seller[62] <= reg_ID_buyer;
                63:buyer_seller[63] <= reg_ID_buyer;
                64:buyer_seller[64] <= reg_ID_buyer;
                65:buyer_seller[65] <= reg_ID_buyer;
                66:buyer_seller[66] <= reg_ID_buyer;
                67:buyer_seller[67] <= reg_ID_buyer;
                68:buyer_seller[68] <= reg_ID_buyer;
                69:buyer_seller[69] <= reg_ID_buyer;

                70:buyer_seller[70] <= reg_ID_buyer;
                71:buyer_seller[71] <= reg_ID_buyer;
                72:buyer_seller[72] <= reg_ID_buyer;
                73:buyer_seller[73] <= reg_ID_buyer;
                74:buyer_seller[74] <= reg_ID_buyer;
                75:buyer_seller[75] <= reg_ID_buyer;
                76:buyer_seller[76] <= reg_ID_buyer;
                77:buyer_seller[77] <= reg_ID_buyer;
                78:buyer_seller[78] <= reg_ID_buyer;
                79:buyer_seller[79] <= reg_ID_buyer;

                80:buyer_seller[80] <= reg_ID_buyer;
                81:buyer_seller[81] <= reg_ID_buyer;
                82:buyer_seller[82] <= reg_ID_buyer;
                83:buyer_seller[83] <= reg_ID_buyer;
                84:buyer_seller[84] <= reg_ID_buyer;
                85:buyer_seller[85] <= reg_ID_buyer;
                86:buyer_seller[86] <= reg_ID_buyer;
                87:buyer_seller[87] <= reg_ID_buyer;
                88:buyer_seller[88] <= reg_ID_buyer;
                89:buyer_seller[89] <= reg_ID_buyer;

                90:buyer_seller[90] <= reg_ID_buyer;
                91:buyer_seller[91] <= reg_ID_buyer;
                92:buyer_seller[92] <= reg_ID_buyer;
                93:buyer_seller[93] <= reg_ID_buyer;
                94:buyer_seller[94] <= reg_ID_buyer;
                95:buyer_seller[95] <= reg_ID_buyer;
                96:buyer_seller[96] <= reg_ID_buyer;
                97:buyer_seller[97] <= reg_ID_buyer;
                98:buyer_seller[98] <= reg_ID_buyer;
                99:buyer_seller[99] <= reg_ID_buyer;

                100:buyer_seller[100] <= reg_ID_buyer;
                101:buyer_seller[101] <= reg_ID_buyer;
                102:buyer_seller[102] <= reg_ID_buyer;
                103:buyer_seller[103] <= reg_ID_buyer;
                104:buyer_seller[104] <= reg_ID_buyer;
                105:buyer_seller[105] <= reg_ID_buyer;
                106:buyer_seller[106] <= reg_ID_buyer;
                107:buyer_seller[107] <= reg_ID_buyer;
                108:buyer_seller[108] <= reg_ID_buyer;
                109:buyer_seller[109] <= reg_ID_buyer;

                110:buyer_seller[110] <= reg_ID_buyer;
                111:buyer_seller[111] <= reg_ID_buyer;
                112:buyer_seller[112] <= reg_ID_buyer;
                113:buyer_seller[113] <= reg_ID_buyer;
                114:buyer_seller[114] <= reg_ID_buyer;
                115:buyer_seller[115] <= reg_ID_buyer;
                116:buyer_seller[116] <= reg_ID_buyer;
                117:buyer_seller[117] <= reg_ID_buyer;
                118:buyer_seller[118] <= reg_ID_buyer;
                119:buyer_seller[119] <= reg_ID_buyer;

                120:buyer_seller[120] <= reg_ID_buyer;
                121:buyer_seller[121] <= reg_ID_buyer;
                122:buyer_seller[122] <= reg_ID_buyer;
                123:buyer_seller[123] <= reg_ID_buyer;
                124:buyer_seller[124] <= reg_ID_buyer;
                125:buyer_seller[125] <= reg_ID_buyer;
                126:buyer_seller[126] <= reg_ID_buyer;
                127:buyer_seller[127] <= reg_ID_buyer;
                128:buyer_seller[128] <= reg_ID_buyer;
                129:buyer_seller[129] <= reg_ID_buyer;

                130:buyer_seller[130] <= reg_ID_buyer;
                131:buyer_seller[131] <= reg_ID_buyer;
                132:buyer_seller[132] <= reg_ID_buyer;
                133:buyer_seller[133] <= reg_ID_buyer;
                134:buyer_seller[134] <= reg_ID_buyer;
                135:buyer_seller[135] <= reg_ID_buyer;
                136:buyer_seller[136] <= reg_ID_buyer;
                137:buyer_seller[137] <= reg_ID_buyer;
                138:buyer_seller[138] <= reg_ID_buyer;
                139:buyer_seller[139] <= reg_ID_buyer;

                140:buyer_seller[140] <= reg_ID_buyer;
                141:buyer_seller[141] <= reg_ID_buyer;
                142:buyer_seller[142] <= reg_ID_buyer;
                143:buyer_seller[143] <= reg_ID_buyer;
                144:buyer_seller[144] <= reg_ID_buyer;
                145:buyer_seller[145] <= reg_ID_buyer;
                146:buyer_seller[146] <= reg_ID_buyer;
                147:buyer_seller[147] <= reg_ID_buyer;
                148:buyer_seller[148] <= reg_ID_buyer;
                149:buyer_seller[149] <= reg_ID_buyer;

                150:buyer_seller[150] <= reg_ID_buyer;
                151:buyer_seller[151] <= reg_ID_buyer;
                152:buyer_seller[152] <= reg_ID_buyer;
                153:buyer_seller[153] <= reg_ID_buyer;
                154:buyer_seller[154] <= reg_ID_buyer;
                155:buyer_seller[155] <= reg_ID_buyer;
                156:buyer_seller[156] <= reg_ID_buyer;
                157:buyer_seller[157] <= reg_ID_buyer;
                158:buyer_seller[158] <= reg_ID_buyer;
                159:buyer_seller[159] <= reg_ID_buyer;

                160:buyer_seller[160] <= reg_ID_buyer;
                161:buyer_seller[161] <= reg_ID_buyer;
                162:buyer_seller[162] <= reg_ID_buyer;
                163:buyer_seller[163] <= reg_ID_buyer;
                164:buyer_seller[164] <= reg_ID_buyer;
                165:buyer_seller[165] <= reg_ID_buyer;
                166:buyer_seller[166] <= reg_ID_buyer;
                167:buyer_seller[167] <= reg_ID_buyer;
                168:buyer_seller[168] <= reg_ID_buyer;
                169:buyer_seller[169] <= reg_ID_buyer;

                170:buyer_seller[170] <= reg_ID_buyer;
                171:buyer_seller[171] <= reg_ID_buyer;
                172:buyer_seller[172] <= reg_ID_buyer;
                173:buyer_seller[173] <= reg_ID_buyer;
                174:buyer_seller[174] <= reg_ID_buyer;
                175:buyer_seller[175] <= reg_ID_buyer;
                176:buyer_seller[176] <= reg_ID_buyer;
                177:buyer_seller[177] <= reg_ID_buyer;
                178:buyer_seller[178] <= reg_ID_buyer;
                179:buyer_seller[179] <= reg_ID_buyer;

                180:buyer_seller[180] <= reg_ID_buyer;
                181:buyer_seller[181] <= reg_ID_buyer;
                182:buyer_seller[182] <= reg_ID_buyer;
                183:buyer_seller[183] <= reg_ID_buyer;
                184:buyer_seller[184] <= reg_ID_buyer;
                185:buyer_seller[185] <= reg_ID_buyer;
                186:buyer_seller[186] <= reg_ID_buyer;
                187:buyer_seller[187] <= reg_ID_buyer;
                188:buyer_seller[188] <= reg_ID_buyer;
                189:buyer_seller[189] <= reg_ID_buyer;

                190:buyer_seller[190] <= reg_ID_buyer;
                191:buyer_seller[191] <= reg_ID_buyer;
                192:buyer_seller[192] <= reg_ID_buyer;
                193:buyer_seller[193] <= reg_ID_buyer;
                194:buyer_seller[194] <= reg_ID_buyer;
                195:buyer_seller[195] <= reg_ID_buyer;
                196:buyer_seller[196] <= reg_ID_buyer;
                197:buyer_seller[197] <= reg_ID_buyer;
                198:buyer_seller[198] <= reg_ID_buyer;
                199:buyer_seller[199] <= reg_ID_buyer;

                200:buyer_seller[200] <= reg_ID_buyer;
                201:buyer_seller[201] <= reg_ID_buyer;
                202:buyer_seller[202] <= reg_ID_buyer;
                203:buyer_seller[203] <= reg_ID_buyer;
                204:buyer_seller[204] <= reg_ID_buyer;
                205:buyer_seller[205] <= reg_ID_buyer;
                206:buyer_seller[206] <= reg_ID_buyer;
                207:buyer_seller[207] <= reg_ID_buyer;
                208:buyer_seller[208] <= reg_ID_buyer;
                209:buyer_seller[209] <= reg_ID_buyer;

                210:buyer_seller[210] <= reg_ID_buyer;
                211:buyer_seller[211] <= reg_ID_buyer;
                212:buyer_seller[212] <= reg_ID_buyer;
                213:buyer_seller[213] <= reg_ID_buyer;
                214:buyer_seller[214] <= reg_ID_buyer;
                215:buyer_seller[215] <= reg_ID_buyer;
                216:buyer_seller[216] <= reg_ID_buyer;
                217:buyer_seller[217] <= reg_ID_buyer;
                218:buyer_seller[218] <= reg_ID_buyer;
                219:buyer_seller[219] <= reg_ID_buyer;

                220:buyer_seller[220] <= reg_ID_buyer;
                221:buyer_seller[221] <= reg_ID_buyer;
                222:buyer_seller[222] <= reg_ID_buyer;
                223:buyer_seller[223] <= reg_ID_buyer;
                224:buyer_seller[224] <= reg_ID_buyer;
                225:buyer_seller[225] <= reg_ID_buyer;
                226:buyer_seller[226] <= reg_ID_buyer;
                227:buyer_seller[227] <= reg_ID_buyer;
                228:buyer_seller[228] <= reg_ID_buyer;
                229:buyer_seller[229] <= reg_ID_buyer;

                230:buyer_seller[230] <= reg_ID_buyer;
                231:buyer_seller[231] <= reg_ID_buyer;
                232:buyer_seller[232] <= reg_ID_buyer;
                233:buyer_seller[233] <= reg_ID_buyer;
                234:buyer_seller[234] <= reg_ID_buyer;
                235:buyer_seller[235] <= reg_ID_buyer;
                236:buyer_seller[236] <= reg_ID_buyer;
                237:buyer_seller[237] <= reg_ID_buyer;
                238:buyer_seller[238] <= reg_ID_buyer;
                239:buyer_seller[239] <= reg_ID_buyer;

                240:buyer_seller[240] <= reg_ID_buyer;
                241:buyer_seller[241] <= reg_ID_buyer;
                242:buyer_seller[242] <= reg_ID_buyer;
                243:buyer_seller[243] <= reg_ID_buyer;
                244:buyer_seller[244] <= reg_ID_buyer;
                245:buyer_seller[245] <= reg_ID_buyer;
                246:buyer_seller[246] <= reg_ID_buyer;
                247:buyer_seller[247] <= reg_ID_buyer;
                248:buyer_seller[248] <= reg_ID_buyer;
                249:buyer_seller[249] <= reg_ID_buyer;

                250:buyer_seller[250] <= reg_ID_buyer;
                251:buyer_seller[251] <= reg_ID_buyer;
                252:buyer_seller[252] <= reg_ID_buyer;
                253:buyer_seller[253] <= reg_ID_buyer;
                254:buyer_seller[254] <= reg_ID_buyer;
                255:buyer_seller[255] <= reg_ID_buyer;
            endcase
        end
        else begin
            for(i = 0; i < 256; i = i + 1)begin
                buyer_seller [i] <= buyer_seller [i];
            end
        end
    end
end


assign buy_success = ((buy_unsuccess == 0) && (reg_action == 4'b0001) && STATE == OUT) ? 1 : 0; 

//Check_case04
assign check_buyer_out = {16'd0 , buyer_money};

always_ff@(posedge clk or negedge inf.rst_n)begin
    if(!inf.rst_n) 
        reg_check <= 0;
    else begin
        case(STATE)
            CHECK_BUYER: reg_check <= 1;
            CHECK_SELLER: reg_check <= 2;
            OUT : reg_check <= reg_check; 
            default: reg_check <= 0;
        endcase
    end
end   

//Check_case05
assign check_seller_out = {14'd0 , seller_L_items , seller_M_items , seller_S_items};

assign check_success = (reg_action == 4'b0010 && STATE == OUT) ? 1 : 0;

//Deposit_case06_case11
assign deposit_or_not = 16'd65535 - buyer_money;
assign deposit_result = (deposit_or_not >= reg_money) ? (buyer_money + reg_money) : (0);

assign a_deposit_money = (deposit_or_not >= reg_money) ? (buyer_money + reg_money) : buyer_money;

assign deposit_success = (reg_action == 4'b0100 && deposit_or_not >= reg_money && STATE == OUT) ? 1 : 0;

assign deposit_out = {16'd0 , deposit_result};

//Return_case12
assign return_wrong_act_other = ((other_operations_seller[buyer_seller_id_history] == 1 ) && (other_operations_user[reg_ID_buyer] == 1)) ? 0 : 1;

//Return_case13
assign return_wrong_buyer = (buyer_seller[buyer_seller_id_history] != reg_ID_buyer)? 1 : 0;

//Return_case14
assign return_seller_wrong = (reg_action == 4'b1000 && reg_ID_seller != buyer_seller_id_history) ? 1 : 0;

//Return_case15
assign return_item_wrong = (reg_action == 4'b1000 && reg_item_ID != buyer_item_id_history) ? 1 : 0;

//Return_case16
assign return_item_num_wrong = (reg_action == 4'b1000 && reg_num != buyer_item_num_history) ? 1 : 0;

assign return_success = (STATE == OUT) ? ~(return_wrong_act_other | return_wrong_buyer | return_seller_wrong | return_item_wrong | return_item_num_wrong) : 0;

assign return_unsuccess = (return_wrong_act_other | return_wrong_buyer | return_seller_wrong | return_item_wrong | return_item_num_wrong);

assign return_out = (return_success) ? {14'd0 , a_buyer_L_items , a_buyer_M_items , a_buyer_S_items} : 0;

assign inf.out_valid = (STATE == OUT) ? 1 : 0;

always_comb begin
    if(STATE == OUT)begin    
        case(reg_action)
            Buy: inf.complete = buy_success;
        
            Check: inf.complete = check_success;
    
            Deposit:inf.complete = deposit_success;
    
            Return:begin
                inf.complete = return_success;
            end
            default: inf.complete = 0;
        endcase
    end
    else inf.complete = 0;
end

always_comb begin
    if(STATE == OUT)begin    
        case(reg_action)
            Buy:begin  if(buyer_item_full == 1) inf.err_msg = 4'b0100;
                       else if(seller_item_not_enough == 1) inf.err_msg = 4'b0010;
                       else if(buyer_money_not_enough == 1 || fee_not_enough == 1) inf.err_msg = 4'b0011;
                       else inf.err_msg = 4'b0000;
                end

            Check: inf.err_msg = 4'b0000;

            Deposit:begin
                if(deposit_success == 0) inf.err_msg = 4'b1000;
                else inf.err_msg = 4'b0000;
            end

            Return:begin
                if(return_wrong_act_other == 1 || return_wrong_buyer == 1) inf.err_msg = 4'b1111;
                else if(return_seller_wrong == 1) inf.err_msg = 4'b1001;
                else if(return_item_num_wrong == 1)  inf.err_msg = 4'b1100;
                else if (return_item_wrong == 1) inf.err_msg = 4'b1010;
                else inf.err_msg = 4'b0000;
            end
            default inf.err_msg = 0;
        endcase
    end
    else inf.err_msg = 0;
end

always_comb begin
    if(STATE == OUT)begin
        case(reg_action)
            Buy: inf.out_info = buy_out;
            Check: inf.out_info = (reg_check == 1) ? check_buyer_out : ((reg_check == 2) ?  check_seller_out: 0) ;
            Deposit: inf.out_info = deposit_out;
            Return:inf.out_info = return_out;
            default : inf.out_info = 0;
        endcase
    end
    else inf.out_info = 0;
end

endmodule