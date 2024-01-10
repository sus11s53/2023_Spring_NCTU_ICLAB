`ifdef RTL
    `define CYCLE_TIME 10.0
`endif
`ifdef GATE
    `define CYCLE_TIME 10.0
`endif


module PATTERN(
    // Output Signals
    clk,
    rst_n,
    in_valid,
    init,
    in0,
    in1,
    in2,
    in3,
    // Input Signals
    out_valid,
    out
);


/* Input for design */
output reg       clk, rst_n;
output reg       in_valid;
output reg [1:0] init;
output reg [1:0] in0, in1, in2, in3; 


/* Output for pattern */
input            out_valid;
input      [1:0] out; 

//================================================================
// clock
//================================================================
real	CYCLE = `CYCLE_TIME;
always	#(CYCLE/2.0) clk = ~clk;

//================================================================
// parameters & integer
//================================================================
integer PATNUM = 300;
integer seed = 333;
integer i, j, k;
integer patcount;
integer gap;
integer y;
integer z;

integer initial_position;
integer row , col;
integer current_col , current_row;
integer delay;
integer total_delay;
integer golden_out;
integer cnt;
integer train_num;
integer train_0 , train_1 , train_2 , train_3;
reg signed [4:0] map [0:3][0:63];
reg [3:0] train;
integer obstacle_2_train , obstacle_2_notrain;
integer obstacle_4_train , obstacle_4_notrain;
integer obstacle_6_train , obstacle_6_notrain;
//================================================================
// initial
//================================================================
initial begin
	rst_n = 1'b1;
    in_valid = 1'b0;
	total_delay = 0;
    train_num = 0;
    obstacle_2_train = 0;
    obstacle_2_notrain = 0;
    obstacle_4_notrain = 0;
    obstacle_6_notrain = 0;
    obstacle_4_train = 0;
    obstacle_6_train = 0;
    train_0 = 0;
    train_1 = 0;
    train_2 = 0;
    train_3 = 0;
    initial_position = 0;
    row = 0;
    col = 0;
    current_row = 0;
    current_col = 0;
    cnt = 0;


	force clk = 0;
	reset_task;
	
	for(patcount = 0; patcount < PATNUM; patcount = patcount + 1)
	begin	
		delay_task;	
        train_generate;
        initial_position_choose;
        obstacle_generate;
        input_map;
		wait_out_valid;
		check_ans;
		$display("\033[0;32mPASS PATTERN NO.%3d \033[m", patcount);
	end

	YOU_PASS_task;
	$finish;
end

//================================================================
// task
//================================================================
//input  
task delay_task; begin
	gap = $urandom_range(2,4);
	repeat(gap) @(negedge clk);
end endtask



task initial_position_choose ; begin
    if(map[0][0] != 3) initial_position = 0;
    else if(map[1][0] != 3) initial_position = 1;
    else if(map[2][0] != 3) initial_position = 2;
    else initial_position = 3;
end endtask

task train_generate ;begin
    
    for(k = 0 ; k < 64; k = k + 1 )begin
        for(j = 0; j < 4 ; j = j + 1)begin
            map[j][k] = 0;
        end
    end

    @(negedge clk);
    
    for(j = 0; j < 8;  j = j + 1)begin
                            
                    train = $urandom_range(1,14);
                    
                    train_0 = train[0];
                    train_1 = train[1];
                    train_2 = train[2];
                    train_3 = train[3];
                    
                    map[0][j*8] = (train_0)? 3 : 0;
                    map[0][j*8 + 1] = (train_0)? 3 : 0;
                    map[0][j*8 + 2] = (train_0)? 3 : 0;
                    map[0][j*8 + 3] = (train_0)? 3 : 0;
                    map[0][j*8 + 4] = 0;
                    map[0][j*8 + 5] = 0;
                    map[0][j*8 + 6] = 0;
                    map[0][j*8 + 7] = 0;
                    
                    map[1][j*8] = (train_1)? 3 : 0;
                    map[1][j*8 + 1] = (train_1)? 3 : 0;
                    map[1][j*8 + 2] = (train_1)? 3 : 0;
                    map[1][j*8 + 3] = (train_1)? 3 : 0;
                    map[1][j*8 + 4] = 0;
                    map[1][j*8 + 5] = 0;
                    map[1][j*8 + 6] = 0;
                    map[1][j*8 + 7] = 0;   

                    map[2][j*8] = (train_2)? 3 : 0;
                    map[2][j*8 + 1] = (train_2)? 3 : 0;
                    map[2][j*8 + 2] = (train_2)? 3 : 0;
                    map[2][j*8 + 3] = (train_2)? 3 : 0;
                    map[2][j*8 + 4] = 0;
                    map[2][j*8 + 5] = 0;
                    map[2][j*8 + 6] = 0;
                    map[2][j*8 + 7] = 0; 

                    map[3][j*8] = (train_3)? 3 : 0;
                    map[3][j*8 + 1] = (train_3)? 3 : 0;
                    map[3][j*8 + 2] = (train_3)? 3 : 0;
                    map[3][j*8 + 3] = (train_3)? 3 : 0;
                    map[3][j*8 + 4] = 0;
                    map[3][j*8 + 5] = 0;
                    map[3][j*8 + 6] = 0;
                    map[3][j*8 + 7] = 0;
                
                
        @(negedge clk);
    end
end endtask

task obstacle_generate ;begin
    
    for(j = 0; j < 8;  j = j + 1)begin            
                for(k = 0; k < 4; k = k + 1)begin      
                    if(map[k][0 + 8*j] != 3)begin
                        obstacle_2_notrain = $urandom_range(0,2);
                        obstacle_4_notrain = $urandom_range(0,2);
                        obstacle_6_notrain = $urandom_range(0,2);
         
                                map[k][0 + 8*j] = 0;
                                map[k][1 + 8*j] = 0;
                                map[k][2 + 8*j] = (obstacle_2_notrain == 2) ? (2):((obstacle_2_notrain == 1) ? (1) : (0));
                                map[k][3 + 8*j] = 0;
                                map[k][4 + 8*j] = (obstacle_4_notrain == 2) ? (2):((obstacle_4_notrain == 1) ? (1) : (0));
                                map[k][5 + 8*j] = 0;
                                map[k][6 + 8*j] = (obstacle_6_notrain == 2) ? (2):((obstacle_6_notrain == 1) ? (1) : (0));
                                map[k][7 + 8*j] = 0;
                    end
                    else begin
                        obstacle_4_train = $urandom_range(0,2);
                        obstacle_6_train = $urandom_range(0,2);
         
                            map[k][0 + 8*j] = 3;
                            map[k][1 + 8*j] = 3;
                            map[k][2 + 8*j] = 3;
                            map[k][3 + 8*j] = 3;
                            map[k][4 + 8*j] = (obstacle_4_train == 2) ? (2):((obstacle_4_train == 1) ? (1) : (0));
                            map[k][5 + 8*j] = 0;
                            map[k][6 + 8*j] = (obstacle_6_train == 2) ? (2):((obstacle_6_train == 1) ? (1) : (0));
                            map[k][7 + 8*j] = 0;
                    end
                    @(negedge clk);
                end        
        @(negedge clk);
    end
end endtask

task input_map;begin
    for(j = 0; j < 64; j = j + 1)begin
            in_valid = 1'b1;
            in0 = map[0][j];
            in1 = map[1][j];
            in2 = map[2][j];
            in3 = map[3][j];
            init = (j == 0) ? initial_position :'bx;
        @(negedge clk);
    end
    in_valid = 1'b0;
	in0 = 'bx;
    in1 = 'bx;
    in2 = 'bx;
    in3 = 'bx;
    init = 'bx;
end endtask

task check_ans; begin
    
    row = initial_position;
    col = 0;
    cnt = 0;
    current_row = 0;
    current_col = 0;
    
    for(j = 0; j < 64; j = j + 1)begin
        
            if(j != 0)begin
                row = current_row;
                col = current_col;
            end

        // forward
        if(out == 2'd0)begin
            if(map[row][col + 1] == 1) begin 
                    fail;
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                $display ("                          SPEC 8-2 The character  must avoid hitting lower obstacles.                           ");
	                $display ("                        				Pattern No. %3d                                                   ",patcount);
                    $display ("                        				Path No. %3d                                                           ",cnt);
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                #(100)
	                $finish;
            end
            else if(map[row][col + 1] == 3)begin 
                    fail;
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                $display ("                          SPEC 8-4 The character  must avoid hitting trains.                                    ");
	                $display ("                        				Pattern No. %3d                                                   ",patcount);
                    $display ("                        				Path No. %3d                                                           ",cnt);
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                #(100)
	                $finish;
            end
            else begin
                    current_row = row;
                    current_col = col + 1;
            end
        end

        // turn right
        else if(out == 2'd1)begin
            if(row == 3)begin 
                	fail;
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                $display ("                          SPEC 8-1 The character cannot run outside the map!                                    ");
	                $display ("                        				Pattern No. %3d                                                   ",patcount);
                    $display ("                        				Path No. %3d                                                           ",cnt);
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                #(100)
	                $finish;
            end
            else if(map[row + 1][col + 1] == 1)begin 
                    fail;
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                $display ("                          SPEC 8-2 The character  must avoid hitting lower obstacles.                           ");
	                $display ("                        				Pattern No. %3d                                                   ",patcount);
                    $display ("                        				Path No. %3d                                                           ",cnt);
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                #(100)
	                $finish;
            end
            else if(map[row + 1][col + 1] == 2)begin 
                    fail;
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                $display ("                          SPEC 8-3 The character  must avoid hitting higher obstacles.                          ");
	                $display ("                        				Pattern No. %3d                                                   ",patcount);
                    $display ("                        				Path No. %3d                                                           ",cnt);
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                #(100)
	                $finish;
            end
            else if(map[row + 1][col + 1] == 3)begin 
                    fail;
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                $display ("                          SPEC 8-4 The character  must avoid hitting trains.                                    ");
	                $display ("                        				Pattern No. %3d                                                   ",patcount);
                    $display ("                        				Path No. %3d                                                           ",cnt);
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                #(100)
	                $finish;
            end
            else begin
                current_row = row + 1;
                current_col = col + 1;
            end
        end
        
        //turn left
        else if(out == 2'd2)begin
            if(row == 0)begin 
                	fail;
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                $display ("                          SPEC 8-1 The character cannot run outside the map!                                    ");
	                $display ("                        				Pattern No. %3d                                                   ",patcount);
                    $display ("                        				Path No. %3d                                                           ",cnt);
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                #(100)
	                $finish;
            end
           else if(map[row - 1][col + 1] == 1)begin 
                    fail;
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                $display ("                          SPEC 8-2 The character  must avoid hitting lower obstacles.                           ");
	                $display ("                        				Pattern No. %3d                                                   ",patcount);
                    $display ("                        				Path No. %3d                                                           ",cnt);
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                #(100)
	                $finish;
            end
            else if(map[row - 1][col + 1] == 2)begin 
                    fail;
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                $display ("                          SPEC 8-3 The character  must avoid hitting higher obstacles.                          ");
	                $display ("                        				Pattern No. %3d                                                   ",patcount);
                    $display ("                        				Path No. %3d                                                           ",cnt);
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                #(100)
	                $finish;
            end
            else if(map[row - 1][col + 1] == 3)begin 
                    fail;
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                $display ("                          SPEC 8-4 The character  must avoid hitting trains.                                    ");
	                $display ("                        				Pattern No. %3d                                                   ",patcount);
                    $display ("                        				Path No. %3d                                                           ",cnt);
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                #(100)
	                $finish;
            end
            else begin
                current_row = row - 1;
                current_col = col + 1;
            end
        end
        
        //jump
        else if(out == 2'd3)begin
            if(map[row][col + 1] == 2) begin 
                    fail;
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                $display ("                          SPEC 8-3 The character  must avoid hitting higher obstacles.                          ");
	                $display ("                        				Pattern No. %3d                                                   ",patcount);
                    $display ("                        				Path No. %3d                                                           ",cnt);
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                #(100)
	                $finish;
            end
            else if(map[row][col + 1] == 3)begin 
                    fail;
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                $display ("                          SPEC 8-4 The character  must avoid hitting trains.                                    ");
	                $display ("                        				Pattern No. %3d                                                   ",patcount);
                    $display ("                        				Path No. %3d                                                           ",cnt);
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                #(100)
	                $finish;
            end
            else if(map[row][col] == 1)begin 
                    fail;
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                $display ("                          SPEC 8-5  you are on a lower obstacle , you cannot use jump                           ");
	                $display ("                        				Pattern No. %3d                                                   ",patcount);
                    $display ("                        				Path No. %3d                                                           ",cnt);
	                $display ("----------------------------------------------------------------------------------------------------------------");
	                #(100)
	                $finish;
            end
            else begin
                current_row = row ;
                current_col = col + 1;
            end
        end
        cnt = cnt + 1;
        @(negedge clk);
    end
end endtask


//SPEC 3
task reset_task ; begin
	#(0.5); rst_n = 0;

	#(2.0);
	if(out_valid !== 0 || out !== 0) begin
		fail;
		$display ("-------------------------------------------------------------------------------");
		$display ("                                 RESET  FAIL!                                  ");
		$display ( "                 out_valid and out should be 0 after initial RESET            ");
		$display ( "------------------------------------------------------------------------------");
		#(100);
	    $finish ;
	end
	
	#(1.0); rst_n = 1 ;
	#(3.0); release clk;
end endtask

//SPEC 4
task check_out_while_output; begin

	if(out_valid === 0 && out !== 0) begin
	fail;
	$display ("-----------------------------------------------------------------------------------------------------");
	$display ("                          					FAIL!                                              		");
	$display ("                        			out should be 0 while out_valid is low                 		        ");
	$display ("-----------------------------------------------------------------------------------------------------");
	#(100)
	$finish;
	end
	
end endtask


//SPEC 5
task check_out_while_input; begin

	if(in_valid===1 && out_valid!==0) begin
	fail;
	$display ("-----------------------------------------------------------------------------------------------------");
	$display ("                          					FAIL!                                              		");
	$display ("                        			out_valid should be 0 while in_valid is high                  		");
	$display ("-----------------------------------------------------------------------------------------------------");
	#(100)
	$finish;
	end
	
end endtask

//SPEC 6
task wait_out_valid ; begin
	
    delay = 0;

	while(out_valid !== 1) begin
		@(negedge clk);
		delay = delay + 1;
		
		if(delay == 3000)	begin
			fail;
			$display ("-------------------------------------------------------------------------");
			$display ("                             FAIL! 		                                ");
			$display ("          out_valid is not pulled high after 3000 CYCLE                  ");
			$display ("-------------------------------------------------------------------------");
			#(100);
		    $finish ;
		end
	end

	total_delay = total_delay + delay;

end endtask

//SPEC 7
task out_check ; begin
	
    cnt = 0;

	while(out_valid == 1) begin
		@(posedge clk);
		cnt = cnt + 1;
		
		if(cnt  > 63 )	begin
			fail;
			$display ("-----------------------------------------------------------------------------------------");
			$display ("                             FAIL! 		                                                ");
			$display ("          out_valid and out must be asserted successively in 63 cycles                   ");
			$display ("-----------------------------------------------------------------------------------------");
			#(100);
		    $finish ;
		end
	end

end endtask


task YOU_PASS_task;begin
$display("\033[37m                                                                                                                                          ");        
$display("\033[37m                                                                                \033[32m      :BBQvi.                                              ");        
$display("\033[37m                                                              .i7ssrvs7         \033[32m     BBBBBBBBQi                                           ");        
$display("\033[37m                        .:r7rrrr:::.        .::::::...   .i7vr:.      .B:       \033[32m    :BBBP :7BBBB.                                         ");        
$display("\033[37m                      .Kv.........:rrvYr7v7rr:.....:rrirJr.   .rgBBBBg  Bi      \033[32m    BBBB     BBBB                                         ");        
$display("\033[37m                     7Q  :rubEPUri:.       ..:irrii:..    :bBBBBBBBBBBB  B      \033[32m   iBBBv     BBBB       vBr                               ");        
$display("\033[37m                    7B  BBBBBBBBBBBBBBB::BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB :R     \033[32m   BBBBBKrirBBBB.     :BBBBBB:                            ");        
$display("\033[37m                   Jd .BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB: Bi    \033[32m  rBBBBBBBBBBBR.    .BBBM:BBB                             ");        
$display("\033[37m                  uZ .BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB .B    \033[32m  BBBB   .::.      EBBBi :BBU                             ");        
$display("\033[37m                 7B .BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB  B    \033[32m MBBBr           vBBBu   BBB.                             ");        
$display("\033[37m                .B  BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB: JJ   \033[32m i7PB          iBBBBB.  iBBB                              ");        
$display("\033[37m                B. BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB  Lu             \033[32m  vBBBBPBBBBPBBB7       .7QBB5i                ");        
$display("\033[37m               Y1 KBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBi XBBBBBBBi :B            \033[32m :RBBB.  .rBBBBB.      rBBBBBBBB7              ");        
$display("\033[37m              :B .BBBBBBBBBBBBBsRBBBBBBBBBBBrQBBBBB. UBBBRrBBBBBBr 1BBBBBBBBB  B.          \033[32m    .       BBBB       BBBB  :BBBB             ");        
$display("\033[37m              Bi BBBBBBBBBBBBBi :BBBBBBBBBBE .BBK.  .  .   QBBBBBBBBBBBBBBBBBB  Bi         \033[32m           rBBBr       BBBB    BBBU            ");        
$display("\033[37m             .B .BBBBBBBBBBBBBBQBBBBBBBBBBBB       \033[38;2;242;172;172mBBv \033[37m.LBBBBBBBBBBBBBBBBBBBBBB. B7.:ii:   \033[32m           vBBB        .BBBB   :7i.            ");        
$display("\033[37m            .B  PBBBBBBBBBBBBBBBBBBBBBBBBBBBBbYQB. \033[38;2;242;172;172mBB: \033[37mBBBBBBBBBBBBBBBBBBBBBBBBB  Jr:::rK7 \033[32m             .7  BBB7   iBBBg                  ");        
$display("\033[37m           7M  PBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB  \033[38;2;242;172;172mBB. \033[37mBBBBBBBBBBBBBBBBBBBBBBB..i   .   v1                  \033[32mdBBB.   5BBBr                 ");        
$display("\033[37m          sZ .BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB  \033[38;2;242;172;172mBB. \033[37mBBBBBBBBBBBBBBBBBBBBBBBBBBB iD2BBQL.                 \033[32m ZBBBr  EBBBv     YBBBBQi     ");        
$display("\033[37m  .7YYUSIX5 .BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB  \033[38;2;242;172;172mBB. \033[37mBBBBBBBBBBBBBBBBBBBBBBBBY.:.      :B                 \033[32m  iBBBBBBBBD     BBBBBBBBB.   ");        
$display("\033[37m LB.        ..BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB. \033[38;2;242;172;172mBB: \033[37mBBBBBBBBBBBBBBBBBBBBBBBBMBBB. BP17si                 \033[32m    :LBBBr      vBBBi  5BBB   ");        
$display("\033[37m  KvJPBBB :BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB: \033[38;2;242;172;172mZB: \033[37mBBBBBBBBBBBBBBBBBBBBBBBBBsiJr .i7ssr:                \033[32m          ...   :BBB:   BBBu  ");        
$display("\033[37m i7ii:.   ::BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBj \033[38;2;242;172;172muBi \033[37mQBBBBBBBBBBBBBBBBBBBBBBBBi.ir      iB                \033[32m         .BBBi   BBBB   iMBu  ");        
$display("\033[37mDB    .  vBdBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBg \033[38;2;242;172;172m7Bi \033[37mBBBBBBBBBBBBBBBBBBBBBBBBBBBBB rBrXPv.                \033[32m          BBBX   :BBBr        ");        
$display("\033[37m :vQBBB. BQBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBQ \033[38;2;242;172;172miB: \033[37mBBBBBBBBBBBBBBBBBBBBBBBBBBBBB .L:ii::irrrrrrrr7jIr   \033[32m          .BBBv  :BBBQ        ");        
$display("\033[37m :7:.   .. 5BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB  \033[38;2;242;172;172mBr \033[37mBBBBBBBBBBBBBBBBBBBBBBBBBBBB:            ..... ..YB. \033[32m           .BBBBBBBBB:        ");        
$display("\033[37mBU  .:. BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB  \033[38;2;242;172;172mB7 \033[37mgBBBBBBBBBBBBBBBBBBBBBBBBBB. gBBBBBBBBBBBBBBBBBB. BL \033[32m             rBBBBB1.         ");        
$display("\033[37m rY7iB: BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB: \033[38;2;242;172;172mB7 \033[37mBBBBBBBBBBBBBBBBBBBBBBBBBB. QBBBBBBBBBBBBBBBBBi  v5                                ");        
$display("\033[37m     us EBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB \033[38;2;242;172;172mIr \033[37mBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBgu7i.:BBBBBBBr Bu                                 ");        
$display("\033[37m      B  7BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB.\033[38;2;242;172;172m:i \033[37mBBBBBBBBBBBBBBBBBBBBBBBBBBBv:.  .. :::  .rr    rB                                  ");        
$display("\033[37m      us  .BBBBBBBBBBBBBQLXBBBBBBBBBBBBBBBBBBBBBBBBq  .BBBBBBBBBBBBBBBBBBBBBBBBBv  :iJ7vri:::1Jr..isJYr                                   ");        
$display("\033[37m      B  BBBBBBB  MBBBM      qBBBBBBBBBBBBBBBBBBBBBB: BBBBBBBBBBBBBBBBBBBBBBBBBB  B:           iir:                                       ");        
$display("\033[37m     iB iBBBBBBBL       BBBP. :BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB  B.                                                       ");        
$display("\033[37m     P: BBBBBBBBBBB5v7gBBBBBB  BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB: Br                                                        ");        
$display("\033[37m     B  BBBs 7BBBBBBBBBBBBBB7 :BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB .B                                                         ");        
$display("\033[37m    .B :BBBB.  EBBBBBQBBBBBJ .BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB. B.                                                         ");        
$display("\033[37m    ij qBBBBBg          ..  .BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB .B                                                          ");        
$display("\033[37m    UY QBBBBBBBBSUSPDQL...iBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBK EL                                                          ");        
$display("\033[37m    B7 BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB: B:                                                          ");        
$display("\033[37m    B  BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBYrBB vBBBBBBBBBBBBBBBBBBBBBBBB. Ls                                                          ");        
$display("\033[37m    B  BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBi_  /UBBBBBBBBBBBBBBBBBBBBBBBBB. :B:                                                        ");        
$display("\033[37m   rM .BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB  ..IBBBBBBBBBBBBBBBBQBBBBBBBBBB  B                                                        ");        
$display("\033[37m   B  BBBBBBBBBdZBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBPBBBBBBBBBBBBEji:..     sBBBBBBBr Br                                                       ");        
$display("\033[37m  7B 7BBBBBBBr     .:vXQBBBBBBBBBBBBBBBBBBBBBBBBBQqui::..  ...i:i7777vi  BBBBBBr Bi                                                       ");        
$display("\033[37m  Ki BBBBBBB  rY7vr:i....  .............:.....  ...:rii7vrr7r:..      7B  BBBBB  Bi                                                       ");        
$display("\033[37m  B. BBBBBB  B:    .::ir77rrYLvvriiiiiiirvvY7rr77ri:..                 bU  iQBB:..rI                                                      ");        
$display("\033[37m.S: 7BBBBP  B.                                                          vI7.  .:.  B.                                                     ");        
$display("\033[37mB: ir:.   :B.                                                             :rvsUjUgU.                                                      ");        
$display("\033[37mrMvrrirJKur                                                                                                                               \033[m");
$display ("-----------------------------------------------------------------------------------------------------------------------------------");
$display ("                                                  Congratulations!                						                          ");
$display ("                                           You have passed all patterns!          						                          ");
$display ("                                           Total latency: %d cycles                						             ", total_delay);
$display ("-----------------------------------------------------------------------------------------------------------------------------------");

$finish;	
end endtask

task fail; begin
$display("\033[38;2;252;238;238m                                                                                                                                           ");      
$display("\033[38;2;252;238;238m                                                                                                :L777777v7.                                ");
$display("\033[31m  i:..::::::i.      :::::         ::::    .:::.       \033[38;2;252;238;238m                                       .vYr::::::::i7Lvi                             ");
$display("\033[31m  BBBBBBBBBBBi     iBBBBBL       .BBBB    7BBB7       \033[38;2;252;238;238m                                      JL..\033[38;2;252;172;172m:r777v777i::\033[38;2;252;238;238m.ijL                           ");
$display("\033[31m  BBBB.::::ir.     BBB:BBB.      .BBBv    iBBB:       \033[38;2;252;238;238m                                    :K: \033[38;2;252;172;172miv777rrrrr777v7:.\033[38;2;252;238;238m:J7                         ");
$display("\033[31m  BBBQ            :BBY iBB7       BBB7    :BBB:       \033[38;2;252;238;238m                                   :d \033[38;2;252;172;172m.L7rrrrrrrrrrrrr77v: \033[38;2;252;238;238miI.                       ");
$display("\033[31m  BBBB            BBB. .BBB.      BBB7    :BBB:       \033[38;2;252;238;238m                                  .B \033[38;2;252;172;172m.L7rrrrrrrrrrrrrrrrr7v..\033[38;2;252;238;238mBr                      ");
$display("\033[31m  BBBB:r7vvj:    :BBB   gBBs      BBB7    :BBB:       \033[38;2;252;238;238m                                  S:\033[38;2;252;172;172m v7rrrrrrrrrrrrrrrrrrr7v. \033[38;2;252;238;238mB:                     ");
$display("\033[31m  BBBBBBBBBB7    BBB:   .BBB.     BBB7    :BBB:       \033[38;2;252;238;238m                                 .D \033[38;2;252;172;172mi7rrrrrrr777rrrrrrrrrrr7v. \033[38;2;252;238;238mB.                    ");
$display("\033[31m  BBBB    ..    iBBBBBBBBBBBP     BBB7    :BBB:       \033[38;2;252;238;238m                                 rv\033[38;2;252;172;172m v7rrrrrr7rirv7rrrrrrrrrr7v \033[38;2;252;238;238m:I                    ");
$display("\033[31m  BBBB          BBBBi7vviQBBB.    BBB7    :BBB.       \033[38;2;252;238;238m                                 2i\033[38;2;252;172;172m.v7rrrrrr7i  :v7rrrrrrrrrrvi \033[38;2;252;238;238mB:                   ");
$display("\033[31m  BBBB         rBBB.      BBBQ   .BBBv    iBBB2ir777L7\033[38;2;252;238;238m                                 2i.\033[38;2;252;172;172mv7rrrrrr7v \033[38;2;252;238;238m:..\033[38;2;252;172;172mv7rrrrrrrrr77 \033[38;2;252;238;238mrX                   ");
$display("\033[31m .BBBB        :BBBB       BBBB7  .BBBB    7BBBBBBBBBBB\033[38;2;252;238;238m                                 Yv \033[38;2;252;172;172mv7rrrrrrrv.\033[38;2;252;238;238m.B \033[38;2;252;172;172m.vrrrrrrrrrrL.\033[38;2;252;238;238m:5                   ");
$display("\033[31m  . ..        ....         ...:   ....    ..   .......\033[38;2;252;238;238m                                 .q \033[38;2;252;172;172mr7rrrrrrr7i \033[38;2;252;238;238mPv \033[38;2;252;172;172mi7rrrrrrrrrv.\033[38;2;252;238;238m:S                   ");
$display("\033[38;2;252;238;238m                                                                                        Lr \033[38;2;252;172;172m77rrrrrr77 \033[38;2;252;238;238m:B. \033[38;2;252;172;172mv7rrrrrrrrv.\033[38;2;252;238;238m:S                   ");
$display("\033[38;2;252;238;238m                                                                                         B: \033[38;2;252;172;172m7v7rrrrrv. \033[38;2;252;238;238mBY \033[38;2;252;172;172mi7rrrrrrr7v \033[38;2;252;238;238miK                   ");
$display("\033[38;2;252;238;238m                                                                              .::rriii7rir7. \033[38;2;252;172;172m.r77777vi \033[38;2;252;238;238m7B  \033[38;2;252;172;172mvrrrrrrr7r \033[38;2;252;238;238m2r                   ");
$display("\033[38;2;252;238;238m                                                                       .:rr7rri::......    .     \033[38;2;252;172;172m.:i7s \033[38;2;252;238;238m.B. \033[38;2;252;172;172mv7rrrrr7L..\033[38;2;252;238;238mB                    ");
$display("\033[38;2;252;238;238m                                                        .::7L7rriiiirr77rrrrrrrr72BBBBBBBBBBBBvi:..  \033[38;2;252;172;172m.  \033[38;2;252;238;238mBr \033[38;2;252;172;172m77rrrrrvi \033[38;2;252;238;238mKi                    ");
$display("\033[38;2;252;238;238m                                                    :rv7i::...........    .:i7BBBBQbPPPqPPPdEZQBBBBBr:.\033[38;2;252;238;238m ii \033[38;2;252;172;172mvvrrrrvr \033[38;2;252;238;238mvs                     ");
$display("\033[38;2;252;238;238m                    .S77L.                      .rvi:. ..:r7QBBBBBBBBBBBgri.    .:BBBPqqKKqqqqPPPPPEQBBBZi  \033[38;2;252;172;172m:777vi \033[38;2;252;238;238mvI                      ");
$display("\033[38;2;252;238;238m                    B: ..Jv                   isi. .:rBBBBBQZPPPPqqqPPdERBBBBBi.    :BBRKqqqqqqqqqqqqPKDDBB:  \033[38;2;252;172;172m:7. \033[38;2;252;238;238mJr                       ");
$display("\033[38;2;252;238;238m                   vv SB: iu                rL: .iBBBQEPqqPPqqqqqqqqqqqqqPPPPbQBBB:   .EBQKqqqqqqPPPqqKqPPgBB:  .B:                        ");
$display("\033[38;2;252;238;238m                  :R  BgBL..s7            rU: .qBBEKPqqqqqqqqqqqqqqqqqqqqqqqqqPPPEBBB:   EBEPPPEgQBBQEPqqqqKEBB: .s                        ");
$display("\033[38;2;252;238;238m               .U7.  iBZBBBi :ji         5r .MBQqPqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqPKgBB:  .BBBBBdJrrSBBQKqqqqKZB7  I:                      ");
$display("\033[38;2;252;238;238m              v2. :rBBBB: .BB:.ru7:    :5. rBQqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqPPBB:  :.        .5BKqqqqqqBB. Kr                     ");
$display("\033[38;2;252;238;238m             .B .BBQBB.   .RBBr  :L77ri2  BBqPqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqPbBB   \033[38;2;252;172;172m.irrrrri  \033[38;2;252;238;238mQQqqqqqqKRB. 2i                    ");
$display("\033[38;2;252;238;238m              27 :BBU  rBBBdB \033[38;2;252;172;172m iri::::: \033[38;2;252;238;238m.BQKqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqKRBs\033[38;2;252;172;172mirrr7777L: \033[38;2;252;238;238m7BqqqqqqqXZB. BLv772i              ");
$display("\033[38;2;252;238;238m               rY  PK  .:dPMB \033[38;2;252;172;172m.Y77777r.\033[38;2;252;238;238m:BEqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqPPBqi\033[38;2;252;172;172mirrrrrv: \033[38;2;252;238;238muBqqqqqqqqqgB  :.:. B:             ");
$display("\033[38;2;252;238;238m                iu 7BBi  rMgB \033[38;2;252;172;172m.vrrrrri\033[38;2;252;238;238mrBEqKqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqPQgi\033[38;2;252;172;172mirrrrv. \033[38;2;252;238;238mQQqqqqqqqqqXBb .BBB .s:.           ");
$display("\033[38;2;252;238;238m                i7 BBdBBBPqbB \033[38;2;252;172;172m.vrrrri\033[38;2;252;238;238miDgPPbPqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqPQDi\033[38;2;252;172;172mirr77 \033[38;2;252;238;238m:BdqqqqqqqqqqPB. rBB. .:iu7         ");
$display("\033[38;2;252;238;238m                iX.:iBRKPqKXB.\033[38;2;252;172;172m 77rrr\033[38;2;252;238;238mi7QPBBBBPqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqPB7i\033[38;2;252;172;172mrr7r \033[38;2;252;238;238m.vBBPPqqqqqqKqBZ  BPBgri: 1B        ");
$display("\033[38;2;252;238;238m                 ivr .BBqqKXBi \033[38;2;252;172;172mr7rri\033[38;2;252;238;238miQgQi   QZKqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqPEQi\033[38;2;252;172;172mirr7r.  \033[38;2;252;238;238miBBqPqqqqqqPB:.QPPRBBB LK        ");
$display("\033[38;2;252;238;238m                   :I. iBgqgBZ \033[38;2;252;172;172m:7rr\033[38;2;252;238;238miJQPB.   gRqqqqqqqqPPPPPPPPqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqPQ7\033[38;2;252;172;172mirrr7vr.  \033[38;2;252;238;238mUBqqPPgBBQPBBKqqqKB  B         ");
$display("\033[38;2;252;238;238m                     v7 .BBR: \033[38;2;252;172;172m.r7ri\033[38;2;252;238;238miggqPBrrBBBBBBBBBBBBBBBBBBQEPPqqPPPqqqqqqqqqqqqqqqqqqqqqqqqqPgPi\033[38;2;252;172;172mirrrr7v7  \033[38;2;252;238;238mrBPBBP:.LBbPqqqqqB. u.        ");
$display("\033[38;2;252;238;238m                      .j. . \033[38;2;252;172;172m :77rr\033[38;2;252;238;238miiBPqPbBB::::::.....:::iirrSBBBBBBBQZPPPPPqqqqqqqqqqqqqqqqqqqqEQi\033[38;2;252;172;172mirrrrrr7v \033[38;2;252;238;238m.BB:     :BPqqqqqDB .B        ");
$display("\033[38;2;252;238;238m                       YL \033[38;2;252;172;172m.i77rrrr\033[38;2;252;238;238miLQPqqKQJ. \033[38;2;252;172;172m ............       \033[38;2;252;238;238m..:irBBBBBBZPPPqqqqqqqPPBBEPqqqdRr\033[38;2;252;172;172mirrrrrr7v \033[38;2;252;238;238m.B  .iBB  dQPqqqqPBi Y:       ");
$display("\033[38;2;252;238;238m                     :U:.\033[38;2;252;172;172mrv7rrrrri\033[38;2;252;238;238miPgqqqqKZB.\033[38;2;252;172;172m.v77777777777777ri::..   \033[38;2;252;238;238m  ..:rBBBBQPPqqqqPBUvBEqqqPRr\033[38;2;252;172;172mirrrrrrvi\033[38;2;252;238;238m iB:RBBbB7 :BQqPqKqBR r7       ");
$display("\033[38;2;252;238;238m                    iI.\033[38;2;252;172;172m.v7rrrrrrri\033[38;2;252;238;238midgqqqqqKB:\033[38;2;252;172;172m 77rrrrrrrrrrrrr77777777ri:..   \033[38;2;252;238;238m .:1BBBEPPB:   BbqqPQr\033[38;2;252;172;172mirrrr7vr\033[38;2;252;238;238m .BBBZPqqDB  .JBbqKPBi vi       ");
$display("\033[38;2;252;238;238m                   :B \033[38;2;252;172;172miL7rrrrrrrri\033[38;2;252;238;238mibgqqqqqqBr\033[38;2;252;172;172m r7rrrrrrrrrrrrrrrrrrrrr777777ri:.  \033[38;2;252;238;238m .iBBBBi  .BbqqdRr\033[38;2;252;172;172mirr7v7: \033[38;2;252;238;238m.Bi.dBBPqqgB:  :BPqgB  B        ");
$display("\033[38;2;252;238;238m                   .K.i\033[38;2;252;172;172mv7rrrrrrrri\033[38;2;252;238;238miZgqqqqqqEB \033[38;2;252;172;172m.vrrrrrrrrrrrrrrrrrrrrrrrrrrr777vv7i.  \033[38;2;252;238;238m :PBBBBPqqqEQ\033[38;2;252;172;172miir77:  \033[38;2;252;238;238m:BB:  .rBPqqEBB. iBZB. Rr        ");
$display("\033[38;2;252;238;238m                    iM.:\033[38;2;252;172;172mv7rrrrrrrri\033[38;2;252;238;238mUQPqqqqqPBi\033[38;2;252;172;172m i7rrrrrrrrrrrrrrrrrrrrrrrrr77777i.   \033[38;2;252;238;238m.  :BddPqqqqEg\033[38;2;252;172;172miir7. \033[38;2;252;238;238mrBBPqBBP. :BXKqgB  BBB. 2r         ");
$display("\033[38;2;252;238;238m                     :U:.\033[38;2;252;172;172miv77rrrrri\033[38;2;252;238;238mrBPqqqqqqPB: \033[38;2;252;172;172m:7777rrrrrrrrrrrrrrr777777ri.   \033[38;2;252;238;238m.:uBBBBZPqqqqqqPQL\033[38;2;252;172;172mirr77 \033[38;2;252;238;238m.BZqqPB:  qMqqPB. Yv:  Ur          ");
$display("\033[38;2;252;238;238m                       1L:.\033[38;2;252;172;172m:77v77rii\033[38;2;252;238;238mqQPqqqqqPbBi \033[38;2;252;172;172m .ir777777777777777ri:..   \033[38;2;252;238;238m.:rBBBRPPPPPqqqqqqqgQ\033[38;2;252;172;172miirr7vr \033[38;2;252;238;238m:BqXQ: .BQPZBBq ...:vv.           ");
$display("\033[38;2;252;238;238m                         LJi..\033[38;2;252;172;172m::r7rii\033[38;2;252;238;238mRgKPPPPqPqBB:.  \033[38;2;252;172;172m ............     \033[38;2;252;238;238m..:rBBBBPPqqKKKKqqqPPqPbB1\033[38;2;252;172;172mrvvvvvr  \033[38;2;252;238;238mBEEDQBBBBBRri. 7JLi              ");
$display("\033[38;2;252;238;238m                           .jL\033[38;2;252;172;172m  777rrr\033[38;2;252;238;238mBBBBBBgEPPEBBBvri:::::::::irrrbBBBBBBDPPPPqqqqqqXPPZQBBBBr\033[38;2;252;172;172m.......\033[38;2;252;238;238m.:BBBBg1ri:....:rIr                 ");
$display("\033[38;2;252;238;238m                            vI \033[38;2;252;172;172m:irrr:....\033[38;2;252;238;238m:rrEBBBBBBBBBBBBBBBBBBBBBBBBBBBBBQQBBBBBBBBBBBBBQr\033[38;2;252;172;172mi:...:.   \033[38;2;252;238;238m.:ii:.. .:.:irri::                    ");
$display("\033[38;2;252;238;238m                             71vi\033[38;2;252;172;172m:::irrr::....\033[38;2;252;238;238m    ...:..::::irrr7777777777777rrii::....  ..::irvrr7sUJYv7777v7ii..                         ");
$display("\033[38;2;252;238;238m                               .i777i. ..:rrri77rriiiiiii:::::::...............:::iiirr7vrrr:.                                             ");
$display("\033[38;2;252;238;238m                                                      .::::::::::::::::::::::::::::::                                                      \033[m");

end endtask

endmodule