ICW1                    equ 00010001b   ; ICW4 needed
ICW3_MASTER             equ 00000100b
ICW3_SLAVE              equ 00000010b
ICW4                    equ 00000001b   ; 8086/88 mode

PIC1            equ 0x20    ; IO base address for master 8259 PIC
PIC2            equ 0xa0    ; addr for slave PIC
PIC1_CMD        equ PIC1
PIC1_DAT        equ PIC1 + 1
PIC2_CMD        equ PIC2
PIC2_DAT        equ PIC2 + 1

PIC_EOI         equ 0x20    ; byte to send to PIC CMD port to acknowledge end of interrupt

pic_init:
    ; https://www.eeeguide.com/programming-8259/
    cli

    ; I will map the master PIC to 0x60+0:7 = 0110,0000b
    ; and the slave PIC to 0x70+0:7 = 0111,0000b (which is actually the default for it anyway)

    mov al, ICW1
    out PIC1_CMD, al
    out PIC2_CMD, al

    mov al, PIC_MASTER_OFFSET
    out PIC1_DAT, al

    mov al, PIC_SLAVE_OFFSET
    out PIC2_DAT, al

    mov al, ICW3_MASTER
    out PIC1_DAT, al

    mov al, ICW3_SLAVE
    out PIC2_DAT, al

    mov al, ICW4
    out PIC1_DAT, al
    out PIC2_DAT, al

    ; Set masks to only enable the keyboard and PIT
    mov al, 11111100b
    out PIC1_DAT, al
    mov al, 0xff
    out PIC2_DAT, al

    mov al, 0xae
    out 0x64, al

    ; Now both of the PICs are initialised correctly
    sti
    ret