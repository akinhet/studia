MAX_N = 20

position = [0] * MAX_N
bije_wiersz = [False] * MAX_N
bije_przek1 = [False] * (2 * MAX_N)
bije_przek2 = [False] * (2 * MAX_N)


def drukuj_rozwiazanie(n):
    for i in range(1, n + 1):
        print(position[i], end=" ")
    print()


def ustaw(i, n):
    for j in range(1, n + 1):
        if not bije_wiersz[j] and not bije_przek1[i + j] and not bije_przek2[i - j + n]:
            position[i] = j
            bije_wiersz[j] = True
            bije_przek1[i + j] = True
            bije_przek2[i - j + n] = True

            if i < n:
                ustaw(i + 1, n)
            else:
                drukuj_rozwiazanie(n)

            position[i] = 0
            bije_wiersz[j] = False
            bije_przek1[i + j] = False
            bije_przek2[i - j + n] = False


def main():
    import sys
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} [number of queens]")
        sys.exit(1)

    try:
        n = int(sys.argv[1])
    except ValueError:
        print(f"ERROR: bad argument: {sys.argv[1]}")
        sys.exit(2)

    if n <= 0:
        print(f"ERROR: bad argument: {sys.argv[1]}")
        sys.exit(2)

    if n < 1 or n > MAX_N:
        print(f"n must be an integer in the range 1-{MAX_N}.")
        sys.exit(3)

    global position, bije_wiersz, bije_przek1, bije_przek2
    position = [0] * MAX_N
    bije_wiersz = [False] * MAX_N
    bije_przek1 = [False] * (2 * MAX_N)
    bije_przek2 = [False] * (2 * MAX_N)

    ustaw(1, n)


if __name__ == "__main__":
    main()
