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
`include "alu_block.v"
`include "alu_control_block.v"
`include "alu_division_block.v"
`include "alu_multiplication_block.v"
`include "branch_jump_conditional_block.v"
//`include "cla.v"
`include "decoder_block.v"
`include "decoder_control_block.v"
//`include "divider_alu.v"
//`include "fourbit_cla.v"
`include "instruction_cache_model.v"
//`include "mem_cache.v"
`include "memory_handler_block.v"
//`include "multiplier_lca.v"
//`include "onetwoeightbit_lca.v"
`include "operands_swap.v"
`include "pc_counter.v"
`include "register_file.v"
`include "sign_extend.v"
//`include "sixteenbit_lca.v"
//`include "sixtyfourbit_lca.v"
`include "hazard_detection.v"
module RV_64IM_v1 (
    clk,
    rst_n,
    start,
    stop,
    initialisation_wr_valid,
    initialisation_wr_address,
    initialisation_wr_data,
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
);
input clk;
input rst_n;
input start;
input stop;
input initialisation_wr_valid;
input [63:0] initialisation_wr_address;
input [63:0] initialisation_wr_data;
output [63:0] o_mem_wr_data;
output [63:0] o_mem_rd_address;
output o_mem_rd_valid;
output [63:0] o_mem_wr_address;
output o_mem_wr_valid;
input [63:0] i_mem_rd_data;
input i_mem_rd_data_valid;
input [63:0] i_mem_rd_data_tag;
output o_cache_busy;
output cache_miss;
output cache_rd_wr_done;
output mem_rd_wr_done;
//////////////////////////////////////////////////////////////////IF STAGE///////////////////////////////////////////////////////////////////
wire w_stall = 0;
wire w_branch_taken;
wire w_jump_taken;
wire w_jump_location;
wire [63:0] w_new_pc_offset;
wire [63:0] w_branch_offset;
wire [63:0] w_pc;
wire [31:0] w_instruction;
wire w_valid;
pc_counter u_pc_cnt(
    .clk (clk),
    .rst_n (rst_n),
    .start (start),
    .stop (stop),
    .stall (stall_if_id),
    .branch_taken(w_branch_taken),
    .jump_taken(w_jump_taken),
    .jump_location(w_jump_location),
    .new_pc_offset(w_new_pc_offset),
    .branch_offset(w_branch_offset),
    .valid(w_valid),
    .pc(w_pc)
);
instruction_cache_model u_inst_model(
    .pc(w_pc),
    .instruction(w_instruction)
);




reg [32-1:0] d1_instruction;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_instruction <= {32{1'b0}};
   end else begin
       if (stall_id_ex == 1'b1) begin
           d1_instruction <= d1_instruction;
       end else if (!stall_id_ex&w_valid == 1'b1) begin
           d1_instruction <= w_instruction; 
       end else begin
           d1_instruction <= 0;
       end
   end
end
reg [64-1:0] d1_pc;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_pc <= {64{1'b0}};
   end else begin
       if (stall_id_ex == 1'b1) begin
           d1_pc <= d1_pc;
       end else if (!stall_id_ex&w_valid == 1'b1) begin
            d1_pc <= w_pc;
       end else begin
           d1_pc <= 0;
       end
   end
end
reg [1-1:0] d1_valid;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_valid <= {1{1'b0}};
   end else begin
       d1_valid <= w_valid;
   end
end


////////////////////////////////////////////////////////////////ID STAGE///////////////////////////////////////////////////////////////////
wire [6:0] w_opcode;
wire [6:0] w_funct7;
wire [2:0] w_funct3;
wire [4:0] w_rs2,w_rs1,w_rd;
wire [31:0] w_imm;
wire [3:0] w_type_instruction;
wire w_rs1_en;
wire w_rs2_en;
wire w_rd_en;
wire w_rg_op;
wire w_imm_en;
wire w_imm_valid_bits_12;
wire w_ld_en;
wire w_mem_rd;
wire w_ld_b;
wire w_ld_h;
wire w_ld_w;
wire w_ld_d;
wire w_ld_us;
wire w_jmp_en;
wire w_link_en;
wire w_pc_en;
wire w_mem_wr;
wire w_sw_en;
wire w_sw_b;
wire w_sw_h;
wire w_sw_w;
wire w_sw_d;
wire w_imm_valid_bits_13;
wire w_brn_en;
wire w_brn_eq;
wire w_brn_neq;
wire w_brn_lt;
wire w_brn_ge;
wire w_brn_ltu;
wire w_brn_geu;
wire w_imm_valid_bits_21;
wire w_imm_valid_bits_32;
wire w_rs2_int;
/*
wire           w_branch_taken;
wire    [63:0] w_branch_offset;
wire           w_jump_taken;
wire           w_jump_location;
wire    [63:0] w_new_pc_offset;
*/
wire [63:0] w_op1_data;
wire [63:0] w_op2_data;
wire [63:0] w_imm_64;
wire w_wr_en;
wire [63:0] w_wr_data;
wire [63:0] w_rs1_data;
wire [63:0] w_rs2_data;
wire [4:0] w_wr_address;
wire w_read_valid;
wire [63:0] w_read_data;
wire w_alu_in_valid;
decoder_block u_dec_block (
    .instruction (d1_instruction),
    .type_instruction (w_type_instruction),
    .opcode (w_opcode),
    .rs1 (w_rs1),
    .rs2 (w_rs2),
    .imm (w_imm),
    .rd (w_rd),
    .funct3 (w_funct3),
    .funct7 (w_funct7)
);
register_file u_register_file (
    .clk (clk ),
    .rst_n (rst_n ),
    .rs1 (w_rs1 ),
    .rs2 (w_rs2 ),
    .rd (w_wr_address ),
    .wr_en (w_wr_en ),
    .wr_data (w_wr_data ),
    .rs1_data (w_rs1_data),
    .rs2_data (w_rs2_data)
);
decoder_control_block u_dec_control_block (
    .clk (clk ),
    .rst_n (rst_n),
    .type_instruction (w_type_instruction),
    .funct3 (w_funct3),
    .funct7 (w_funct7),
    .rs1_en (w_rs1_en ),
    .rs2_en (w_rs2_en ),
    .rd_en (w_rd_en ),
    .rg_op (w_rg_op ),
    .imm_en (w_imm_en ),
    .imm_valid_bits_12 (w_imm_valid_bits_12 ),
    .ld_en (w_ld_en ),
    .mem_rd (w_mem_rd ),
    .ld_b (w_ld_b ),
    .ld_h (w_ld_h ),
    .ld_w (w_ld_w ),
    .ld_d (w_ld_d ),
    .ld_us (w_ld_us ),
    .jmp_en (w_jmp_en ),
    .link_en (w_link_en ),
    .pc_en (w_pc_en ),
    .mem_wr (w_mem_wr ),
    .sw_en (w_sw_en ),
    .sw_b (w_sw_b ),
    .sw_h (w_sw_h ),
    .sw_w (w_sw_w ),
    .sw_d (w_sw_d ),
    .imm_valid_bits_13 (w_imm_valid_bits_13 ),
    .brn_en (w_brn_en ),
    .brn_eq (w_brn_eq ),
    .brn_neq (w_brn_neq ),
    .brn_lt (w_brn_lt ),
    .brn_ge (w_brn_ge ),
    .brn_ltu (w_brn_ltu ),
    .brn_geu (w_brn_geu ),
    .imm_valid_bits_21 (w_imm_valid_bits_21 ),
    .imm_valid_bits_32 (w_imm_valid_bits_32),
    .rs2_int (w_rs2_int)
);
operands_swap u_op_swap(
    .rs1_en (w_rs1_en),
    .rs2_en (w_rs2_en),
    .pc_en (w_pc_en),
    .imm_en (w_imm_en),
    .rs2_int (w_rs2_int),
    .rs1_data (w_rs1_data),
    .rs2_data (w_rs2_data),
    .pc (d1_pc),
    .imm_64 (w_imm_64),
    .op1_data (w_op1_data),
    .op2_data (w_op2_data)
);
sign_extend u_sign_extend (
    .imm_valid_bits_12 (w_imm_valid_bits_12),
    .imm_valid_bits_13 (w_imm_valid_bits_13),
    .imm_valid_bits_21 (w_imm_valid_bits_21),
    .imm_valid_bits_32 (w_imm_valid_bits_32),
    .imm (w_imm),
    .imm_64 (w_imm_64)
);
branch_jump_conditional_block u_branch_block (
    .brn_en (w_brn_en ),
    .brn_eq (w_brn_eq ),
    .brn_neq (w_brn_neq ),
    .brn_lt (w_brn_lt ),
    .brn_ge (w_brn_ge ),
    .brn_ltu (w_brn_ltu ),
    .brn_geu (w_brn_geu ),
    .jmp_en (w_jmp_en),
    .link_en (w_link_en),
    .rs1_data (w_rs1_data),
    .op1_data (w_op1_data),
    .op2_data (w_op2_data),
    .imm_64 (w_imm_64),
    .branch_taken (w_branch_taken),
    .branch_offset (w_branch_offset),
    .jump_taken (w_jump_taken),
    .jump_location (w_jump_location),
    .new_pc_offset (w_new_pc_offset)
);




























reg [5-1:0] d1_type_instruction;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_type_instruction <= {5{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_type_instruction <= d1_type_instruction;
       end else if (!stall_id_ex&d1_valid) begin
           d1_type_instruction <= w_type_instruction;
       end else begin
           d1_type_instruction <= 0;
       end
   end
end
reg [3-1:0] d1_funct3;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_funct3 <= {3{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_funct3 <= d1_funct3;
       end else if (!stall_id_ex&d1_valid) begin
           d1_funct3 <= w_funct3;
       end else begin
           d1_funct3 <= 0;
       end
   end
end
reg [7-1:0] d1_funct7;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_funct7 <= {7{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_funct7 <= d1_funct7;
       end else if (!stall_id_ex&d1_valid) begin
           d1_funct7 <= w_funct7;
       end else begin
           d1_funct7 <= 0;
       end
   end
end
reg [1-1:0] d1_rs1_en;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_rs1_en <= {1{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_rs1_en <= d1_rs1_en;
       end else if (!stall_id_ex&d1_valid) begin
           d1_rs1_en <= w_rs1_en;
       end else begin
           d1_rs1_en <= 0;
       end
   end
end
reg [1-1:0] d1_rs2_en;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_rs2_en <= {1{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_rs2_en <= d1_rs2_en;
       end else if (!stall_id_ex&d1_valid) begin
           d1_rs2_en <= w_rs2_en;
       end else begin
           d1_rs2_en <= 0;
       end
   end
end
reg [1-1:0] d1_rd_en;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_rd_en <= {1{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_rd_en <= d1_rd_en;
       end else if (!stall_id_ex&d1_valid) begin
           d1_rd_en <= w_rd_en;
       end else begin
           d1_rd_en <= 0;
       end
   end
end
reg [1-1:0] d1_rg_op;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_rg_op <= {1{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_rg_op <= d1_rg_op;
       end else if (!stall_id_ex&d1_valid) begin
           d1_rg_op <= w_rg_op;
       end else begin
           d1_rg_op <= 0;
       end
   end
end
reg [1-1:0] d1_ld_en;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_ld_en <= {1{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_ld_en <= d1_ld_en;
       end else if (!stall_id_ex&d1_valid) begin
           d1_ld_en <= w_ld_en;
       end else begin
           d1_ld_en <= 0;
       end
   end
end
reg [1-1:0] d1_mem_rd;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_mem_rd <= {1{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_mem_rd <= d1_mem_rd;
       end else if (!stall_id_ex&d1_valid) begin
           d1_mem_rd <= w_mem_rd;
       end else begin
           d1_mem_rd <= 0;
       end
   end
end
reg [1-1:0] d1_ld_b;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_ld_b <= {1{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_ld_b <= d1_ld_b;
       end else if (!stall_id_ex&d1_valid) begin
           d1_ld_b <= w_ld_b;
       end else begin
           d1_ld_b <= 0;
       end
   end
end
reg [1-1:0] d1_ld_h;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_ld_h <= {1{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_ld_h <= d1_ld_h;
       end else if (!stall_id_ex&d1_valid) begin
           d1_ld_h <= w_ld_h;
       end else begin
           d1_ld_h <= 0;
       end
   end
end
reg [1-1:0] d1_ld_w;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_ld_w <= {1{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_ld_w <= d1_ld_w;
       end else if (!stall_id_ex&d1_valid) begin
           d1_ld_w <= w_ld_w;
       end else begin
           d1_ld_w <= 0;
       end
   end
end
reg [1-1:0] d1_ld_d;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_ld_d <= {1{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_ld_d <= d1_ld_d;
       end else if (!stall_id_ex&d1_valid) begin
           d1_ld_d <= w_ld_d;
       end else begin
           d1_ld_d <= 0;
       end
   end
end
reg [1-1:0] d1_ld_us;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_ld_us <= {1{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_ld_us <= d1_ld_us;
       end else if (!stall_id_ex&d1_valid) begin
           d1_ld_us <= w_ld_us;
       end else begin
           d1_ld_us <= 0;
       end
   end
end
reg [1-1:0] d1_pc_en;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_pc_en <= {1{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_pc_en <= d1_pc_en;
       end else if (!stall_id_ex&d1_valid) begin
           d1_pc_en <= w_pc_en;
       end else begin
           d1_pc_en <= 0;
       end
   end
end
reg [1-1:0] d1_mem_wr;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_mem_wr <= {1{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_mem_wr <= d1_mem_wr;
       end else if (!stall_id_ex&d1_valid) begin
           d1_mem_wr <= w_mem_wr;
       end else begin
           d1_mem_wr <= 0;
       end
   end
end
reg [1-1:0] d1_sw_en;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_sw_en <= {1{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_sw_en <= d1_sw_en;
       end else if (!stall_id_ex&d1_valid) begin
           d1_sw_en <= w_sw_en;
       end else begin
           d1_sw_en <= 0;
       end
   end
end
reg [1-1:0] d1_sw_b;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_sw_b <= {1{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_sw_b <= d1_sw_b;
       end else if (!stall_id_ex&d1_valid) begin
           d1_sw_b <= w_sw_b;
       end else begin
           d1_sw_b <= 0;
       end
   end
end
reg [1-1:0] d1_sw_h;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_sw_h <= {1{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_sw_h <= d1_sw_h;
       end else if (!stall_id_ex&d1_valid) begin
           d1_sw_h <= w_sw_h;
       end else begin
           d1_sw_h <= 0;
       end
   end
end
reg [1-1:0] d1_sw_w;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_sw_w <= {1{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_sw_w <= d1_sw_w;
       end else if (!stall_id_ex&d1_valid) begin
           d1_sw_w <= w_sw_w;
       end else begin
           d1_sw_w <= 0;
       end
   end
end
reg [1-1:0] d1_sw_d;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_sw_d <= {1{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_sw_d <= d1_sw_d;
       end else if (!stall_id_ex&d1_valid) begin
           d1_sw_d <= w_sw_d;
       end else begin
           d1_sw_d <= 0;
       end
   end
end
reg [5-1:0] d1_rd;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_rd <= {5{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_rd <= d1_rd;
       end else if (!stall_id_ex&d1_valid) begin
           d1_rd <= w_rd;
       end else begin
           d1_rd <= 0;
       end
   end
end
reg [64-1:0] d1_rs2_data;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_rs2_data <= {64{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_rs2_data <= d1_rs2_data;
       end else if (!stall_id_ex&d1_valid) begin
           d1_rs2_data <= w_rs2_data;
       end else begin
           d1_rs2_data <= 0;
       end
   end
end
reg [64-1:0] d1_op1_data;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_op1_data <= {64{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_op1_data <= d1_op1_data;
       end else if (!stall_id_ex&d1_valid) begin
           d1_op1_data <= w_op1_data;
       end else begin
           d1_op1_data <= 0;
       end
   end
end
reg [64-1:0] d1_op2_data;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_op2_data <= {64{1'b0}};
   end else begin
       if (stall_id_ex) begin
           d1_op2_data <= d1_op2_data;
       end else if (!stall_id_ex&d1_valid) begin
           d1_op2_data <= w_op2_data;
       end else begin
           d1_op2_data <= 0;
       end
   end
end
reg [1-1:0] d2_valid;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_valid <= {1{1'b0}};
   end else begin
       d2_valid <= d1_valid;
   end
end
reg [32-1:0] d2_instruction;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_instruction <= {32{1'b0}};
   end else begin
       if (stall_id_ex == 1'b1) begin
           d2_instruction <= d2_instruction;
       end else if (!stall_id_ex&d1_valid == 1'b1) begin
            d2_instruction <= d1_instruction;
       end else begin
           d2_instruction <= 0;
       end
   end
end


////////////////////////////////////////////////////////////EXECUTE////////////////////////////////////////////////////////////////////
wire [4:0] w_alu_control;
wire [63:0] w_alu_output_1;
wire w_alu_valid_1;
wire [63:0] w_alu_output_2;
wire w_alu_valid_2;
wire [63:0] w_alu_output_3;
wire w_alu_valid_3;
wire it_alu_valid;
wire [63:0] it_alu_output;
wire [4:0] d_rd,out_d_rd;
assign d_rd = d2_instruction[11:7];
alu_control_block u_alu_control_block (
    .type_instruction (d1_type_instruction),
    .funct3 (d1_funct3),
    .funct7 (d1_funct7),
    .alu_control (w_alu_control),
    .valid (d2_valid),
    .out_valid (w_alu_in_valid)

);
alu_block u_alu_block (
//    .op1_data (d1_op1_data),
//    .op2_data (d1_op2_data),
    .op1_data (w_bypass_op1_data),
    .op2_data (w_bypass_op2_data),
    .alu_control (w_alu_control),
    .alu_output (w_alu_output_1),
    .alu_valid (w_alu_valid_1),
    .valid (w_alu_in_valid)
);
alu_multiplication_block u_alu_mult_block(
    .clk (clk),
    .rst_n (rst_n),
//    .op1_data (d1_op1_data),
//    .op2_data (d1_op2_data),
    .op1_data (w_bypass_op1_data),
    .op2_data (w_bypass_op2_data),
    .alu_control (w_alu_control),
    .alu_valid (w_alu_valid_2),
    .alu_output (w_alu_output_2),
    .valid     (w_alu_in_valid)
);
alu_division_block u_alu_division_block (
    .clk (clk),
    .rst_n (rst_n),
//    .op1_data (d1_op1_data),
//    .op2_data (d1_op2_data),
    .op1_data (w_bypass_op1_data),
    .op2_data (w_bypass_op2_data),
    .rd (d_rd),
    .alu_control (w_alu_control),
    .alu_valid (w_alu_valid_3),
    .alu_output (w_alu_output_3),
    .out_rd (out_d_rd),
    .valid (w_alu_in_valid)
);
assign it_alu_valid = w_alu_valid_1;
assign it_alu_output = w_alu_output_1;

























reg [32-1:0] d3_instruction;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d3_instruction <= {32{1'b0}};
   end else begin
       if (stall_ex_mrw == 1'b1) begin
           d3_instruction <= d3_instruction;
       end else if (!stall_ex_mrw&d2_valid == 1'b1) begin
            d3_instruction <= d2_instruction;
       end else begin
           d3_instruction <= 0;
       end
   end
end
reg [1-1:0] d1_alu_valid;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_alu_valid <= {1{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d1_alu_valid <= d1_alu_valid;
       end else if (!stall_ex_mrw&d2_valid) begin
           d1_alu_valid <= it_alu_valid;
       end else begin
           d1_alu_valid <= 0;
       end
   end
end
reg [64-1:0] d1_alu_output;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_alu_output <= {64{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d1_alu_output <= d1_alu_output;
       end else if (!stall_ex_mrw&d2_valid) begin
           d1_alu_output <= it_alu_output;
       end else begin
           d1_alu_output <= 0;
       end
   end
end
reg [1-1:0] d2_rs1_en;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_rs1_en <= {1{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_rs1_en <= d2_rs1_en;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_rs1_en <= d1_rs1_en;
       end else begin
           d2_rs1_en <= 0;
       end
   end
end
reg [1-1:0] d2_rs2_en;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_rs2_en <= {1{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_rs2_en <= d2_rs2_en;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_rs2_en <= d1_rs2_en;
       end else begin
           d2_rs2_en <= 0;
       end
   end
end
reg [1-1:0] d2_rd_en;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_rd_en <= {1{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_rd_en <= d2_rd_en;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_rd_en <= d1_rd_en;
       end else begin
           d2_rd_en <= 0;
       end
   end
end
reg [1-1:0] d2_rg_op;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_rg_op <= {1{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_rg_op <= d2_rg_op;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_rg_op <= d1_rg_op;
       end else begin
           d2_rg_op <= 0;
       end
   end
end
reg [1-1:0] d2_ld_en;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_ld_en <= {1{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_ld_en <= d2_ld_en;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_ld_en <= d1_ld_en;
       end else begin
           d2_ld_en <= 0;
       end
   end
end
reg [1-1:0] d2_mem_rd;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_mem_rd <= {1{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_mem_rd <= d2_mem_rd;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_mem_rd <= d1_mem_rd;
       end else begin
           d2_mem_rd <= 0;
       end
   end
end
reg [1-1:0] d2_ld_b;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_ld_b <= {1{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_ld_b <= d2_ld_b;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_ld_b <= d1_ld_b;
       end else begin
           d2_ld_b <= 0;
       end
   end
end
reg [1-1:0] d2_ld_h;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_ld_h <= {1{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_ld_h <= d2_ld_h;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_ld_h <= d1_ld_h;
       end else begin
           d2_ld_h <= 0;
       end
   end
end
reg [1-1:0] d2_ld_w;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_ld_w <= {1{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_ld_w <= d2_ld_w;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_ld_w <= d1_ld_w;
       end else begin
           d2_ld_w <= 0;
       end
   end
end
reg [1-1:0] d2_ld_d;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_ld_d <= {1{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_ld_d <= d2_ld_d;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_ld_d <= d1_ld_d;
       end else begin
           d2_ld_d <= 0;
       end
   end
end
reg [1-1:0] d2_ld_us;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_ld_us <= {1{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_ld_us <= d2_ld_us;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_ld_us <= d1_ld_us;
       end else begin
           d2_ld_us <= 0;
       end
   end
end
reg [1-1:0] d2_pc_en;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_pc_en <= {1{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_pc_en <= d2_pc_en;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_pc_en <= d1_pc_en;
       end else begin
           d2_pc_en <= 0;
       end
   end
end
reg [1-1:0] d2_mem_wr;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_mem_wr <= {1{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_mem_wr <= d2_mem_wr;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_mem_wr <= d1_mem_wr;
       end else begin
           d2_mem_wr <= 0;
       end
   end
end
reg [1-1:0] d2_sw_en;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_sw_en <= {1{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_sw_en <= d2_sw_en;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_sw_en <= d1_sw_en;
       end else begin
           d2_sw_en <= 0;
       end
   end
end
reg [1-1:0] d2_sw_b;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_sw_b <= {1{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_sw_b <= d2_sw_b;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_sw_b <= d1_sw_b;
       end else begin
           d2_sw_b <= 0;
       end
   end
end
reg [1-1:0] d2_sw_h;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_sw_h <= {1{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_sw_h <= d2_sw_h;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_sw_h <= d1_sw_h;
       end else begin
           d2_sw_h <= 0;
       end
   end
end
reg [1-1:0] d2_sw_w;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_sw_w <= {1{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_sw_w <= d2_sw_w;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_sw_w <= d1_sw_w;
       end else begin
           d2_sw_w <= 0;
       end
   end
end
reg [1-1:0] d2_sw_d;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_sw_d <= {1{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_sw_d <= d2_sw_d;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_sw_d <= d1_sw_d;
       end else begin
           d2_sw_d <= 0;
       end
   end
end
reg [5-1:0] d2_rd;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_rd <= {5{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_rd <= d2_rd;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_rd <= d1_rd;
       end else begin
           d2_rd <= 0;
       end
   end
end
reg [64-1:0] d2_rs2_data;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_rs2_data <= {64{1'b0}};
   end else begin
       if (stall_ex_mrw) begin
           d2_rs2_data <= d2_rs2_data;
       end else if (!stall_ex_mrw&d2_valid) begin
           d2_rs2_data <= d1_rs2_data;
       end else begin
           d2_rs2_data <= 0;
       end
   end
end
reg [1-1:0] d3_valid;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d3_valid <= {1{1'b0}};
   end else begin
       d3_valid <= d2_valid;
   end
end


//////////////////////////////////////////////////////////Mem stage////////////////////////////////////////////////////////
memory_handler_block u_memhandler(
    .clk (clk),
    .rst_n (rst_n),
    .initialisation_wr_valid (initialisation_wr_valid),
    .initialisation_wr_address (initialisation_wr_address),
    .initialisation_wr_data (initialisation_wr_data),
    .alu_valid (d1_alu_valid),
    .ld_en (d2_ld_en),
    .ld_b (d2_ld_b),
    .ld_h (d2_ld_h),
    .ld_w (d2_ld_w),
    .ld_d (d2_ld_d),
    .ld_us (d2_ld_us),
    .sw_en (d2_sw_en),
    .sw_b (d2_sw_b),
    .sw_h (d2_sw_h),
    .sw_w (d2_sw_w),
    .sw_d (d2_sw_d),
    .address (d1_alu_output),
    .write_data (d2_rs2_data),
    .read_valid (w_read_valid),
    .read_data (w_read_data),
    .o_mem_wr_data (o_mem_wr_data),
    .o_mem_rd_address (o_mem_rd_address),
    .o_mem_rd_valid (o_mem_rd_valid),
    .o_mem_wr_address (o_mem_wr_address),
    .o_mem_wr_valid (o_mem_wr_valid),
    .i_mem_rd_data (i_mem_rd_data),
    .i_mem_rd_data_valid (i_mem_rd_data_valid),
    .i_mem_rd_data_tag (i_mem_rd_data_tag),
    .o_cache_busy (o_cache_busy),
    .cache_miss (cache_miss),
    .cache_rd_wr_done (cache_rd_wr_done),
    .mem_rd_wr_done (mem_rd_wr_done)
//    .valid_1 (valid_1),
//    .cache_mem_1 (cache_mem_1),
//    .tag_1 (tag_1)

);










reg [1-1:0] d3_mem_rd;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d3_mem_rd <= {1{1'b0}};
   end else begin
       if (stall_mrw_wb) begin
           d3_mem_rd <= d3_mem_rd;
       end else if (!stall_mrw_wb&d3_valid) begin
           d3_mem_rd <= d2_mem_rd;
       end else begin
           d3_mem_rd <= 0;
       end
   end
end
reg [1-1:0] d3_rg_op;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d3_rg_op <= {1{1'b0}};
   end else begin
       if (stall_mrw_wb) begin
           d3_rg_op <= d3_rg_op;
       end else if (!stall_mrw_wb&d3_valid) begin
           d3_rg_op <= d2_rg_op;
       end else begin
           d3_rg_op <= 0;
       end
   end
end

reg [1-1:0] d3_mem_wr;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d3_mem_wr <= {1{1'b0}};
   end else begin
       if (stall_mrw_wb) begin
           d3_mem_wr <= d3_mem_wr;
       end else if (!stall_mrw_wb&d3_valid) begin
           d3_mem_wr <= d2_mem_wr;
       end else begin
           d3_mem_wr <= 0;
       end
   end
end
reg [5-1:0] d3_rd;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d3_rd <= {5{1'b0}};
   end else begin
       if (stall_mrw_wb) begin
           d3_rd <= d3_rd;
       end else if (!stall_mrw_wb&d3_valid) begin
           d3_rd <= d2_rd;
       end else begin
           d3_rd <= 0;
       end
   end
end
reg [32-1:0] d4_instruction;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d4_instruction <= {32{1'b0}};
   end else begin
       if (stall_mrw_wb == 1'b1) begin
           d4_instruction <= d4_instruction;
       end else if (!stall_mrw_wb&d3_valid == 1'b1) begin
           d4_instruction <= d3_instruction;
       end else begin
           d4_instruction <= 0;
       end
   end
end
reg [1-1:0] d2_alu_valid;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_alu_valid <= {1{1'b0}};
   end else begin
       if (stall_mrw_wb) begin
           d2_alu_valid <= d2_alu_valid;
       end else if (!stall_mrw_wb&d3_valid) begin
           d2_alu_valid <= d1_alu_valid;
       end else begin
           d2_alu_valid <= 0;
       end
   end
end
reg [64-1:0] d2_alu_output;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d2_alu_output <= {64{1'b0}};
   end else begin
       if (stall_mrw_wb) begin
           d2_alu_output <= d2_alu_output;
       end else if (!stall_mrw_wb&d3_valid) begin
           d2_alu_output <= d1_alu_output;
       end else begin
           d2_alu_output <= 0;
       end
   end
end
/*
reg [1-1:0] d1_read_valid;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_read_valid <= {1{1'b0}};
   end else begin
       if (!w_stall&d3_valid == 1'b1) begin
           d1_read_valid <= w_read_valid;
       end else if (!w_stall&d3_valid == 1'b0) begin
       end else begin
           d1_read_valid <= 0;
       end
   end
end
reg [64-1:0] d1_read_data;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d1_read_data <= {64{1'b0}};
   end else begin
       if (!w_stall&d3_valid == 1'b1) begin
           d1_read_data <= w_read_data;
       end else if (!w_stall&d3_valid == 1'b0) begin
       end else begin
           d1_read_data <= 0;
       end
   end
end
*/

wire d1_read_valid = w_read_valid;
wire [63:0] d1_read_data = w_read_data;
reg [1-1:0] d4_valid;
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
       d4_valid <= {1{1'b0}};
   end else begin
       d4_valid <= d3_valid;
   end
end


////////////////////////////////////////////////////////WB//////////////////////////////////////////////////////////////////////////
assign w_wr_en = d3_mem_rd ? d1_read_valid : d2_alu_valid&d3_rg_op ? 1'b1 : w_alu_valid_2 ? 1'b1 : w_alu_valid_3 ;
assign w_wr_data = d3_mem_rd ? d1_read_data : d2_alu_valid&d3_rg_op ? d2_alu_output : w_alu_valid_2 ? w_alu_output_2 : w_alu_valid_3 ? w_alu_output_3 : 64'd0;
assign w_wr_address = w_alu_valid_3 ? out_d_rd : d3_rd;
////////////////////////////////////////////////////Hazard_detection/////////////////////////////////////////////////////////////////



wire w_hazard_detected;
wire [2:0] w_bypass_activate_op1,w_bypass_activate_op2;
wire w_bypass_op1,w_bypass_op2;
wire [3:0] w_stall_activate;

hazard_detection u_h_d (
    .clk                	(clk),
    .rst_n              	(rst_n),
    .valid_1            	(d2_valid),
    .instruction_1      	(d2_instruction),
    .valid_2            	(d3_valid),
    .instruction_2      	(d3_instruction),
    .valid_3            	(d4_valid),
    .instruction_3      	(d4_instruction),
    .hazard_detected    	(w_hazard_detected),
    .bypass_activate_op1	(w_bypass_activate_op1),
    .bypass_activate_op2	(w_bypass_activate_op2),
    .bypass_op1         	(w_bypass_op1),
    .bypass_op2         	(w_bypass_op2),
    .stall_activate     	(w_stall_activate)
);


wire [63:0] w_bypass_op1_data;
wire [63:0] w_bypass_op2_data;

assign w_bypass_op1_data = w_hazard_detected & w_bypass_op1 ? (w_bypass_activate_op1 == 3'b110) ? d1_alu_output : (w_bypass_activate_op1 == 3'b101) ? w_wr_data : d1_op1_data : d1_op1_data;

assign w_bypass_op2_data = w_hazard_detected & w_bypass_op2 ? (w_bypass_activate_op2 == 3'b110) ? d1_alu_output : (w_bypass_activate_op2 == 3'b101) ? w_wr_data : d1_op2_data : d1_op2_data;


wire stall_if_id;
wire stall_id_ex;
wire stall_ex_mrw;
wire stall_mrw_wb;


assign stall_if_id  = w_hazard_detected & w_stall_activate[3];
assign stall_id_ex  = w_hazard_detected & w_stall_activate[2];
assign stall_ex_mrw = w_hazard_detected & w_stall_activate[1];
assign stall_mrw_wb = w_hazard_detected & w_stall_activate[0];

endmodule
