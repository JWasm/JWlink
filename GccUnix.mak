
# This makefile creates the JWasm Elf binary for Linux/FreeBSD.

TARGET1=jwlink

ifndef DEBUG
DEBUG=0
endif

inc_dirs  = -I. -Ih -Iwatcom/h -Ilib_misc/h -Iorl/h -Idwarf/dw/h -Isdk/rc/rc/h -Isdk/rc/wres/h

#cflags stuff

ifeq ($(DEBUG),0)
extra_c_flags = -DNDEBUG -O2
OUTD=GccUnixR
else
extra_c_flags = -DDEBUG_OUT -g
OUTD=GccUnixD
endif

c_flags =-D__UNIX__ -D_BSD_SOURCE -DINSIDE_WLINK $(extra_c_flags) -D_WCUNALIGNED= -DO_BINARY=0

# CC=clang allowed
CC ?= gcc

.SUFFIXES:
.SUFFIXES: .c .o

include gccmod.inc

orl_lib = orl/GccUnixR/orl.a
dwarf_dw_lib= dwarf/dw/GccUnixR/dwarf.a
wres_lib= sdk/rc/wres/GccUnixR/wres.a

xlibs = $(wres_lib) $(dwarf_dw_lib) $(orl_lib)

#.c.o:
#	$(CC) -c $(inc_dirs) $(c_flags) -o $(OUTD)/$*.o $<
$(OUTD)/%.o: c/%.c
	$(CC) -c $(inc_dirs) $(c_flags) -o $(OUTD)/$*.o $<
$(OUTD)/%.o: lib_misc/c/%.c
	$(CC) -c $(inc_dirs) $(c_flags) -o $(OUTD)/$*.o $<
$(OUTD)/%.o: sdk/rc/rc/c/%.c
	$(CC) -c $(inc_dirs) $(c_flags) -o $(OUTD)/$*.o $<

all:  $(OUTD) $(OUTD)/$(TARGET1)

$(OUTD):
	mkdir $(OUTD)

$(OUTD)/$(TARGET1) : $(proj_obj) $(xlibs)
	$(CC) -o $@ $(proj_obj) $(xlibs)
######

clean:
	rm -f $(OUTD)/$(TARGET1)
	rm -f $(OUTD)/*.o
	rm -f $(OUTD)/*.map

