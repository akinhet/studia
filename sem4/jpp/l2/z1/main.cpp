#include <iostream>

#include "ring.hpp"


int main() {
	try {
		Ring<7> a = 5;
		Ring<7> b = 3;
		b = 10;

		std::cout << "a = " << a << ", b = " << b << std::endl;
		std::cout << "a + b = " << (a + b) << std::endl;
		std::cout << "a / b = " << (a / b) << std::endl;
		
		Ring<10> c = 2;
		Ring<10> d = c / 4;
	} catch (const std::exception& e) {
		std::cerr << "Błąd: " << e.what() << std::endl;
	}
	return 0;
}
