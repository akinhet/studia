#!/usr/bin/env python3
def NWD(a, b):
    if a < 0:
        a = -a

    if b < 0:
        b = -b

    while b > 0:
        tmp = a
        a = b
        b = tmp % b
    return a


def main():
    a = int(input("Podaj liczbę pierwszą: "))
    b = int(input("Podaj liczbę drugą: "))

    print("Wynik to", NWD(a, b))


if __name__ == "__main__":
    main()
