CPP=g++

INC=-I/usr/local/include -I/usr/include/eigen3

CPPFLAGS=-Wall -O2 -std=c++17 -DHAVE_GLEW

LIBS=-lpangolin -lGL -lGLEW

all: server plot

server: server.c
	cc -Wall -O2 -o server server.c

plot: plot.o 
	$(CPP) -o $@ $? $(LIBS)

plot.o: plot.cpp
	$(CPP) $(INC) $(CPPFLAGS) -c -o $@ $<

clean:
	rm -rf server plot *.o
