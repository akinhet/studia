#include <iostream>
#include "ring.hpp"
#include "dh.hpp"


int main() {
	try {
		const int MOD = 1234567891;
		using Zp = Ring<MOD>;

		DHSetup<Zp, MOD> setup;
		std::cout << "Wylosowany generator g: " << setup.getGenerator() << std::endl;

		User<Zp, MOD> alice(setup);
		User<Zp, MOD> bob(setup);

		alice.setKey(bob.getPublicKey());
		bob.setKey(alice.getPublicKey());

		Zp message(42069);
		Zp encrypted = alice.encrypt(message);
		Zp decrypted = bob.decrypt(encrypted);

		std::cout << "Wiadomosc: " << message << std::endl;
		std::cout << "Zaszyfrowana: " << encrypted << std::endl;
		std::cout << "Odszyfrowana: " << decrypted << std::endl;

	} catch (const std::exception& e) {
		std::cerr << "Error: " << e.what() << std::endl;
	}
	return 0;
}
