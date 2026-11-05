clean:
	rm -f *.a *.o *.so *.ali b~* main

static:
	gcc -c gcd_lib.adb
	ar rcs libgcdlib.a gcd_lib.o
	gcc main.c -L. -lgcdlib -lgnat -o main
	./main

shared:
	gnatmake -c gcd_lib
	gnatbind -Lgcdlib gcd_lib
	gcc -c -fPIC b~gcd_lib.adb
	gcc -shared -fPIC -lgnat -o libgcdlib.so b~gcd_lib.o gcd_lib.o
	gcc -L. -lgcdlib main.c -o main
	LD_LIBRARY_PATH=. ./main

