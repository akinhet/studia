import std/[math, strformat]

# --- 1. DEFINICJA PORZĄDKU PRODUKTOWEGO ---

proc `<=`*(x, y: seq[int]): bool =
  assert x.len == y.len, "Elementy musza miec ten sam wymiar"
  for i in 0 ..< x.len:
    if x[i] > y[i]: return false
  return true

proc `<`*(x, y: seq[int]): bool =
  x <= y and x != y

# --- 2. ALGORYTM SZUKANIA ELEMENTÓW MINIMALNYCH ---

# Podstawowy algorytm $O(N^2)$ (zgodny z poleceniem dla skończonej listy)
proc findMinimals*(A: seq[seq[int]]): seq[seq[int]] =
  result = @[]
  for x in A:
    var isMinimal = true
    for y in A:
      if y < x:
        isMinimal = false
        break
    if isMinimal:
      if not result.contains(x):
        result.add(x)

# Zoptymalizowana wersja przydatna do olbrzymich zbiorów (np. setB)
proc findMinimalsOptimized*(A: seq[seq[int]]): seq[seq[int]] =
  result = @[]
  for pt in A:
    var isDominated = false
    for m in result:
      if m <= pt:
        isDominated = true
        break
    if not isDominated:
      var newResult: seq[seq[int]] = @[]
      for m in result:
        if not (pt <= m):
          newResult.add(m)
      newResult.add(pt)
      result = newResult

# --- 3. GŁÓWNY PROGRAM ---

when isMainModule:
  let (a, b, c, d, e, f) = (2, 8, 3, 9, 6, 1)

  echo "=== A) Porównywanie par ==="
  let p1 = @[a, b] # (2, 8)
  let p2 = @[c, d] # (3, 9)
  let p3 = @[e, f] # (6, 1)

  echo fmt"p1=(2,8), p2=(3,9), p3=(6,1)"
  echo fmt"(2,8) <= (3,9) : {p1 <= p2}"
  echo fmt"(3,9) <= (2,8) : {p2 <= p1}"
  echo fmt"(2,8) <= (6,1) : {p1 <= p3}"
  echo fmt"(6,1) <= (2,8) : {p3 <= p1}"
  echo fmt"(3,9) <= (6,1) : {p2 <= p3}"
  echo fmt"(6,1) <= (3,9) : {p3 <= p2}"

  echo "\n=== B) Porównywanie trójek ==="
  let t1 = @[a, c, e] # (2, 3, 6)
  let t2 = @[b, d, f] # (8, 9, 1)
  
  echo fmt"t1=(2,3,6), t2=(8,9,1)"
  echo fmt"t1 <= t2 : {t1 <= t2}"
  echo fmt"t2 <= t1 : {t2 <= t1}"

  echo "\n=== C) Zbiór A (2D) ==="
  # A = { (x, y) w N^2 : (x - 2)^2 + (y - 8)^2 < 5 }
  var setA: seq[seq[int]] = @[]
  for x in 0..10:
    for y in 0..15:
      if (x - a)^2 + (y - b)^2 < 5:
        setA.add(@[x, y])

  echo "Wygenerowany zbior A:"
  echo setA
  echo "Elementy minimalne w A:"
  echo findMinimals(setA)

  echo "\n=== D) Zbiór B (4D) ==="
  # B = { (x1,x2,x3,x4) w N^4 : (x1 - 3)^2 + (x2 - 9)^2 + (x3 - 6)^2 + (x4 - 1)^2 > 224 }
  # Generujemy skończony podzbiór B, który na pewno pokryje dolny brzeg minimów.
  var setB: seq[seq[int]] = @[]
  
  for x1 in 0..14:
    for x2 in 0..23:
      for x3 in 0..18:
        for x4 in 0..11:
          if (x1 - c)^2 + (x2 - d)^2 + (x3 - e)^2 + (x4 - f)^2 > 224:
            setB.add(@[x1, x2, x3, x4])

  echo fmt"Wygenerowano skrajny dolny brzeg zbioru B (liczba badanych punktow: {setB.len})..."
  let minB = findMinimalsOptimized(setB)
  echo "Znalezione elementy minimalne w B:"
  for m in minB:
    echo m
