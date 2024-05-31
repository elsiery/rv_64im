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
module divider_alu (
    clk,
    rst_n,
    valid,
    alu_control,
    rd,
    unsigned_div,
    a,
    b,
    out_valid,
    div_ab,
    rem_ab,
    out_rd,
    out_alu_control
);

input [63:0] a,b;
input clk,rst_n,valid;
input [4:0] rd;
input unsigned_div;
output [63:0] div_ab,rem_ab;
output out_valid;
output [4:0] out_rd;
input [4:0] alu_control;
output [4:0] out_alu_control;
parameter  IDLE  = 2'b00;
parameter  START = 2'b01;
parameter  BUSY  = 2'b10;
parameter  DONE  = 2'b11;

reg [1:0] cs,ns;
reg [63:0] dividend_reg;
reg [63:0] quotient_reg;
reg [63:0] quotient_mask;
reg [126:0] divisor_reg;
reg sign_c;
reg [4:0] r_rd;
reg [4:0] r_alu_control;
wire complete;
wire [63:0] valid_a = !(unsigned_div) ? a[63] ? ~a+1'b1 : a : a;
wire [63:0] valid_b = !(unsigned_div) ? b[63] ? ~b+1'b1 : b : b; 
assign complete = ~(| quotient_mask) &(cs==BUSY);
always@(*) begin
    ns = 2'd0;
    case(cs)
    IDLE: begin
        if (valid)
            ns = START;
        else
            ns = IDLE;
    end
    START: ns = BUSY;

    BUSY: begin
        if (complete&!valid)
            ns = IDLE;
        else if(complete&valid)
            ns = START;
        else
            ns = BUSY;
    end
    endcase
end

always@(posedge clk or negedge rst_n)
    if(!rst_n)
        cs <= 2'd0;
    else
        cs <= ns;


always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dividend_reg  <= 64'd0;
        quotient_reg  <= 64'd0;
        quotient_mask <= 64'd0;
        divisor_reg   <= 127'd0;
        sign_c        <= 1'd0;
        r_rd          <= 5'd0;
        r_alu_control <= 5'd0;
    end
    else if(cs == IDLE) begin
        dividend_reg  <= 64'd0;
        quotient_reg  <= 64'd0;
        quotient_mask <= 64'd0;
        divisor_reg   <= 127'd0;
        sign_c        <= 1'd0;
        r_rd          <= 5'd0;
        r_alu_control <= 5'd0;
    end
    else if(cs == START) begin
        dividend_reg <= valid_a;
        divisor_reg  <= {valid_b,63'd0};
        quotient_mask<= 64'h8000_0000_0000_0000;
        sign_c       <= !unsigned_div ? a[63] ^ b[63] : 1'b0;
        r_rd         <= rd;
        r_alu_control<= alu_control;
    end
    else if(cs == BUSY) begin
        if (divisor_reg <= {63'b0, dividend_reg}) begin
            dividend_reg <= dividend_reg - divisor_reg[31:0];
            quotient_reg <= quotient_reg | quotient_mask;
        end
        divisor_reg <= {1'b0, divisor_reg[126:1]};
        quotient_mask  <= {1'b0, quotient_mask[63:1]};
    end
end


assign div_ab = complete ? sign_c ?  ~quotient_reg+1'b1 : quotient_reg : 64'd0;
assign rem_ab = complete ? sign_c ?  ~dividend_reg+1'b1 : dividend_reg : 64'd0;
assign out_valid =  complete;
assign out_rd = r_rd;
assign out_alu_control = r_alu_control;

endmodule



















