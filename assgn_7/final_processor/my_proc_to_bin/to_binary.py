import sys
import re
import json

# ???? remove comments checked: alu(0), alu(imm), LD, ST, POP, PUSH, MOVE, NOP, 
# HALT, CALL, RET, LDSP, STSP, BR, BMI, BPL, BZ
# ???? left to check: 

REG_VAL = {}
ISA_ENCODING = {}
OUTPUT_FILE = open("test_out.txt","w")
def twos_complement(num,nbits):    # gives nbit long two complement representation of number
    if num>=0:
        return f"{num:0{nbits}b}"
    else:
        return f"{((1<<nbits)+num):0{nbits}b}"

#???? check for whther rd is sp or not in ldsp and stsp
def emit_bin_instr(line):
    try:
        opcode_b=ISA_ENCODING[line[0]][0]
        opcode=int(opcode_b,2)
        
        if opcode == 0:
            funcode_b=ISA_ENCODING[line[0]][-1]
            funcode=int(funcode_b,2)
            if len(line)!=4:
                print(f"error in line {line}")
                return    #gives nbit long two complement representation of number
            else:
                rs=f"{REG_VAL[line[2]]:05b}"
                rt=f"{REG_VAL[line[3]]:05b}"
                rd=f"{REG_VAL[line[1]]:05b}"
                redundant=f"{ISA_ENCODING[line[0]][-3]}"
                shamt=f"{ISA_ENCODING[line[0]][-2]}"
                funct=f"{ISA_ENCODING[line[0]][-1]}"
                print(f"{opcode_b}{rs}{rt}{rd}{redundant}{shamt}{funct},", file = OUTPUT_FILE)
        elif opcode == 1 or opcode == 2 or opcode == 3 or opcode == 4 or opcode == 5 or opcode == 6 or opcode == 7 or opcode == 8 or opcode == 9:
            if len(line)!=4:
                print(f"error in line {line}")
                return
            else:
                rs=f"{REG_VAL[line[2]]:05b}"
                rt=f"{REG_VAL[line[1]]:05b}"
                imm_dec=int(line[3])
                imm=twos_complement(imm_dec,16)
                print(f"{opcode_b}{rs}{rt}{imm},", file = OUTPUT_FILE)
        elif opcode == 10 or opcode == 11 or opcode == 12 or opcode == 13:
            if len(line)!=4:
                print(f"error in line {line}")
                return
            else:
                rs=f"{REG_VAL[line[3]]:05b}"
                rt=f"{REG_VAL[line[1]]:05b}"
                imm_dec=int(line[2])
                imm=twos_complement(imm_dec,16)
                print(f"{opcode_b}{rs}{rt}{imm},", file = OUTPUT_FILE)
        elif opcode == 14:
            if len(line)!=2:
                print(f"error in line {line}")
                return
            else:
                imm_dec=int(line[1])
                imm=twos_complement(imm_dec,26)
                print(f"{opcode_b}{imm},", file = OUTPUT_FILE)
        elif opcode == 15 or opcode == 16 or opcode == 17:
            if len(line)!=3:
                print(f"error in line {line}")
                return
            else:
                rs=f"{REG_VAL[line[1]]:05b}"
                rt=f"{ISA_ENCODING[line[0]][2]}"
                imm_dec=int(line[2])
                imm=twos_complement(imm_dec,16)
                print(f"{opcode_b}{rs}{rt}{imm},", file = OUTPUT_FILE)
        elif opcode == 18:
            if len(line)!=2:
                print(f"error in line {line}")
                return
            else:
                rs=f"{ISA_ENCODING[line[0]][1]}"
                rt=f"{REG_VAL[line[1]]:05b}"
                rd=f"{ISA_ENCODING[line[0]][3]}"
                redundant=f"{ISA_ENCODING[line[0]][-3]}"
                shamt=f"{ISA_ENCODING[line[0]][-2]}"
                funct=f"{ISA_ENCODING[line[0]][-1]}"
                print(f"{opcode_b}{rs}{rt}{rd}{redundant}{shamt}{funct},", file = OUTPUT_FILE)
        elif opcode == 19:
            if len(line)!=2:
                print(f"error in line {line}")
                return
            else:
                rs=f"{ISA_ENCODING[line[0]][1]}"
                rt=f"{ISA_ENCODING[line[0]][2]}"
                rd=f"{REG_VAL[line[1]]:05b}"
                redundant=f"{ISA_ENCODING[line[0]][-3]}"
                shamt=f"{ISA_ENCODING[line[0]][-2]}"
                funct=f"{ISA_ENCODING[line[0]][-1]}"
                print(f"{opcode_b}{rs}{rt}{rd}{redundant}{shamt}{funct},", file = OUTPUT_FILE)
        elif opcode == 20:
            if len(line)!=2:
                print(f"error in line {line}")
                return
            else:
                rs=f"{ISA_ENCODING[line[0]][1]}"
                rt=f"{ISA_ENCODING[line[0]][2]}"
                imm_dec=int(line[1])
                imm=twos_complement(imm_dec,16)
                print(f"{opcode_b}{rs}{rt}{imm},", file = OUTPUT_FILE)
        elif opcode == 21:
            if len(line)!=1:
                print(f"error in line {line}")
                return
            else:
                rs=f"{ISA_ENCODING[line[0]][1]}"
                rt=f"{ISA_ENCODING[line[0]][2]}"
                imm=f"{ISA_ENCODING[line[0]][-1]}"
                print(f"{opcode_b}{rs}{rt}{imm},", file = OUTPUT_FILE)
        elif opcode == 22:
            if len(line)!=3:
                print(f"error in line {line}")
                return
            else:
                rs=f"{REG_VAL[line[2]]:05b}"
                rt=f"{ISA_ENCODING[line[0]][2]}"
                rd=f"{REG_VAL[line[1]]:05b}"
                redundant=f"{ISA_ENCODING[line[0]][-3]}"
                shamt=f"{ISA_ENCODING[line[0]][-2]}"
                funct=f"{ISA_ENCODING[line[0]][-1]}"
                print(f"{opcode_b}{rs}{rt}{rd}{redundant}{shamt}{funct},", file = OUTPUT_FILE)
        elif opcode == 23:
            if len(line)!=1:
                print(f"error in line {line}")
                return
            else:
                imm_dec=(ISA_ENCODING[line[0]][1])
                print(f"{opcode_b}{imm_dec},", file = OUTPUT_FILE)
        elif opcode == 24:
            if len(line)!=1:
                print(f"error in line {line}")
                return
            else:
                imm_dec=(ISA_ENCODING[line[0]][1])
                print(f"{opcode_b}{imm_dec},", file = OUTPUT_FILE)
    except:
        print(f"error in line {line}")



def bin_comm(string):
    string = re.sub(re.compile("/'''.*?\'''", re.DOTALL), "", string)
    string = re.sub(re.compile("#.*?\n"), "", string)
    return string


def convert_file(filename):
    print("memory_initialization_radix=2;", file = OUTPUT_FILE)
    print("memory_initialization_vector=", file = OUTPUT_FILE)
    print(f"{0:032b}", file = OUTPUT_FILE)
    with open(filename, 'r') as f:
        lines = f.readlines()
        for line in lines:
            line.strip()
            line = bin_comm(line)
            
            line = line.replace(',',' ').replace(')',' ').replace('(',' ').split()
            if len(line):
                emit_bin_instr(line)
    print(f"{0:032b};", file = OUTPUT_FILE)


if __name__ == '__main__':
    with open('ISA.json', 'r') as f:
        ISA_ENCODING = json.load(f)
    with open('reg_init.json', 'r') as f:
        REG_VAL = json.load(f)
    convert_file(sys.argv[1])