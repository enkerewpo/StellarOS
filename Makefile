GCCFLAGS = -Wall -O2 -ffreestanding -nostdinc -nostdlib -nostartfiles
GCCPATH = /opt/gcc-arm/gcc-arm-10.3-2021.07-x86_64-aarch64-none-elf/bin
SRC_DIR = src
BUILD_DIR = build
CFILES = $(wildcard $(SRC_DIR)/*.c)
OFILES = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(CFILES))

all: clean stellaros-kernel.img

$(BUILD_DIR)/boot.o: $(SRC_DIR)/asm/boot.s
	$(GCCPATH)/aarch64-none-elf-gcc $(GCCFLAGS) -c $(SRC_DIR)/asm/boot.s -o $(BUILD_DIR)/boot.o

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(GCCPATH)/aarch64-none-elf-gcc $(GCCFLAGS) -c $< -o $@

stellaros-kernel.img: $(BUILD_DIR)/boot.o $(OFILES)
	$(GCCPATH)/aarch64-none-elf-ld -nostdlib $(BUILD_DIR)/boot.o $(OFILES) -T src/asm/link.ld -o $(BUILD_DIR)/stellaros-kernel.elf
	$(GCCPATH)/aarch64-none-elf-objcopy -O binary $(BUILD_DIR)/stellaros-kernel.elf $(BUILD_DIR)/stellaros-kernel.img

clean:
	/bin/rm stellaros-kernel.elf *.o *.img > /dev/null 2> /dev/null || true