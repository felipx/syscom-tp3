[bits 16]
[org 0x7c00]

    jmp 0:start
                                    ; Inicio Definicion de GDT
gdt_start:
gdt_null:
    dd 0x0
    dd 0x0
gdt_code:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0
gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0
gdt_end:
gdt_descriptor:
    dw gdt_end - gdt_start
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
                                   ; Fin definición de GDT
msg db 'Hello Protected Mode!', 0           ; String a imprimir

start:                             ; Inicio
    mov ax, 0
    mov ss, ax
    mov sp, 0xFFFC

    mov ax, 0
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    call clear                     ; Borra la pantalla

    cli                            ; Deshabilita interrupciones
    lgdt[gdt_descriptor]           ; Carga GDT
    mov eax, cr0
    or eax, 0x1                    ; Setea en 1
    mov cr0, eax                   ; ... bit 0 de CR0
    jmp CODE_SEG:b32               ; En modo protegido va a código 32 bits

[bits 32]

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

clear:
    pusha
    mov ah, 0x00
    mov al, 0x03
    int 0x10
    popa
    ret

print:
    pusha
    mov edx, VIDEO_MEMORY
.loop:
    mov al, [ebx]
    mov ah, WHITE_ON_BLACK
    cmp al, 0
    je .done
    mov [edx], ax
    add ebx, 1
    add edx, 2
    jmp .loop
.done:
    popa
    ret

b32:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov ebp, 0x2000
    mov esp, ebp

    mov ebx, msg
    call print

    jmp $

[SECTION signature start=0x7dfe]
dw 0AA55h