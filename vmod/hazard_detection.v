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
module hazard_detection (
    clk,
    rst_n,
    valid_1,
    instruction_1,
    valid_2,
    instruction_2,
    valid_3,
    instruction_3,
    hazard_detected,
    bypass_activate_op1,
    bypass_activate_op2,
    bypass_op1,
    bypass_op2,
    stall_activate
);


input clk;
input rst_n;
input valid_1,valid_2,valid_3;
input [31:0] instruction_1,instruction_2,instruction_3;

output reg hazard_detected;
output reg [2:0] bypass_activate_op1,bypass_activate_op2;
output reg [3:0] stall_activate;
output reg bypass_op1,bypass_op2;
wire [31:0] w_instruction_1,w_instruction_2,w_instruction_3;

assign w_instruction_1 = {{32{valid_1}}} & instruction_1;
assign w_instruction_2 = {{32{valid_2}}} & instruction_2;
assign w_instruction_3 = {{32{valid_3}}} & instruction_3;

wire hz_c1_r1 = (((w_instruction_3[6:0] == 51) && (w_instruction_1[6:0]==51)) || 
                 ((w_instruction_3[6:0] == 19) && (w_instruction_1[6:0]==19)) || 
                 ((w_instruction_3[6:0] == 19) && (w_instruction_1[6:0]==51)) || 
                 ((w_instruction_3[6:0] == 51) && (w_instruction_1[6:0]== 19)));
wire hz_c1_r2 = ((w_instruction_3[6:0] == 51) && (w_instruction_1[6:0]==51));

wire hz_c2_r1 = (((w_instruction_2[6:0] == 51) && (w_instruction_1[6:0] == 51)) || 
                 ((w_instruction_2[6:0] == 19) && (w_instruction_1[6:0] == 19)) || 
                 ((w_instruction_2[6:0] == 51) && (w_instruction_1[6:0] == 19)) || 
                 ((w_instruction_2[6:0] == 19) && (w_instruction_1[6:0] == 51)));
wire hz_c2_r2 = ((w_instruction_2[6:0] == 51) && (w_instruction_1[6:0]==51));

wire hz_c3_r1 = (((w_instruction_3[6:0] == 51) && (w_instruction_1[6:0] == 3)) || 
                 ((w_instruction_3[6:0] == 19) && (w_instruction_1[6:0] == 3)));

wire hz_c3_r2 = ((w_instruction_3[6:0] == 51) && (w_instruction_1[6:0]  == 3));

wire hz_c4_r1 = (((w_instruction_2[6:0] == 51) && (w_instruction_1[6:0] == 3)) || 
                 ((w_instruction_2[6:0] == 19) && (w_instruction_1[6:0] == 3)));

wire hz_c4_r2 = ((w_instruction_2[6:0] == 51) && (w_instruction_1[6:0] == 3));

wire hz_c5_r1 = (((w_instruction_2[6:0]==3) && (w_instruction_1[6:0]==51)) ||
                 ((w_instruction_2[6:0]==3) && (w_instruction_1[6:0]==19)));

wire hz_c6_r1 = (((w_instruction_3[6:0]==3) && (w_instruction_1[6:0]==51)) ||
                 ((w_instruction_3[6:0]==3) && (w_instruction_1[6:0]==19)));

always@(*) begin
    hazard_detected     =   0;
    bypass_activate_op1 =   0;
    bypass_activate_op2 =   0;
    stall_activate      =   0;
    bypass_op1          =   0;
    bypass_op2          =   0;
    if (((w_instruction_2[11:7] == w_instruction_1[19:15])||(w_instruction_2[11:7] == w_instruction_1[24:20])) && (hz_c5_r1)) begin
        hazard_detected = 1'b1;
        stall_activate = 4'b1100; 
    end
    else if ((w_instruction_2[11:7] == w_instruction_1[19:15]) && (hz_c2_r1||hz_c4_r1) && !(((w_instruction_2[11:7] == w_instruction_1[24:20])) && (hz_c2_r2||hz_c4_r2))) begin
        hazard_detected = 1'b1;
        bypass_activate_op1 = 3'b110;
        bypass_op1 = 1'b1;
        if (((w_instruction_3[11:7] == w_instruction_1[24:20])) && (hz_c1_r2||hz_c3_r2)) begin
            bypass_activate_op2 = 3'b110;
            bypass_op2 = 1'b1;
        end
    end
    else if ((w_instruction_2[11:7] == w_instruction_1[24:20]) && (hz_c2_r2||hz_c4_r2) && !(((w_instruction_2[11:7] == w_instruction_1[19:15])) && (hz_c2_r1||hz_c4_r1))) begin
        hazard_detected = 1'b1;
        bypass_activate_op2 = 3'b110;
        bypass_op2 = 1'b1;
        if (((w_instruction_3[11:7] == w_instruction_1[19:15])) && (hz_c1_r1||hz_c3_r1)) begin
            bypass_activate_op1 = 3'b110;
            bypass_op1 = 1'b1;
        end
    end
    else if ((w_instruction_2[11:7] == w_instruction_1[24:20]) && (hz_c2_r2||hz_c4_r2) && (((w_instruction_2[11:7] == w_instruction_1[19:15])) && (hz_c2_r1||hz_c4_r1))) begin
        hazard_detected = 1'b1;
        bypass_activate_op1 = 3'b110;
        bypass_activate_op2 = 3'b110;
        bypass_op2 = 1'b1;
        bypass_op1 = 1'b1;
    end
    else if ((w_instruction_3[11:7] == w_instruction_1[19:15]) && (hz_c1_r1||hz_c3_r1||hz_c6_r1) && !(((w_instruction_3[11:7] == w_instruction_1[24:20])) && (hz_c1_r2||hz_c3_r2||hz_c6_r1))) begin
        hazard_detected = 1'b1;
        bypass_activate_op1 = 3'b101;
        bypass_op1 = 1'b1;
    end
    else if ((w_instruction_3[11:7] == w_instruction_1[24:20]) && (hz_c1_r2||hz_c3_r2||hz_c6_r1) && !(((w_instruction_3[11:7] == w_instruction_1[19:15])) && (hz_c1_r1||hz_c3_r1||hz_c6_r1))) begin
        hazard_detected = 1'b1;
        bypass_activate_op2 = 3'b101;
        bypass_op2 = 1'b1;
    end
    else if ((w_instruction_3[11:7] == w_instruction_1[24:20]) && (hz_c1_r2||hz_c3_r2||hz_c6_r1) && (((w_instruction_3[11:7] == w_instruction_1[19:15])) && (hz_c1_r1||hz_c3_r1||hz_c6_r1))) begin
        hazard_detected = 1'b1;
        bypass_activate_op1 = 3'b101;
        bypass_activate_op2 = 3'b101;
        bypass_op2 = 1'b1;
        bypass_op1 = 1'b1;
    end
end

endmodule

