type
  Ring*[N: static[int]] = object
    value: int

proc toRing*(n: static[int], v: int): Ring[n] =
  static:
    assert n > 1, "Moduł pierścienia musi być większy niż 1!"
  let res = ((v mod n) + n) mod n
  result = Ring[n](value: res)

proc inverse(a, n: int): int =
  var
    (t, newt) = (0, 1)
    (r, newr) = (n, a)

  while newr != 0:
    let quotient = r div newr
    (t, newt) = (newt, t - quotient * newt)
    (r, newr) = (newr, r - quotient * newr)

  if r > 1:
    raise newException(ValueError, "Element is not invertible (gcd != 1)")
  if t < 0:
    t = t + n
  return t

proc `+`*[N](a, b: Ring[N]): Ring[N] =
  toRing(N, a.value + b.value)

proc `+`*[N](a: Ring[N], b: int): Ring[N] =
  # toRing(N, a.value + b)
  a + toRing(N, b)

proc `-`*[N](a, b: Ring[N]): Ring[N] =
  toRing(N, a.value - b.value)

proc `*`*[N](a, b: Ring[N]): Ring[N] =
  toRing(N, a.value * b.value)

proc `/`*[N](a, b: Ring[N]): Ring[N] =
  let inv = inverse(b.value, N.int)
  toRing(N, a.value * inv.int)

proc `==`*[N](a, b: Ring[N]): bool = a.value == b.value
proc `<`*[N](a, b: Ring[N]): bool = a.value < b.value
proc `<=`*[N](a, b: Ring[N]): bool = a.value <= b.value

proc `$`*[N](r: Ring[N]): string = $r.value

proc `int`*[N](r: Ring[N]): int = r.value


when isMainModule:
  try:
    # let a = toRing(7'u, 5)
    # let b = toRing(7'u, 3)
    #
    # echo "mod 7"
    # echo "a = ", a
    # echo "b = ", b
    # echo "a + b = ", a + b
    # echo "a * b = ", a * b
    # echo "a / b = ", a / b
    #
    # let x = toRing(10'u, 5)
    # let y = toRing(10'u, 2)
    # echo "x / y = ", x / y # will error
    let
      a = toRing(31, 29)
      b = toRing(31, 2)

    echo "29 + 2 = ", a + b
    echo "29 + 15 = ", a + 15
    echo "33 - 35 = ", toRing(31, 33) - toRing(31, 35)
    echo "-2 * 7 = ", toRing(31, -2) * toRing(31, 7)
    echo "25 / 29 = ", toRing(31, 25) / toRing(31, 29)
    echo "-7 > 20 ? ", toRing(31, -7) > toRing(31, 20)
    echo "10 < 20 ? ", toRing(31, 10) < toRing(31, 20)
    echo "-5 == 26 ? ", toRing(31, -5) < toRing(31, 26)
    echo "3 mod 31 * 15 = ", toRing(31, 3).int * 15

  except ValueError as e:
    echo "ERROR: ", e.msg
