
# This makefile creates the JWasm Elf binary for Linux/FreeBSD.

TARGET1=wres.a

ifndef DEBUG
DEBUG=0
endif

watcom_dir=../../../watcom

inc_dirs  = -I../../../h -Ih -I$(watcom_dir)/h

#cflags stuff

ifeq ($(DEBUG),0)
extra_c_flags = -DNDEBUG -O2
OUTD=GccUnixR
else
extra_c_flags = -DDEBUG_OUT -g
OUTD=GccUnixD
endif

c_flags =-D__UNIX__ $(extra_c_flags) -D_WCUNALIGNED= -DO_BINARY=0

# CC=clang allowed
CC ?= gcc
AR ?= ar

.SUFFIXES:
.SUFFIXES: .c .o

include gccmod.inc

#.c.o:
#	$(CC) -c $(inc_dirs) $(c_flags) -o $(OUTD)/$*.o $<
$(OUTD)/%.o: c/%.c
	$(CC) -c $(inc_dirs) $(c_flags) -o $(OUTD)/$*.o $<

all:  $(OUTD) $(OUTD)/$(TARGET1)

$(OUTD):
	mkdir $(OUTD)

$(OUTD)/$(TARGET1) : $(proj_obj)
ifeq ($(DEBUG),0)
	$(AR) rcs $(OUTD)/$(TARGET1) $(proj_obj)
else
	$(AR) rcs $(OUTD)/$(TARGET1) $(proj_obj)
endif

######

clean:
	rm -f $(OUTD)/$(TARGET1)
	rm -f $(OUTD)/*.o
	rm -f $(OUTD)/*.map

