[org 0x7c00]            ; Origen del programa en 0x7c00.

section .code16
    mov si, msg         ; Carga string "Hello World!" en dirección apuntada por si.
    mov ah, 0x0E        ; Carga función de interrucpción 0x0E.

loop:
    lodsb               ; Carga un byte desde la dirección apuntada por si, en al.
    or al, al           ; Si el byte es 0
    jz halt             ; ...salta a hlt.
    int 0x10            ; Llama la función de interrucpción 0x0E.
    jmp loop            ; Salta a loop.

halt:
    hlt                 ; Detiene la ejecución.

msg db "Hello World!"

times 510-($-$$) db 0   ; Padding de 510 bytes.
dw 0xAA55               ; Número mágico de MBR, 0xAA55.
