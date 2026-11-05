import math


def main():
    a = int(input("Podaj pierwszą liczbę: "))
    b = int(input("Podaj drugą liczbę: "))
    c = int(input("Podaj trzecią liczbę: "))

    delta = b*b - (4 * a * c)

    if delta < 0:
        print("To równianie nie ma pierwiastków w liczbach rzeczywistych.")
    elif delta == 0:
        x1 = -b / (2 * a)
        print(f"Rozwiązaniem tego równania jest {x1}")
    else:
        x1 = (-b + math.sqrt(delta)) / (2 * a)
        x2 = (-b - math.sqrt(delta)) / (2 * a)
        print(f"Rozwiązaniami tego równania są {x1} i {x2}")


if __name__ == "__main__":
    main()
