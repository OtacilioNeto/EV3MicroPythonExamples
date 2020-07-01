CFLAGS=-Wall -O2

all: server

server: server.o
	$(CC) -o $@ $?

server.o: server.c
	$(CC) $(CFLAGS) -c -o $@ $?

clean:
	rm -rf server *.o
