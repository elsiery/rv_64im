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
module decoder_control_block (
    clk,
    rst_n,
    type_instruction,
    funct3,
    funct7,
    rs1_en,	  
    rs2_en,	  
    rd_en,	  
    rg_op,	  
    imm_en,	  
    imm_valid_bits_12, 	  
    ld_en,		  
    mem_rd,		  
    ld_b,     	  
    ld_h,     	  
    ld_w,     	  
    ld_d,     	  
    ld_us,     	  
    jmp_en,		  
    link_en, 		  
    pc_en,     	  
    mem_wr,		  
    sw_en,		  
    sw_b,		  
    sw_h,		  
    sw_w,		  
    sw_d,		  
    imm_valid_bits_13, 	  
    brn_en,	  
    brn_eq,	  
    brn_neq,	  
    brn_lt,	  
    brn_ge,	  
    brn_ltu,	  
    brn_geu,	  
    imm_valid_bits_21, 	  
    imm_valid_bits_32,
    rs2_int	  
);


input clk;
input rst_n;
input [3:0] type_instruction;
input [6:0] funct7;
input [2:0] funct3;

output reg    rs1_en;	
output reg    rs2_en;	
output reg    rd_en;	
output reg    rg_op;		
output reg    imm_en;	
output reg    imm_valid_bits_12; 	
output reg    ld_en;	
output reg    mem_rd;	
output reg    ld_b;	
output reg    ld_h;	
output reg    ld_w;	
output reg    ld_d;	
output reg    ld_us;	
output reg    jmp_en;	
output reg    link_en;	
output reg    pc_en;	
output reg    mem_wr;	
output reg    sw_en;	
output reg    sw_b;	
output reg    sw_h;	
output reg    sw_w;	
output reg    sw_d;	
output reg    imm_valid_bits_13; 	
output reg    brn_en; 		
output reg    brn_eq;		
output reg    brn_neq;		
output reg    brn_lt;		
output reg    brn_ge;		
output reg    brn_ltu;		
output reg    brn_geu;		
output reg    imm_valid_bits_21; 	
output reg    imm_valid_bits_32;
output reg    rs2_int; 	








always@(*) begin
    rs1_en 		  = 1'b0;
    rs2_en 		  = 1'b0;
    rd_en  		  = 1'b0;
    rg_op  		  = 1'b0;
    imm_en 		  = 1'b0;
    imm_valid_bits_12 	  = 1'b0;
    ld_en  		  = 1'b0;
    mem_rd 		  = 1'b0;
    ld_b 		  = 1'b0;
    ld_h 		  = 1'b0;
    ld_w 		  = 1'b0;
    ld_d 		  = 1'b0;
    ld_us 		  = 1'b0;
    jmp_en 		  = 1'b0;
    link_en 		  = 1'b0;
    pc_en 		  = 1'b0;
    mem_wr 		  = 1'b0;
    sw_en  		  = 1'b0;
    sw_b 		  = 1'b0;
    sw_h 		  = 1'b0;
    sw_w 		  = 1'b0;
    sw_d 		  = 1'b0;
    imm_valid_bits_13 	  = 1'b0;
    brn_en 		  = 1'b0;
    brn_eq 		  = 1'b0;
    brn_neq 		  = 1'b0;
    brn_lt 		  = 1'b0;
    brn_ge 		  = 1'b0;
    brn_ltu 		  = 1'b0;
    brn_geu 		  = 1'b0;
    imm_valid_bits_21 	  = 1'b0;
    imm_valid_bits_32 	  = 1'b0;
    rs2_int               = 1'b0;
    case(type_instruction)
    4'd1: begin //R - type
        rs1_en = 1'b1;
        rs2_en = 1'b1;
        rd_en  = 1'b1;
        rg_op  = 1'b1;
    end
    4'd2: begin //I - type
        rs1_en = 1'b1;
        imm_en = 1'b1;
        imm_valid_bits_12 = 1'b1;
        rd_en = 1'b1;
        rg_op = 1'b1;
    end
    4'd3: begin //I lb 
        rs1_en = 1'b1;
        imm_en = 1'b1;
        imm_valid_bits_12 = 1'b1;
        ld_en  = 1'b1;
        rd_en  = 1'b1;
        mem_rd = 1'b1;
        rg_op  = 1'b1;
        if (funct3 == 3'h0) begin
            ld_b = 1'b1;
        end
        else if (funct3 == 3'h1) begin
            ld_h = 1'b1;
        end
        else if (funct3 == 3'h2) begin
            ld_w = 1'b1;
        end
        else if (funct3 == 3'h3) begin
            ld_d = 1'b1;
        end
        else if (funct3 == 3'h4) begin
            ld_b = 1'b1;
            ld_us = 1'b1;
        end
        else if (funct3 == 3'h5) begin
            ld_h = 1'b1;
            ld_us = 1'b1;
        end
        else if (funct3 == 3'h6) begin
            ld_w = 1'b1;
            ld_us = 1'b1;
        end
    end
    4'd7: begin  //I   J&L
        imm_en = 1'b1;
        imm_valid_bits_12 = 1'b1;
        jmp_en = 1'b1;
        link_en = 1'b1;
        rd_en = 1'b1;
        rg_op = 1'b1;
        pc_en = 1'b1;
        rs2_int = 1'b1;
    end
    4'd4: begin  //S
        rs1_en = 1'b1;
        rs2_en = 1'b1;
        imm_en = 1'b1;
        imm_valid_bits_12 = 1'b1;
        mem_wr = 1'b1;
        sw_en  = 1'b1;
        if (funct3 == 3'h0) begin
            sw_b = 1'b1;
        end
        else if (funct3 == 3'h1) begin
            sw_h = 1'b1;
        end
        else if (funct3 == 3'h2) begin
            sw_w = 1'b1;
        end
        else if (funct3 == 3'h3) begin
            sw_d = 1'b1;
        end
    end
    4'd5: begin  //B
        rs1_en = 1'b1;
        rs2_en = 1'b1;
        imm_valid_bits_13 = 1'b1;
        brn_en = 1'b1;
        if(funct3 == 3'h0) begin
            brn_eq = 1'b1;
        end
        else if(funct3 == 3'h1) begin
            brn_neq = 1'b1;
        end
        else if(funct3 == 3'h4) begin
            brn_lt = 1'b1;
        end
        else if(funct3 == 3'h5) begin
            brn_ge = 1'b1;
        end
        else if(funct3 == 3'h6) begin
            brn_ltu = 1'b1;
        end
        else if(funct3 == 3'h7) begin
            brn_geu = 1'b1;
        end
    end
    4'd6: begin  //J 
        imm_en = 1'b1;
        imm_valid_bits_21 = 1'b1;
        jmp_en = 1'b1;
        rd_en = 1'b1;
        pc_en =  1'b1;
        rs2_int = 1'b1;
        rg_op = 1'b1;
    end
    4'd8: begin //U
        imm_en = 1'b1;
        imm_valid_bits_32 = 1'b1;
        rg_op=1'b1;
    end
    4'd9: begin
        imm_en = 1'b1;
        imm_valid_bits_32 = 1'b1;
        pc_en = 1'b1;
        rg_op=1'b1;
    end
    endcase
end
endmodule












