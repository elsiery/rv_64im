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
`timescale 1ns/1ps
`include "RV_64IM_v1.v"
`define INS_NUMBER 36
module RV_64IM_test;

reg clk;
reg rst_n;
reg start;
reg stop;
reg initialisation_wr_valid;
reg [63:0] initialisation_wr_address;
reg [63:0] initialisation_wr_data;
wire [63:0] o_mem_wr_data;
wire [63:0] o_mem_rd_address;
wire o_mem_rd_valid;
wire [63:0] o_mem_wr_address;
wire o_mem_wr_valid;
reg [63:0] i_mem_rd_data;
reg i_mem_rd_data_valid;
reg [63:0] i_mem_rd_data_tag;
wire o_cache_busy;
wire cache_miss;
wire cache_rd_wr_done;
wire mem_rd_wr_done;
wire valid_1 [0:1023];
wire [63:0] cache_mem_1 [0:1023];
wire [46:0] tag_1 [0:1023];
reg [31:0] i_mem [0:`INS_NUMBER -1];
reg [63:0] d_mem [0:1023];
reg [63:0] r_mem [0:31];
reg [6:0] t_opcode,q_opcode,p_opcode;
reg [4:0] t_rd,t_rs1,t_rs2,q_rd,q_rs2,p_rd,p_rs1,p_rs2;
reg [2:0] t_func3,q_funct3,p_funct3;
reg [6:0] t_func7,p_funct7;
reg [63:0] t_mem_access,p_mem_out;
integer i,c;
integer r,j,k,l,m,n,p,fetch,decode,execute,mem_access_number,wb_number,q,s,a,md;
integer rpt;
reg [63:0] t_alu_out,q_alu_out,p_alu_out,p_mul_divide;
reg [63:0] comp;
reg [4:0] comp_addr,addr,j_rs1,r_rs1,q_rs1,l_rs1;
reg [63:0] wrapped_address;
reg [63:0] j_interim_offset,l_interim_offset,r_interim_offset,q_interim_offset,p_interim_offset;
reg [64:0] j_branch_jump_taken,p_branch_jump_taken,q_branch_jump_taken,r_branch_jump_taken,l_branch_jump_taken;
RV_64IM_v1 u_dut(
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
//    valid_1,
//    cache_mem_1,
//    tag_1
);




always #5 clk = ~clk;
initial begin
    $readmemh("sixth_program_hexa.txt",i_mem);
    rpt = $fopen("sixth_program_report1.rpt");
end

initial begin
    $dumpfile("RV_waves.vcd");
    $dumpvars();
end

initial begin
    clk = 0;
    rst_n=1;
    start=0;
    stop=1;
    s = 0;
    a = 0;
    i_mem_rd_data=0;
    i_mem_rd_data_tag=0;
    i_mem_rd_data_valid=0;
    initialisation_wr_valid = 0;
    initialisation_wr_address = 0;
    initialisation_wr_data = 0;

    for (i=0;i<32;i=i+1) begin
        r_mem[i] = i;
    end
    for (i=0;i<1023;i=i+1) begin
        d_mem[i]=0;
    end
    @(posedge clk);
    rst_n=0;
    @(posedge clk);
    rst_n=1;
    #30;
    @(posedge clk);
    initialisation_wr_valid = 1'b1;
    #150000;
    @(posedge clk);
    initialisation_wr_valid = 1'b0;
    @(posedge clk);
    start=1;
    stop=0;
    @(posedge clk);
    start=0;

    #5000;
    //$display("Fetch=%d",fetch);
    $display("Fetch=%d,decode=%d,execute=%d,mem_access=%d,wb_number=%d",fetch,decode,execute,mem_access_number,wb_number);
    $finish;
end
always@(posedge clk) begin
    if(initialisation_wr_valid) begin
        initialisation_wr_address = s*64;
        initialisation_wr_data     = 0;
    end
end
always@(posedge clk) begin
    if(initialisation_wr_valid) begin
    if(initialisation_wr_valid&cache_miss) begin
        a = a+1;
        if(a==3) begin
            i_mem_rd_data = 64;
            i_mem_rd_data_valid = cache_miss;
            i_mem_rd_data_tag   = initialisation_wr_address;
            a = 0;
        end
    end
    else begin
        i_mem_rd_data_valid = 1'b0;
    end
end
end
always@(posedge clk) begin
    #1;
    if(initialisation_wr_valid & !cache_miss & cache_rd_wr_done) begin
        #1;
        if((s<2047)) begin
            s = s+1;
        end
        else begin
            initialisation_wr_valid=0;
            initialisation_wr_address=0;
            initialisation_wr_data=0;
        end
    end
end


initial begin
    @(posedge clk);
    @(posedge clk);
    #30;
    @(posedge clk);
    #150000;
    @(posedge clk);
    @(posedge clk);
    fetch = 0;
    j_branch_jump_taken=0;
    for(j=0;j<`INS_NUMBER;j=j+0) begin
        #1;
        k = j*64;
        if ((k==u_dut.w_pc)&&(i_mem[j]==u_dut.w_instruction)) begin
            $fdisplay(rpt,"Fetch stage is accurate for instruction %d",j);
            fetch = fetch+1;
        end
        else begin 
            $fdisplay(rpt,"Fetch stage is not accurate for instruction %d and pc is %d and k is %d",j,u_dut.w_pc,k);
        end
        @(posedge clk);
        if (j>=1) begin
            j_branch_jump_taken = branch_jump_taken(j-1);
        end
        else
            j_branch_jump_taken = 0;
        if (j_branch_jump_taken[64]&&(i_mem[j-1][6:0]!=103)) begin
            j = j_branch_jump_taken[63:6]+j;
            //$fdisplay(rpt,"j=%d,j_branch_jump_taken=%h",j,j_branch_jump_taken);
        end
        else if (j_branch_jump_taken[64]&&(i_mem[j-1][6:0]==103)) begin
            j_rs1 = i_mem[j-1][19:15];
            j_interim_offset = j_branch_jump_taken[63:0] + r_mem[j_rs1];
            j = j_interim_offset[63:6]; 
            //$fdisplay(rpt,"j=%h",j);
            //$fdisplay(rpt,"j_rs1=%h,value=%h",j_rs1,r_mem[j_rs1]);
        end
        else begin
            j = j+1;
        end
    end

end



function [64:0] branch_jump_taken;
    input integer c;
    reg [6:0] c_opcode;
    reg [2:0] c_funct3;
    reg [4:0] c_rs1;
    reg [4:0] c_rs2;
    reg [63:0] c_rs1_data;
    reg [63:0] c_rs2_data;
    reg [12:0] c_imm;
    begin
        c_opcode    = i_mem[c][6:0];
        c_imm[11]   = i_mem[c][7];
        c_imm[4:1]  = i_mem[c][11:8];
        c_funct3    = i_mem[c][14:12];
        c_rs1       = i_mem[c][19:15];
        c_rs2       = i_mem[c][24:20];
        c_imm[10:5] = i_mem[c][30:25];
        c_imm[12]   = i_mem[c][31];
        c_imm[0]    = 0;
        c_rs1_data  = r_mem[c_rs1];
        c_rs2_data  = r_mem[c_rs2];
        //$display("c_opcode=%d",c_opcode);
        if (c_opcode==99) begin
            if(c_funct3==0) begin
                if((c_rs1_data==c_rs2_data))
                    branch_jump_taken = {1'b1,{51{c_imm[12]}},c_imm};
                else
                    branch_jump_taken = 0;
            end else if(c_funct3==1) begin
                if((c_rs1_data!=c_rs2_data))
                    branch_jump_taken = {1'b1,{51{c_imm[12]}},c_imm};
                else
                    branch_jump_taken = 0;
            end else if(c_funct3==4) begin
                if(($signed(c_rs1_data) < $signed(c_rs2_data)))
                    branch_jump_taken = {1'b1,{51{c_imm[12]}},c_imm};
                else
                    branch_jump_taken = 0;
            end else if(c_funct3==5) begin
                if(($signed(c_rs1_data) >= $signed(c_rs2_data)))
                    branch_jump_taken = {1'b1,{51{c_imm[12]}},c_imm};
                else
                    branch_jump_taken = 0;
            end else if(c_funct3==6) begin
                if(((c_rs1_data) < (c_rs2_data)))
                    branch_jump_taken = {1'b1,{51{c_imm[12]}},c_imm};
                else
                    branch_jump_taken = 0;
            end else if(c_funct3==7) begin
                if(((c_rs1_data) >= (c_rs2_data)))
                    branch_jump_taken = {1'b1,{51{c_imm[12]}},c_imm};
                else
                    branch_jump_taken = 0;
            end
        end
        else if(c_opcode==111) begin
            branch_jump_taken = {1'b1,{43{i_mem[c][31]}},i_mem[c][31],i_mem[c][19:12],i_mem[c][20],i_mem[c][30:21],1'b0};
            //$display("offset =%h",branch_jump_taken);
        end
        else if(c_opcode==103) begin
            branch_jump_taken = {1'b1,{52{i_mem[c][31]}},i_mem[c][31:20]};
            //$fdisplay(rpt,"branch_jump_taken=%h",branch_jump_taken);
        end
        else begin
            branch_jump_taken = 0;
        end
    end
endfunction


initial begin
    @(posedge clk);
    @(posedge clk);
    #30;
    @(posedge clk);
    #150000;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    decode = 0;
    for(l=0;l<`INS_NUMBER;l=l+0) begin
        #1;
        t_opcode    = i_mem[l][6:0];
        t_rd        = i_mem[l][11:7];
        t_func3     = i_mem[l][14:12];
        t_rs1       = i_mem[l][19:15];
        t_rs2       = i_mem[l][24:20];
        t_func7     = i_mem[l][31:25];
        if ((t_opcode==u_dut.w_opcode)&&
            (t_rs1==u_dut.w_rs1) &&
            (t_rs2==u_dut.w_rs2) &&
            (t_rd==u_dut.w_rd) &&
            (t_func3==u_dut.w_funct3)&&
            (t_func7==u_dut.w_funct7)) begin
            $fdisplay(rpt,"decode stage is accurate for instruction %d",l);
            decode = decode+1;
        end
        else begin 
            $fdisplay(rpt,"decode stage is not accurate for instruction %d",l);
        end
        @(posedge clk);
        if (l>=1) begin
            l_branch_jump_taken = branch_jump_taken(l-1);
        end
        else
            l_branch_jump_taken = 0;
        /*
        if (l_branch_jump_taken[64]) begin
            l = l_branch_jump_taken[63:6]+l;
        end
        else begin
            l = l+1;
        end
        */
        if (l_branch_jump_taken[64]&&(i_mem[l-1][6:0]!=103)) begin
            l = l_branch_jump_taken[63:6]+l;
            //$fdisplay(rpt,"l=%d,l_branch_jump_taken=%h",l,l_branch_jump_taken);
        end
        else if (l_branch_jump_taken[64]&&(i_mem[l-1][6:0]==103)) begin
            l_rs1 = i_mem[l-1][19:15];
            l_interim_offset = l_branch_jump_taken[63:0] + r_mem[l_rs1];
            l = l_interim_offset[63:6]; 
            //$fdisplay(rpt,"l=%h",l);
            //$fdisplay(rpt,"l_rs1=%h,value=%h",l_rs1,r_mem[l_rs1]);
        end
        else begin
            l = l+1;
        end
    end
end
initial begin
    @(posedge clk);
    @(posedge clk);
    #30;
    @(posedge clk);
    #150000;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    execute = 0;
    for(r=0;r<`INS_NUMBER;r=r+0) begin
        #1;
        t_alu_out = m_alu_out(r);
        if((i_mem[r][6:0] != 99) && !((i_mem[r][14:12] <= 7)&&(i_mem[r][14:12] >= 0)&&(i_mem[r][31:25]==1)&&(i_mem[r][6:0]==51))) begin
            if((t_alu_out==u_dut.w_alu_output_1)&&(u_dut.w_alu_valid_1)) begin
                $fdisplay(rpt,"Alu is accurate for instruction %d",r);
                //$fdisplay(rpt,"r=%d,t_alu_out=%d,w_alu_output=%d",r,t_alu_out,u_dut.w_alu_output_1);
                //$fdisplay(rpt,"%d %d %d",u_dut.w_bypass_op1_data,u_dut.w_bypass_op2_data,u_dut.w_alu_control);
                execute=execute+1;
            end 
            else begin
                $fdisplay(rpt,"Alu is not accurate for instruction %d",r);
                $fdisplay(rpt,"%d %d",t_alu_out,u_dut.w_alu_output_1);
                $fdisplay(rpt,"%d %d %d",u_dut.w_bypass_op1_data,u_dut.w_bypass_op2_data,u_dut.w_alu_control);
            end
        end else begin
            execute=execute+1;
        end 
        @(posedge clk);
        if (r>=1) begin
            r_branch_jump_taken = branch_jump_taken(r-1);
        end
        else
            r_branch_jump_taken = 0;
        /*
        if (r_branch_jump_taken[64]) begin
            r = r_branch_jump_taken[63:6]+r;
        end
        else begin
            r = r+1;
        end
        */
        if (r_branch_jump_taken[64]&&(i_mem[r-1][6:0]!=103)) begin
            r = r_branch_jump_taken[63:6]+r;
            //$fdisplay(rpt,"r=%d,r_branch_jump_taken=%h",r,r_branch_jump_taken);
        end
        else if (r_branch_jump_taken[64]&&(i_mem[r-1][6:0]==103)) begin
            r_rs1 = i_mem[r-1][19:15];
            r_interim_offset = r_branch_jump_taken[63:0] + r_mem[r_rs1];
            r = r_interim_offset[63:6]; 
            //$fdisplay(rpt,"r=%h",r);
            //$fdisplay(rpt,"r_rs1=%h,value=%h",r_rs1,r_mem[r_rs1]);
        end
        else begin
            r = r+1;
        end
    end
end
initial begin
    @(posedge clk);
    @(posedge clk);
    #30;
    @(posedge clk);
    #150000;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    mem_access_number = 0;
    for(q=0;q<`INS_NUMBER;q=q+0) begin
        #1;
        t_mem_access = mem_access(q);
        q_alu_out = m_alu_out(q);
        q_opcode = i_mem[q][6:0];
        q_rs2    = i_mem[q][24:20];
        q_funct3 = i_mem[q][14:12];
        wrapped_address = q_alu_out[63:6];
        if ((q_opcode==35)&&(q_funct3==0)) begin
            d_mem[wrapped_address][7:0] = r_mem[q_rs2][7:0];
        end
        else if ((q_opcode==35)&&(q_funct3==1)) begin
            d_mem[wrapped_address][15:0] = r_mem[q_rs2][15:0];
        end
        else if ((q_opcode==35)&&(q_funct3==2)) begin
            d_mem[wrapped_address][31:0] = r_mem[q_rs2][31:0];
        end
        else if ((q_opcode==35)&&(q_funct3==3)) begin
            d_mem[wrapped_address] = r_mem[q_rs2];
        end
        if(q_opcode == 35) begin
            if(q_funct3==0) begin 
                if((d_mem[wrapped_address][7:0]==u_dut.d2_rs2_data[7:0])&&(q_alu_out==u_dut.d1_alu_output)) begin 
                    $fdisplay(rpt,"memory wr is accurate for instruction %d",q);
                    mem_access_number = mem_access_number+1;
                end
                else begin
                    $fdisplay(rpt,"memory wr is not accurate for instruction %d",q);
                    $fdisplay(rpt,"%d %d",d_mem[wrapped_address][7:0],u_dut.d2_rs2_data[7:0]);
                    $fdisplay(rpt,"%d %d",q_alu_out,u_dut.d1_alu_output);
                end
            end
            else if(q_funct3==1) begin 
                if((d_mem[wrapped_address][15:0]==u_dut.d2_rs2_data[15:0])&&(q_alu_out==u_dut.d1_alu_output)) begin 
                    $fdisplay(rpt,"memory wr is accurate for instruction %d",q);
                    mem_access_number = mem_access_number+1;
                end
                else begin
                    $fdisplay(rpt,"memory wr is not accurate for instruction %d",q);
                    $fdisplay(rpt,"%d %d",d_mem[wrapped_address][15:0],u_dut.d2_rs2_data[15:0]);
                    $fdisplay(rpt,"%d %d",q_alu_out,u_dut.d1_alu_output);
                end
            end
            else if(q_funct3==2) begin 
                if((d_mem[wrapped_address][31:0]==u_dut.d2_rs2_data[31:0])&&(q_alu_out==u_dut.d1_alu_output)) begin 
                    $fdisplay(rpt,"memory wr is accurate for instruction %d",q);
                    mem_access_number = mem_access_number+1;
                end
                else begin
                    $fdisplay(rpt,"memory wr is not accurate for instruction %d",q);
                    $fdisplay(rpt,"%d %d",d_mem[wrapped_address][31:0],u_dut.d2_rs2_data[31:0]);
                    $fdisplay(rpt,"%d %d",q_alu_out,u_dut.d1_alu_output);
                end
            end
            else if(q_funct3==3) begin 
                if((d_mem[wrapped_address]==u_dut.d2_rs2_data)&&(q_alu_out==u_dut.d1_alu_output)) begin 
                    $fdisplay(rpt,"memory wr is accurate for instruction %d",q);
                    mem_access_number = mem_access_number+1;
                end
                else begin
                    $fdisplay(rpt,"memory wr is not accurate for instruction %d",q);
                    $fdisplay(rpt,"%d %d",d_mem[wrapped_address],u_dut.d2_rs2_data);
                    $fdisplay(rpt,"%d %d",q_alu_out,u_dut.d1_alu_output);
                end
            end
        end
        else if(q_opcode!=3) begin
            mem_access_number = mem_access_number+1;
        end 
        @(posedge clk);
        /*
        if((q_opcode == 3)) begin
            if((t_mem_access==u_dut.w_read_data)&&(u_dut.w_read_valid)) begin
                $fdisplay(rpt,"memory rd is accurate for instruction %d",q+1);
                mem_access_number = mem_access_number+1;
            end
            else begin
                $fdisplay (rpt,"memory rd is not accurate for instruction %d",q+1);
                $fdisplay (rpt,"%d  %d  %d",u_dut.w_read_data,t_mem_access,u_dut.w_read_valid);
            end
        end

        */
        /*
        #1;
        if((q_opcode == 3)) begin
            if((t_mem_access==u_dut.w_read_data)&&(u_dut.w_read_valid)) begin
                $fdisplay(rpt,"memory rd is accurate for instruction %d",q);
                mem_access_number = mem_access_number+1;
            end
            else begin
                $fdisplay (rpt,"memory rd is not accurate for instruction %d",q);
                $fdisplay (rpt,"%d  %d  %d",u_dut.w_read_data,t_mem_access,u_dut.w_read_valid);
            end
        end
        */
        if (q>=1) begin
            q_branch_jump_taken = branch_jump_taken(q-1);
        end
        else
            q_branch_jump_taken = 0;

        /*
        if (q_branch_jump_taken[64]) begin
            q = q_branch_jump_taken[63:6]+q;
        end
        else begin
            q = q+1;
        end
        */
        if (q_branch_jump_taken[64]&&(i_mem[q-1][6:0]!=103)) begin
            q = q_branch_jump_taken[63:6]+q;
            //$fdisplay(rpt,"q=%d,q_branch_jump_taken=%h",q,q_branch_jump_taken);
        end
        else if (q_branch_jump_taken[64]&&(i_mem[q-1][6:0]==103)) begin
            q_rs1 = i_mem[q-1][19:15];
            q_interim_offset = q_branch_jump_taken[63:0] + r_mem[q_rs1];
            q = q_interim_offset[63:6]; 
            //$fdisplay(rpt,"q=%h",q);
            //$fdisplay(rpt,"q_rs1=%h,value=%h",q_rs1,r_mem[q_rs1]);
        end
        else begin
            q = q+1;
        end
    end
end

initial begin
    @(posedge clk);
    @(posedge clk);
    #30;
    @(posedge clk);
    #150000;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    wb_number = 0;
    for(p=0;p<`INS_NUMBER;p=p+0) begin
        #1;
        p_alu_out = m_alu_out(p);
        p_mul_divide = multiply_divide(p);
        p_mem_out = mem_access(p);
        p_opcode  = i_mem[p][6:0];
        p_rd      = i_mem[p][11:7];
        p_funct3  = i_mem[p][14:12];
        p_rs1     = i_mem[p][19:15];
        p_rs2     = i_mem[p][24:20];
        p_funct7  = i_mem[p][31:25];
        if ((p_opcode==51)||(p_opcode==19)||(p_opcode==111)||(p_opcode==103)||(p_opcode==55)||(p_opcode==23)) begin
            addr = p_rd;
            if((p_funct3>=0)&&(p_funct3<=7)&&(p_funct7==1)&&(p_opcode==51)) begin 
                r_mem[addr] = p_mul_divide;
                comp = p_mul_divide;
            end else begin
                r_mem[addr] = p_alu_out;
                comp = p_alu_out;
            end
            comp_addr = addr;
        end
        else if (p_opcode == 3) begin
            addr = p_rd;
            r_mem[addr] = p_mem_out;
            comp = p_mem_out;
            comp_addr = addr;
        end

        if((p_opcode == 3)) begin
            if((p_mem_out==u_dut.w_read_data)&&(u_dut.w_read_valid)) begin
                $fdisplay(rpt,"memory rd is accurate for instruction %d",p);
                //$fdisplay (rpt,"%d  %d  %d",u_dut.w_read_data,p_mem_out,u_dut.w_read_valid);
                mem_access_number = mem_access_number+1;
            end
            else begin
                $fdisplay (rpt,"memory rd is not accurate for instruction %d",p);
                $fdisplay (rpt,"%d  %d  %d",u_dut.w_read_data,p_mem_out,u_dut.w_read_valid);
            end
        end

        if ((p_opcode==51)||(p_opcode==3)||(p_opcode==19)||(p_opcode==111)||(p_opcode==103)||(p_opcode==55)||(p_opcode==23)) begin
            if ((comp==u_dut.w_wr_data)&&(comp_addr==u_dut.w_wr_address)&&u_dut.w_wr_en) begin
                $fdisplay (rpt,"WB is accurate for instruction %d",p);
                //$fdisplay (rpt,"%d %d",comp,u_dut.w_wr_data);
                //$fdisplay (rpt,"%d %d",comp_addr,u_dut.w_wr_address);
                wb_number = wb_number+1;
            end
            else begin
                $fdisplay (rpt,"WB is not accurate for %d",p);
                $fdisplay (rpt,"%d %d",comp,u_dut.w_wr_data);
                $fdisplay (rpt,"%d %d",comp_addr,u_dut.w_wr_address);
            end
        end
        else
            wb_number = wb_number+1;
        @(posedge clk);

        if (p>=1) begin
            p_branch_jump_taken = branch_jump_taken(p-1);
        end
        else
            p_branch_jump_taken = 0;

        /*
        if (p_branch_jump_taken[64]) begin
            p = p_branch_jump_taken[63:6]+p;
        end
        else begin
            p = p+1;
        end
        */
        if (p_branch_jump_taken[64]&&(i_mem[p-1][6:0]!=103)) begin
            p = p_branch_jump_taken[63:6]+p;
            //$fdisplay(rpt,"p=%d,p_branch_jump_taken=%h",p,p_branch_jump_taken);
        end
        else if (p_branch_jump_taken[64]&&(i_mem[p-1][6:0]==103)) begin
            p_rs1 = i_mem[p-1][19:15];
            p_interim_offset = p_branch_jump_taken[63:0] + r_mem[p_rs1];
            p = p_interim_offset[63:6]; 
            //$fdisplay(rpt,"p=%h",p);
            //$fdisplay(rpt,"p_rs1=%h,value=%h",p_rs1,r_mem[p_rs1]);
        end
        else begin
            p = p+1;
        end
    end
end


function [63:0] mem_access;
    input integer l;
    reg [6:0] l_opcode;
    reg [2:0] l_funct3;
    reg [63:0] temp;
    reg [63:0] alu_out;
    reg [7:0] temp_1;
    reg [15:0] temp_2;
    reg [31:0] temp_3;
    reg [63:0] wrapped_address1;
    begin
        l_opcode = i_mem[l][6:0];
        l_funct3 = i_mem[l][14:12];

        if (l_opcode == 3) begin
            alu_out=m_alu_out(l);
            wrapped_address1 = alu_out[63:6];
            temp = d_mem[wrapped_address1];
            //$fdisplay(rpt,"wrapped_address=%d",wrapped_address1);
            //$fdisplay(rpt,"temp=%d",temp);
        end
        else begin 
            temp=0;
        end
        if ((l_opcode==3)&&(l_funct3==0)) begin
            temp_1 = temp[7:0];
            mem_access = {{56{temp_1[7]}},temp_1};
            //$fdisplay(rpt,"t1");
        end
        else if ((l_opcode==3)&&(l_funct3==1)) begin
            temp_2 = temp[15:0];
            mem_access = {{48{temp_2[15]}},temp_2};
            //$fdisplay(rpt,"t2");
        end
        else if ((l_opcode==3)&&(l_funct3==2)) begin
            temp_3 = temp[31:0];
            mem_access = {{32{temp_3[31]}},temp_3};
            //$fdisplay(rpt,"t3");
        end
        else if ((l_opcode==3)&&(l_funct3==3)) begin
            mem_access = temp;
            //$fdisplay(rpt,"t4");
        end
        else if ((l_opcode==3)&&(l_funct3==4)) begin
            temp_1 = temp[7:0];
            mem_access = {{56{1'b0}},temp_1};
            //$fdisplay(rpt,"t5");
        end
        else if ((l_opcode==3)&&(l_funct3==5)) begin
            temp_2 = temp[15:0];
            mem_access = {{48{1'b0}},temp_2};
            //$fdisplay(rpt,"t6");
        end
        else if ((l_opcode==3)&&(l_funct3==6)) begin
            temp_3 = temp[31:0];
            mem_access = {{32{1'b0}},temp_3};
            //$fdisplay(rpt,"t7");
        end
        else begin
            mem_access=0;
            //$fdisplay(rpt,"opcode = %d, funct3=%d,l=%d,t8",l_opcode,l_funct3,l);
        end
    end
endfunction

function [63:0] m_alu_out;
    input integer m;
    reg [63:0] m_op1_data,m_op2_data;
    reg [6:0] m_opcode;
    reg [4:0] m_rs1,m_rs2,m_rd;
    reg [2:0] m_func3;
    reg [6:0] m_func7;   
    reg [63:0] m_imm_64;
    begin
        m_opcode    = i_mem[m][6:0];
        m_rd        = i_mem[m][11:7];
        m_func3     = i_mem[m][14:12];
        m_rs1       = i_mem[m][19:15];
        m_rs2       = i_mem[m][24:20];
        m_func7     = i_mem[m][31:25];
        if((m_opcode==3)||(m_opcode==19))
            m_imm_64    = {{52{m_func7[6]}},m_func7,m_rs2};
        else if(m_opcode==35)
            m_imm_64    = {{52{m_func7[6]}},m_func7,m_rd};
        else if((m_opcode==111)||(m_opcode==103)) 
            m_imm_64    = {55'd0,3'd4,6'd0};
        else if((m_opcode==55)||(m_opcode==23))
            m_imm_64    = {32'd0,m_func7,m_rs2,m_rs1,m_func3,5'd0,7'd0};

        if((m_opcode==111)||(m_opcode==103)||(m_opcode==23))
            m_op1_data = m*64;
        else if(m_opcode==55)
            m_op1_data = 0;
        else
            m_op1_data = r_mem[m_rs1];
        if(m_opcode==51) begin
            m_op2_data = r_mem[m_rs2];
        end
        else if((m_opcode==3)||(m_opcode==35)||(m_opcode==19)||(m_opcode==111)||(m_opcode==103)||(m_opcode==55)||(m_opcode==23)) begin
            m_op2_data = m_imm_64;
        end
        //$fdisplay(rpt,"m=%d,m_opcode=%d,m_func3=%d,m_func7=%d",m,m_opcode,m_func3,m_func7);
        if ((((m_opcode==51)||(m_opcode==19))&&(m_func3==0)&&(m_func7==0))||(m_opcode==3)||(m_opcode==35)||(m_opcode==111)||(m_opcode==103)||(m_opcode==23)) begin
            m_alu_out = $signed(m_op1_data)+$signed(m_op2_data);
            //$fdisplay(rpt," m=%d,m_op1_data=%d,m_op2_data=%d",m,m_op1_data,m_op2_data);
        end
        else if ((m_opcode==51)&&(m_func3 == 0)&&(m_func7==32))
            m_alu_out = $signed(m_op1_data)-$signed(m_op2_data);
        else if ((((m_opcode==51)||(m_opcode==19))&&(m_func3 ==7)&&(m_func7==0)))
            m_alu_out = m_op1_data&m_op2_data;
        else if ((((m_opcode==51)||(m_opcode==19))&&(m_func3 ==6)&&(m_func7==0)))
            m_alu_out = m_op1_data | m_op2_data;
        else if ((((m_opcode==51)||(m_opcode==19))&&(m_func3 ==4)&&(m_func7==0)))
            m_alu_out = m_op1_data ^ m_op2_data;
        else if ((((m_opcode==51)||(m_opcode==19))&&(m_func3 ==1)&&(m_func7==0)))
            m_alu_out = m_op1_data << m_op2_data;
        else if (((m_opcode==51)&&(m_func3 ==5)&&(m_func7==0))||((m_opcode==19)&&(m_func7==0)&&(m_func3==5)))
            m_alu_out = m_op1_data >> m_op2_data;
        else if (((m_opcode==51)&&(m_func3 ==5)&&(m_func7==32))||((m_opcode==19)&&((m_func7==32)&&(m_func3==5)))) begin
            m_alu_out = m_op1_data >>> m_op2_data;
            //$fdisplay(rpt,"m_op1_data=%h,m_op2_data=%h,m_alu_out=%h",m_op1_data,m_op2_data,m_alu_out);
        end
        else if ((((m_opcode==51)||(m_opcode==19))&&(m_func3 ==2)&&(m_func7==0)))
            m_alu_out = ($signed(m_op1_data) < $signed(m_op2_data))? 1'b1 : 0;
        else if ((((m_opcode==51)||(m_opcode==19))&&(m_func3 ==3)&&(m_func7==0)))
            m_alu_out = ((m_op1_data) < (m_op2_data))? 1'b1 : 0;
        else if(m_opcode==55) begin
            m_alu_out = m_op2_data;
            $fdisplay(rpt,"lui");
        end
        else
            m_alu_out=0;
    end

endfunction

function [63:0] multiply_divide;
    input integer md;
    reg [63:0] md_op1_data,md_op2_data;
    reg [6:0] md_opcode;
    reg [4:0] md_rs1,md_rs2,md_rd;
    reg [2:0] md_func3;
    reg [6:0] md_func7;   
    reg [127:0] multiply_divide_real;
    begin
        md_opcode    = i_mem[md][6:0];
        md_rd        = i_mem[md][11:7];
        md_func3     = i_mem[md][14:12];
        md_rs1       = i_mem[md][19:15];
        md_rs2       = i_mem[md][24:20];
        md_func7     = i_mem[md][31:25];
        md_op1_data  = r_mem[md_rs1];
        md_op2_data  = r_mem[md_rs2];
        if((md_opcode==51)&&(md_func7==1)) begin
            if(md_func3==0) begin
                multiply_divide_real = $signed(md_op1_data) * $signed(md_op2_data);
                multiply_divide = multiply_divide_real[63:0];
            end
            else if(md_func3==1) begin
                multiply_divide_real = $signed(md_op1_data) * $signed(md_op2_data);
                multiply_divide = multiply_divide_real[127:64];
            end
            else if(md_func3==2) begin
                multiply_divide_real = $signed(md_op1_data) * md_op2_data;
                multiply_divide = multiply_divide_real[127:64];
            end
            else if(md_func3==3) begin
                multiply_divide_real = md_op1_data * md_op2_data;
                multiply_divide = multiply_divide_real[127:64];
            end
            else if(md_func3==4) begin
                multiply_divide = $signed(md_op1_data)/$signed(md_op2_data);
            end
            else if(md_func3==5) begin
                multiply_divide = (md_op1_data)/(md_op2_data);
            end
            else if(md_func3==6) begin
                multiply_divide = $signed(md_op1_data) % $signed(md_op2_data);
            end
            else if(md_func3==7) begin
                multiply_divide = (md_op1_data) % (md_op2_data);
            end
            else
                multiply_divide = 0;
        end
        else
            multiply_divide =   0;
    end
endfunction



endmodule
