CC = gcc
CFLAGS = -Wall -ggdb
EXECS = inc dec rand insertion quick hybrid

all: $(EXECS)

%: %.c
	$(CC) -o $@ $< $(CFLAGS)

clean:
	rm -f $(EXECS)

.PHONY: all clean
