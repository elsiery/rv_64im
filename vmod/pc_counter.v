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
module pc_counter (
    clk,
    rst_n,
    start,
    stop,
    stall,
    branch_taken,
    jump_taken,
    jump_location,
    new_pc_offset,
    branch_offset,
    valid,
    pc
);



input   clk;
input   rst_n;
input   start;
input   stop;
input   stall;
input   branch_taken;
input   jump_taken;
input   jump_location;
input [63:0]   new_pc_offset;
input [63:0]   branch_offset;
output reg [63:0]  pc;
output reg valid;
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        pc <= 0;
        valid <=0;
    end
    else if(start) begin
        pc <= 0;
        valid <= 1;
    end
    else if (stall) begin
        pc <= pc;
    end
    else if (stop) begin
        pc <= 0;
        valid <= 0;
    end
    else if(branch_taken) begin
        pc <= pc + branch_offset;
    end
    else if(jump_taken) begin
        if(jump_location) begin
            pc <= new_pc_offset;
        end
        else begin
            pc <= pc + new_pc_offset;
        end
    end
    else begin
        pc <= pc + 8'd64;
    end
end

endmodule





