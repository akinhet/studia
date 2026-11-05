clean:
	rm -f main *.o *.a *.so

static:
	gcc -o gcdlib.o -c gcdlib.c 
	ar rcs libgcdlib.a gcdlib.o
	gcc main.c -L. -lgcdlib -o main

shared:
	gcc -c -fPIC gcdlib.c -o gcdlib.o
	gcc -shared -o libgcdlib.so gcdlib.o
	gcc main.c -L. -lgcdlib -o main
	LD_LIBRARY_PATH=. ./main
