"""
Author: Elsie Rezinold Yedida
"""





import sys
import getopt
import re
Registers = {
'r0' :   0,
'r1' :   1,
'r2' :   2,
'r3' :   3,
'r4' :   4,	
'r5' :   5,	
'r6' :   6,	
'r7' :   7,	
'r8' :   8,	
'r9' :   9,	
'r10':	 10,
'r11':  11,       
'r12':  12,       
'r13':  13,       
'r14':	 14,
'r15':	 15,
'r16':	 16,
'r17':	 17,
'r18':	 18,
'r19':	 19,
'r20':  20,       
'r21':  21,       
'r22':  22,       
'r23':  23,       
'r24':	 24,
'r25':	 25,
'r26':	 26,
'r27':	 27,
'r28':	 28,
'r29':	 29,
'r30':  30,       
'r31':  31
}

r_format = {
'sll'  : 1,
'srl'  : 5,
'sra'  : 5,
'add'  : 0,
'sub'  : 0,
'and'  : 7,
'or'   : 6,
'xor'  : 4,
'slt'  : 2,
'sltu' : 3
}
i_format = {
'slli'  : 1,
'srli'  : 5,
'srai'  : 5,
'addi'  : 0,
'andi'  : 7,
'ori'   : 6,
'xori'  : 4,
'slti'  : 2,
'sltiu' : 3
}
s_format = {
'sb' : 1,
'sh' : 2,
'sw' : 3,
'sd' : 4
}


l_format = {
    'lb'    :   0,
    'lh'    :   1,
    'lw'    :   2,
    'ld'    :   3,
    'lbu'   :   4,
    'lhu'   :   5,
    'lwu'   :   6
}


b_format = {
    'beq'   :   0,
    'bne'   :   1,
    'blt'   :   4,
    'bge'   :   5,
    'bltu'  :   6,
    'bgeu'  :   7
}


j_format = {
    'jal'   :   111,
    'jalr'  :   103
}

u_format = {
    'lui'   :   55,
    'auipc' :   23
}

m_format = {
    'mul'   :   0,
    'mulh'  :   1,
    'mulsu' :   2,
    'mulu'  :   3,
    'div'   :   4,
    'divu'  :   5,
    'rem'   :   6,
    'remu'  :   7
}




def extract():
    argv = sys.argv[1:]

    opt,args = getopt.getopt(argv,"",["asm="])

    for i,j in opt:
        if i in ['--asm']:
            asm = j



    
    return str(asm)

asm = extract()


in_loc = str(asm)

out_loc = str(asm)+"_hexa.txt"

oh = open(out_loc,'w')
with open(in_loc,'r') as ih:
    for line in ih:
        line = line.strip()
        list_in = re.split(',| ',line)
        print(list_in)
        print(list_in[0])
        #r_type
        if list_in[0] in r_format.keys():
            print('r')
            opcode = f'{51:07b}'
            v = r_format[list_in[0]]
            func3 = f'{v:03b}'
            v1 = Registers[list_in[1]]
            rd = f'{v1:05b}'
            v2 = Registers[list_in[2]]
            rs1 = f'{v2:05b}'
            v3 = Registers[list_in[3]]
            rs2 = f'{v3:05b}'
            if list_in[0] in ['sub','sra']:
                func7 = f'{32:07b}'
            else:
                func7 = f'{0:07b}'
            print(opcode)
            print(rs1)
            print(rs2)
            print(rd)
            print(func3)
            print(func7)
            it = func7+rs2+rs1+func3+rd+opcode
            it = int(str(it),2)
            it = hex(it)
            it = it.strip('0x')
            oh.write(str(it)+"\n")            
        elif list_in[0] in i_format.keys():
            print('i')
            opcode = f'{19:07b}'
            v = i_format[list_in[0]]
            func3 = f'{v:03b}'
            v1 = Registers[list_in[1]]
            rd = f'{v1:05b}'
            v2 = Registers[list_in[2]]
            rs1 = f'{v2:05b}'
            v3 = int(list_in[3])
            imm = f'{v3:05b}'
            if list_in[0] in ['srai']:
                func7 = f'{32:07b}'
            else:
                func7 = f'{0:07b}'
            print(opcode)
            print(rs1)
            print(imm)
            print(rd)
            print(func3)
            print(func7)
            it = func7+imm+rs1+func3+rd+opcode
            it = int(str(it),2)
            it = hex(it)
            it = it.strip('0x')
            oh.write(str(it)+"\n")
        elif list_in[0] in s_format.keys():
            print('s')
            opcode = f'{35:07b}'
            v1 = Registers[list_in[1]]
            rs2 = f'{v1:05b}'
            temp = list_in[2].strip(')')
            temp = temp.split('(')
            v2 = Registers[temp[1]]
            rs1 = f'{v2:05b}'
            v3 = int(temp[0],16)
            imm = f'{v3:012b}'
            if (list_in[0] == 'sb'):
                func3 = f'{0:03b}'
            elif (list_in[0] == 'sh'):
                func3 = f'{1:03b}'
            elif (list_in[0] == 'sw'):
                func3 = f'{2:03b}'
            elif (list_in[0] == 'sd'):
                func3 = f'{3:03b}'
            print(opcode)
            print(func3)
            print(imm[7:])
            print(rs1)
            print(rs2)
            print(imm[:7])

            it = imm[0:7]+rs2+rs1+func3+imm[7:]+opcode
            print(it)
            it = int(str(it),2)
            it = hex(it)
            it = it.strip('0x')
            oh.write(str(it)+"\n")
        elif list_in[0] in l_format.keys():
            print('l')
            opcode = f'{3:07b}'
            v = l_format[list_in[0]]
            func3 = f'{v:03b}'
            v1 = Registers[list_in[1]]
            rd = f'{v1:05b}'
            temp = list_in[2].strip(')')
            temp = temp.split('(')
            v2 = Registers[temp[1]]
            rs1 = f'{v2:05b}'
            v3 = int(temp[0],16)
            imm = f'{v3:012b}'
            print(opcode)
            print(rd)
            print(func3)
            print(rs1)
            print(imm)
            it = imm+rs1+func3+rd+opcode
            print(it)
            it = int(str(it),2)
            it = hex(it)
            it = it.strip('0x')
            oh.write(str(it)+"\n")
        elif list_in[0] in b_format.keys():
            print('b')
            opcode = f'{99:07b}'
            v = b_format[list_in[0]]
            func3 = f'{v:03b}'
            v1 = Registers[list_in[1]]
            rs1 = f'{v1:05b}'
            v2 = Registers[list_in[2]]
            rs2 = f'{v2:05b}'
            v3 = list_in[3]
            v4 = int(v3,16)
            imm = f'{v4:013b}'
            print(opcode)
            print(rs1)
            print(rs2)
            print(func3)
            print(imm)
            it = imm[0]+imm[2:8]+rs2+rs1+func3+imm[8:12]+imm[1]+opcode                
            print(it)
            it = int(str(it),2)
            it = hex(it)
            it = it.strip('0x')
            oh.write(str(it)+"\n")
        elif list_in[0] in j_format.keys():
            print('j')
            v = j_format[list_in[0]]
            opcode = f'{v:07b}'
            v1 = Registers[list_in[1]]
            rd = f'{v1:05b}'
            if (v==103):
                temp = list_in[2].strip(')')
                temp = temp.split('(')
                v2 = Registers[temp[1]]
                rs1 = f'{v2:05b}'
                v3 = int(temp[0],16)
                imm = f'{v3:012b}'
                func3 = f'{0:03b}'
            else:
                temp = list_in[2]
                temp = int(temp,16)
                imm = f'{temp:021b}'

            if (v==103):
                it = imm+rs1+func3+rd+opcode
            else:
                it = imm[0]+imm[10:20]+imm[9]+imm[1:9]+rd+opcode
            print(it)
            it = int(str(it),2)
            it = hex(it)
            it = it.strip('0x')
            oh.write(str(it)+"\n")
        elif list_in[0] in u_format.keys():
            print('u')
            v = u_format[list_in[0]]
            opcode = f'{v:07b}'
            v1 = Registers[list_in[1]]
            rd = f'{v1:05b}'
            temp = list_in[2]
            temp = int(temp,16)
            imm = f'{temp:032b}'
            it = imm[0:20]+rd+opcode
            print(it)
            it = int(str(it),2)
            it = hex(it)
            it = it.strip('0x')
            oh.write(str(it)+"\n")
        elif list_in[0] in m_format.keys():
            print('m')
            opcode = f'{51:07b}'
            v = m_format[list_in[0]]
            func3 = f'{v:03b}'
            v1 = Registers[list_in[1]]
            rd = f'{v1:05b}'
            v2 = Registers[list_in[2]]
            rs1 = f'{v2:05b}'
            v3 = Registers[list_in[3]]
            rs2 = f'{v3:05b}'
            func7 = f'{1:07b}'
            print(opcode)
            print(rs1)
            print(rs2)
            print(rd)
            print(func3)
            print(func7)
            it = func7+rs2+rs1+func3+rd+opcode
            it = int(str(it),2)
            it = hex(it)
            it = it.strip('0x')
            oh.write(str(it)+"\n")            
    oh.close()
    ih.close()
                

















