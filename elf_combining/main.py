import os
import contextlib
import mmap
out_name = "a_hello"
header_name = "header"
main_name = "test"
temp_key = b'\x8eNT\xdee\x96\xda\xec'

compile_header = f"nasm -fbin -o in/{header_name} src/{header_name}.asm"
compile_main = f"nasm -fbin -o in/{main_name} src/{main_name}.asm"

os.system(compile_header)
header_size = os.path.getsize(f"in/{header_name}")

with open(f"src/{main_name}.asm", 'r+', encoding='utf8') as asm:
    asm_txt = asm.read()
    j = 19
    s = asm_txt[j]
    while s != " ":
        asm.seek(j)
        asm.write(" ")
        j += 1
        s = asm_txt[j]
    asm.seek(19)
    print(hex(header_size + 0x00400000))
    asm.write(hex(header_size + 0x00400000)+"\n")

os.system(compile_main)

file_size = os.path.getsize(f"in/{main_name}")

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
