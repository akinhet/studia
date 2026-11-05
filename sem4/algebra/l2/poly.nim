import "../l1/z2/poly.nim"

proc totalDegree*[T: not Poly](p: Poly[T]): int =
  return p.degree()

proc totalDegree*[T: Poly](p: Poly[T]): int =
  if p.isZero(): return -1

  let degX = p.degree()
  let innerPoly = p.coeffs[degX]
  let degY = innerPoly.totalDegree()

  return degX + degY

proc `<`*[T](a, b: Poly[T]): bool = # lex
  if a.isZero():
    return true
  if b.isZero():
    return false

  if a.degree() != b.degree:
    return a.degree() < b.degree()
  else:
    for i in countdown(a.degree(), 0):
      if a.coeffs[i] != b.coeffs[i]:
        return a.coeffs[i] < b.coeffs[i]
    return false

proc grlex*[T](a, b: Poly[T]): bool = # grlex
  if a.isZero(): return true
  if b.isZero(): return false

  let totalDegA = a.totalDegree()
  let totalDegB = b.totalDegree()

  if totalDegA != totalDegB:
    return totalDegA < totalDegB
  else:
    return a < b

proc `==`*[T](a, b: Poly[T]): bool =
  return a.coeffs == b.coeffs

proc `>`*[T](a, b: Poly[T]): bool =
  return not ( a == b ) and not ( a < b )

proc leadingMonomial[T](p: Poly[T]): seq[int] =
  for i in countdown(p.coeffs.high, 0):
    let c = p.coeffs[i]

    when c is Poly:
      if not isZero(c):
        return @[i] & leadingMonomial(c)
    else:
      if c != 0:
        return @[i]
  return @[]

proc leadingTerm*[T](p: Poly[T]): Poly[T] =
  var np = p
  trim(np)
  if p.isZero(): return p
  let idx = p.coeffs.high
  result.coeffs.setLen(idx + 1)
  when T is Poly:
    result.coeffs[idx] = leadingTerm(p.coeffs[idx])
  else:
    result.coeffs[idx] = p.coeffs[idx]

proc divMonomials[T](a, b: Poly[T]): Poly[T] =
  let degA = a.coeffs.high
  let degB = b.coeffs.high
  let degRes = degA - degB
  result.coeffs.setLen(degRes + 1)
  when T is Poly:
    result.coeffs[degRes] = divMonomials(a.coeffs[degA], b.coeffs[degB])
  else:
    when T is SomeInteger:
      result.coeffs[degRes] = a.coeffs[degA] div b.coeffs[degB]
    else:
      result.coeffs[degRes] = a.coeffs[degA] / b.coeffs[degB]

proc divides(lmG, lmP: seq[int]): bool =
  if lmG.len > lmP.len: return false
  for i in 0 ..< lmG.len:
    if lmG[i] > lmP[i]: return false
  return true

proc polynomialReduce*[T](f: Poly[T], G: seq[Poly[T]]): (seq[Poly[T]], Poly[T]) =
  let n = G.len

  var alpha = newSeq[Poly[T]](n)
  var r = initPoly(newSeq[T](0))
  var p = f

  while not p.isZero():
    let ltP = p.leadingTerm()
    let lmP = p.leadingMonomial()

    var reduced = false

    for i in 0..<n:
      if G[i].isZero():
        continue

      let lmG = G[i].leadingMonomial()
      if divides(lmG, lmP):
        let ltG = G[i].leadingTerm()
        let q = divMonomials(ltP, ltG)

        alpha[i] = alpha[i] + q
        p = p - q * G[i]

        reduced = true
        break

    if not reduced:
      r = r + ltP
      p = p - ltP

  return (alpha, r)

when isMainModule:
  let a = initPoly([initPoly([0]), initPoly([0]), initPoly([0]), initPoly([1])]) # x^3
  let b = initPoly([initPoly([0]), initPoly([0, 0, 0, 0, 1])]) # y^2

  echo a < b
  echo a > b
  echo grlex(a, b)
  echo grlex(b, a)
  echo a == a
  echo a == b

  echo leadingMonomial(a)
  echo leadingMonomial(b)
  let f = initPoly([initPoly([0]), initPoly([0]), initPoly([0]), initPoly([1])])

  # Definiujemy ciąg G zawierający jeden wielomian g1 = x^2
  let g1 = initPoly([initPoly([0]), initPoly([0]), initPoly([1])])
  let G = @[g1]

  let (alphas, reszta) = polynomialReduce(f, G)

  echo "Iloraz alpha_1 (powinien być x): ", alphas[0].coeffs
  echo "Reszta r (powinna być 0): ", reszta.coeffs
