import std/[math, sequtils, strformat, strutils]

# --- 1. STRUKTURA I INICJALIZACJA ---
type
  Poly*[T] = object
    coeffs*: seq[T]

proc clean*[T](p: var Poly[T]) =
  # Usuwanie wiodących zer (używamy epsilonu dla precyzji zmiennoprzecinkowej)
  while p.coeffs.len > 0 and abs(p.coeffs[^1]) < 1e-9:
    p.coeffs.delete(p.coeffs.high)

proc initPoly*[T](c: openArray[T]): Poly[T] =
  result.coeffs = @c
  # result.clean()

proc isZero*(x: SomeNumber): bool = x == 0
proc isZero*[T](p: Poly[T]): bool =
  if p.coeffs.len == 0: return true
  for c in p.coeffs:
    if not isZero(c): return false
  return true

# Norma Euklidesowa
proc degree*[T](p: Poly[T]): int =
  if p.isZero(): -1 else: p.coeffs.len - 1

proc trim*[T](p: var Poly[T]) =
  while p.coeffs.len > 0 and isZero(p.coeffs[^1]):
    discard p.coeffs.pop()

# --- 2. PODSTAWOWA ARYTMETYKA ---
proc `+`*[T](a, b: Poly[T]): Poly[T] =
  let maxLen = max(a.coeffs.len, b.coeffs.len)
  var res = newSeq[T](maxLen)
  for i in 0..<maxLen:
    var ca: T
    var cb: T
    if i < a.coeffs.len: ca = a.coeffs[i]
    if i < b.coeffs.len: cb = b.coeffs[i]
    res[i] = ca + cb
  result = initPoly(res)

proc `-`*[T](a, b: Poly[T]): Poly[T] =
  let maxLen = max(a.coeffs.len, b.coeffs.len)
  var res = newSeq[T](maxLen)
  for i in 0..<maxLen:
    var ca: T
    var cb: T
    if i < a.coeffs.len: ca = a.coeffs[i]
    if i < b.coeffs.len: cb = b.coeffs[i]
    res[i] = ca - cb
  result = initPoly(res)

# proc `*`*[T](a, b: Poly[T]): Poly[T] =
#   if a.isZero() or b.isZero(): return initPoly(newSeq[T](0))
#   var res = newSeq[T](a.degree() + b.degree() + 1)
#   for i in 0..a.degree():
#     for j in 0..b.degree():
#       res[i+j] = res[i+j] + a.coeffs[i] * b.coeffs[j]
#   result = initPoly(res)

proc `*`*[T](a, b: Poly[T]): Poly[T] =
  if a.isZero() or b.isZero(): return
  let resLen = a.coeffs.len + b.coeffs.len - 1
  result.coeffs.setLen(resLen)
  for i in 0 ..< a.coeffs.len:
    for j in 0 ..< b.coeffs.len:
      result.coeffs[i+j] = result.coeffs[i+j] + (a.coeffs[i] * b.coeffs[j])
  trim(result)

proc `*`*[T](a: Poly[T], scalar: T): Poly[T] =
  result = initPoly(a.coeffs.mapIt(it * scalar))

# --- 3. DZIELENIE, NWD, NWW, EXT-NWD ---
proc divMod*[T](n, d: Poly[T]): tuple[q, r: Poly[T]] =
  if d.isZero(): raise newException(ValueError, "Dzielenie przez wielomian zerowy!")
  var q = initPoly(newSeq[T](0))
  var r = n
  while r.degree() >= d.degree() and not r.isZero():
    let degDiff = r.degree() - d.degree()
    let leadRatio = r.coeffs[^1] / d.coeffs[^1]

    var stepCoeffs = newSeq[T](degDiff + 1)
    stepCoeffs[degDiff] = leadRatio
    let stepPoly = initPoly(stepCoeffs)

    q = q + stepPoly
    r = r - (d * stepPoly)
  return (q, r)

proc normalize*[T](p: Poly[T]): Poly[T] =
  if p.isZero(): return p
  let invLead = 1.T / p.coeffs[^1]
  result = initPoly(p.coeffs.mapIt(it * invLead))

proc gcd*[T](a, b: Poly[T]): Poly[T] =
  var (aa, bb) = (a, b)
  while not bb.isZero():
    let (_, r) = divMod(aa, bb)
    aa = bb
    bb = r
  return aa.normalize()

proc lcm*[T](a, b: Poly[T]): Poly[T] =
  if a.isZero() or b.isZero(): return initPoly(newSeq[T](0))
  let (q, _) = divMod(a * b, gcd(a, b))
  return q.normalize()

proc extGcd*[T](a, b: Poly[T]): tuple[g, s, t: Poly[T]] =
  var 
    old_r = a
    r = b
    old_s = initPoly([1.T])
    s = initPoly(newSeq[T](0))
    old_t = initPoly(newSeq[T](0))
    t = initPoly([1.T])

  while not r.isZero():
    let (quot, rem) = divMod(old_r, r)
    old_r = r
    r = rem

    let temp_s = old_s - (quot * s)
    old_s = s
    s = temp_s

    let temp_t = old_t - (quot * t)
    old_t = t
    t = temp_t

  let inv = 1.T / old_r.coeffs[^1]
  return (old_r * inv, old_s * inv, old_t * inv)

# Funkcja pomocnicza do ładnego drukowania
proc `$`*[T](p: Poly[T]): string =
  return $p.coeffs
  # if p.isZero(): return "0"
  # var terms: seq[string] = @[]
  # for i in countdown(p.degree(), 0):
  #   let c = p.coeffs[i]
  #   if abs(c) > 1e-9:
  #     var term = ""
  #     if i < p.degree() and c > 0: term &= "+ "
  #     elif c < 0: term &= "- "
  #     let absC = abs(c)
  #     if absC != 1.0 or i == 0: term &= fmt"{absC:.2f}"
  #     if i > 0:
  #       if i == 1: term &= "x"
  #       else: term &= fmt"x^{i}"
  #     terms.add(term.strip())
  # result = terms.join(" ")
  # if result.startsWith("+ "): result = result[2..^1]

proc eval*[T](p: Poly[T], x: T): T =
  result = 0.T
  var xPow = 1.T
  for c in p.coeffs:
    result += c * xPow
    xPow *= x

# Metoda bisekcji do znajdowania pierwiastka rzeczywistego w przedziale [startA, startB]
proc findRealRoot*(p: Poly[float], startA, startB: float): float =
  var a = startA
  var b = startB
  for _ in 0 ..< 100: # 100 iteracji gwarantuje wysoką precyzję zmiennoprzecinkową
    let mid = (a + b) / 2.0
    if p.eval(mid) * p.eval(a) > 0:
      a = mid
    else:
      b = mid
  return (a + b) / 2.0

when isMainModule:
  echo "--- CZESC A ---"
  # P(x) = 3x^2 + 8
  let P = initPoly([8.0, 0.0, 3.0])
  # D(x) = x + 1
  let D = initPoly([1.0, 1.0])

  echo "P(x) = ", P
  echo "Norma P(x) = ", P.degree()

  let (quot, rem) = divMod(P, D)
  echo "Wynik dzielenia przez (x + 1): ", quot
  echo "Reszta z dzielenia: ", rem
  echo ""

  echo "--- CZESC B ---"
  let v = initPoly([9.0, 3.0, 8.0, 2.0])
  let w = initPoly([0.0, 1.0, 6.0, 9.0])

  echo "v(x) = ", v
  echo "w(x) = ", w

  var (nwd, s, t) = extGcd(v, w)
  echo "\nRozszerzony algorytm NWD dla (v(x), w(x)):"
  echo "NWD: ", nwd
  echo "wsp. s: ", s
  echo "wsp. t: ", t

  let g = w.eval(findRealRoot(v, -4.0, -3.0))
  echo "g = ", g
  let gPoly = initPoly([g])

  let wg = w - gPoly
  echo "w(x) - g = ", wg

  (nwd, s, t) = extGcd(v, wg)
  echo "\nRozszerzony algorytm NWD dla (v(x), w(x) - g):"
  echo "NWD: ", nwd
  echo "wsp. s: ", s
  echo "wsp. t: ", t

  let nww = lcm(v, wg)
  echo "NWW dla (v(x), w(x) + g): ", nww
