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

`include "divider_alu.v"

module alu_division_block (
    clk,
    rst_n,
    op1_data,
    op2_data,
    rd,
    alu_control,
    alu_valid,
    alu_output,
    out_rd,
    valid
);


input clk;
input rst_n;
input [63:0] op1_data;
input [63:0] op2_data;
input [4:0] rd;
input [4:0] alu_control;
output alu_valid;
output [4:0] out_rd;
output reg [63:0] alu_output;
input valid;

wire in_valid;
wire unsigned_div;
wire [63:0] div_ab;
wire [63:0] rem_ab;
wire [4:0] out_rd;
wire [4:0] out_alu_control;
assign in_valid = ((alu_control >= 5'd16) && (alu_control <= 5'd19))&&valid;
assign unsigned_div = ((alu_control == 5'd17) || (alu_control == 5'd19));

reg in_valid_d1;
reg [4:0] alu_control_d1;
reg [4:0] rd_d1;
reg unsigned_div_d1;
reg [63:0] op1_data_d1,op2_data_d1;

always@(posedge clk or negedge rst_n)
    if(!rst_n)
        in_valid_d1 <= 0;
    else
        in_valid_d1 <= in_valid;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        alu_control_d1 <= 5'd0;
    else if(in_valid)
        alu_control_d1 <= alu_control;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        rd_d1 <= 5'd0;
    else if(in_valid)
        rd_d1 <= rd;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        unsigned_div_d1 <= 0;
    else if(in_valid)
        unsigned_div_d1 <= unsigned_div;
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        op1_data_d1 <= 64'd0;
    else if(in_valid)
        op1_data_d1 <= op1_data;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        op2_data_d1 <= 64'd0;
    else if(in_valid)
        op2_data_d1 <= op2_data;
end


divider_alu uut (
    .clk         (clk),
    .rst_n       (rst_n),
    .valid       (in_valid_d1),
    .alu_control (alu_control_d1),
    .rd          (rd_d1),
    .unsigned_div(unsigned_div_d1),
    .a           (op1_data_d1),
    .b           (op2_data_d1),
    .out_valid   (alu_valid),
    .div_ab      (div_ab),
    .rem_ab      (rem_ab),
    .out_rd      (out_rd),
    .out_alu_control (out_alu_control)
);


always@(*) begin
    alu_output = 64'd0;
    case(out_alu_control)
    5'd16,5'd17: alu_output = div_ab;
    5'd18,5'd19: alu_output = rem_ab;
    endcase
end



endmodule