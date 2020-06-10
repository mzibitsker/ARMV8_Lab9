# Example Makefile
#
# This makefile is intended for use with GNU make
# This example is intended to be built with Linaro bare-metal GCC on Linux or Windows

# The project includes two files, main.c and a .S assembly language file.
# BASE is used as the base name for the .S file as well as for the corresponding
# compiled .o file and the complete compiled file.

BASE=lab9
TARGET=${BASE}.axf

CC=aarch64-elf-gcc
LD=aarch64-elf-gcc

# Select build rules based on Windows or Unix
ifdef WINDIR
DONE=@if exist $(1) echo Build completed.
RM=if exist $(1) del /q $(1)
SHELL=$(WINDIR)\system32\cmd.exe
else
ifdef windir
DONE=@if exist $(1) echo Build completed.
RM=if exist $(1) del /q $(1)
SHELL=$(windir)\system32\cmd.exe
else
DONE=@if [ -f $(1) ]; then echo Build completed.; fi
RM=rm -f $(1)
endif
endif

all: $(TARGET)
	$(call DONE,$(TARGET))
	
rebuild: clean all

clean:
	$(call RM,*.o)
	$(call RM,$(TARGET))

main.o: main.c
# Compile for best debug view (lowest optimization)
	$(CC) -c -march=armv8-a -g -O0 $^ -o $@

$(BASE).o: $(BASE).S
# Compile for best debug view (lowest optimization)
	$(CC) -c -march=armv8-a -g -O0 $^ -o $@

$(TARGET): main.o $(BASE).o
# Link with specific base address to suit VE model memory layout
	$(LD) --specs=aem-ve.specs -Wl,--build-id=none main.o $(BASE).o -o $@
