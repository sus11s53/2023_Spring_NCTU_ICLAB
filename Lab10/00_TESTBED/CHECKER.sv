//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//
//   File Name   : CHECKER.sv
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
//`include "Usertype_PKG.sv"

module Checker(input clk, INF.CHECKER inf);
import usertype::*;

covergroup Spec1 @(posedge clk iff inf.amnt_valid);
   	coverpoint inf.D.d_money {
   		option.at_least = 10 ;
   		bins b1 = {[0:12000]};
        bins b2 = {[12001:24000]};
        bins b3 = {[24001:36000]};
        bins b4 = {[36001:48000]};
        bins b5 = {[48001:60000]};
   	}
endgroup : Spec1

covergroup Spec2 @(posedge clk iff inf.id_valid);
   	coverpoint inf.D.d_id[0] {
   		option.at_least = 2 ;
   		option.auto_bin_max = 256 ;
   	}
endgroup : Spec2


covergroup Spec3 @(posedge clk iff inf.act_valid);
   	coverpoint inf.D.d_act[0] {
   		option.at_least = 10 ;
   		bins b[] = (Buy, Check, Deposit, Return => Buy, Check, Deposit, Return) ;
   	}
endgroup : Spec3

covergroup Spec4 @(posedge clk iff inf.item_valid);
   	coverpoint inf.D.d_item[0] {
   		option.at_least = 20 ;
   		bins b[] = {Large, Medium, Small} ;
   	}
endgroup : Spec4


covergroup Spec5 @(negedge clk iff inf.out_valid);
	coverpoint inf.err_msg {
		option.at_least = 20 ;
		bins b1 = {No_Err    } ;
		bins b2 = {INV_Not_Enough } ;
		bins b3 = {Out_of_money} ;
		bins b4 = {INV_Full} ;
		bins b5 = {Wallet_is_Full} ;
		bins b6 = {Wrong_ID} ;
		bins b7 = {Wrong_Num} ;
        bins b8 = {Wrong_Item} ;
        bins b9 = {Wrong_act} ;
	}
endgroup : Spec5

covergroup Spec6 @(negedge clk iff inf.out_valid);
	coverpoint inf.complete {
		option.at_least = 200 ;
		bins b1 = {0 } ;
		bins b2 = {1 } ;
	}
endgroup : Spec6

//declare other cover group

//declare the cover group 
//Spec1 cov_inst_1 = new();

Spec1 cov_inst_1 = new();
Spec2 cov_inst_2 = new();
Spec3 cov_inst_3 = new();
Spec4 cov_inst_4 = new();
Spec5 cov_inst_5 = new();
Spec6 cov_inst_6 = new();



//************************************ below assertion is to check your pattern ***************************************** 
//                                          Please finish and hand in it
// This is an example assertion given by TA, please write other assertions at the below
// assert_interval : assert property ( @(posedge clk)  inf.out_valid |=> inf.id_valid == 0)
// else
// begin
// 	$display("Assertion X is violated");
// 	$fatal; 
// end

wire #(0.5) rst_reg = inf.rst_n;

//write other assertions

//========================================================================================================================================================
//  assertions
//========================================================================================================================================================
Action act ;
always_ff @(posedge clk or negedge rst_reg)  begin
	if (!rst_reg)				act <= No_action ;
	else begin 
		if (inf.act_valid === 1) 	act <= inf.D.d_act[0] ;
        else if(inf.out_valid === 1) act <= No_action;
	end
end

Action act_comb ;
assign act_comb = (inf.act_valid === 1) ? inf.D.d_act[0] : No_action ;

//==================================================================
// Assertion 1
//==================================================================
always @(negedge rst_reg) begin
	#1;
	assert_1 : assert (
		// OS output
        (inf.out_valid    === 0) && (inf.err_msg      === 0) &&
		(inf.complete     === 0) && (inf.out_info     === 0) &&
		(inf.C_addr       === 0) && (inf.C_data_w     === 0) &&
		(inf.C_in_valid   === 0) && (inf.C_r_wb       === 0) &&

        // bridge output
		(inf.C_out_valid  === 0) && (inf.C_data_r     === 0) &&
		(inf.AR_VALID     === 0) && (inf.AR_ADDR      === 0) &&
		(inf.R_READY      === 0) && (inf.AW_VALID     === 0) &&
		(inf.AW_ADDR      === 0) && (inf.W_VALID      === 0) &&
		(inf.W_DATA       === 0) && (inf.B_READY      === 0)
	)
	else begin 
        $display("Assertion 1 is violated"); 
        $fatal; 
    end
end

//==================================================================
// Assertion 2
//==================================================================
assert_2 : assert property ( @(posedge clk) (inf.complete === 1 && inf.out_valid === 1) |-> (inf.err_msg === No_Err) )
    else begin
    	$display("Assertion 2 is violated");
    	$fatal; 
    end

//==================================================================
// Assertion 3
//==================================================================
assert_3 : assert property ( @(posedge clk) (inf.complete === 0 && inf.out_valid === 1) |-> (inf.out_info === 0) )
    else begin
    	$display("Assertion 3 is violated");
    	$fatal; 
    end

//==================================================================
// Assertion 4
//==================================================================
assert_4_1 : assert property ( @(posedge clk)  (inf.id_valid === 1) |=> (inf.id_valid === 0) )
else begin
	$display("Assertion 4 is violated");
	$fatal; 
end

assert_4_2 : assert property ( @(posedge clk)  (inf.act_valid === 1) |=> (inf.act_valid === 0) )
else begin
	$display("Assertion 4 is violated");
	$fatal; 
end

assert_4_3 : assert property ( @(posedge clk)  (inf.item_valid === 1) |=> (inf.item_valid === 0) )
else begin
	$display("Assertion 4 is violated");
	$fatal; 
end

assert_4_4 : assert property ( @(posedge clk)  (inf.num_valid === 1) |=> (inf.num_valid === 0) )
else begin
	$display("Assertion 4 is violated");
	$fatal; 
end

assert_4_5 : assert property ( @(posedge clk)  (inf.amnt_valid === 1) |=> (inf.amnt_valid === 0) )
else begin
	$display("Assertion 4 is violated");
	$fatal; 
end

//==================================================================
// Assertion 6
//==================================================================
assert_6_1 :assert property ( @(posedge clk) ( inf.act_valid === 1 && (act_comb == Buy || act_comb == Return)) |-> ## [2:6] (inf.item_valid))
else begin
 	$display("Assertion 6 is violated");
 	$fatal; 
end

assert_6_1_1 :assert property ( @(posedge clk) ( inf.act_valid === 1 && (act_comb == Buy || act_comb == Return)) |=> (inf.act_valid === 0 && inf.num_valid === 0 && inf.amnt_valid === 0 && inf.id_valid === 0) [*3])
else begin
 	$display("Assertion 6 is violated");
 	$fatal; 
end

assert_6_2 :assert property ( @(posedge clk) ( inf.act_valid === 1 && (act_comb == Buy || act_comb == Return) ) |-> ## 1 (inf.item_valid === 0))
else begin
 	$display("Assertion 6 is violated");
 	$fatal; 
end

assert_6_3 :assert property ( @(posedge clk) ( inf.item_valid === 1 && (act == Buy || act == Return )) |-> ## [2:6] (inf.num_valid))
else begin
 	$display("Assertion 6 is violated");
 	$fatal; 
end

assert_6_3_1 :assert property ( @(posedge clk) ( inf.item_valid === 1 && (act == Buy || act == Return )) |=>  (inf.act_valid === 0 && inf.item_valid === 0 && inf.amnt_valid === 0 && inf.id_valid === 0) [*3])
else begin
 	$display("Assertion 6 is violated");
 	$fatal; 
end

assert_6_4 :assert property ( @(posedge clk) ( inf.item_valid === 1 && (act == Buy || act == Return )) |-> ## 1 (inf.num_valid === 0) )
else begin
 	$display("Assertion 6 is violated");
 	$fatal; 
end

assert_6_5 :assert property ( @(posedge clk) ( inf.num_valid === 1 && (act == Buy || act == Return )) |-> ## [2:6] (inf.id_valid))
else begin
 	$display("Assertion 6 is violated");
 	$fatal; 
end

assert_6_5_1 :assert property ( @(posedge clk) ( inf.num_valid === 1 && (act == Buy || act == Return )) |=>  (inf.act_valid === 0 && inf.item_valid === 0 && inf.amnt_valid === 0 && inf.num_valid === 0) [*3])
else begin
 	$display("Assertion 6 is violated");
 	$fatal; 
end

assert_6_6 :assert property ( @(posedge clk) ( inf.num_valid === 1 && (act == Buy || act == Return )) |-> ## 1 (inf.id_valid === 0) )
else begin
 	$display("Assertion 6 is violated");
 	$fatal; 
end

assert_6_7 :assert property ( @(posedge clk) ( inf.id_valid === 1 && (act == No_action)) |-> ## [2:6] (inf.act_valid))
else begin
 	$display("Assertion 6 is violated");
 	$fatal; 
end

assert_6_7_1 :assert property ( @(posedge clk) ( inf.id_valid === 1 && (act == No_action)) |=>  (inf.id_valid === 0 && inf.item_valid === 0 && inf.amnt_valid === 0 && inf.num_valid === 0) [*3])
else begin
 	$display("Assertion 6 is violated");
 	$fatal; 
end

assert_6_8 :assert property ( @(posedge clk) ( inf.id_valid === 1 && (act == No_action)) |-> ## 1 (inf.act_valid === 0) )
else begin
 	$display("Assertion 6 is violated");
 	$fatal; 
end

assert_6_9 :assert property ( @(posedge clk) ( inf.act_valid === 1 && (act_comb == Deposit)) |-> ## [2:6] (inf.amnt_valid))
else begin
 	$display("Assertion 6 is violated");
 	$fatal; 
end

assert_6_9_1 :assert property ( @(posedge clk) ( inf.act_valid === 1 && (act_comb == Deposit)) |=>  (inf.id_valid === 0 && inf.item_valid === 0 && inf.act_valid === 0 && inf.num_valid === 0) [*3])
else begin
 	$display("Assertion 6 is violated");
 	$fatal; 
end

assert_6_10 :assert property ( @(posedge clk) (  inf.act_valid === 1 && (act_comb == Deposit) ) |-> ## 1 (inf.amnt_valid === 0))
else begin
 	$display("Assertion 6 is violated");
 	$fatal; 
end

assert_6_11 :assert property ( @(posedge clk) (  inf.act_valid === 1 && (act_comb == Check) ) |-> ## 1 (inf.id_valid === 0))
else begin
 	$display("Assertion 6 is violated");
 	$fatal; 
end

assert_6_11_1 :assert property ( @(posedge clk) (  inf.act_valid === 1 && (act_comb == Check) ) |=>  (inf.amnt_valid === 0 && inf.item_valid === 0 && inf.act_valid === 0 && inf.num_valid === 0) [*5])
else begin
 	$display("Assertion 6 is violated");
 	$fatal; 
end

assert_6_12 :assert property ( @(posedge clk) ( inf.act_valid === 1 && (act_comb == Check)) |-> ## 8 (inf.id_valid === 0))
else begin
 	$display("Assertion 6 is violated");
 	$fatal; 
end

logic [3:0] all_valids;
assign all_valids = inf.id_valid + inf.act_valid + inf.item_valid + inf.num_valid + inf.amnt_valid;
//==================================================================
// Assertion 5
//==================================================================
assert5 : assert property ( @(posedge clk)  all_valids < 2)
    else begin
        $display("Assertion 5 is violated");
        $fatal; 
    end

//==================================================================
// Assertion 7
//==================================================================
assert_7 : assert property ( @(posedge clk)  (inf.out_valid === 1) |=> (inf.out_valid === 0) )
else begin
	$display("Assertion 7 is violated");
	$fatal; 
end

//==================================================================
// Assertion 8
//==================================================================

assert_8_1 :assert property ( @(posedge clk) (inf.out_valid === 1)  |-> ##[2:10] ( (inf.act_valid === 1) || (inf.id_valid === 1)))  
else begin
 	$display("Assertion 8 is violated");
 	$fatal; 
end

assert_8_2 : assert property ( @(posedge clk)  (inf.out_valid === 1) |-> ##1 ( (inf.act_valid === 0) && (inf.id_valid === 0)) )
else begin
    $display("Assertion 8 is violated");
    $fatal; 
end

//==================================================================
// Assertion 9
//==================================================================

assert_9_3 : assert property ( @(posedge clk) ( (act === Buy || act === Return) && (inf.id_valid === 1)) |-> ( ##[1:10000] inf.out_valid === 1 ) )
else begin
	$display("Assertion 9 is violated");
	$fatal; 
end

assert_9_4 : assert property ( @(posedge clk) ( (act === Deposit) && (inf.amnt_valid === 1)) |-> ( ##[1:10000] inf.out_valid === 1 ) )
else begin
	$display("Assertion 9 is violated");
	$fatal; 
end



User_id id_reg_1;
always_ff @(posedge clk or negedge rst_reg)  begin
	if (!rst_reg)				id_reg_1 <= 0 ;
	else begin 
		if (inf.id_valid === 1) 	id_reg_1 <= inf.D.d_id[0] ;
	end
end

User_id id_reg_2;
always_ff @(posedge clk or negedge rst_reg)  begin
	if (!rst_reg)				id_reg_2 <= 0 ;
	else begin 
		if (inf.id_valid === 1 && act === No_action) 	id_reg_2 <= inf.D.d_id[0] ;
	end
end

logic[2:0] cnt_check;
always_ff @(posedge clk or negedge rst_reg)  begin
	if (!rst_reg)				cnt_check <= 0 ;
	else begin 
		if (act === Check) 	cnt_check <= cnt_check + 1 ;
		else                cnt_check <= 0 ;
	end
end

logic check_flag;

always_ff @(posedge clk or negedge inf.rst_n)begin
    if(!inf.rst_n)begin
        check_flag <= 0;
    end
    else begin
        if(act == Check && cnt_check <= 5  && inf.id_valid)         check_flag <= 1; //1 for stocks
        else if(act != Check)                                       check_flag <= 0; //0 for money
    end
end

// 1 = user , 0 = seller
logic user_or_seller;
assign user_or_seller = (id_reg_1 == id_reg_2) ? 1 : 0;

assert_9_1 : assert property ( @(negedge clk) (check_flag == 1)   |-> (##[1:10000] (inf.out_valid === 1)) )
else begin
    $display("Assertion 9 is violated");
    $fatal; 
end

assert_9_2 : assert property ( @(negedge clk) ((check_flag == 0) && (act == Check) && (inf.act_valid === 1) )  |-> ##[1:10000] (inf.out_valid === 1) )
else begin
    $display("Assertion 9 is violated");
    $fatal; 
end

endmodule