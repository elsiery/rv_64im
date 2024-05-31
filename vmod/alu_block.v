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
`include "sixtyfourbit_lca.v"
module alu_block (
    op1_data,
    op2_data,
    alu_control,
    alu_output,
    alu_valid,
    valid
);



input [63:0] op1_data;
input [63:0] op2_data;
input [4:0] alu_control;
output reg [63:0] alu_output;
output reg alu_valid;
input valid;
wire [63:0] w_op1_data;
wire [63:0] w_op2_data;
wire [63:0] w_alu_output1;

assign w_op1_data = op1_data;
assign w_op2_data = (alu_control==4'd2) ? ~op2_data + 1'b1 : op2_data;



sixtyfourbit_lca add_sub (
    .a(w_op1_data),
    .b(w_op2_data),
    .c(1'b0),
    .s(w_alu_output1),
    .g(),
    .p()
);

always@(*) begin
    alu_valid = 1'b0;
    alu_output = 64'd0;
    case(alu_control)
    4'd1,4'd2 : begin
        alu_valid = valid;
        alu_output = w_alu_output1;
    end
    4'd3: begin
        alu_valid = valid;
        alu_output = op1_data ^ op2_data;
    end
    4'd4: begin
        alu_valid = valid;
        alu_output = op1_data | op2_data;
    end
    4'd5: begin
        alu_valid = valid;
        alu_output = op1_data & op2_data;
    end
    4'd6: begin
        alu_valid = valid;
        alu_output = op1_data << op2_data;
    end
    4'd7: begin
        alu_valid = valid;
        alu_output = op1_data >> op2_data;
    end
    4'd8: begin
        alu_valid = valid;
        alu_output = op1_data >>> op2_data;
    end
    4'd9: begin
        alu_valid = valid;
        alu_output = ($signed(op1_data) < $signed(op2_data)) ? 1'b1 : 1'b0;
    end
    4'd10: begin
        alu_valid = valid;
        alu_output = (op1_data < op2_data) ? 1'b1 : 1'b0;
    end
    4'd11: begin
        alu_valid = valid;
        alu_output = op2_data;
    end
    endcase
end


endmodule

