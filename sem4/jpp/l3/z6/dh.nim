import std/[math, random]
import "ring"

type
  DHSetup*[N: static[int]] = object
    generator: Ring[N]

proc power*[N](a: Ring[N], b: int): Ring[N] =
  result = toRing(N, 1)
  var
    base = a
    exp = b

  while exp > 0:
    if (exp and 1) == 1:
      result = result * base

    base = base * base
    exp = exp shr 1

proc isGenerator[N: static[int]](g: Ring[N], phi: int): bool =
  if g <= toRing(N,1): return false

  let candidate = g

  var nPhi = phi
  var divisor = 2

  while divisor * divisor <= nPhi:
    if nPhi mod divisor == 0:
      if power(candidate, phi div divisor) == toRing(N, 1):
        return false
      while nPhi mod divisor == 0:
        nPhi = nPhi div divisor
    divisor.inc

  if nPhi > 1:
    if power(candidate, phi div nPhi) == toRing(N,1):
      return false

  return true

proc initDHSetup*[N: static[int]](): DHSetup[N] =
  randomize()

  let phi = N - 1
  var gVal: system.int
  var candidate: Ring[N]

  while true:
    gVal = rand(2 .. N - 1)
    candidate = toRing(N, gVal)

    if isGenerator(candidate, phi):
      break

  result = DHSetup[N](
    generator: candidate
  )

proc getGenerator*[N](dh: DHSetup[N]): Ring[N] =
  dh.generator


type
  User*[N: static[int]] = object
    dh: DHSetup[N]
    secret: int
    encryptionKey: Ring[N]
    hasKey: bool

proc initUser*[N](dh: DHSetup[N]): User[N] =
  randomize()

  User[N](
    dh: dh,
    secret: rand(2 .. 100000),
    hasKey: false
  )

proc getPublicKey*[N](u: User[N]): Ring[N] =
  power(u.dh.getGenerator(), u.secret)

proc setKey*[N](u: var User[N], a: Ring[N]) =
  u.encryptionKey = power(a, u.secret)
  u.hasKey = true

proc encrypt*[N](u: User[N], m: Ring[N]): Ring[N] =
  if not u.hasKey:
    raise newException(ValueError, "Encryption key not set")

  m * u.encryptionKey

proc decrypt*[N](u: User[N], c: Ring[N]): Ring[N] =
  if not u.hasKey:
    raise newException(ValueError, "Encryption key not set")

  c / u.encryptionKey


when isMainModule:

  const MODULO = 1234567891

  type F = Ring[MODULO]

  let dh = initDHSetup[MODULO]()

  echo "Generator: ", dh.getGenerator()

  var alice = initUser(dh)
  var bob = initUser(dh)

  let alicePub = alice.getPublicKey()
  let bobPub = bob.getPublicKey()

  echo "Alice public key: ", alicePub
  echo "Bob public key: ", bobPub

  alice.setKey(bobPub)
  bob.setKey(alicePub)

  let message = toRing(MODULO, 123456)

  echo "\nOriginal: ", message

  let encrypted = alice.encrypt(message)

  echo "Encrypted: ", encrypted

  let decrypted = bob.decrypt(encrypted)

  echo "Decrypted: ", decrypted

  echo "\nOK: ", decrypted == message
