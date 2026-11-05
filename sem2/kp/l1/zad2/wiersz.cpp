#include <iostream>
#include <stdexcept>
#include <vector>
#include <cstdlib>
#include "wiersz.hpp"

IntegerOutOfBounds::IntegerOutOfBounds(const std::string& message) {
	msg = message;
}

const char* IntegerOutOfBounds::what() const noexcept {
	return msg.c_str();
}

WierszTrojkataPascala::WierszTrojkataPascala(int n) {
	if (n < 0) {
		throw IntegerOutOfBounds("nieprawidłowy numer wiersza");
	}
	numer = n;
}

void WierszTrojkataPascala::GenerateRow() {
	wiersz.resize(numer + 1);
	wiersz[0] = 1;
	for (int i = 0; i < numer; i++)
		for (int j = numer; j > 0; j--)
			wiersz[j] = wiersz[j] + wiersz[j - 1];
}

int WierszTrojkataPascala::GetElement(int i) {
	if (i < 0 || i > numer) {
		throw IntegerOutOfBounds("liczba spoza zakresu");
	}
	return wiersz[i];
}
