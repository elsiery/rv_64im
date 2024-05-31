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
`include "cla.v"
module fourbit_cla (
    a,
    b,
    c,
    s,
    g,
    p
);



input [3:0] a,b;
output [3:0] s;
output [3:0] g,p;
input c;
wire c1,c2,c3;
wire g0,g1,g2,g3;
wire p0,p1,p2,p3;
cla cla_0 (
    a[0],
    b[0],
    c,
    s[0],
    g0,
    p0
);

assign c1 = g0 | (p0&c);
cla cla_1 (
    a[1],
    b[1],
    c1,
    s[1],
    g1,
    p1
);
assign c2 = g1 | (p1&c1);
cla cla_2 (
    a[2],
    b[2],
    c2,
    s[2],
    g2,
    p2
);
assign c3 = g2 | (p2&c2);

cla cla_3 (
    a[3],
    b[3],
    c3,
    s[3],
    g3,
    p3
);


assign g = {g3,g2,g1,g0};
assign p = {p3,p2,p1,p0};





endmodule




