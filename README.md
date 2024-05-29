# rv_64im

* This repo consists of a 'RISC-V' cpu that supports I&M extensions of the opensource Risc-V ISA.
* This cpu is coded in verilog hdl.
* It supports all type of instruction formats such as "R, I, S, B, U and J" formats.
* This cpu datapath is of 64-bit width.
* The instruction bit width is 32, all the Registers and the rest datapath is of 64-bits.
* There are 32, 64-bit registers available.
* The cache available is of 128KB. 
* This cpu is implemented in classical 5 stage style.
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
* In EXE stage for division instead of using "\" we have implemented iterative divider.
* In MEM stage a 128kb "2-way associative" with "lru replacement policy" cache has been implemented.  

### IF stage

* This stage contains two blocks 'pc_counter_block' and 'instruction_memory_model'.





