#include "figury.h"
#include <stdexcept>
#include <iostream>

using namespace std;

Kolo::Kolo(int r) {
    if (r < 0) throw invalid_argument("argument cannot be negative");
    this->r = r;
}

double Kolo::pole() const {
    return 3.14 * r * r;
}

double Kolo::obwod() const {
    return 6.28 * r;
}

string Kolo::name() const {
    return "Koło";
}

Pieciokat::Pieciokat(int a) {
    if (a < 0) throw invalid_argument("argument cannot be negative");
    this->a = a;
}

double Pieciokat::pole() const {
    return (5.0 / 4.0) * a * a * (1.0 / tan(M_PI / 5));
}

double Pieciokat::obwod() const {
    return 5 * a;
}

string Pieciokat::name() const {
    return "Pięciokąt";
}

Szesciokat::Szesciokat(int a) {
    if (a < 0) throw invalid_argument("argument cannot be negative");
    this->a = a;
}

double Szesciokat::pole() const {
    return ((3 * sqrt(3)) / 2) * a * a;
}

double Szesciokat::obwod() const {
    return 6 * a;
}

string Szesciokat::name() const {
    return "Sześciokąt";
}

Kwadrat::Kwadrat(int a) {
    if (a < 0) throw invalid_argument("argument cannot be negative");
    this->a = a;
}

double Kwadrat::pole() const {
    return a * a;
}

double Kwadrat::obwod() const {
    return 4 * a;
}

string Kwadrat::name() const {
    return "Kwadrat";
}

Romb::Romb(int a, int kat) {
    if (a < 0 || kat <= 0 || kat >= 180)
        throw invalid_argument("invalid argument for Romb");
    this->a = a;
    this->kat = kat;
}

double Romb::pole() const {
    double rad = kat * M_PI / 180.0;
    return a * a * sin(rad);
}

double Romb::obwod() const {
    return 4 * a;
}

string Romb::name() const {
    return "Romb";
}

Prostokat::Prostokat(int a, int c, int b, int d) {
    if (a < 0 || b < 0 || c < 0 || d < 0)
        throw invalid_argument("side length cannot be negative");
    if (a != c || b != d)
        throw invalid_argument("opposite sides must be equal for a rectangle");
    this->a = a;
    this->b = b;
}

double Prostokat::pole() const {
    return a * b;
}

double Prostokat::obwod() const {
    return 2 * (a + b);
}

string Prostokat::name() const {
    return "Prostokąt";
}
