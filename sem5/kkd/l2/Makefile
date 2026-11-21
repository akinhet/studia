CC = gcc
CFLAGS = -Wall -Wextra
DEPS = htree.h

all: encode decode

encode: encode.c $(DEPS)
	$(CC) -o $@ $@.c $(CFLAGS) -lm

decode: decode.c $(DEPS)
	$(CC) -o $@ $@.c $(CFLAGS)

clean:
	rm -f encode decode

.PHONY: all clean
