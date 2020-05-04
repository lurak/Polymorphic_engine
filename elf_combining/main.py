import os
import contextlib
import mmap

temp_key = b'\x8eNT\xdee\x96\xda\xec'
path_out = "out/a"
path_header = "in/header"
path_main = "in/hello"
path_mixed = "in/elf64header"

compile_header = "nasm -fbin -o in/header src/header.asm"
compile_main = "nasm -fbin -o in/hello src/hello.asm"
compile_mixed = "nasm -fbin -o in/elf64header src/elf64header.asm"

os.system(compile_header)
header_size = os.path.getsize(path_header)

with open("src/hello.asm", 'r+', encoding='utf8') as asm:
    asm_txt = asm.read()
    asm.seek(19)
    asm.write(hex(header_size + 0x00400000))
    # asm.write(asm_txt)

os.system(compile_main)
os.system(compile_mixed)

file_size = os.path.getsize(path_main)
mixed_size = os.path.getsize(path_mixed)

print(f"header size: {header_size}")
print(f"file size: {file_size}")
print(f"header_size + file_size: {header_size + file_size}")
print(f"mixed size: {mixed_size}")

i = 0
with open(path_main, 'rb') as out:
    main = list(out.read())
# XOR
while i < file_size:
    main[i] = main[i] ^ temp_key[i % 8]
    i += 1

with open(path_out, "wb+") as out, open(path_header, "rb") as header:
    out.write(header.read())
    out.write(bytearray(main))

a_bytes_little = (header_size + file_size).to_bytes(8, 'little')
with open(path_out, 'r+b') as out:
    out.seek(0x60)
    out.write(a_bytes_little)
    out.write(a_bytes_little)
