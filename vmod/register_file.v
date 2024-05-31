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
module register_file (
    clk,
    rst_n,
    rs1,
    rs2,
    rd,
    wr_en,
    wr_data,
    rs1_data,
    rs2_data
);



input clk;
input rst_n;
input [4:0] rs1;
input [4:0] rs2;
input [4:0] rd;
input wr_en;
input [63:0] wr_data;
output reg [63:0] rs1_data;
output reg [63:0] rs2_data;

reg [63:0] register_file[0:31];

always@(posedge clk,negedge rst_n) begin
    if(!rst_n) begin
        register_file[0]  <= 64'd0;
        register_file[1]  <= 64'd1;
        register_file[2]  <= 64'd2;
        register_file[3]  <= 64'd3;
        register_file[4]  <= 64'd4;
        register_file[5]  <= 64'd5;
        register_file[6]  <= 64'd6;
        register_file[7]  <= 64'd7;
        register_file[8]  <= 64'd8;
        register_file[9]  <= 64'd9;
        register_file[10] <= 64'd10;
        register_file[11] <= 64'd11;
        register_file[12] <= 64'd12;
        register_file[13] <= 64'd13;
        register_file[14] <= 64'd14;
        register_file[15] <= 64'd15;
        register_file[16] <= 64'd16;
        register_file[17] <= 64'd17;
        register_file[18] <= 64'd18;
        register_file[19] <= 64'd19;
        register_file[20] <= 64'd20;
        register_file[21] <= 64'd21;
        register_file[22] <= 64'd22;
        register_file[23] <= 64'd23;
        register_file[24] <= 64'd24;
        register_file[25] <= 64'd25;
        register_file[26] <= 64'd26;
        register_file[27] <= 64'd27;
        register_file[28] <= 64'd28;
        register_file[29] <= 64'd29;
        register_file[30] <= 64'd30;
        register_file[31] <= 64'd31;
    end
    else begin
        if(wr_en) begin
            register_file[rd]   <=  wr_data;
        end
    end
end


always@(*) begin
    if(wr_en &&(rs1==rd)) begin
        rs1_data = wr_data;
    end
    else
        rs1_data = register_file[rs1];
    if(wr_en &&(rs2==rd)) begin
        rs2_data = wr_data;
    end
    else
        rs2_data = register_file[rs2];
end

endmodule                
        
