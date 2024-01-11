module CC(
  in_s0,
  in_s1,
  in_s2,
  in_s3,
  in_s4,
  in_s5,
  in_s6,
  opt,
  a,
  b,
  s_id0,
  s_id1,
  s_id2,
  s_id3,
  s_id4,
  s_id5,
  s_id6,
  out

);
input [3:0]in_s0;
input [3:0]in_s1;
input [3:0]in_s2;
input [3:0]in_s3;
input [3:0]in_s4;
input [3:0]in_s5;
input [3:0]in_s6;
input [2:0]opt;
input [1:0]a;
input [2:0]b;
output [2:0] s_id0;
output [2:0] s_id1;
output [2:0] s_id2;
output [2:0] s_id3;
output [2:0] s_id4;
output [2:0] s_id5;
output [2:0] s_id6;
output [2:0] out; 
//==================================================================
// reg & wire
//==================================================================
wire signed [6:0] s0,s1,s2,s3,s4,s5,s6;
wire signed [6:0] z0,z1,z2,z3,z4,z5,z6;
wire signed [6:0] y0,y1,y2,y3,y4,y5,y6;
wire signed [6:0] x0,x1,x2,x3,x4,x5,x6;
wire signed [6:0] w0,w1,w2,w3,w4,w5,w6;
wire signed [6:0] v0,v1,v2,v3,v4,v5,v6;
wire signed [6:0] u0,u1,u2,u3,u4,u5,u6;
wire signed [6:0] t0,t1,t2,t3,t4,t5,t6;

wire signed [3:0] c0_s0,c1_s0,c2_s0,c3_s0,c4_s0,c5_s0,c6_s0;
wire signed [3:0] c0_s1,c1_s1,c2_s1,c3_s1,c4_s1,c5_s1,c6_s1;
wire signed [3:0] c0_s2,c1_s2,c2_s2,c3_s2,c4_s2,c5_s2,c6_s2;
wire signed [3:0] c0_s3,c1_s3,c2_s3,c3_s3,c4_s3,c5_s3,c6_s3;
wire signed [3:0] c0_s4,c1_s4,c2_s4,c3_s4,c4_s4,c5_s4,c6_s4;
wire signed [3:0] c0_s5,c1_s5,c2_s5,c3_s5,c4_s5,c5_s5,c6_s5;
wire signed [3:0] c0_s6,c1_s6,c2_s6,c3_s6,c4_s6,c5_s6,c6_s6;
wire signed [3:0] c0_s7,c1_s7,c2_s7,c3_s7,c4_s7,c5_s7,c6_s7;
wire signed [8:0] lt0,lt1,lt2,lt3,lt4,lt5,lt6;

wire  [6:0] u_s0,u_s1,u_s2,u_s3,u_s4,u_s5,u_s6;
wire  [6:0] u_z0,u_z1,u_z2,u_z3,u_z4,u_z5,u_z6;
wire  [6:0] u_y0,u_y1,u_y2,u_y3,u_y4,u_y5,u_y6;
wire  [6:0] u_x0,u_x1,u_x2,u_x3,u_x4,u_x5,u_x6;
wire  [6:0] u_w0,u_w1,u_w2,u_w3,u_w4,u_w5,u_w6;
wire  [6:0] u_v0,u_v1,u_v2,u_v3,u_v4,u_v5,u_v6;
wire  [6:0] u_u0,u_u1,u_u2,u_u3,u_u4,u_u5,u_u6;
wire  [6:0] u_t0,u_t1,u_t2,u_t3,u_t4,u_t5,u_t6;

wire [3:0] c0_us0,c1_us0,c2_us0,c3_us0,c4_us0,c5_us0,c6_us0;
wire [3:0] c0_us1,c1_us1,c2_us1,c3_us1,c4_us1,c5_us1,c6_us1;
wire [3:0] c0_us2,c1_us2,c2_us2,c3_us2,c4_us2,c5_us2,c6_us2;
wire [3:0] c0_us3,c1_us3,c2_us3,c3_us3,c4_us3,c5_us3,c6_us3;
wire [3:0] c0_us4,c1_us4,c2_us4,c3_us4,c4_us4,c5_us4,c6_us4;
wire [3:0] c0_us5,c1_us5,c2_us5,c3_us5,c4_us5,c5_us5,c6_us5;
wire [3:0] c0_us6,c1_us6,c2_us6,c3_us6,c4_us6,c5_us6,c6_us6;
wire [3:0] c0_us7,c1_us7,c2_us7,c3_us7,c4_us7,c5_us7,c6_us7;
wire [8:0] u_lt0,u_lt1,u_lt2,u_lt3,u_lt4,u_lt5,u_lt6;

wire  [5:0] u_avg;
wire  [5:0] u_ps;

wire [6:0] a_u;
wire [4:0] b_u;

wire signed [3:0] neg_0,neg_1,neg_2,neg_3,neg_4,neg_5,neg_6;
wire signed [4:0] avg,ps;

wire signed [6:0] a_s;
wire signed [4:0] b_s;

wire [2:0] u_sid0,u_sid1,u_sid2,u_sid3,u_sid4,u_sid5,u_sid6;
wire [2:0] u_r0,u_r1,u_r2,u_r3,u_r4,u_r5,u_r6;

wire u_pf0,u_pf1,u_pf2,u_pf3,u_pf4,u_pf5,u_pf6;
wire [3:0] u_count;

wire [2:0] sid0,sid1,sid2,sid3,sid4,sid5,sid6;
wire [2:0] r0,r1,r2,r3,r4,r5,r6;

wire pf0,pf1,pf2,pf3,pf4,pf5,pf6;
wire [3:0]count; 

//==================================================================
// design
//==================================================================
assign neg_0 = in_s0; 
assign neg_1 = in_s1; 
assign neg_2 = in_s2; 
assign neg_3 = in_s3; 
assign neg_4 = in_s4; 
assign neg_5 = in_s5; 
assign neg_6 = in_s6; 

assign c0_s0 = (opt[0] && in_s0[3])?(neg_0):(in_s0);
assign c1_s0 = (opt[0] && in_s1[3])?(neg_1):(in_s1);
assign c2_s0 = (opt[0] && in_s2[3])?(neg_2):(in_s2);
assign c3_s0 = (opt[0] && in_s3[3])?(neg_3):(in_s3);
assign c4_s0 = (opt[0] && in_s4[3])?(neg_4):(in_s4);
assign c5_s0 = (opt[0] && in_s5[3])?(neg_5):(in_s5);
assign c6_s0 = (opt[0] && in_s6[3])?(neg_6):(in_s6);

assign s0 = {3'b000,c0_s0};
assign s1 = {3'b001,c1_s0};
assign s2 = {3'b010,c2_s0};
assign s3 = {3'b011,c3_s0};
assign s4 = {3'b100,c4_s0};
assign s5 = {3'b101,c5_s0};
assign s6 = {3'b110,c6_s0};

assign c0_s1 = z0[3:0];
assign c1_s1 = z1[3:0];
assign c2_s1 = z2[3:0];
assign c3_s1 = z3[3:0];
assign c4_s1 = z4[3:0];
assign c5_s1 = z5[3:0];
assign c6_s1 = z6[3:0];

assign c0_s2 = y0[3:0];
assign c1_s2 = y1[3:0];
assign c2_s2 = y2[3:0];
assign c3_s2 = y3[3:0];
assign c4_s2 = y4[3:0];
assign c5_s2 = y5[3:0];
assign c6_s2 = y6[3:0];

assign c0_s3 = x0[3:0];
assign c1_s3 = x1[3:0];
assign c2_s3 = x2[3:0];
assign c3_s3 = x3[3:0];
assign c4_s3 = x4[3:0];
assign c5_s3 = x5[3:0];
assign c6_s3 = x6[3:0];

assign c0_s4 = w0[3:0];
assign c1_s4 = w1[3:0];
assign c2_s4 = w2[3:0];
assign c3_s4 = w3[3:0];
assign c4_s4 = w4[3:0];
assign c5_s4 = w5[3:0];
assign c6_s4 = w6[3:0];

assign c0_s5 = v0[3:0];
assign c1_s5 = v1[3:0];
assign c2_s5 = v2[3:0];
assign c3_s5 = v3[3:0];
assign c4_s5 = v4[3:0];
assign c5_s5 = v5[3:0];
assign c6_s5 = v6[3:0];

assign c0_s6 = u0[3:0];
assign c1_s6 = u1[3:0];
assign c2_s6 = u2[3:0];
assign c3_s6 = u3[3:0];
assign c4_s6 = u4[3:0];
assign c5_s6 = u5[3:0];
assign c6_s6 = u6[3:0];

assign c0_s7 = t0[3:0];
assign c1_s7 = t1[3:0];
assign c2_s7 = t2[3:0];
assign c3_s7 = t3[3:0];
assign c4_s7 = t4[3:0];
assign c5_s7 = t5[3:0];
assign c6_s7 = t6[3:0];

assign sid0 = t0[6:4];
assign sid1 = t1[6:4];
assign sid2 = t2[6:4];
assign sid3 = t3[6:4];
assign sid4 = t4[6:4];
assign sid5 = t5[6:4];
assign sid6 = t6[6:4];

assign r0 = ((c0_s7 == c1_s7)&&(sid0 > sid1))?(sid1):(sid0);
assign r1 = ((c1_s7 == c2_s7)&&(sid1 > sid2))?(sid2):(sid1);
assign r2 = ((c2_s7 == c3_s7)&&(sid2 > sid3))?(sid3):(sid2);
assign r3 = ((c3_s7 == c4_s7)&&(sid3 > sid4))?(sid4):(sid3);
assign r4 = ((c4_s7 == c5_s7)&&(sid4 > sid5))?(sid5):(sid4);
assign r5 = ((c5_s7 == c6_s7)&&(sid5 > sid6))?(sid6):(sid5);
assign r6 = ((c5_s7 == c6_s7)&&(sid5 > sid6))?(sid5):(sid6);

assign avg = (c0_s7 + c1_s7 + c2_s7 + c3_s7 + c4_s7 + c5_s7 + c6_s7) / 7;
assign ps = avg - a;

assign a_s = a + 1;
assign b_s = b;

assign lt0 = (c0_s7 < 0)?((c0_s7/a_s)+b_s):((a_s*c0_s7)+b_s);
assign lt1 = (c1_s7 < 0)?((c1_s7/a_s)+b_s):((a_s*c1_s7)+b_s);
assign lt2 = (c2_s7 < 0)?((c2_s7/a_s)+b_s):((a_s*c2_s7)+b_s);
assign lt3 = (c3_s7 < 0)?((c3_s7/a_s)+b_s):((a_s*c3_s7)+b_s);
assign lt4 = (c4_s7 < 0)?((c4_s7/a_s)+b_s):((a_s*c4_s7)+b_s);
assign lt5 = (c5_s7 < 0)?((c5_s7/a_s)+b_s):((a_s*c5_s7)+b_s);
assign lt6 = (c6_s7 < 0)?((c6_s7/a_s)+b_s):((a_s*c6_s7)+b_s);

assign pf0 = (lt0 >= ps)?1:0;
assign pf1 = (lt1 >= ps)?1:0;
assign pf2 = (lt2 >= ps)?1:0;
assign pf3 = (lt3 >= ps)?1:0;
assign pf4 = (lt4 >= ps)?1:0;
assign pf5 = (lt5 >= ps)?1:0;
assign pf6 = (lt6 >= ps)?1:0;

assign count = (opt[2]== 0) ? (pf0 + pf1 + pf2 + pf3 + pf4 + pf5 + pf6):(7 - pf0 - pf1 - pf2 - pf3 - pf4 - pf5 - pf6); 


assign z0 = (opt[1] == 0) ? ((c0_s0 > c1_s0) ? s1 : s0 ): ((c0_s0 < c1_s0) ? s1 : s0 );
assign z1 = (opt[1] == 0) ? ((c0_s0 > c1_s0) ? s0 : s1 ): ((c0_s0 < c1_s0) ? s0 : s1 );
assign z2 = (opt[1] == 0) ? ((c2_s0 > c3_s0) ? s3 : s2 ): ((c2_s0 < c3_s0) ? s3 : s2 );
assign z3 = (opt[1] == 0) ? ((c2_s0 > c3_s0) ? s2 : s3 ): ((c2_s0 < c3_s0) ? s2 : s3 );
assign z4 = (opt[1] == 0) ? ((c4_s0 > c5_s0) ? s5 : s4 ): ((c4_s0 < c5_s0) ? s5 : s4 );
assign z5 = (opt[1] == 0) ? ((c4_s0 > c5_s0) ? s4 : s5 ): ((c4_s0 < c5_s0) ? s4 : s5 );
assign z6 = s6;

assign y0 = z0;
assign y1 = (opt[1] == 0) ? ((c1_s1 > c2_s1) ? z2 : z1 ): ((c1_s1 < c2_s1) ? z2 : z1 );
assign y2 = (opt[1] == 0) ? ((c1_s1 > c2_s1) ? z1 : z2 ): ((c1_s1 < c2_s1) ? z1 : z2 );
assign y3 = (opt[1] == 0) ? ((c3_s1 > c4_s1) ? z4 : z3 ): ((c3_s1 < c4_s1) ? z4 : z3 );
assign y4 = (opt[1] == 0) ? ((c3_s1 > c4_s1) ? z3 : z4 ): ((c3_s1 < c4_s1) ? z3 : z4 );
assign y5 = (opt[1] == 0) ? ((c5_s1 > c6_s1) ? z6 : z5 ): ((c5_s1 < c6_s1) ? z6 : z5 );
assign y6 = (opt[1] == 0) ? ((c5_s1 > c6_s1) ? z5 : z6 ): ((c5_s1 < c6_s1) ? z5 : z6 );

assign x0 = (opt[1] == 0) ? ((c0_s2 > c1_s2) ? y1 : y0 ): ((c0_s2 < c1_s2) ? y1 : y0 );
assign x1 = (opt[1] == 0) ? ((c0_s2 > c1_s2) ? y0 : y1 ): ((c0_s2 < c1_s2) ? y0 : y1 );
assign x2 = (opt[1] == 0) ? ((c2_s2 > c3_s2) ? y3 : y2 ): ((c2_s2 < c3_s2) ? y3 : y2 );
assign x3 = (opt[1] == 0) ? ((c2_s2 > c3_s2) ? y2 : y3 ): ((c2_s2 < c3_s2) ? y2 : y3 );
assign x4 = (opt[1] == 0) ? ((c4_s2 > c5_s2) ? y5 : y4 ): ((c4_s2 < c5_s2) ? y5 : y4 );
assign x5 = (opt[1] == 0) ? ((c4_s2 > c5_s2) ? y4 : y5 ): ((c4_s2 < c5_s2) ? y4 : y5 );
assign x6 = y6;

assign w0 = x0;
assign w1 = (opt[1] == 0) ? ((c1_s3 > c2_s3) ? x2 : x1 ): ((c1_s3 < c2_s3) ? x2 : x1 );
assign w2 = (opt[1] == 0) ? ((c1_s3 > c2_s3) ? x1 : x2 ): ((c1_s3 < c2_s3) ? x1 : x2 );
assign w3 = (opt[1] == 0) ? ((c3_s3 > c4_s3) ? x4 : x3 ): ((c3_s3 < c4_s3) ? x4 : x3 );
assign w4 = (opt[1] == 0) ? ((c3_s3 > c4_s3) ? x3 : x4 ): ((c3_s3 < c4_s3) ? x3 : x4 );
assign w5 = (opt[1] == 0) ? ((c5_s3 > c6_s3) ? x6 : x5 ): ((c5_s3 < c6_s3) ? x6 : x5 );
assign w6 = (opt[1] == 0) ? ((c5_s3 > c6_s3) ? x5 : x6 ): ((c5_s3 < c6_s3) ? x5 : x6 );

assign v0 = (opt[1] == 0) ? ((c0_s4 > c1_s4) ? w1 : w0 ): ((c0_s4 < c1_s4) ? w1 : w0 );
assign v1 = (opt[1] == 0) ? ((c0_s4 > c1_s4) ? w0 : w1 ): ((c0_s4 < c1_s4) ? w0 : w1 );
assign v2 = (opt[1] == 0) ? ((c2_s4 > c3_s4) ? w3 : w2 ): ((c2_s4 < c3_s4) ? w3 : w2 );
assign v3 = (opt[1] == 0) ? ((c2_s4 > c3_s4) ? w2 : w3 ): ((c2_s4 < c3_s4) ? w2 : w3 );
assign v4 = (opt[1] == 0) ? ((c4_s4 > c5_s4) ? w5 : w4 ): ((c4_s4 < c5_s4) ? w5 : w4 );
assign v5 = (opt[1] == 0) ? ((c4_s4 > c5_s4) ? w4 : w5 ): ((c4_s4 < c5_s4) ? w4 : w5 );
assign v6 = w6;

assign u0 = v0;
assign u1 = (opt[1] == 0) ? ((c1_s5 > c2_s5) ? v2 : v1 ): ((c1_s5 < c2_s5) ? v2 : v1 );
assign u2 = (opt[1] == 0) ? ((c1_s5 > c2_s5) ? v1 : v2 ): ((c1_s5 < c2_s5) ? v1 : v2 );
assign u3 = (opt[1] == 0) ? ((c3_s5 > c4_s5) ? v4 : v3 ): ((c3_s5 < c4_s5) ? v4 : v3 );
assign u4 = (opt[1] == 0) ? ((c3_s5 > c4_s5) ? v3 : v4 ): ((c3_s5 < c4_s5) ? v3 : v4 );
assign u5 = (opt[1] == 0) ? ((c5_s5 > c6_s5) ? v6 : v5 ): ((c5_s5 < c6_s5) ? v6 : v5 );
assign u6 = (opt[1] == 0) ? ((c5_s5 > c6_s5) ? v5 : v6 ): ((c5_s5 < c6_s5) ? v5 : v6 );

assign t0 = (opt[1] == 0) ? ((c0_s6 > c1_s6) ? u1 : u0 ): ((c0_s6 < c1_s6) ? u1 : u0 );
assign t1 = (opt[1] == 0) ? ((c0_s6 > c1_s6) ? u0 : u1 ): ((c0_s6 < c1_s6) ? u0 : u1 );
assign t2 = (opt[1] == 0) ? ((c2_s6 > c3_s6) ? u3 : u2 ): ((c2_s6 < c3_s6) ? u3 : u2 );
assign t3 = (opt[1] == 0) ? ((c2_s6 > c3_s6) ? u2 : u3 ): ((c2_s6 < c3_s6) ? u2 : u3 );
assign t4 = (opt[1] == 0) ? ((c4_s6 > c5_s6) ? u5 : u4 ): ((c4_s6 < c5_s6) ? u5 : u4 );
assign t5 = (opt[1] == 0) ? ((c4_s6 > c5_s6) ? u4 : u5 ): ((c4_s6 < c5_s6) ? u4 : u5 );
assign t6 = u6;


assign c0_us0 = in_s0;
assign c1_us0 = in_s1;
assign c2_us0 = in_s2;
assign c3_us0 = in_s3;
assign c4_us0 = in_s4;
assign c5_us0 = in_s5;
assign c6_us0 = in_s6;

assign u_s0 = {3'b000,c0_us0};
assign u_s1 = {3'b001,c1_us0};
assign u_s2 = {3'b010,c2_us0};
assign u_s3 = {3'b011,c3_us0};
assign u_s4 = {3'b100,c4_us0};
assign u_s5 = {3'b101,c5_us0};
assign u_s6 = {3'b110,c6_us0};

assign c0_us1 = u_z0[3:0];
assign c1_us1 = u_z1[3:0];
assign c2_us1 = u_z2[3:0];
assign c3_us1 = u_z3[3:0];
assign c4_us1 = u_z4[3:0];
assign c5_us1 = u_z5[3:0];
assign c6_us1 = u_z6[3:0];

assign c0_us2 = u_y0[3:0];
assign c1_us2 = u_y1[3:0];
assign c2_us2 = u_y2[3:0];
assign c3_us2 = u_y3[3:0];
assign c4_us2 = u_y4[3:0];
assign c5_us2 = u_y5[3:0];
assign c6_us2 = u_y6[3:0];

assign c0_us3 = u_x0[3:0];
assign c1_us3 = u_x1[3:0];
assign c2_us3 = u_x2[3:0];
assign c3_us3 = u_x3[3:0];
assign c4_us3 = u_x4[3:0];
assign c5_us3 = u_x5[3:0];
assign c6_us3 = u_x6[3:0];

assign c0_us4 = u_w0[3:0];
assign c1_us4 = u_w1[3:0];
assign c2_us4 = u_w2[3:0];
assign c3_us4 = u_w3[3:0];
assign c4_us4 = u_w4[3:0];
assign c5_us4 = u_w5[3:0];
assign c6_us4 = u_w6[3:0];

assign c0_us5 = u_v0[3:0];
assign c1_us5 = u_v1[3:0];
assign c2_us5 = u_v2[3:0];
assign c3_us5 = u_v3[3:0];
assign c4_us5 = u_v4[3:0];
assign c5_us5 = u_v5[3:0];
assign c6_us5 = u_v6[3:0];

assign c0_us6 = u_u0[3:0];
assign c1_us6 = u_u1[3:0];
assign c2_us6 = u_u2[3:0];
assign c3_us6 = u_u3[3:0];
assign c4_us6 = u_u4[3:0];
assign c5_us6 = u_u5[3:0];
assign c6_us6 = u_u6[3:0];

assign c0_us7 = u_t0[3:0];
assign c1_us7 = u_t1[3:0];
assign c2_us7 = u_t2[3:0];
assign c3_us7 = u_t3[3:0];
assign c4_us7 = u_t4[3:0];
assign c5_us7 = u_t5[3:0];
assign c6_us7 = u_t6[3:0];

assign u_sid0 = u_t0[6:4];
assign u_sid1 = u_t1[6:4];
assign u_sid2 = u_t2[6:4];
assign u_sid3 = u_t3[6:4];
assign u_sid4 = u_t4[6:4];
assign u_sid5 = u_t5[6:4];
assign u_sid6 = u_t6[6:4];

assign u_z0 = (opt[1] == 0) ? ((c0_us0 > c1_us0) ? u_s1 : u_s0 ): ((c0_us0 < c1_us0) ? u_s1 : u_s0 );
assign u_z1 = (opt[1] == 0) ? ((c0_us0 > c1_us0) ? u_s0 : u_s1 ): ((c0_us0 < c1_us0) ? u_s0 : u_s1 );
assign u_z2 = (opt[1] == 0) ? ((c2_us0 > c3_us0) ? u_s3 : u_s2 ): ((c2_us0 < c3_us0) ? u_s3 : u_s2 );
assign u_z3 = (opt[1] == 0) ? ((c2_us0 > c3_us0) ? u_s2 : u_s3 ): ((c2_us0 < c3_us0) ? u_s2 : u_s3 );
assign u_z4 = (opt[1] == 0) ? ((c4_us0 > c5_us0) ? u_s5 : u_s4 ): ((c4_us0 < c5_us0) ? u_s5 : u_s4 );
assign u_z5 = (opt[1] == 0) ? ((c4_us0 > c5_us0) ? u_s4 : u_s5 ): ((c4_us0 < c5_us0) ? u_s4 : u_s5 );
assign u_z6 = u_s6;

assign u_y0 = u_z0;
assign u_y1 = (opt[1] == 0) ? ((c1_us1 > c2_us1) ? u_z2 : u_z1 ): ((c1_us1 < c2_us1) ? u_z2 : u_z1 );
assign u_y2 = (opt[1] == 0) ? ((c1_us1 > c2_us1) ? u_z1 : u_z2 ): ((c1_us1 < c2_us1) ? u_z1 : u_z2 );
assign u_y3 = (opt[1] == 0) ? ((c3_us1 > c4_us1) ? u_z4 : u_z3 ): ((c3_us1 < c4_us1) ? u_z4 : u_z3 );
assign u_y4 = (opt[1] == 0) ? ((c3_us1 > c4_us1) ? u_z3 : u_z4 ): ((c3_us1 < c4_us1) ? u_z3 : u_z4 );
assign u_y5 = (opt[1] == 0) ? ((c5_us1 > c6_us1) ? u_z6 : u_z5 ): ((c5_us1 < c6_us1) ? u_z6 : u_z5 );
assign u_y6 = (opt[1] == 0) ? ((c5_us1 > c6_us1) ? u_z5 : u_z6 ): ((c5_us1 < c6_us1) ? u_z5 : u_z6 );

assign u_x0 = (opt[1] == 0) ? ((c0_us2 > c1_us2) ? u_y1 : u_y0 ): ((c0_us2 < c1_us2) ? u_y1 : u_y0 );
assign u_x1 = (opt[1] == 0) ? ((c0_us2 > c1_us2) ? u_y0 : u_y1 ): ((c0_us2 < c1_us2) ? u_y0 : u_y1 );
assign u_x2 = (opt[1] == 0) ? ((c2_us2 > c3_us2) ? u_y3 : u_y2 ): ((c2_us2 < c3_us2) ? u_y3 : u_y2 );
assign u_x3 = (opt[1] == 0) ? ((c2_us2 > c3_us2) ? u_y2 : u_y3 ): ((c2_us2 < c3_us2) ? u_y2 : u_y3 );
assign u_x4 = (opt[1] == 0) ? ((c4_us2 > c5_us2) ? u_y5 : u_y4 ): ((c4_us2 < c5_us2) ? u_y5 : u_y4 );
assign u_x5 = (opt[1] == 0) ? ((c4_us2 > c5_us2) ? u_y4 : u_y5 ): ((c4_us2 < c5_us2) ? u_y4 : u_y5 );
assign u_x6 = u_y6;

assign u_w0 = u_x0;
assign u_w1 = (opt[1] == 0) ? ((c1_us3 > c2_us3) ? u_x2 : u_x1 ): ((c1_us3 < c2_us3) ? u_x2 : u_x1 );
assign u_w2 = (opt[1] == 0) ? ((c1_us3 > c2_us3) ? u_x1 : u_x2 ): ((c1_us3 < c2_us3) ? u_x1 : u_x2 );
assign u_w3 = (opt[1] == 0) ? ((c3_us3 > c4_us3) ? u_x4 : u_x3 ): ((c3_us3 < c4_us3) ? u_x4 : u_x3 );
assign u_w4 = (opt[1] == 0) ? ((c3_us3 > c4_us3) ? u_x3 : u_x4 ): ((c3_us3 < c4_us3) ? u_x3 : u_x4 );
assign u_w5 = (opt[1] == 0) ? ((c5_us3 > c6_us3) ? u_x6 : u_x5 ): ((c5_us3 < c6_us3) ? u_x6 : u_x5 );
assign u_w6 = (opt[1] == 0) ? ((c5_us3 > c6_us3) ? u_x5 : u_x6 ): ((c5_us3 < c6_us3) ? u_x5 : u_x6 );

assign u_v0 = (opt[1] == 0) ? ((c0_us4 > c1_us4) ? u_w1 : u_w0 ): ((c0_us4 < c1_us4) ? u_w1 : u_w0 );
assign u_v1 = (opt[1] == 0) ? ((c0_us4 > c1_us4) ? u_w0 : u_w1 ): ((c0_us4 < c1_us4) ? u_w0 : u_w1 );
assign u_v2 = (opt[1] == 0) ? ((c2_us4 > c3_us4) ? u_w3 : u_w2 ): ((c2_us4 < c3_us4) ? u_w3 : u_w2 );
assign u_v3 = (opt[1] == 0) ? ((c2_us4 > c3_us4) ? u_w2 : u_w3 ): ((c2_us4 < c3_us4) ? u_w2 : u_w3 );
assign u_v4 = (opt[1] == 0) ? ((c4_us4 > c5_us4) ? u_w5 : u_w4 ): ((c4_us4 < c5_us4) ? u_w5 : u_w4 );
assign u_v5 = (opt[1] == 0) ? ((c4_us4 > c5_us4) ? u_w4 : u_w5 ): ((c4_us4 < c5_us4) ? u_w4 : u_w5 );
assign u_v6 = u_w6;

assign u_u0 = u_v0;
assign u_u1 = (opt[1] == 0) ? ((c1_us5 > c2_us5) ? u_v2 : u_v1 ): ((c1_us5 < c2_us5) ? u_v2 : u_v1 );
assign u_u2 = (opt[1] == 0) ? ((c1_us5 > c2_us5) ? u_v1 : u_v2 ): ((c1_us5 < c2_us5) ? u_v1 : u_v2 );
assign u_u3 = (opt[1] == 0) ? ((c3_us5 > c4_us5) ? u_v4 : u_v3 ): ((c3_us5 < c4_us5) ? u_v4 : u_v3 );
assign u_u4 = (opt[1] == 0) ? ((c3_us5 > c4_us5) ? u_v3 : u_v4 ): ((c3_us5 < c4_us5) ? u_v3 : u_v4 );
assign u_u5 = (opt[1] == 0) ? ((c5_us5 > c6_us5) ? u_v6 : u_v5 ): ((c5_us5 < c6_us5) ? u_v6 : u_v5 );
assign u_u6 = (opt[1] == 0) ? ((c5_us5 > c6_us5) ? u_v5 : u_v6 ): ((c5_us5 < c6_us5) ? u_v5 : u_v6 );

assign u_t0 = (opt[1] == 0) ? ((c0_us6 > c1_us6) ? u_u1 : u_u0 ): ((c0_us6 < c1_us6) ? u_u1 : u_u0 );
assign u_t1 = (opt[1] == 0) ? ((c0_us6 > c1_us6) ? u_u0 : u_u1 ): ((c0_us6 < c1_us6) ? u_u0 : u_u1 );
assign u_t2 = (opt[1] == 0) ? ((c2_us6 > c3_us6) ? u_u3 : u_u2 ): ((c2_us6 < c3_us6) ? u_u3 : u_u2 );
assign u_t3 = (opt[1] == 0) ? ((c2_us6 > c3_us6) ? u_u2 : u_u3 ): ((c2_us6 < c3_us6) ? u_u2 : u_u3 );
assign u_t4 = (opt[1] == 0) ? ((c4_us6 > c5_us6) ? u_u5 : u_u4 ): ((c4_us6 < c5_us6) ? u_u5 : u_u4 );
assign u_t5 = (opt[1] == 0) ? ((c4_us6 > c5_us6) ? u_u4 : u_u5 ): ((c4_us6 < c5_us6) ? u_u4 : u_u5 );
assign u_t6 = u_u6;

assign u_r0 = ((c0_us7 == c1_us7)&&(u_sid0 > u_sid1))?(u_sid1):(u_sid0);
assign u_r1 = ((c1_us7 == c2_us7)&&(u_sid1 > u_sid2))?(u_sid2):(u_sid1);
assign u_r2 = ((c2_us7 == c3_us7)&&(u_sid2 > u_sid3))?(u_sid3):(u_sid2);
assign u_r3 = ((c3_us7 == c4_us7)&&(u_sid3 > u_sid4))?(u_sid4):(u_sid3);
assign u_r4 = ((c4_us7 == c5_us7)&&(u_sid4 > u_sid5))?(u_sid5):(u_sid4);
assign u_r5 = ((c5_us7 == c6_us7)&&(u_sid5 > u_sid6))?(u_sid6):(u_sid5);
assign u_r6 = ((c5_us7 == c6_us7)&&(u_sid5 > u_sid6))?(u_sid5):(u_sid6);

assign u_avg = (c0_us7 + c1_us7 + c2_us7 + c3_us7 + c4_us7 + c5_us7 + c6_us7) / 7;
assign u_ps = (u_avg < a)?(0):(u_avg - a);

assign a_u = a + 1;
assign b_u = b;

assign u_lt0 = (c0_us7 < 0)?((c0_us7/a_u)+b_u):((a_u*c0_us7)+b_u);
assign u_lt1 = (c1_us7 < 0)?((c1_us7/a_u)+b_u):((a_u*c1_us7)+b_u);
assign u_lt2 = (c2_us7 < 0)?((c2_us7/a_u)+b_u):((a_u*c2_us7)+b_u);
assign u_lt3 = (c3_us7 < 0)?((c3_us7/a_u)+b_u):((a_u*c3_us7)+b_u);
assign u_lt4 = (c4_us7 < 0)?((c4_us7/a_u)+b_u):((a_u*c4_us7)+b_u);
assign u_lt5 = (c5_us7 < 0)?((c5_us7/a_u)+b_u):((a_u*c5_us7)+b_u);
assign u_lt6 = (c6_us7 < 0)?((c6_us7/a_u)+b_u):((a_u*c6_us7)+b_u);

assign u_pf0 = (u_lt0 >= u_ps)?1:0;
assign u_pf1 = (u_lt1 >= u_ps)?1:0;
assign u_pf2 = (u_lt2 >= u_ps)?1:0;
assign u_pf3 = (u_lt3 >= u_ps)?1:0;
assign u_pf4 = (u_lt4 >= u_ps)?1:0;
assign u_pf5 = (u_lt5 >= u_ps)?1:0;
assign u_pf6 = (u_lt6 >= u_ps)?1:0;

assign u_count = (opt[2]== 0)?(u_pf0 + u_pf1 + u_pf2 + u_pf3 + u_pf4 + u_pf5 + u_pf6):(7 - u_pf0 - u_pf1 - u_pf2 - u_pf3 - u_pf4 - u_pf5 - u_pf6);


assign out = (opt[0] == 1) ? ( count ):( u_count );

assign s_id0 = (opt[0] == 1)? r0 : u_r0;
assign s_id1 = (opt[0] == 1)? r1 : u_r1;
assign s_id2 = (opt[0] == 1)? r2 : u_r2;
assign s_id3 = (opt[0] == 1)? r3 : u_r3;
assign s_id4 = (opt[0] == 1)? r4 : u_r4;
assign s_id5 = (opt[0] == 1)? r5 : u_r5;
assign s_id6 = (opt[0] == 1)? r6 : u_r6;

endmodule
