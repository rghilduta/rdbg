# Toolchain definitions
CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
OBJDUMP = arm-none-eabi-objdump

# Target CPU flags for A56 (ARMv8-A architecture)
CFLAGS = -mcpu=cortex-a57 \
         -marm \
         -mno-unaligned-access \
         -fno-builtin \
         -ffreestanding \
         -O2 \
         -Wall \
         -nostdlib \
         -nostartfiles \
         -fPIC \
         -fpic \
         -msingle-pic-base \
         -mno-pic-data-is-text-relative

# Source files
SRCS = uart_hello.c
OBJS = $(SRCS:.c=.o)

# Output files
TARGET = uart_hello
TARGET_ELF = $(TARGET).elf
TARGET_BIN = $(TARGET).bin

# Default target
all: $(TARGET_BIN)

# Compile C files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Link
$(TARGET_ELF): $(OBJS)
	$(LD) -T uart.ld --pic-executable $(OBJS) -o $@

# Generate binary
$(TARGET_BIN): $(TARGET_ELF)
	$(OBJCOPY) -O binary $< $@
	$(OBJDUMP) -D $(TARGET_ELF) > $(TARGET).lst

# Clean
clean:
	rm -f $(OBJS) $(TARGET_ELF) $(TARGET_BIN) $(TARGET).lst

.PHONY: all clean
