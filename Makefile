#
# 'make depend' uses makedepend to automatically generate dependencies
#			   (dependencies are added to end of Makefile)
# 'make'		build executable file
# 'make clean'  removes all .o and executable files
#

# define the C compiler to use
CC = /opt/local/bin/g++-mp-6
#CC = g++
#CC = clang++

CTAGGEN = ~/bin/gcc_ctag_with_dep.sh
#CTAGGEN = ~/bin/clang_ctag_with_dep.sh

# define C++ version, it can be c++11 or c++1y or just comment it out.
C++VER = -std=c++11

# define any compile-time flags
CFLAGS = -Wall -g -v $(C++VER)

# define any directories containing header files other than /usr/include
#
INCLUDES = -I/opt/local/include/ -I/usr/local/include -I../include -I.

# define library paths in addition to /usr/lib
#   if I wanted to include libraries not in /usr/lib I'd specify
#   their path using -Lpath, something like:
LFLAGS = -L/opt/local/lib -L/usr/local/lib

# define any libraries to link into executable:
#   if I want to link in libraries (libx.so or libx.a) I use the -llibname
#   option, something like (this will link in libmylib.so and libm.so:
LIBS = -lboost_system-mt -lboost_container-mt -lm

# define the C source files
SRCS = headertest.cpp \
	class.cpp

# define the C object files
#
# This uses Suffix Replacement within a macro:
#   $(name:string1=string2)
#		 For each word in 'name' replace 'string1' with 'string2'
# Below we are replacing the suffix .c of all words in the macro SRCS
# with the .o suffix
#
OBJS = $(SRCS:.cpp=.o)

# define the executable file
MAIN = test

#
# The following part of the makefile is generic; it can be used to
# build any executable just by changing the definitions above and by
# deleting dependencies appended to the file from 'make depend'
#

.PHONY: depend clean

all:	$(MAIN)
		@echo
		@echo ====================Project Compiled====================
		@echo
		$(CTAGGEN) *.cpp

$(MAIN): $(OBJS)
		$(CC) $(CFLAGS) $(INCLUDES) -o $(MAIN) $(OBJS) $(LFLAGS) $(LIBS)

# this is a suffix replacement rule for building .o's from .c's
# it uses automatic variables $<: the name of the prerequisite of
# the rule(a .c file) and $@: the name of the target of the rule (a .o file)
# (see the gnu make manual section about automatic variables)
.cpp.o:
		$(CC) $(CFLAGS) $(INCLUDES) -c $<  -o $@

clean:
		$(RM) *.o *~ $(MAIN)

depend: $(SRCS)
		/opt/X11/bin/makedepend $(INCLUDES) $^

# DO NOT DELETE THIS LINE -- make depend needs it
