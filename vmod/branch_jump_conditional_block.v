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
module branch_jump_conditional_block (
    brn_en,	  
    brn_eq,	  
    brn_neq,	  
    brn_lt,	  
    brn_ge,	  
    brn_ltu,	  
    brn_geu,	  
    jmp_en,
    link_en,
    rs1_data,
    op1_data,
    op2_data,
    imm_64,
    branch_taken,
    branch_offset,
    jump_taken,
    jump_location,
    new_pc_offset
);


input brn_en;
input brn_eq;
input brn_neq;
input brn_lt;
input brn_ge;
input brn_ltu;
input brn_geu;
input jmp_en;
input link_en;
input [63:0] rs1_data;
input [63:0] op1_data;
input [63:0] op2_data;
input [63:0] imm_64;
output reg branch_taken;
output reg [63:0] branch_offset;
output reg jump_taken;
output reg jump_location;
output reg [63:0] new_pc_offset;



always@(*) begin
    branch_taken = 1'b0;
    branch_offset = 64'd0;
    jump_taken = 1'b0;
    new_pc_offset = 64'd0;
    jump_location = 1'b0;
    if(brn_en) begin
        if(brn_eq) begin
            if(op1_data == op2_data) begin
                branch_taken = 1'b1;
                branch_offset = imm_64;
            end
        end
       else if(brn_neq) begin
            if(op1_data != op2_data) begin
                branch_taken = 1'b1;
                branch_offset = imm_64;
            end
        end
        else if(brn_lt) begin
            if($signed(op1_data) < $signed(op2_data)) begin
                branch_taken = 1'b1;
                branch_offset = imm_64;
            end
        end
        else if(brn_ge) begin
            if($signed(op1_data) >= $signed(op2_data)) begin
                branch_taken = 1'b1;
                branch_offset = imm_64;
            end
        end
        else if(brn_ltu) begin
            if(op1_data < op2_data) begin
                branch_taken = 1'b1;
                branch_offset = imm_64;
            end
        end
        else if(brn_geu) begin
            if(op1_data >= op2_data) begin
                branch_taken = 1'b1;
                branch_offset = imm_64;
            end
        end
    end
    else if(jmp_en) begin
        if(link_en) begin
            jump_taken = 1'b1;
            jump_location = 1'b1;
            new_pc_offset = rs1_data + imm_64;
        end
        else begin
            jump_taken = 1'b1;
            new_pc_offset = imm_64;
        end
    end
end 

endmodule



