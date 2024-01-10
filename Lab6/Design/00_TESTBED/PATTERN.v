//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    (C) Copyright Optimum Application-Specific Integrated System Laboratory
//    All Right Reserved
//		Date		: 2023/03
//		Version		: v1.0
//   	File Name   : PATTERN.v
//   	Module Name : PATTERN
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

`ifdef RTL_TOP
    `define CYCLE_TIME 48.0
`endif

`ifdef GATE_TOP
    `define CYCLE_TIME 48.0
`endif

module PATTERN (
    // Output signals
    clk, rst_n, in_valid,
    in_Px, in_Py, in_Qx, in_Qy, in_prime, in_a,
    // Input signals
    out_valid, out_Rx, out_Ry
);

// ===============================================================
// Input & Output Declaration
// ===============================================================
output reg clk, rst_n, in_valid;
output reg [5:0] in_Px, in_Py, in_Qx, in_Qy, in_prime, in_a;
input  out_valid;
input  [5:0] out_Rx, out_Ry;

parameter CYCLE           = `CYCLE_TIME;
integer golden_output_x, golden_output_y;
integer Px_reg, Py_reg, Qx_reg, Qy_reg, Rx_reg, Ry_reg, a_reg, prime_reg;
integer S_reg, S_before_mod;
integer latency, total_latency, pat, patnum;
integer t, get_p;
integer i;
integer multi, mod, IN_num, IN_P, mark, IP_output;
reg [5:0] box[0:16];
//================================================================
//   Clock
//================================================================
initial clk = 1'b0;
always #(CYCLE/2.0) clk = ~clk;

//================================================================
//   initial
//================================================================
initial begin

	reset_task;
	patnum = 10000;
	golden_output_x=10;
    golden_output_y=10;
	for (pat = 0; pat < patnum; pat = pat+1)
	begin
		input_task;
        compute_ans_task;
		wait_out_valid_task;

       check_ans_task;

       $display("you passed %d pattern", pat);
		
    end
		
	$display("Total Latency = %d ", total_latency);
	YOU_PASS_task;


end
integer Rx_temp, Ry_temp;
task compute_ans_task;begin
    mark = 0;
    if(Px_reg==Qx_reg && Py_reg == Qy_reg)begin //doubling
        IN_num = 2*Py_reg;
        if(IN_num>prime_reg) IN_num = IN_num - prime_reg;
    end
    else begin
        IN_num = Qx_reg - Px_reg;
        if(IN_num<0) IN_num = IN_num + prime_reg;
    end
    IN_P = prime_reg;
    for( i = 1 ; i < IN_P; i = i + 1)begin
        multi = IN_num * i;
        mod = multi % IN_P;
        if(mod == 1 && mark == 0)begin
            IP_output = i;
            mark=1;
        end 
    end
    if(Px_reg==Qx_reg && Py_reg == Qy_reg)begin
        S_before_mod = IP_output*(3*Px_reg*Px_reg + a_reg);
        while(S_before_mod<0)begin
            S_before_mod = S_before_mod + prime_reg;
        end 
        
        S_reg = S_before_mod%prime_reg;
    end
    else begin
        S_before_mod = (IP_output*(Qy_reg-Py_reg));
        while(S_before_mod<0)begin
            S_before_mod = S_before_mod + prime_reg;
        end 
        
        S_reg = S_before_mod%prime_reg;
    end

    Rx_temp = (S_reg*S_reg-Px_reg-Qx_reg);
    while (Rx_temp<0) begin
        Rx_temp = Rx_temp +prime_reg;
    end
    Rx_reg = Rx_temp%prime_reg;

    Ry_temp = (S_reg*(Px_reg-Rx_reg) - Py_reg);
    while (Ry_temp<0) begin
        Ry_temp = Ry_temp +prime_reg;
    end
    Ry_reg = Ry_temp%prime_reg;


end endtask



task check_ans_task;begin //check 1.out of map   2.hit lower obstacle  3.hit high obstacle  4.hit train  
                          //      5.jump on the lower obstacle 
    golden_output_x=Rx_reg;
    golden_output_y=Ry_reg;
	while (out_valid===1) begin
        
        if(golden_output_x!==out_Rx || golden_output_y!==out_Ry)begin
            $display ("----------------------------------------------------------------------");
		    $display ("                            wrong answer!!!                           ");
		    $display ("                     golden_Rx= %d, golden_Ry= %d   .                 ",golden_output_x,golden_output_y);
		    $display ("                         your_Rx= %d, your_Ry= %d                     ",out_Rx,out_Ry);
		    $display ("----------------------------------------------------------------------");
		    $finish;
        end
        
        @(negedge clk);
	end
	out_outvalid_task;   
end endtask
task input_task; begin

    t = $urandom_range(0, 2);  // 2~4 negedge comes a new pattern
	repeat(t) @(negedge clk);

    in_valid = 'd1;
    get_p = $urandom_range(0, 16);
    in_prime = box[get_p];
    in_Py = $urandom_range(1, in_prime-1);
    in_Qy = $urandom_range(1, in_prime-1);
    while(in_Qy == (in_prime - in_Py))begin
        in_Qy = $urandom_range(1, in_prime-1);
    end
    in_Px = $urandom_range(1, in_prime-1);
    in_Qx = $urandom_range(1, in_prime-1);
    if(in_Qy != in_Py)begin
        while (in_Px == in_Qx) begin
            in_Qx = $urandom_range(1, in_prime-1);
        end
    end
    in_a = $urandom_range(1, in_prime-1);
    if(pat<10)begin
        in_Px = in_Qx;
        in_Py = in_Qy;
    end
    if(pat==0)begin
        in_Px = 60;
        in_Py = 60;
        in_Qx = 60;
        in_Qy = 60;
        in_prime = 61;
        in_a = 60;
    end
    Px_reg = in_Px;
    Py_reg = in_Py;
    Qx_reg = in_Qx;
    Qy_reg = in_Qy;
    a_reg = in_a;
    prime_reg = in_prime;
    @(negedge clk);
    in_valid = 'b0;
    in_Px = 'bx;
    in_Py = 'bx;
	in_Qx = 'bx;
	in_Qy = 'bx;
    in_prime = 'bx;
    in_a = 'bx;
end endtask

task reset_task ; begin  
    total_latency = 0;
    rst_n = 'b1;
    in_valid = 'b0;
    in_Px = 'bx;
    in_Py = 'bx;
	in_Qx = 'bx;
	in_Qy = 'bx;
    in_prime = 'bx;
    in_a = 'bx;
    box[0]=3;
    box[1]=5;
    box[2]=7;
    box[3]=11;
    box[4]=13;
    box[5]=17;
    box[6]=19;
    box[7]=23;
    box[8]=29;
    box[9]=31;
    box[10]=37;
    box[11]=41;
    box[12]=43;
    box[13]=47;
    box[14]=53;
    box[15]=59;
    box[16] = 61;
    force clk = 0;

    #CYCLE; rst_n = 0; 
    #CYCLE; rst_n = 1;
    
    if((out_valid !== 0) || (out_Rx !== 0) || (out_Ry !== 0)) begin
        $display ("----------------------------------------------------------------------------------------------------------");
        $display ("                           Output signal should be 0 after initial RESET at %8t                           ",$time);
        $display ("----------------------------------------------------------------------------------------------------------");
        $finish;
    end
    #CYCLE; release clk;
end endtask

task wait_out_valid_task; begin
	latency = 0;
	while(out_valid === 0)begin
		latency = latency + 1;
        out_outvalid_task;
		if(latency == 1000) begin
           $display ("---------------------------------------------------------------------------------------------------");
           $display ("                                         Pattern NO.%03d                                           ", pat);
           $display ("                           The execution latency are over 1000 cycles                              ");
           $display ("---------------------------------------------------------------------------------------------------");
           $finish;
       end
   @(negedge clk);
   end
   total_latency = total_latency + latency;
end endtask

task  out_outvalid_task; begin
	
	if(out_valid === 'b0)begin
	    if( out_Rx !== 'd0 || out_Ry !== 'd0) begin //out!==0
            $display("------------------------------------------------------------------");   
            $display("      Output should be 0 while out_valid == 0  at %8t             ",$time);
            $display("------------------------------------------------------------------");
            $finish;
        end
	end

end endtask

task YOU_PASS_task; begin
	$display ("----------------------------------------------------------------------------------------------------------------------");
	$display ("                                                  Congratulations!                						             ");
	$display ("                                           You have passed all patterns!          						             ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	$finish;
end endtask
endmodule