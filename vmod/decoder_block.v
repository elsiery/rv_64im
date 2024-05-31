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
/*


   31	   25 24	20 19	15 14	 12 11	7 6	0 

R     funct7 |    rs2     |  rs1  | funct3 | rd  | opcode

I           imm[11:0]     |  rs1  | funct3 | rd  | opcode

S   imm[11:5]|    rs2     |  rs1  | funct3 |imm[4:0]| opcode

SB imm[12|10:5]|  rs2     |  rs1  | funct3 |imm[4:1|11]|opcode

U               imm[31:12]                 | rd  | opcode

UJ          imm[20|10:1|11|19:12]          | rd  | opcode

*/

module decoder_block (
    instruction,
    type_instruction,
    opcode,
    rs1,
    rs2,
    imm,
    rd,
    funct3,
    funct7
);

input [31:0] instruction;
output [6:0] opcode;
output [6:0] funct7;
output [2:0] funct3;
output [4:0] rs2,rs1,rd;
output reg [31:0] imm;



output reg [3:0] type_instruction;

always@(*) begin
    type_instruction = 4'd0;
    case(instruction[6:0])
    7'b0110011: type_instruction = 4'd1;         //R
    7'b0010011: type_instruction = 4'd2;         //I
    7'b0000011: type_instruction = 4'd3;         //I lb
    7'b0100011: type_instruction = 4'd4;         //S
    7'b1100011: type_instruction = 4'd5;         //B
    7'b1101111: type_instruction = 4'd6;         //J
    7'b1100111: type_instruction = 4'd7;         //I j&l
    7'b0110111: type_instruction = 4'd8;         //U1
    7'b0010111: type_instruction = 4'd9;         //U2
    endcase
end


assign opcode = instruction[6:0];
assign rd     = instruction[11:7];
assign funct3 = instruction[14:12];
assign rs1    = instruction[19:15];
assign rs2    = instruction[24:20];
assign funct7 = instruction[31:25];

always@(*) begin
    imm = 32'd0;
    case(instruction[6:0])
    7'b0010011,7'b0000011,7'b1100111: imm = {20'd0,funct7,rs2};         //I
    7'b0100011: imm = {20'd0,funct7,rd};                                //S
    7'b1100011: imm = {19'd0,funct7[6],rd[0],funct7[5:0],rd[4:1],1'b0}; //B
    7'b0110111,7'b0010111: imm = {funct7,rs2,rs1,funct3,12'd0};         //U
    7'b1101111: imm = {11'b0,instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0};  //J
    endcase
end

endmodule







