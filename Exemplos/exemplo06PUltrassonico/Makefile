CPP=g++

INC=-I/usr/local/include -I/usr/include/eigen3

CPPFLAGS=-Wall -O2 -std=c++17 -DHAVE_GLEW

LIBS=-lpango_plot -lpango_opengl -lpango_display -lGL -lGLEW

.PHONY: all clean

all: plot

plot: plot.o 
	$(CPP) -o $@ $? $(LIBS)

plot.o: plot.cpp
	$(CPP) $(INC) $(CPPFLAGS) -c -o $@ $<

clean:
	rm -rf plot *.o
