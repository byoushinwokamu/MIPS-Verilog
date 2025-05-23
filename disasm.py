import argparse

REGISTER_NAMES = {
    0: "$zero", 1: "$at", 2: "$v0", 3: "$v1",
    4: "$a0", 5: "$a1", 6: "$a2", 7: "$a3",
    8: "$t0", 9: "$t1", 10: "$t2", 11: "$t3",
    12: "$t4", 13: "$t5", 14: "$t6", 15: "$t7",
    16: "$s0", 17: "$s1", 18: "$s2", 19: "$s3",
    20: "$s4", 21: "$s5", 22: "$s6", 23: "$s7",
    24: "$t8", 25: "$t9", 26: "$k0", 27: "$k1",
    28: "$gp", 29: "$sp", 30: "$fp", 31: "$ra"
}

def decode_instruction(instr, use_numeric=False):
    opcode = (instr >> 26) & 0x3F
    rs     = (instr >> 21) & 0x1F
    rt     = (instr >> 16) & 0x1F
    rd     = (instr >> 11) & 0x1F
    shamt  = (instr >> 6) & 0x1F
    funct  = instr & 0x3F
    imm    = instr & 0xFFFF
    addr   = instr & 0x3FFFFFF

    def reg(i):
        return f"${i}" if use_numeric else REGISTER_NAMES.get(i, f"${i}")

    if opcode == 0x00:
        if funct == 0x20:
            return f"add {reg(rd)}, {reg(rs)}, {reg(rt)}"
        elif funct == 0x22:
            return f"sub {reg(rd)}, {reg(rs)}, {reg(rt)}"
        elif funct == 0x24:
            return f"and {reg(rd)}, {reg(rs)}, {reg(rt)}"
        elif funct == 0x25:
            return f"or {reg(rd)}, {reg(rs)}, {reg(rt)}"
        elif funct == 0x2A:
            return f"slt {reg(rd)}, {reg(rs)}, {reg(rt)}"
        elif funct == 0x08:
            return f"jr {reg(rs)}"
        else:
            return f"unknown R-type funct: 0x{funct:X}"
    elif opcode == 0x08:
        return f"addi {reg(rt)}, {reg(rs)}, {sign_extend(imm)}"
    elif opcode == 0x0C:
        return f"andi {reg(rt)}, {reg(rs)}, 0x{imm:X}"
    elif opcode == 0x0D:
        return f"ori {reg(rt)}, {reg(rs)}, 0x{imm:X}"
    elif opcode == 0x23:
        return f"lw {reg(rt)}, {sign_extend(imm)}({reg(rs)})"
    elif opcode == 0x2B:
        return f"sw {reg(rt)}, {sign_extend(imm)}({reg(rs)})"
    elif opcode == 0x04:
        return f"beq {reg(rs)}, {reg(rt)}, offset 0x{sign_extend(imm)<<2:X}"
    elif opcode == 0x05:
        return f"bne {reg(rs)}, {reg(rt)}, offset 0x{sign_extend(imm)<<2:X}"
    elif opcode == 0x02:
        return f"j 0x{addr<<2:X}"
    elif opcode == 0x03:
        return f"jal 0x{addr<<2:X}"
    else:
        return f"unknown opcode: 0x{opcode:X}"

def sign_extend(value):
    return value if value < 0x8000 else value - 0x10000

def parse_args():
    parser = argparse.ArgumentParser(description="MIPS Disassembler")
    parser.add_argument("input", help="Input hex file (one 4-byte instruction per line)")
    parser.add_argument("-n", "--numeric", action="store_true", help="Use numeric register names")
    parser.add_argument("-a", "--address", action="store_true", help="Show instruction address")
    parser.add_argument("-c", "--comment", action="store_true", help="Include hex in comment")
    parser.add_argument("-b", "--base", type=lambda x: int(x, 0), default=0x00000000,
                        help="Set base address for instruction (default: 0x00000000)")
    return parser.parse_args()

def main():
    args = parse_args()

    with open(args.input) as f:
        lines = [line.strip() for line in f if line.strip()]

    for i, line in enumerate(lines):
        try:
            instr = int(line, 16)
        except ValueError:
            print(f"Invalid line {i}: {line}")
            continue

        asm = decode_instruction(instr, args.numeric)
        address = args.base + i * 4

        output = ""
        if args.address:
            output += f"{address:08X}: "
        output += asm
        if args.comment:
            output += f"  # {instr:08X}"

        print(output)

if __name__ == "__main__":
    main()
