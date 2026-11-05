import std/[random, math]
import "ring"

type
  RSA*[N: static[int]] = object
    publicKey: int
    privateKey: int

proc modPow[N](base: Ring[N], exp: int): Ring[N] =
  result = toRing(N, 1)
  var
    b = base
    e = exp

  while e > 0:
    if (e and 1) == 1:
      result = result * b

    b = b * b
    e = e shr 1

proc generateE(phi: int): int =
  randomize()
  while true:
    let e = rand(2 .. phi - 1)
    if gcd(e, phi) == 1:
      return e

proc initRSA*[P, Q: static[int]](): RSA[P * Q] =
  const
    n = P * Q
    phi = (P - 1) * (Q - 1)

  let e = generateE(phi)
  let d = inverse(e, phi)

  RSA[n](
    publicKey: e,
    privateKey: d
  )

proc getModulo*[N](rsa: RSA[N]): uint =
  N.uint

proc getPublicKey*[N](rsa: RSA[N]): int =
  rsa.publicKey

proc encrypt*[N](rsa: RSA[N], m: Ring[N]): Ring[N] =
  modPow(m, rsa.publicKey)

proc decrypt*[N](rsa: RSA[N], s: Ring[N]): Ring[N] =
  modPow(s, rsa.privateKey)


when isMainModule:
  let rsa = initRSA[10007, 10009]()

  echo "Modulo n = ", rsa.getModulo()
  echo "Public key e = ", rsa.getPublicKey()

  let message = toRing(10007 * 10009, 123456)

  echo "Original message: ", message

  let encrypted = rsa.encrypt(message)
  echo "Encrypted: ", encrypted

  let decrypted = rsa.decrypt(encrypted)
  echo "Decrypted: ", decrypted

  echo "OK: ", decrypted == message
