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
`include "mem_cache.v"

module memory_handler_block (
clk,
rst_n,
initialisation_wr_valid,
initialisation_wr_address,
initialisation_wr_data,
alu_valid,
ld_en,
ld_b,
ld_h,
ld_w,
ld_d,
ld_us,
sw_en,
sw_b,
sw_h,
sw_w,
sw_d,
//write_valid,
address,
write_data,
read_valid,
read_data,
o_mem_wr_data,
o_mem_rd_address,
o_mem_rd_valid,
o_mem_wr_address,
o_mem_wr_valid,
i_mem_rd_data,
i_mem_rd_data_valid,
i_mem_rd_data_tag,
o_cache_busy,
cache_miss,
cache_rd_wr_done,
mem_rd_wr_done
//valid_1,
//cache_mem_1,
//tag_1
);

parameter AWIDTH = 64, WIDTH=64,TAG_WIDTH=47;
input               clk;
input               rst_n;
input initialisation_wr_valid;
input [AWIDTH-1:0] initialisation_wr_address;
input [WIDTH-1:0] initialisation_wr_data;
input ld_en;
input ld_b;
input ld_h;
input ld_w;
input ld_d;
input ld_us;
input alu_valid;
input sw_en;
input sw_b;
input sw_h;
input sw_w;
input sw_d;
//input write_valid;
input [63:0] address;
input [63:0] write_data;
output read_valid;
output reg  [63:0] read_data;
output cache_miss;
output cache_rd_wr_done;
output mem_rd_wr_done;
output              o_cache_busy;
output [WIDTH-1:0]  o_mem_wr_data;
output [AWIDTH-1:0] o_mem_rd_address;
output              o_mem_rd_valid;
output [AWIDTH-1:0] o_mem_wr_address;
output              o_mem_wr_valid;
input  [WIDTH-1:0]  i_mem_rd_data;
input               i_mem_rd_data_valid;
input  [AWIDTH-1:0] i_mem_rd_data_tag;
//output valid_1 [0:1023];
//output [WIDTH-1:0] cache_mem_1 [0:1023];
//output [TAG_WIDTH-1] tag_1 [0:1023];
wire [WIDTH-1:0] w1_write_data;
wire [WIDTH-1:0] w_read_data;
wire w_read_valid;
wire w_rd_valid = ld_en & alu_valid;
wire w_wr_valid = ((sw_en & alu_valid)|initialisation_wr_valid);
wire [AWIDTH-1:0] w_address = initialisation_wr_address | address;
wire [WIDTH-1:0] w_write_data = initialisation_wr_data | w1_write_data; 
 
assign w1_write_data = sw_b ? {{56{1'b0}},write_data[7:0]} : sw_h ? {{48{1'b0}},write_data[15:0]} : sw_w ? {{32{1'b0}},write_data[31:0]} : write_data;

mem_cache  uut (
  .clk               (clk)
 ,.rst_n            (rst_n)
 ,.i_cpu_address    (w_address) 
 ,.i_cpu_din        (w_write_data)
 ,.i_rd_valid       (w_rd_valid)
 ,.i_wr_valid       (w_wr_valid)
 ,.o_cpu_dout_valid (w_read_valid)
 ,.o_cpu_dout_data  (w_read_data)
 ,.o_cache_busy     (o_cache_busy)
 ,.miss             (cache_miss)
 ,.o_mem_wr_data    (o_mem_wr_data)
 ,.o_mem_rd_address (o_mem_rd_address)
 ,.o_mem_rd_valid   (o_mem_rd_valid)
 ,.o_mem_wr_address (o_mem_wr_address)
 ,.o_mem_wr_valid   (o_mem_wr_valid)
 ,.i_mem_rd_data    (i_mem_rd_data)
 ,.i_mem_rd_data_valid (i_mem_rd_data_valid)
 ,.i_mem_rd_data_tag   (i_mem_rd_data_tag)
 ,.cache_rd_wr_done    (cache_rd_wr_done)
 ,.mem_rd_wr_done      (mem_rd_wr_done)
// ,.valid_1             (valid_1)
// ,.cache_mem_1         (cache_mem_1)
// ,.tag_1               (tag_1)
);
reg ld_en_d1;
reg ld_b_d1;
reg ld_h_d1;
reg ld_w_d1;
reg ld_d_d1;
reg ld_us_d1;

always@(posedge clk or negedge rst_n)
    if(!rst_n)
        ld_en_d1 <= 0;
    else
        ld_en_d1 <= ld_en;

always@(posedge clk or negedge rst_n)
    if(!rst_n)
        ld_b_d1 <= 0;
    else
        ld_b_d1 <= ld_b;


always@(posedge clk or negedge rst_n)
    if(!rst_n)
        ld_h_d1 <= 0;
    else
        ld_h_d1 <= ld_h;


always@(posedge clk or negedge rst_n)
    if(!rst_n)
        ld_w_d1 <= 0;
    else
        ld_w_d1 <= ld_w;


always@(posedge clk or negedge rst_n)
    if(!rst_n)
        ld_d_d1 <= 0;
    else
        ld_d_d1 <= ld_d;


always@(posedge clk or negedge rst_n)
    if(!rst_n)
        ld_us_d1 <= 0;
    else
        ld_us_d1 <= ld_us;









assign read_valid = w_read_valid;
always@(*) begin
    read_data = 64'd0;
    if(ld_b_d1) begin
        if (!ld_us_d1) begin
            read_data = {{56{w_read_data[7]}},w_read_data[7:0]};
        end
        else begin
            read_data = {{56{1'b0}},w_read_data[7:0]};
        end
    end
    else if(ld_h_d1) begin
        if (!ld_us_d1) begin
            read_data = {{48{w_read_data[15]}},w_read_data[15:0]};
        end
        else begin
            read_data = {{48{1'b0}},w_read_data[15:0]};
        end
    end
    else if(ld_w_d1) begin
        if (!ld_us_d1) begin
            read_data = {{32{w_read_data[31]}},w_read_data[31:0]};
        end
        else begin
            read_data = {{32{1'b0}},w_read_data[31:0]};
        end
    end
    else if(ld_d_d1) begin
        read_data = w_read_data;
    end
end

   
endmodule





