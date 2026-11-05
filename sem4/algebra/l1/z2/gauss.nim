import std/math
import std/strformat
import std/sequtils

type
  Gauss* = object
    a, b: int

proc toGauss(a, b: int): Gauss =
  result = Gauss(a: a, b: b)


proc `+`*(x, y: Gauss): Gauss =
  toGauss(x.a + y.a, x.b + y.b)


proc `-`*(x, y: Gauss): Gauss =
  toGauss(x.a - y.a, x.b - y.b)


proc `*`*(x, y: Gauss): Gauss =
  toGauss(x.a * y.a - x.b * y.b, x.a * y.b + x.b * y.a)


proc `$`*(x: Gauss): string =
  "(" & $x.a & " + " & $x.b & "i)"


proc norm*(x: Gauss): int =
  x.a ^ 2 + x.b ^ 2


proc `==`*(x, y: Gauss): bool =
  x.a == y.a and x.b == y.b


proc getNearestGaussians(real, img: float): seq[Gauss] =
  let
    rLow = floor(real).int
    rHigh = ceil(real).int
    iLow = floor(img).int
    iHigh = ceil(img).int

  var candidates: seq[Gauss] = @[]
  for r in [rLow, rHigh]:
    for i in [iLow, iHigh]:
      let g = Gauss(a: r, b: i)
      if g notin candidates: candidates.add(g)

  let minDist = candidates.mapIt((real - it.a.float)^2 + (img - it.b.float)^2).min()
  result = candidates.filterIt((real - it.a.float)^2 + (img - it.b.float)^2 <= minDist + 0.0001)


proc getAssociates(x: Gauss): seq[Gauss] =
  @[x, Gauss(a: -x.b, b: x.a), Gauss(a: -x.a, b: -x.b), Gauss(a: x.b, b: -x.a)]


proc divRem*(x, y: Gauss): seq[(Gauss, Gauss)] =
  let
    denom = norm(y).float
    a = x
    b = toGauss(y.a, -y.b)
    c = a * b
    real = c.a.float / denom
    img = c.b.float / denom

  let quotients = getNearestGaussians(real, img)
  for q in quotients:
    let r = x - (y * q)
    result.add((q, r))


proc `%`*(x, y: Gauss): Gauss =
  let (_, r) = divRem(x, y)[0]
  return r


proc gcd(x, y: Gauss): seq[Gauss] =
  if x.norm == 0: return getAssociates(y)
  if y.norm == 0: return getAssociates(x)

  var a = x
  var b = y
  while b.norm != 0:
    let r = a % b
    a = b
    b = r
  return getAssociates(a)



proc gcd*(arr: openArray[Gauss]): seq[Gauss] =
  if arr.len == 0: return @[Gauss(a: 0, b: 0)]
  if arr.len == 1: return getAssociates(arr[0])

  var currentGcds = gcd(arr[0], arr[1])
  for i in 2 ..< arr.len:
    currentGcds = gcd(currentGcds[0], arr[i])
  return currentGcds



when isMainModule:
  let a = toGauss(2,8)
  echo fmt"norma {a}: ", norm(toGauss(2,8))
  let
    b = toGauss(3,9)
    c = toGauss(2,8)
    d = toGauss(6,1)

  let res = divRem((b + c), d)
  for i in res:
    echo fmt"({b} + {c}) / {d}: ", i

  let list = @[toGauss(2, 8), toGauss(3, 9), toGauss(6, 1)]
  echo "\nNWD dla trójki liczb Gaussa: ", list
  echo "Wszystkie możliwe wyniki (z dokładnością do jedności):"
  echo gcd(list)

  echo "\nNWD dla listy pustej: ", gcd([])
  echo "NWD dla listy 1-elementowej (2+8i): ", gcd([toGauss(2, 8)])
