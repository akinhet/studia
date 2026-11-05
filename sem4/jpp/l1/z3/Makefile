shared:
	gcc -o main -L./target/release -lgcdlib main.c
	LD_LIBRARY_PATH=./target/release ./main

static:
	gcc main.c ./target/release/libgcdlib.a -o main
