#include <iostream>
#include <stdexcept>
#include <cstdlib>
#include "wiersz.hpp"


int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cout << "Brak argumentów." << std::endl;
        return 1;
    }

    try {
        int n = std::stoi(argv[1]);
        WierszTrojkataPascala wiersz(n);
        wiersz.GenerateRow();

        for (int i = 2; i < argc; i++) {
            try {
                int index = std::stoi(argv[i]);
                std::cout << argv[i] << " - " << wiersz.GetElement(index) << std::endl;
            } catch (const std::invalid_argument& ex) {
                std::cout << argv[i] << " - nieprawidłowa dana" << std::endl;
            } catch (const IntegerOutOfBounds& ex) {
                std::cout << argv[i] << " - " << ex.what() << std::endl;
            }
        }
    } catch (const std::invalid_argument& ex) {
        std::cout << argv[1] << " - nieprawidłowa dana" << std::endl;
    } catch (const IntegerOutOfBounds& ex) {
        std::cout << argv[1] << " - " << ex.what() << std::endl;
    }

    return 0;
}

