ENTRY(main)

MEMORY
{
    SRAM (rwx) : ORIGIN = 0x00000000, LENGTH = 64K
}

SECTIONS
{
    . = ALIGN(4);

    .text : {
        *(.vector_table)
        *(.text.*)
        *(.rodata.*)
        . = ALIGN(4);
    } > SRAM

    .got : {
        *(.got)
        *(.got.plt)
        . = ALIGN(4);
    } > SRAM

    .data : {
        . = ALIGN(4);
        _data = .;
        *(.data.*)
        . = ALIGN(4);
        _edata = .;
    } > SRAM

    .bss : {
        . = ALIGN(4);
        _bss = .;
        *(.bss.*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } > SRAM

    /DISCARD/ : {
        *(.ARM.attributes)
        *(.comment)
        *(.debug*)
        *(.note.*)
        *(.interp)
        *(.dynsym)
        *(.dynstr)
        *(.hash)
        *(.dynamic)
    }
}

/* Set initial stack pointer to end of SRAM */
_stack_top = ORIGIN(SRAM) + LENGTH(SRAM);
