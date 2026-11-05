def main():
    n = int(input("Podaj liczbę: "))
    p = int(input("Podaj podstawę: "))

    num = n
    out = 0

    while num > 0:
        out *= p
        out += num % p
        num //= p

    if n == out:
        print(f"Liczba {n} jest plaindromem w podstawie {p}.")
    else:
        print(f"Liczba {n} nie jest plaindromem w podstawie {p}.")


if __name__ == "__main__":
    main()
