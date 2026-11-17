CC = gcc
CFLAGS = -Wall -Wextra
DEPS = htree.h

all: encode decode

encode: $(DEPS)
	$(CC) -o $@ $@.c $(CFLAGS)

decode: $(DEPS)
	$(CC) -o $@ $@.c $(CFLAGS)

clean:
	rm -f encode decode

.PHONY: all clean
