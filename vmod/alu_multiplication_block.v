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
`include "multiplier_lca.v"
module alu_multiplication_block (
    clk,
    rst_n,
    op1_data,
    op2_data,
    alu_control,
    alu_valid,
    alu_output,
    valid
);

input clk;
input rst_n;
input [63:0] op1_data;
input [63:0] op2_data;
input [4:0] alu_control;
reg [4:0] alu_control_d1;
reg [4:0] alu_control_d2;
output reg [63:0] alu_output;
output alu_valid;
input valid;
wire [127:0] mult_output;

wire in_valid = (alu_control <= 5'd15) && (alu_control >= 5'd12)&&valid;
wire unsigned_a = (alu_control==5'd15);
wire unsigned_b = (alu_control==5'd14) || (alu_control==5'd15);

multiplier_lca  uut(
    .clk         (clk),
    .rst_n       (rst_n),
    .valid       (in_valid),
    .unsigned_a  (unsigned_a),
    .a           (op1_data),
    .unsigned_b  (unsigned_b),
    .b           (op2_data),
    .out_valid   (alu_valid),
    .c           (mult_output)
);


always@(posedge clk or negedge rst_n)
    if(~rst_n)
        alu_control_d1 <= 0;
    else
        alu_control_d1 <= alu_control;


always@(posedge clk or negedge rst_n)
    if(~rst_n)
        alu_control_d2 <= 0;
    else
        alu_control_d2 <= alu_control_d1;


always@(*) begin
    alu_output = 64'd0;
    case(alu_control_d2)
    5'd12: alu_output = mult_output[63:0];
    5'd13,5'd14,5'd15: alu_output = mult_output[127:64];
    endcase
end

endmodule