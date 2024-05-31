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
module operands_swap (
    rs1_en,
    rs2_en,
    pc_en,
    imm_en,
    rs2_int,
    rs1_data,
    rs2_data,
    pc,
    imm_64,
    op1_data,
    op2_data
);


input rs1_en;
input rs2_en;
input pc_en;
input imm_en;
input rs2_int;
input [63:0] rs1_data;
input [63:0] rs2_data;

input [63:0] pc;
input [63:0] imm_64;

output  reg [63:0] op1_data;
output  reg [63:0] op2_data;


always@(*) begin
    op1_data=0;
    op2_data=0;
    if(rs1_en)
        op1_data = rs1_data;
    else if(pc_en)
        op1_data = pc;
    if(rs2_en&!imm_en)
        op2_data = rs2_data;
    else if(imm_en&!rs2_int)
        op2_data = imm_64;
    else if(rs2_int)
        op2_data = {55'd0,3'd4,6'd0};
end

endmodule




