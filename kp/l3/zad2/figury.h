#ifndef FIGURY_H
#define FIGURY_H

#include <string>
#include <memory>
#include <cmath>

using namespace std;

class Figura {
public:
    virtual string name() const = 0;
    virtual double pole() const = 0;
    virtual double obwod() const = 0;
    virtual ~Figura() {}
};

class Kolo : public Figura {
    int r;

public:
    Kolo(int r);
    double pole() const override;
    double obwod() const override;
    string name() const override;
};

class Pieciokat : public Figura {
    int a;

public:
    Pieciokat(int a);
    double pole() const override;
    double obwod() const override;
    string name() const override;
};

class Szesciokat : public Figura {
    int a;

public:
    Szesciokat(int a);
    double pole() const override;
    double obwod() const override;
    string name() const override;
};

class Kwadrat : public Figura {
    int a;

public:
    Kwadrat(int a);
    double pole() const override;
    double obwod() const override;
    string name() const override;
};

class Romb : public Figura {
    int a, kat;

public:
    Romb(int a, int kat);
    double pole() const override;
    double obwod() const override;
    string name() const override;
};

class Prostokat : public Figura {
    int a, b;

public:
    Prostokat(int a, int b, int c, int d);
    double pole() const override;
    double obwod() const override;
    string name() const override;
};

#endif
