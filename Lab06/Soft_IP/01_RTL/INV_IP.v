//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    (C) Copyright Optimum Application-Specific Integrated System Laboratory
//    All Right Reserved
//		Date		: 2023/03
//		Version		: v1.0
//   	File Name   : INV_IP.v
//   	Module Name : INV_IP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module INV_IP #(parameter IP_WIDTH = 7) (
    // Input signals
    IN_1, IN_2,
    // Output signals
    OUT_INV
);

// ===============================================================
// Declaration
// ===============================================================
input  [IP_WIDTH-1:0] IN_1, IN_2;
output [IP_WIDTH-1:0] OUT_INV;

// ===============================================================
// Parameters
// ===============================================================


// ===============================================================
// Soft IP DESIGN
// ===============================================================

wire[IP_WIDTH-1 : 0] mod [1:126];
reg [IP_WIDTH-1:0] inverse;

genvar  node_idx;
generate
        for(node_idx = 1; node_idx < 127; node_idx = node_idx + 1)begin:gen_node
                assign mod [node_idx] =  (IN_1 > IN_2) ? IN_2 * node_idx % IN_1 :  IN_1 * node_idx  % IN_2;
        end 
endgenerate
        
            
           always@(*)begin 
                if(mod[1] == 1) inverse = 1;
                else if(mod[2] == 1) inverse = 2;
                else if(mod[3] == 1) inverse = 3;
                else if(mod[4] == 1) inverse = 4;
                else if(mod[5] == 1) inverse = 5;
                else if(mod[6] == 1) inverse = 6;
                else if(mod[7] == 1) inverse = 7;
                else if(mod[8] == 1) inverse = 8;
                else if(mod[9] == 1) inverse = 9;
                else if(mod[10] == 1) inverse = 10;
                else if(mod[11] == 1) inverse = 11;
                else if(mod[12] == 1) inverse = 12;
                else if(mod[13] == 1) inverse = 13;
                else if(mod[14] == 1) inverse = 14;
                else if(mod[15] == 1) inverse = 15;
                else if(mod[16] == 1) inverse = 16;
                else if(mod[17] == 1) inverse = 17;
                else if(mod[18] == 1) inverse = 18;
                else if(mod[19] == 1) inverse = 19;
                else if(mod[20] == 1) inverse = 20;
                else if(mod[21] == 1) inverse = 21;
                else if(mod[22] == 1) inverse = 22;
                else if(mod[23] == 1) inverse = 23;
                else if(mod[24] == 1) inverse = 24;
                else if(mod[25] == 1) inverse = 25;
                else if(mod[26] == 1) inverse = 26;

                else if(mod[27] == 1) inverse = 27;
                else if(mod[28] == 1) inverse = 28;
                else if(mod[29] == 1) inverse = 29;
                else if(mod[30] == 1) inverse = 30;
                else if(mod[31] == 1) inverse = 31;
                else if(mod[32] == 1) inverse = 32;
                else if(mod[33] == 1) inverse = 33;
                else if(mod[34] == 1) inverse = 34;
                else if(mod[35] == 1) inverse = 35;
                else if(mod[36] == 1) inverse = 36;
                else if(mod[37] == 1) inverse = 37;
                else if(mod[38] == 1) inverse = 38;
                else if(mod[39] == 1) inverse = 39;
                else if(mod[40] == 1) inverse = 40;
                else if(mod[41] == 1) inverse = 41;
                else if(mod[42] == 1) inverse = 42;

                else if(mod[43] == 1) inverse = 43;
                else if(mod[44] == 1) inverse = 44;
                else if(mod[45] == 1) inverse = 45;
                else if(mod[46] == 1) inverse = 46;
                else if(mod[47] == 1) inverse = 47;
                else if(mod[48] == 1) inverse = 48;
                else if(mod[49] == 1) inverse = 49;
                else if(mod[50] == 1) inverse = 50;
                else if(mod[51] == 1) inverse = 51;
                else if(mod[52] == 1) inverse = 52;
                else if(mod[53] == 1) inverse = 53;
                else if(mod[54] == 1) inverse = 54;
                else if(mod[55] == 1) inverse = 55;
                else if(mod[56] == 1) inverse = 56;
                else if(mod[57] == 1) inverse = 57;
                else if(mod[58] == 1) inverse = 58;
                else if(mod[59] == 1) inverse = 59;
                else if(mod[60] == 1) inverse = 60;
                else if(mod[61] == 1) inverse = 61;
                else if(mod[62] == 1) inverse = 62;
                else if(mod[63] == 1) inverse = 63;

                else if(mod[64] == 1) inverse = 64;
                else if(mod[65] == 1) inverse = 65;
                else if(mod[66] == 1) inverse = 66;
                else if(mod[67] == 1) inverse = 67;
                else if(mod[68] == 1) inverse = 68;
                else if(mod[69] == 1) inverse = 69;
                else if(mod[70] == 1) inverse = 70;
                else if(mod[71] == 1) inverse = 71;
                else if(mod[72] == 1) inverse = 72;
                else if(mod[73] == 1) inverse = 73;
                else if(mod[74] == 1) inverse = 74;
                else if(mod[75] == 1) inverse = 75;
                else if(mod[76] == 1) inverse = 76;
                else if(mod[77] == 1) inverse = 77;
                else if(mod[78] == 1) inverse = 78;
                else if(mod[79] == 1) inverse = 79;
                else if(mod[80] == 1) inverse = 80;
                else if(mod[81] == 1) inverse = 81;
                else if(mod[82] == 1) inverse = 82;
                else if(mod[83] == 1) inverse = 83;
                else if(mod[84] == 1) inverse = 84;

                else if(mod[85] == 1) inverse = 85;
                else if(mod[86] == 1) inverse = 86;
                else if(mod[87] == 1) inverse = 87;
                else if(mod[88] == 1) inverse = 88;
                else if(mod[89] == 1) inverse = 89;
                else if(mod[90] == 1) inverse = 90;
                else if(mod[91] == 1) inverse = 91;
                else if(mod[92] == 1) inverse = 92;
                else if(mod[93] == 1) inverse = 93;
                else if(mod[94] == 1) inverse = 94;
                else if(mod[95] == 1) inverse = 95;
                else if(mod[96] == 1) inverse = 96;
                else if(mod[97] == 1) inverse = 97;
                else if(mod[98] == 1) inverse = 98;
                else if(mod[99] == 1) inverse = 99;
                
                else if(mod[100] == 1) inverse = 100;
                else if(mod[101] == 1) inverse = 101;
                else if(mod[102] == 1) inverse = 102;
                else if(mod[103] == 1) inverse = 103;
                else if(mod[104] == 1) inverse = 104;
                else if(mod[105] == 1) inverse = 105;
                else if(mod[106] == 1) inverse = 106;
                else if(mod[107] == 1) inverse = 107;
                else if(mod[108] == 1) inverse = 108;
                else if(mod[109] == 1) inverse = 109;
                else if(mod[110] == 1) inverse = 110;
                else if(mod[111] == 1) inverse = 111;
                else if(mod[112] == 1) inverse = 112;
                else if(mod[113] == 1) inverse = 113;
                else if(mod[114] == 1) inverse = 114;
                else if(mod[115] == 1) inverse = 115;
                else if(mod[116] == 1) inverse = 116;
                else if(mod[117] == 1) inverse = 117;
                else if(mod[118] == 1) inverse = 118;
                else if(mod[119] == 1) inverse = 119;
                else if(mod[120] == 1) inverse = 120;
                else if(mod[121] == 1) inverse = 121;
                else if(mod[122] == 1) inverse = 122;
                else if(mod[123] == 1) inverse = 123;
                else if(mod[124] == 1) inverse = 124;
                else if(mod[125] == 1) inverse = 125;
                else if(mod[126] == 1) inverse = 126;

                else inverse = 0;
           end

assign OUT_INV = inverse;



endmodule