# rv_64im

* This repo consists of a 'RISC-V' cpu that supports I&M extensions of the opensource Risc-V ISA.
* This cpu is coded in verilog hdl.
* It supports all type of instruction formats such as "R, I, S, B, U and J" formats.
* This cpu datapath is of 64-bit width.
* The instruction bit width is 32, all the Registers and the rest datapath is of 64-bits.
* There are 32, 64-bit registers available.
* The cache available is of 128KB. 
* This cpu is implemented in classical 5 stage style and pipelined.
* These stages are Instruction Fetch(IF), Instruction Decode(ID), Execute(EX), Memory Read & Write(MEM) and Write Back(WB).
* The whole data path is pipelined with pipes between each of the above stages.
* This cpu supports 40 Integer(I) type instructions and 8 Multiplication(M) type instructions.

    |   s.no   |   Instruction     |   type    | format-type   |
    |----------|-------------------|-----------|---------------|
    |   1      |       add         |     I     |       R       |
    |   2      |       sub         |     I     |       R       |
    |   3      |       xor         |     I     |       R       |
    |   4      |       or          |     I     |       R       |
    |   5      |       and         |     I     |       R       |
    |   6      |       sll         |     I     |       R       |
    |   7      |       srl         |     I     |       R       |
    |   8      |       sra         |     I     |       R       |
    |   9      |       slt         |     I     |       R       |
    |  10      |       sltu        |     I     |       R       |
    |  11      |       addi        |     I     |       I       |
    |  12      |       xori        |     I     |       I       |
    |  13      |       ori         |     I     |       I       |
    |  14      |       andi        |     I     |       I       |
    |  15      |       slli        |     I     |       I       |
    |  16      |       srli        |     I     |       I       |
    |  17      |       srai        |     I     |       I       |
    |  18      |       slti        |     I     |       I       |
    |  19      |       sltiu       |     I     |       I       |
    |  20      |       lb          |     I     |       I       |
    |  21      |       lh          |     I     |       I       |
    |  22      |       lw          |     I     |       I       |
    |  23      |       ld          |     I     |       I       |
    |  24      |       lbu         |     I     |       I       |
    |  25      |       lhu         |     I     |       I       |
    |  26      |       lwu         |     I     |       I       |
    |  27      |       sb          |     I     |       S       |
    |  28      |       sh          |     I     |       S       |
    |  29      |       sw          |     I     |       S       |
    |  30      |       sd          |     I     |       S       |
    |  31      |       beq         |     I     |       B       |
    |  32      |       bne         |     I     |       B       |
    |  33      |       blt         |     I     |       B       |
    |  34      |       bge         |     I     |       B       |
    |  35      |       bltu        |     I     |       B       |
    |  36      |       bgeu        |     I     |       B       |
    |  37      |       jal         |     I     |       J       |
    |  38      |       jalr        |     I     |       J & I   |
    |  39      |       lui         |     I     |       U       |
    |  40      |       auipc       |     I     |       U       |
    |  41      |       mul         |     M     |       R       |
    |  42      |       mulh        |     M     |       R       |
    |  43      |       mulu        |     M     |       R       |
    |  44      |       mulsu       |     M     |       R       |
    |  45      |       div         |     M     |       R       |
    |  46      |       divu        |     M     |       R       |
    |  47      |       rem         |     M     |       R       |
    |  48      |       remu        |     M     |       R       |

## Micro architecture details

* This cpu supports Branch & Jump instructions. Branch & Jump instructions are decoded and managed in second stage itself i.e ID stage.
* Hazard detection is done in EXE stage, forwarding or bypassing is available. For hazards where forwarding is not possible cpu stall is used.  
* In EXE stage for 64-bit alu addition and subtraction a "LCU" adder has been implemented using lower bit "CLA" adders. 
* In EXE stage for addition or subtraction instead of directly using "+/-" we have implemented these modules from scratch.
* In EXE stage for multiplication instead of using "*" we have implemented parallel multiplier using "128 bit LCA" adders.
* In EXE stage for division instead of using '/' or '%' we have implemented iterative divider.
* In MEM stage a 128kb "2-way associative" with "lru replacement policy" cache has been implemented.  
* The IF stage operates in same cycle.
* The ID stage operates in same cycle.
* In EXE stage "alu" has a pipeline depth of 1,operates in same cycle. "alu_multiplier" takes 2 clock cycles to finish, it is pipelined can handle serial instructions.
* In EXE stage "alu_divider" takes multiple cycles, next instruction has to wait for current one to finish. 'div/divu/rem/remu' instructions are done in out-of-order.
* In MEM stage the cache takes 1 complete cycle to read data.
* In WB stage things happen in same cycle.
* The locations of pipes are as follows 
    1. between fetch and decode stages.
    2. between decode and alu stages.
    3. between alu and mem_rd_wr stages.
    4. between mem_rd_wr and wb stages.

* "vmod" directory contains all the verilog files.
* "RV_64IM_v1.v" is top file.



## Verification details

* Individual verification of each block has been done.
* Overall verification of 48 instructions has been done.
* Top testbench file is "RV_64IM_test.v"
* 8 programs written in asm have been successfully verified.
* These asm programs are converted to hexa using my 'convert_asm_hexa.py' then the hexa file is used in top testbench file and "instruction_memory_model.v" file to run.
* Please follow above instructions to run 

* step1

    >python convert_asm_hexa.py --asm=first_program

* step2 change file names in "RV_64IM_test.v" and "instruction_memory_model.v"

* step3

    >iverilog -o RV RV_64IM_test.v

    >vvp RV

* step4 check report in generated file "first_program_report.rpt"

* "test_programs" directory contains all program, hexa and reports of all 8 programs.

* You can run your own asm program, follow the same given program formats and above steps.

## Tools used

* "Icarus verilog" and "gtkwave"

 
