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
`include "sixteenbit_lca.v"



module sixtyfourbit_lca (
    a,
    b,
    c,
    s,
    g,
    p
);


input [63:0] a,b;
input c;

output [63:0] s;
output g,p;

wire g3,g2,g1,g0;
wire p3,p2,p1,p0;

wire c16,c32,c48;
wire [63:0] valid_a,valid_b;

assign valid_a = a[63] ? ~a + 1'b1 : a;
assign valid_b = b[63] ? ~b + 1'b1 : b;
sixteenbit_lca uut_0 (
    a[15:0],
    b[15:0],
    c,
    s[15:0],
    g0,
    p0
);

assign c16 = g0 | (p0&c);
sixteenbit_lca uut_1 (
    a[31:16],
    b[31:16],
    c16,
    s[31:16],
    g1,
    p1
);
assign c32 = g1 | (p1 & c16);

sixteenbit_lca uut_2 (
    a[47:32],
    b[47:32],
    c32,
    s[47:32],
    g2,
    p2
);
assign c48 = g2 | (p2 & c32);

sixteenbit_lca uut_3 (
    a[63:48],
    b[63:48],
    c48,
    s[63:48],
    g3,
    p3
);


assign p = p3&p2&p1&p0;

assign g = g3 | (g2 & p3) | (g1&p2&p3) |(g0&p1&p2&p3);
endmodule