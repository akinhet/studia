import math

def findzero(f, a, b, eps):
    if a >= b or f(a) * f(b) >= 0:
        return a

    start = a
    end = b

    while (end - start) > eps:
        mid = (start + end) / 2

        if f(mid) == 0:
            return mid

        if f(start) * f(mid) < 0:
            end = mid
        else:
            start = mid

    return mid

def halfcos(x):
    return math.cos(x / 2)

def main():
    eps = 0.1
    for i in range(8):
        print(f"{findzero(halfcos, 2, 4, eps):.20f}")
        eps /= 10

if __name__ == "__main__":
    main()
