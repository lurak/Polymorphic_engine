import os
import re
from modules.engine import SimplePol

out_name = "encrypted"
header_name = "header"
main_name = "all_nop"
temp_key = b'\x8eNT\xdee\x96\xda\xec'


def compile_file(file):
    compile_str = f"nasm -fbin -o in/{file} src/{file}.asm"
    os.system(compile_str)
    return os.path.getsize(f"in/{file}")


def change_asm_file(file, template, to):
    with open(file, 'r+', encoding='utf8') as asm:
        asm_txt = asm.read()
        asm_txt = re.sub(template, to, asm_txt)
        asm.seek(0)
        asm.write(asm_txt)
        asm.truncate()


a = SimplePol(f"src/{header_name}.asm")
a.polymorph()
# HERE polymorphism header_name function
header_name += "_pol"
header_size = compile_file(header_name)

change_asm_file(f"src/{main_name}.asm", r'(org)\s+(0[xX])?[a-fA-F0-9]+', f"org    {hex(header_size + 0x00400000)}")

file_size = compile_file(main_name)

change_asm_file(f"src/{header_name}.asm", r'(mov)\s+(rax)\s*(,)\s*(0[xX])?[a-fA-F0-9]+',
                f"mov rax, {hex(header_size + file_size + 0x00400000)}")
change_asm_file(f"src/{header_name}.asm", r'(mov)\s+(rcx)\s*(,)\s*(0[xX])?[a-fA-F0-9]+', f"mov rcx, {hex(file_size)}")
compile_file(header_name)

print(f"header size: {header_size}")
print(f"file size: {file_size}")
print(f"header_size + file_size: {header_size + file_size}")

i = 0
with open(f"in/{main_name}", 'r+b') as out:
    main = list(out.read())
# XOR
while i < file_size:
    main[i] = main[i] ^ temp_key[len(temp_key) - 1 - (i % 8)]
    i += 1

with open(f"out/{out_name}", "wb+") as out, open(f"in/{header_name}", "rb") as header:
    out.write(header.read())
    out.write(bytearray(main))

a_bytes_little = (header_size + file_size).to_bytes(8, 'little')
with open(f"out/{out_name}", 'r+b') as out:
    out.seek(0x60)
    out.write(a_bytes_little)
    out.write(a_bytes_little)
