# Ziyan M. 2013-03-06. Based on the following sources:
# http://babbage.cs.qc.edu/courses/cs701/Handouts/using_make.html
# http://www.cs.toronto.edu/~penny/teaching/csc444-05f/maketutorial.html

#The C compiler to use 
CC	:=	gcc

#Some standard options
CFLAGS	+=	-g -Wall -Werror 

#Preprocessor flags like include paths
CPPFLAGS+=	-I. -lm

#Add libraries to this, e.g. -lm for the math library
LDFLAGS	:=

#List of C source files
SRCS	:=	$(wildcard *.c)

#List of test input files
TESTS	:=	$(wildcard *.inp)

#Change this to the name of your program
BINARY	:=	projI

.SUFFIXES : .inp .out
#.PHONY all : $(BINARY) 

$(BINARY) : $(SRCS:.c=.o)
	$(LINK.c) $^  -o $@

test : $(TESTS:.inp=.out)

%.out : %.inp %.exp $(BINARY) 
	@./$(BINARY) < $< > $@ || printf "\e[4;31mERROR: cannot test with input $< \e[0m\n"
	@sdiff -Wib $(<:.inp=.exp) $@ || printf "\e[4;31mERROR: input $< failed \e[0m\n"

%.d: %.c
	$(CC) -MM $(CPPFLAGS) $< | sed 's/$*.o/& $@/g' > $@

.PHONY clean :
	-rm -f *.out *.o *.d core $(BINARY)

-include $(SRCS:.c=.d)
