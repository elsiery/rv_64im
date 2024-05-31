/*
MIT License

Copyright (c) 2024 Elsie Rezinold Y

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
`include "onetwoeightbit_lca.v"
module multiplier_lca (
    clk,
    rst_n,
    valid,
    unsigned_a,
    a,
    unsigned_b,
    b,
    out_valid,
    c
);

input [63:0] a,b;
output [127:0] c;
input clk,rst_n;
input valid;
input unsigned_a;
input unsigned_b;
reg valid_d1;
reg valid_d2;
output out_valid;
wire sign_a;
wire sign_b;
wire sign_c;
wire [63:0] valid_a,valid_b;

wire [127:0] valid_c;
wire [127:0] c_final;
wire [63:0] b_revert;
wire [63:0] a_revert;
wire [127:0] p0,p1,p2,p3,p4,p5,p6,p7,p8,p9;
wire [127:0] p10,p11,p12,p13,p14,p15,p16,p17,p18,p19;
wire [127:0] p20,p21,p22,p23,p24,p25,p26,p27,p28,p29;
wire [127:0] p30,p31,p32,p33,p34,p35,p36,p37,p38,p39;
wire [127:0] p40,p41,p42,p43,p44,p45,p46,p47,p48,p49;
wire [127:0] p50,p51,p52,p53,p54,p55,p56,p57,p58,p59;
wire [127:0] p60,p61,p62,p63;
assign b_revert = !unsigned_b ? !b[63] ? b : ~b + 1'b1 : b;
assign a_revert = !unsigned_a ? !a[63] ? a : ~a + 1'b1 : a;
assign valid_a = a_revert[63:0];
assign valid_b = b_revert[63:0];
assign sign_a = a[63];
assign sign_b = b[63];
assign p0 = (valid_a & {{64{valid_b[0]}}})     ;
assign p1 = (valid_a & {{64{valid_b[1]}}}) << 1;
assign p2 = (valid_a & {{64{valid_b[2]}}}) << 2;
assign p3 = (valid_a & {{64{valid_b[3]}}}) << 3;
assign p4 = (valid_a & {{64{valid_b[4]}}}) << 4;
assign p5 = (valid_a & {{64{valid_b[5]}}}) << 5;
assign p6 = (valid_a & {{64{valid_b[6]}}}) << 6;
assign p7 = (valid_a & {{64{valid_b[7]}}}) << 7;
assign p8 = (valid_a & {{64{valid_b[8]}}}) << 8;
assign p9 = (valid_a & {{64{valid_b[9]}}}) << 9;

assign p10 = (valid_a & {{64{valid_b[10]}}}) << 10;
assign p11 = (valid_a & {{64{valid_b[11]}}}) << 11;
assign p12 = (valid_a & {{64{valid_b[12]}}}) << 12;
assign p13 = (valid_a & {{64{valid_b[13]}}}) << 13;
assign p14 = (valid_a & {{64{valid_b[14]}}}) << 14;
assign p15 = (valid_a & {{64{valid_b[15]}}}) << 15;
assign p16 = (valid_a & {{64{valid_b[16]}}}) << 16;
assign p17 = (valid_a & {{64{valid_b[17]}}}) << 17;
assign p18 = (valid_a & {{64{valid_b[18]}}}) << 18;
assign p19 = (valid_a & {{64{valid_b[19]}}}) << 19;

assign p20 = (valid_a & {{64{valid_b[20]}}}) << 20;
assign p21 = (valid_a & {{64{valid_b[21]}}}) << 21;
assign p22 = (valid_a & {{64{valid_b[22]}}}) << 22;
assign p23 = (valid_a & {{64{valid_b[23]}}}) << 23;
assign p24 = (valid_a & {{64{valid_b[24]}}}) << 24;
assign p25 = (valid_a & {{64{valid_b[25]}}}) << 25;
assign p26 = (valid_a & {{64{valid_b[26]}}}) << 26;
assign p27 = (valid_a & {{64{valid_b[27]}}}) << 27;
assign p28 = (valid_a & {{64{valid_b[28]}}}) << 28;
assign p29 = (valid_a & {{64{valid_b[29]}}}) << 29;

assign p30 = (valid_a & {{64{valid_b[30]}}}) << 30;
assign p31 = (valid_a & {{64{valid_b[31]}}}) << 31;
assign p32 = (valid_a & {{64{valid_b[32]}}}) << 32;
assign p33 = (valid_a & {{64{valid_b[33]}}}) << 33;
assign p34 = (valid_a & {{64{valid_b[34]}}}) << 34;
assign p35 = (valid_a & {{64{valid_b[35]}}}) << 35;
assign p36 = (valid_a & {{64{valid_b[36]}}}) << 36;
assign p37 = (valid_a & {{64{valid_b[37]}}}) << 37;
assign p38 = (valid_a & {{64{valid_b[38]}}}) << 38;
assign p39 = (valid_a & {{64{valid_b[39]}}}) << 39;

assign p40 = (valid_a & {{64{valid_b[40]}}}) << 40;
assign p41 = (valid_a & {{64{valid_b[41]}}}) << 41;
assign p42 = (valid_a & {{64{valid_b[42]}}}) << 42;
assign p43 = (valid_a & {{64{valid_b[43]}}}) << 43;
assign p44 = (valid_a & {{64{valid_b[44]}}}) << 44;
assign p45 = (valid_a & {{64{valid_b[45]}}}) << 45;
assign p46 = (valid_a & {{64{valid_b[46]}}}) << 46;
assign p47 = (valid_a & {{64{valid_b[47]}}}) << 47;
assign p48 = (valid_a & {{64{valid_b[48]}}}) << 48;
assign p49 = (valid_a & {{64{valid_b[49]}}}) << 49;

assign p50 = (valid_a & {{64{valid_b[50]}}}) << 50;
assign p51 = (valid_a & {{64{valid_b[51]}}}) << 51;
assign p52 = (valid_a & {{64{valid_b[52]}}}) << 52;
assign p53 = (valid_a & {{64{valid_b[53]}}}) << 53;
assign p54 = (valid_a & {{64{valid_b[54]}}}) << 54;
assign p55 = (valid_a & {{64{valid_b[55]}}}) << 55;
assign p56 = (valid_a & {{64{valid_b[56]}}}) << 56;
assign p57 = (valid_a & {{64{valid_b[57]}}}) << 57;
assign p58 = (valid_a & {{64{valid_b[58]}}}) << 58;
assign p59 = (valid_a & {{64{valid_b[59]}}}) << 59;

assign p60 = (valid_a & {{64{valid_b[60]}}}) << 60;
assign p61 = (valid_a & {{64{valid_b[61]}}}) << 61;
assign p62 = (valid_a & {{64{valid_b[62]}}}) << 62;
assign p63 = (valid_a & {{64{valid_b[63]}}}) << 63;


wire [127:0] r0,r1,r2,r3;
wire [127:0] r4,r5,r6,r7;
wire [127:0] r8,r9,r10,r11;
wire [127:0] r12,r13,r14,r15;
wire [127:0] r16,r17,r18,r19;
wire [127:0] r20,r21,r22,r23;
wire [127:0] r24,r25,r26,r27;
wire [127:0] r28,r29,r30,r31;
wire carry ;
assign carry = 0;


onetwoeightbit_lca uut_0 (
    p0,
    p1,
    carry,
    r0
);


onetwoeightbit_lca uut_1 (
    p2,
    p3,
    carry,
    r1
);
onetwoeightbit_lca uut_2 (
    p4,
    p5,
    carry,
    r2
);
onetwoeightbit_lca uut_3 (
    p6,
    p7,
    carry,
    r3
);
onetwoeightbit_lca uut_4 (
    p8,
    p9,
    carry,
    r4
);

onetwoeightbit_lca uut_5 (
    p10,
    p11,
    carry,
    r5
);


onetwoeightbit_lca uut_6 (
    p12,
    p13,
    carry,
    r6
);
onetwoeightbit_lca uut_7 (
    p14,
    p15,
    carry,
    r7
);
onetwoeightbit_lca uut_8 (
    p16,
    p17,
    carry,
    r8
);
onetwoeightbit_lca uut_9 (
    p18,
    p19,
    carry,
    r9
);


onetwoeightbit_lca uut_10 (
    p20,
    p21,
    carry,
    r10
);


onetwoeightbit_lca uut_11 (
    p22,
    p23,
    carry,
    r11
);
onetwoeightbit_lca uut_12 (
    p24,
    p25,
    carry,
    r12
);
onetwoeightbit_lca uut_13 (
    p26,
    p27,
    carry,
    r13
);
onetwoeightbit_lca uut_14 (
    p28,
    p29,
    carry,
    r14
);



onetwoeightbit_lca uut_15 (
    p30,
    p31,
    carry,
    r15
);


onetwoeightbit_lca uut_16 (
    p32,
    p33,
    carry,
    r16
);
onetwoeightbit_lca uut_17 (
    p34,
    p35,
    carry,
    r17
);
onetwoeightbit_lca uut_18 (
    p36,
    p37,
    carry,
    r18
);
onetwoeightbit_lca uut_19 (
    p38,
    p39,
    carry,
    r19
);

onetwoeightbit_lca uut_20 (
    p40,
    p41,
    carry,
    r20
);


onetwoeightbit_lca uut_21 (
    p42,
    p43,
    carry,
    r21
);
onetwoeightbit_lca uut_22 (
    p44,
    p45,
    carry,
    r22
);
onetwoeightbit_lca uut_23 (
    p46,
    p47,
    carry,
    r23
);
onetwoeightbit_lca uut_24 (
    p48,
    p49,
    carry,
    r24
);


onetwoeightbit_lca uut_25 (
    p50,
    p51,
    carry,
    r25
);


onetwoeightbit_lca uut_26 (
    p52,
    p53,
    carry,
    r26
);
onetwoeightbit_lca uut_27 (
    p54,
    p55,
    carry,
    r27
);
onetwoeightbit_lca uut_28 (
    p56,
    p57,
    carry,
    r28
);
onetwoeightbit_lca uut_29 (
    p58,
    p59,
    carry,
    r29
);



onetwoeightbit_lca uut_30 (
    p60,
    p61,
    carry,
    r30
);

onetwoeightbit_lca uut_31 (
    p62,
    p63,
    carry,
    r31
);


reg [127:0] r0_d;
reg [127:0] r1_d;
reg [127:0] r2_d;
reg [127:0] r3_d;
reg [127:0] r4_d;
reg [127:0] r5_d;
reg [127:0] r6_d;
reg [127:0] r7_d;
reg [127:0] r8_d;
reg [127:0] r9_d;

reg [127:0] r10_d;
reg [127:0] r11_d;
reg [127:0] r12_d;
reg [127:0] r13_d;
reg [127:0] r14_d;
reg [127:0] r15_d;
reg [127:0] r16_d;
reg [127:0] r17_d;
reg [127:0] r18_d;
reg [127:0] r19_d;

reg [127:0] r20_d;
reg [127:0] r21_d;
reg [127:0] r22_d;
reg [127:0] r23_d;
reg [127:0] r24_d;
reg [127:0] r25_d;
reg [127:0] r26_d;
reg [127:0] r27_d;
reg [127:0] r28_d;
reg [127:0] r29_d;

reg [127:0] r30_d;
reg [127:0] r31_d;



always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r0_d <= 128'd0;
	else
		r0_d <= r0;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r1_d <= 128'd0;
	else
		r1_d <= r1;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r2_d <= 128'd0;
	else
		r2_d <= r2;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r3_d <= 128'd0;
	else
		r3_d <= r3;
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r4_d <= 128'd0;
	else
		r4_d <= r4;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r5_d <= 128'd0;
	else
		r5_d <= r5;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r6_d <= 128'd0;
	else
		r6_d <= r6;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r7_d <= 128'd0;
	else
		r7_d <= r7;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r8_d <= 128'd0;
	else
		r8_d <= r8;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r9_d <= 128'd0;
	else
		r9_d <= r9;
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r10_d <= 128'd0;
	else
		r10_d <= r10;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r11_d <= 128'd0;
	else
		r11_d <= r11;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r12_d <= 128'd0;
	else
		r12_d <= r12;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r13_d <= 128'd0;
	else
		r13_d <= r13;
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r14_d <= 128'd0;
	else
		r14_d <= r14;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r15_d <= 128'd0;
	else
		r15_d <= r15;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r16_d <= 128'd0;
	else
		r16_d <= r16;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r17_d <= 128'd0;
	else
		r17_d <= r17;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r18_d <= 128'd0;
	else
		r18_d <= r18;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r19_d <= 128'd0;
	else
		r19_d <= r19;
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r20_d <= 128'd0;
	else
		r20_d <= r20;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r21_d <= 128'd0;
	else
		r21_d <= r21;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r22_d <= 128'd0;
	else
		r22_d <= r22;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r23_d <= 128'd0;
	else
		r23_d <= r23;
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r24_d <= 128'd0;
	else
		r24_d <= r24;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r25_d <= 128'd0;
	else
		r25_d <= r25;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r26_d <= 128'd0;
	else
		r26_d <= r26;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r27_d <= 128'd0;
	else
		r27_d <= r27;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r28_d <= 128'd0;
	else
		r28_d <= r28;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r29_d <= 128'd0;
	else
		r29_d <= r29;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r30_d <= 128'd0;
	else
		r30_d <= r30;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r31_d <= 128'd0;
	else
		r31_d <= r31;
end

wire [127:0] q0,q1,q2,q3;
wire [127:0] q4,q5,q6,q7;
wire [127:0] q8,q9,q10,q11;
wire [127:0] q12,q13,q14,q15;
wire carry2;
assign carry2 = 0;
onetwoeightbit_lca uut_2_0 (
    r0_d,
    r1_d,
    carry2,
    q0
);


onetwoeightbit_lca uut_2_1 (
    r2_d,
    r3_d,
    carry2,
    q1
);
onetwoeightbit_lca uut_2_2 (
    r4_d,
    r5_d,
    carry2,
    q2
);
onetwoeightbit_lca uut_2_3 (
    r6_d,
    r7_d,
    carry2,
    q3
);
onetwoeightbit_lca uut_2_4 (
    r8_d,
    r9_d,
    carry2,
    q4
);

onetwoeightbit_lca uut_2_5 (
    r10_d,
    r11_d,
    carry2,
    q5
);


onetwoeightbit_lca uut_2_6 (
    r12_d,
    r13_d,
    carry2,
    q6
);
onetwoeightbit_lca uut_2_7 (
    r14_d,
    r15_d,
    carry2,
    q7
);
onetwoeightbit_lca uut_2_8 (
    r16_d,
    r17_d,
    carry2,
    q8
);
onetwoeightbit_lca uut_2_9 (
    r18_d,
    r19_d,
    carry2,
    q9
);


onetwoeightbit_lca uut_2_10 (
    r20_d,
    r21_d,
    carry2,
    q10
);


onetwoeightbit_lca uut_2_11 (
    r22_d,
    r23_d,
    carry2,
    q11
);
onetwoeightbit_lca uut_2_12 (
    r24_d,
    r25_d,
    carry2,
    q12
);
onetwoeightbit_lca uut_2_13 (
    r26_d,
    r27_d,
    carry2,
    q13
);
onetwoeightbit_lca uut_2_14 (
    r28_d,
    r29_d,
    carry2,
    q14
);



onetwoeightbit_lca uut_2_15 (
    r30_d,
    r31_d,
    carry2,
    q15
);
reg [127:0] q0_d;
reg [127:0] q1_d;
reg [127:0] q2_d;
reg [127:0] q3_d;
reg [127:0] q4_d;
reg [127:0] q5_d;
reg [127:0] q6_d;
reg [127:0] q7_d;
reg [127:0] q8_d;
reg [127:0] q9_d;

reg [127:0] q10_d;
reg [127:0] q11_d;
reg [127:0] q12_d;
reg [127:0] q13_d;
reg [127:0] q14_d;
reg [127:0] q15_d;





always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		q0_d <= 128'd0;
	else
		q0_d <= q0;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		q1_d <= 128'd0;
	else
		q1_d <= q1;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		q2_d <= 128'd0;
	else
		q2_d <= q2;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		q3_d <= 128'd0;
	else
		q3_d <= q3;
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		q4_d <= 128'd0;
	else
		q4_d <= q4;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		q5_d <= 128'd0;
	else
		q5_d <= q5;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		q6_d <= 128'd0;
	else
		q6_d <= q6;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		q7_d <= 128'd0;
	else
		q7_d <= q7;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		q8_d <= 128'd0;
	else
		q8_d <= q8;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		q9_d <= 128'd0;
	else
		q9_d <= q9;
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		q10_d <= 128'd0;
	else
		q10_d <= q10;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		q11_d <= 128'd0;
	else
		q11_d <= q11;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		q12_d <= 128'd0;
	else
		q12_d <= q12;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		q13_d <= 128'd0;
	else
		q13_d <= q13;
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		q14_d <= 128'd0;
	else
		q14_d <= q14;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		q15_d <= 128'd0;
	else
		q15_d <= q15;
end

wire carry3;
assign carry3 = 0;
wire [127:0] s0,s1,s2,s3;
wire [127:0] s4,s5,s6,s7;




onetwoeightbit_lca uut_3_0 (
    q0_d,
    q1_d,
    carry3,
    s0
);


onetwoeightbit_lca uut_3_1 (
    q2_d,
    q3_d,
    carry3,
    s1
);
onetwoeightbit_lca uut_3_2 (
    q4_d,
    q5_d,
    carry3,
    s2
);
onetwoeightbit_lca uut_3_3 (
    q6_d,
    q7_d,
    carry3,
    s3
);
onetwoeightbit_lca uut_3_4 (
    q8_d,
    q9_d,
    carry3,
    s4
);

onetwoeightbit_lca uut_3_5 (
    q10_d,
    q11_d,
    carry3,
    s5
);


onetwoeightbit_lca uut_3_6 (
    q12_d,
    q13_d,
    carry3,
    s6
);
onetwoeightbit_lca uut_3_7 (
    q14_d,
    q15_d,
    carry3,
    s7
);
wire [127:0] t0,t1,t2,t3;

wire carry4;
assign carry4 = 0;




onetwoeightbit_lca uut_4_0 (
    s0,
    s1,
    carry4,
    t0
);


onetwoeightbit_lca uut_4_1 (
    s2,
    s3,
    carry4,
    t1
);
onetwoeightbit_lca uut_4_2 (
    s4,
    s5,
    carry4,
    t2
);
onetwoeightbit_lca uut_4_3 (
    s6,
    s7,
    carry4,
    t3
);


wire [127:0] u0,u1;

wire [127:0] v0;
wire carry5 ;
assign carry5 = 0;
onetwoeightbit_lca uut_5_0 (
    t0,
    t1,
    carry5,
    u0
);


onetwoeightbit_lca uut_5_1 (
    t2,
    t3,
    carry5,
    u1
);

wire carry6 ;
assign carry6 = 0;
onetwoeightbit_lca uut_6_0 (
    u0,
    u1,
    carry6,
    v0
);


reg sign_a_d1,sign_a_d2;
reg sign_b_d1,sign_b_d2;

reg unsigned_a_d1,unsigned_a_d2;
reg unsigned_b_d1,unsigned_b_d2;
always@(posedge clk or negedge rst_n)
    if(!rst_n)
        sign_a_d1 <= 0;
    else
        sign_a_d1 <= sign_a;

always@(posedge clk or negedge rst_n)
    if(!rst_n)
        sign_a_d2 <= 0;
    else
        sign_a_d2 <= sign_a_d1;

always@(posedge clk or negedge rst_n)
    if(!rst_n)
        sign_b_d1 <= 0;
    else
        sign_b_d1 <= sign_b;

always@(posedge clk or negedge rst_n)
    if(!rst_n)
        sign_b_d2 <= 0;
    else
        sign_b_d2 <= sign_b_d1;

always@(posedge clk or negedge rst_n)
    if(!rst_n)
        valid_d1 <= 0;
    else
        valid_d1 <= valid;

always@(posedge clk or negedge rst_n)
    if(!rst_n)
        valid_d2 <= 0;
    else
        valid_d2 <= valid_d1;
always@(posedge clk or negedge rst_n)
    if(!rst_n)
        unsigned_a_d1 <= 0;
    else
        unsigned_a_d1 <= unsigned_a;

always@(posedge clk or negedge rst_n)
    if(!rst_n)
        unsigned_a_d2 <= 0;
    else
        unsigned_a_d2 <= unsigned_a_d1;

always@(posedge clk or negedge rst_n)
    if(!rst_n)
        unsigned_b_d1 <= 0;
    else
        unsigned_b_d1 <= unsigned_b;

always@(posedge clk or negedge rst_n)
    if(!rst_n)
        unsigned_b_d2 <= 0;
    else
        unsigned_b_d2 <= unsigned_b_d1;


assign sign_c = (!unsigned_a_d2 & !unsigned_b_d2) ?  sign_a_d2 ^ sign_b_d2 : !unsigned_a ? sign_a : 1'b0;
assign out_valid = valid_d2;


assign c = sign_c ? ~v0 + 1 : v0;
endmodule
