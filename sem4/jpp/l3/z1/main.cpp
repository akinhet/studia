#include <iostream>
#include "rsa.hpp"


int main() {
    const unsigned p = 10007;
    const unsigned q = 10009;
    const unsigned n_val = p * q;

    RSA<Ring<p*q>> rsa(p, q);

    std::cout << "--- Test RSA ---" << std::endl;
    std::cout << "Modulo n: " << rsa.getModulo() << std::endl;
    std::cout << "Klucz publiczny e: " << rsa.getPublicKey() << std::endl;

    Ring<p*q> message(12345678);
    std::cout << "\nOryginalna wiadomosc: " << message << std::endl;

    auto encrypted = rsa.encrypt(message);
    std::cout << "Zaszyfrowana: " << encrypted << std::endl;

    auto decrypted = rsa.decrypt(encrypted);
    std::cout << "Odszyfrowana: " << decrypted << std::endl;

    if (message == decrypted) {
        std::cout << "\nSukces: Wiadomosc poprawnie odzyskana!" << std::endl;
    } else {
        std::cout << "\nBlad: Wiadomosci sie roznia." << std::endl;
    }

    return 0;
}
