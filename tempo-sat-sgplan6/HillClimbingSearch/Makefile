####################################
# Makefile for HillClimbingSearch  #
####################################


####### FLAGS

TARGET = lpg
LIBS=  -lm 


####### COMPILE

CC	= gcc 

PATH_HEADERS = -I$(SRC_HEADER)

SRC_HEADER =../include

SOURCES = relax.c \
	  output.c \
	  search.c

OBJECTS = $(SOURCES:.c=.o)

find_header = $(wildcard $(dir)/*.h)

HEADERS := $(foreach dir,../include,$(find_header))


####### Implicit rules

.SUFFIXES:

.SUFFIXES: .c .o

.c.o:; $(CC) $(PATH_HEADERS) -c $(CFLAGS) $<


####### Build rules

HillClimbingSearch.a: 	$(OBJECTS)
			$(AR) rc $@ $^ 

$(OBJECTS): $(HEADERS)

clean:
	rm -f *.o *.a *~

#######
