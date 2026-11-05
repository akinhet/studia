import sys

num_good_boards = 0


def eval_board(a, n):
    global num_good_boards
    for i in range(n - 1):
        for j in range(i + 1, n):
            if a[j] == a[i] + j - i or a[j] == a[i] - j + i:
                return

    print(" ".join(map(str, a)))
    num_good_boards += 1


def gen_permutations(a, size, n):
    if size == 0:
        eval_board(a, n)
        return

    for i in range(size):
        gen_permutations(a, size - 1, n)

        if size % 2 == 1:
            a[0], a[size - 1] = a[size - 1], a[0]
        else:
            a[i], a[size - 1] = a[size - 1], a[i]


def main():
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

    a = list(range(1, n + 1))
    gen_permutations(a, n, n)

    print(f"Number of solutions: {num_good_boards}")


if __name__ == "__main__":
    main()
