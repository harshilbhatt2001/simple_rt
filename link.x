/* Memory layout of the LM3S6965 microcontoller */
/* 1K = 1kiBi = 1024 bytes */
MEMORY
{
    FLASH : ORIGIN = 0x00000000, LENGTH = 256K
    RAM : ORIGIN = 0x20000000, LENGTH = 64K
}

/* The entry point of the reset handle */
ENTRY(Reset);

EXTERN(RESET_VECTOR);

SECTIONS
{
    .vector_table ORIGIN(FLASH) :
    {
        /* First entry: initial stack pointer value */
        LONG(ORIGIN(RAM) + LENGTH(RAM));

        /* Second entry: reset vector */
        KEEP(*(.vector_table.reset_vector));
    } > FLASH

    .text :
    {
        *(.text .text.*);
    } > FLASH

    .rodata :
    {
        *(.rodata .rodata.*);
    } > FLASH 

    .bss :
    {
        /* _s? and _e? is used to specify start and end address of ? sections 
           which will later be used in Rust code */
        _sbss = .;
        *(.bss .bss.*);
        _ebss = .;
    } > RAM

    /* We set the Load Memory Access (LMA) of ".data" section at the end of the
       ".rodata" section */
    .data : AT(ADDR(.rodata) + SIZEOF(.rodata))
    {
        /* _s? and _e? is used to specify start and end address of ? sections 
           which will later be used in Rust code */
        _sdata = .;
        *(.data .data.*);
        _edata = .;
    } > RAM

    /* We associate a symbol to the LMA of ".data" */
    _sidata = LOADADDR(.data);

    /* This section is related to exception handling but we are not doing stack
       unwinding on panics and they might take up space in Flash memory, so we 
       discard them. */
    /DISCARD/ :
    {
        *(.ARM.exidx .ARM.exidx.*);
    }
}
