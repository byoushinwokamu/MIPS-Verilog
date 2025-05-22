import sys

def get_register_name(num):
    registers = [
        "$zero", "$at", "$v0", "$v1", "$a0", "$a1", "$a2", "$a3",
        "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7",
        "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7",
        "$t8", "$t9", "$k0", "$k1", "$gp", "$sp", "$fp", "$ra"
    ]
    return registers[num] if num < 32 else f"$r{num}"

def disassemble(hex_instr):
    instr = int(hex_instr, 16)
    opcode = (instr >> 26) & 0x3F

    if opcode == 0x00:
        rs = (instr >> 21) & 0x1F
        rt = (instr >> 16) & 0x1F
        rd = (instr >> 11) & 0x1F
        shamt = (instr >> 6) & 0x1F
        funct = instr & 0x3F
        if funct == 0x20:
            return f"add {get_register_name(rd)}, {get_register_name(rs)}, {get_register_name(rt)}"
        elif funct == 0x22:
            return f"sub {get_register_name(rd)}, {get_register_name(rs)}, {get_register_name(rt)}"
        elif funct == 0x24:
            return f"and {get_register_name(rd)}, {get_register_name(rs)}, {get_register_name(rt)}"
        elif funct == 0x25:
            return f"or {get_register_name(rd)}, {get_register_name(rs)}, {get_register_name(rt)}"
        elif funct == 0x2A:
            return f"slt {get_register_name(rd)}, {get_register_name(rs)}, {get_register_name(rt)}"
        elif funct == 0x00:
            return f"sll {get_register_name(rd)}, {get_register_name(rt)}, {shamt}"
        elif funct == 0x02:
            return f"srl {get_register_name(rd)}, {get_register_name(rt)}, {shamt}"
        elif funct == 0x08:
            return f"jr {get_register_name(rs)}"
        elif funct == 0x0C:
            return f"syscall"
        else:
            return f"Unknown R-type funct: 0x{funct:X}"

    elif opcode in [0x08, 0x0C, 0x0D, 0x0A, 0x23, 0x2B, 0x04, 0x05]:
        rs = (instr >> 21) & 0x1F
        rt = (instr >> 16) & 0x1F
        imm = instr & 0xFFFF
        if imm & 0x8000:
            imm -= 0x10000
        if opcode == 0x08:
            return f"addi {get_register_name(rt)}, {get_register_name(rs)}, {imm}"
        elif opcode == 0x0C:
            return f"andi {get_register_name(rt)}, {get_register_name(rs)}, 0x{imm & 0xFFFF:X}"
        elif opcode == 0x0D:
            return f"ori {get_register_name(rt)}, {get_register_name(rs)}, 0x{imm & 0xFFFF:X}"
        elif opcode == 0x0A:
            return f"slti {get_register_name(rt)}, {get_register_name(rs)}, {imm}"
        elif opcode == 0x23:
            return f"lw {get_register_name(rt)}, {imm}({get_register_name(rs)})"
        elif opcode == 0x2B:
            return f"sw {get_register_name(rt)}, {imm}({get_register_name(rs)})"
        elif opcode == 0x04:
            return f"beq {get_register_name(rs)}, {get_register_name(rt)}, {imm}"
        elif opcode == 0x05:
            return f"bne {get_register_name(rs)}, {get_register_name(rt)}, {imm}"
        else:
            return f"Unknown I-type opcode: 0x{opcode:X}"

    elif opcode in [0x02, 0x03]:
        addr = instr & 0x03FFFFFF
        if opcode == 0x02:
            return f"j 0x{addr << 2:08X}"
        elif opcode == 0x03:
            return f"jal 0x{addr << 2:08X}"
        else:
            return f"Unknown J-type opcode: 0x{opcode:X}"

    else:
        return f"Unknown opcode: 0x{opcode:X}"

def disassemble_hex_file(filename, show_addr=True, show_hex=True, output_file=None):
    output_lines = []
    with open(filename, 'r') as f:
        for lineno, line in enumerate(f, 1):
            words = line.strip().split()
            for i, hex_instr in enumerate(words):
                asm = disassemble(hex_instr)
                addr_str = f"{(lineno-1)*8 + i:04d}: " if show_addr else ""
                hex_str = f"0x{hex_instr}  =>  " if show_hex else ""
                output_lines.append(addr_str + hex_str + asm)

    if output_file:
        with open(output_file, 'w') as out:
            out.write('\n'.join(output_lines))
        print(f"[✓] 결과를 '{output_file}'에 저장했습니다.")
    else:
        print('\n'.join(output_lines))

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="MIPS 기계어(hex) 디어셈블러")
    parser.add_argument("hexfile", help="입력 hex 파일")
    parser.add_argument("-o", "--output", help="출력 파일명 (없으면 콘솔 출력)")
    parser.add_argument("--no-addr", action="store_true", help="주소 번호 숨기기")
    parser.add_argument("--no-hex", action="store_true", help="hex 코드 숨기기")

    args = parser.parse_args()

    disassemble_hex_file(
        filename=args.hexfile,
        show_addr=not args.no_addr,
        show_hex=not args.no_hex,
        output_file=args.output
    )
