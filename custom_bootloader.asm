bits 16

boot:
    jmp main
    TIMES 3-($-$$) DB 0x90   ; Support 2 or 3 byte encoded JMPs before BPB.

    ; Dos 4.0 EBPB 1.44MB floppy
    OEMname:           db    "mkfs.fat"  ; mkfs.fat is what OEMname mkdosfs uses
    bytesPerSector:    dw    512
    sectPerCluster:    db    1
    reservedSectors:   dw    1
    numFAT:            db    2
    numRootDirEntries: dw    224
    numSectors:        dw    2880
    mediaType:         db    0xf0
    numFATsectors:     dw    9
    sectorsPerTrack:   dw    18
    numHeads:          dw    2
    numHiddenSectors:  dd    0
    numSectorsHuge:    dd    0
    driveNum:          db    0
    reserved:          db    0
    signature:         db    0x29
    volumeID:          dd    0x2d7e5a1a
    volumeLabel:       db    "NO NAME    "
    fileSysType:       db    "FAT12   "

main:
    mov ax, 07C0h       ; Set up 4K stack space after this bootloader
    add ax, 288         ; (4096 + 512) / 16 bytes per paragraph
    mov ss, ax
    mov sp, 4096

    mov ax, 07C0h       ; Set data segment to where we're loaded
    mov ds, ax

    mov cl, 10          ; Use this register as our loop counter
    mov ah, 0Eh         ; This register holds our BIOS instruction

    mov si, msg         
    mov ah, 0x0E        
loop:
    lodsb
    or al, al
    jz halt
    int 0x10
    jmp loop

halt:
    hlt                 

msg db "Hello World!"

times 510-($-$$) db 0   ; Pad remainder of boot sector with 0s
dw 0xAA55