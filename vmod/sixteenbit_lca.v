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
`include "fourbit_cla.v"

module sixteenbit_lca (
    a,
    b,
    c,
    s,
    g,
    p
);


input [15:0] a,b;
input c;
output [15:0] s;
output g,p;
wire [3:0] g0,p0,g1,p1,g2,p2,g3,p3;
wire pg0,gg0,pg1,gg1,pg2,gg2,pg3,gg3;
wire p_lcu,g_lcu;
wire c4,c8,c12;
wire [3:0] sp0,sp1,sp2,sp3;
fourbit_cla u_4cla_0 (
    a[3:0],
    b[3:0],
    c,
    sp0,
    g0,
    p0
);

assign pg0 = &p0;
assign gg0 = g0[3] | (g0[2]&p0[3])|(g0[1]&p0[2]&p0[3])|(g0[0]&p0[1]&p0[2]&p0[3]);

assign c4 = gg0 | (pg0&c);

fourbit_cla u_4cla_1 (
    a[7:4],
    b[7:4],
    c4,
    sp1,
    g1,
    p1
);

assign pg1 = &p1;
assign gg1 = g1[3] | (g1[2]&p1[3])|(g1[1]&p1[2]&p1[3])|(g1[0]&p1[1]&p1[2]&p1[3]);

assign c8 = gg1 | (pg1&c4);

fourbit_cla u_4cla_2 (
    a[11:8],
    b[11:8],
    c8,
    sp2,
    g2,
    p2
);
assign pg2 = &p2;
assign gg2 = g2[3] | (g2[2]&p2[3])|(g2[1]&p2[2]&p2[3])|(g2[0]&p2[1]&p2[2]&p2[3]);

assign c12 = gg2 | (pg2&c8);

fourbit_cla u_4cla_3 (
    a[15:12],
    b[15:12],
    c12,
    sp3,
    g3,
    p3
);
assign pg3 = &p3;
assign gg3 = g3[3] | (g3[2]&p3[3])|(g3[1]&p3[2]&p3[3])|(g3[0]&p3[1]&p3[2]&p3[3]);

assign p_lcu = pg3 & pg2 & pg1 & pg0;
assign g_lcu = gg3 | (gg2 & pg3) | (gg1 & pg2 & pg3) |(gg0 & pg1 & pg2 & pg3);

assign p = p_lcu;
assign g = g_lcu;
assign s = {sp3,sp2,sp1,sp0};
endmodule