#ifndef WIERSZTROJKATAPASCALA_H
#define WIERSZTROJKATAPASCALA_H

#include <exception>
#include <string>
#include <vector>

class IntegerOutOfBounds : public std::exception {
private:
    std::string msg;
public:
    IntegerOutOfBounds(const std::string& message);
	const char* what() const noexcept;
};

class WierszTrojkataPascala {
private:
    int numer;
    std::vector<long int> wiersz;

public:
    WierszTrojkataPascala(int n);
    void GenerateRow();
    int GetElement(int i);
};

#endif
