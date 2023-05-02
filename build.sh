nasm -f bin -o hello_world.img nasm_hello_world.asm
nasm -f bin -o main.img custom_bootloader.asm
nasm -f bin -o hello_protected.img nasm_protected_mode.asm
