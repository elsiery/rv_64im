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
module alu_control_block (
    type_instruction,
    funct3,
    funct7,
    alu_control,
    valid,
    out_valid
);

input [4:0] type_instruction;
input [2:0] funct3;
input [6:0] funct7;
input valid;
output reg [4:0] alu_control;
output reg out_valid;
always@(*) begin
    if(((type_instruction==4'd1)&&(funct3==3'h0)&&(funct7==7'h0))||((type_instruction==4'd2)&&(funct3==3'h0))||(type_instruction==4'd3)||(type_instruction==4'd4)||(type_instruction==4'd6)||(type_instruction==4'd7)||(type_instruction==4'd9)) begin
        alu_control = 5'd1;
        out_valid   =  valid;           //add,addi,ld addr cal,st addr cal, j&l -2 results
    end
    else if((type_instruction==4'd1)&&(funct3==3'h0)&&(funct7==7'h20)) begin 
        alu_control = 5'd2;           //sub
        out_valid   =  valid;
    end
    else if(((type_instruction==4'd1)||(type_instruction==4'd2))&&(funct3==3'h4)&&(funct7!=1)) begin 
        alu_control = 5'd3;           //xor,xori
        out_valid   =  valid;
    end
    else if(((type_instruction==4'd1)||(type_instruction==4'd2))&&(funct3==3'h6)&&(funct7!=1)) begin 
        alu_control = 5'd4;           //or,ori
        out_valid   =  valid;
    end
    else if(((type_instruction==4'd1)||(type_instruction==4'd2))&&(funct3==3'h7)&&(funct7!=1)) begin 
        alu_control = 5'd5;           //and,andi
        out_valid   =  valid;
    end
    else if(((type_instruction==4'd1)||(type_instruction==4'd2))&&(funct3==3'h1)&&(funct7!=1)) begin 
        alu_control = 5'd6;           //sll,slli
        out_valid   =  valid;
    end
    else if(((type_instruction==4'd1)||(type_instruction==4'd2))&&(funct3 == 3'h5) && (funct7 == 7'h0)) begin
        alu_control = 5'd7;           //srl,srli
        out_valid   =  valid;
    end
    else if(((type_instruction==4'd1)||(type_instruction==4'd2))&&(funct3==3'h5)&&(funct7==7'h20)) begin 
        out_valid   =  valid;
        alu_control = 5'd8;           //sra,srai
    end
    else if(((type_instruction==4'd1)||(type_instruction==4'd2))&&(funct3==3'h2)&&(funct7!=1)) begin 
        alu_control = 5'd9;           //slt,slti
        out_valid   =  valid;
    end
    else if(((type_instruction==4'd1)||(type_instruction==4'd2))&&(funct3==3'h3)&&(funct7!=1)) begin 
        alu_control = 5'd10;          //sltu,sltiu
        out_valid   =  valid;
    end
    else if (type_instruction == 4'd8) begin
        alu_control = 5'd11;           //lui
        out_valid   =  valid;
    end
    else if((type_instruction==4'd1)&&(funct3==3'h0)&&(funct7==7'h1)) begin 
        alu_control = 5'd12;           //mul
        out_valid   =  valid;
    end
    else if((type_instruction==4'd1)&&(funct3==3'h1)&&(funct7==7'h1)) begin 
        alu_control = 5'd13;           //mulh
        out_valid   =  valid;
    end
    else if((type_instruction==4'd1)&&(funct3==3'h2)&&(funct7==7'h1)) begin 
        alu_control = 5'd14;           //mulhsu
        out_valid   =  valid;
    end
    else if((type_instruction==4'd1)&&(funct3==3'h3)&&(funct7==7'h1)) begin 
        alu_control = 5'd15;           //mulhu
        out_valid   =  valid;
    end
    else if((type_instruction==4'd1)&&(funct3==3'h4)&&(funct7==7'h1)) begin 
        alu_control = 5'd16;           //div
        out_valid   =  valid;
    end
    else if((type_instruction==4'd1)&&(funct3==3'h5)&&(funct7==7'h1)) begin 
        out_valid   =  valid;
        alu_control = 5'd17;           //divu
    end
    else if((type_instruction==4'd1)&&(funct3==3'h6)&&(funct7==7'h1)) begin 
        alu_control = 5'd18;           //rem
        out_valid   =  valid;
    end
    else if((type_instruction==4'd1)&&(funct3==3'h7)&&(funct7==7'h1)) begin 
        alu_control = 5'd19;           //remu
        out_valid   =  valid;
    end
    else begin
        out_valid   =  0;
        alu_control = 5'd0;
    end
end

endmodule
