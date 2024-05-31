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
module sign_extend (
    imm_valid_bits_12,
    imm_valid_bits_13,
    imm_valid_bits_21,
    imm_valid_bits_32,
    imm,
    imm_64
);


input imm_valid_bits_12;
input imm_valid_bits_13;
input imm_valid_bits_21;
input imm_valid_bits_32;

input [31:0] imm;
output reg [63:0] imm_64;



always@(*) begin
    imm_64 = 64'd0;
    if(imm_valid_bits_12)
        imm_64 = {{52{imm[11]}},imm};
    else if(imm_valid_bits_13)
        imm_64 = {{51{imm[12]}},imm};
    else if(imm_valid_bits_21)
        imm_64 = {{43{imm[20]}},imm};
    else if(imm_valid_bits_32)
        imm_64 = {{32{imm[31]}},imm};
    else
        imm_64 = 64'd0;
end


endmodule





