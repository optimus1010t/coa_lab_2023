import sys
import re
import json

REG_VAL = {}
ISA_ENCODING = {}
OUTPUT_FILE = open("output","w")
def twos_complement(num,nbits):
    '''
    gives nbit long two complement representation of number
    '''
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
            if len(line)!=4:
                print(f"error in line {line}")
                return
            else:
                rs=f"{REG_VAL[line[1]]:05b}"
                rt=f"{REG_VAL[line[2]]:05b}"
                rd=f"{REG_VAL[line[3]]:05b}"
                redundant=f"{ISA_ENCODING[line[0]][-3]}"
                shamt=f"{ISA_ENCODING[line[0]][-2]}"
                funct=f"{ISA_ENCODING[line[0]][-1]}"
                print(f"{opcode}{rs}{rt}{rd}{redundant}{shamt}{funct},", file = OUTPUT_FILE)
            
    except:
        print(f"error in line {line}")



def bin_comm(string):
    string = re.sub(re.compile("/'''.*?\'''", re.DOTALL), "", string)
    string = re.sub(re.compile("#.*?\n"), "", string)
    return string


def process(filename):
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
    process(sys.argv[1])