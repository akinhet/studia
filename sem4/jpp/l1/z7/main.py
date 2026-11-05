import ctypes
import os

class DiophantineSolution(ctypes.Structure):
    _fields = [
            ("x", ctypes.c_uint32),
            ("y", ctypes.c_uint32),
            ]

clib = ctypes.CDLL("../z1/libgcdlib.so")
adalib = ctypes.CDLL("../z2/libgcdlib.so")
rustlib = ctypes.CDLL("../z3/target/release/libgcdlib.so")

clib.gcd.argtypes = [ctypes.c_uint32, ctypes.c_uint32]
clib.gcd.restype = ctypes.c_uint32

clib.smallest_prime_factor.argtypes = [ctypes.c_uint32]
clib.smallest_prime_factor.restype = ctypes.c_uint32

clib.euler_totient.argtypes = [ctypes.c_uint32]
clib.euler_totient.restype = ctypes.c_uint32

clib.diophantes.argtypes = [ctypes.c_uint32, ctypes.c_uint32, ctypes.c_uint32]
clib.diophantes.restype = DiophantineSolution


adalib.gcd.argtypes = [ctypes.c_uint32, ctypes.c_uint32]
adalib.gcd.restype = ctypes.c_uint32

adalib.smallest_prime_factor.argtypes = [ctypes.c_uint32]
adalib.smallest_prime_factor.restype = ctypes.c_uint32

adalib.euler_totient.argtypes = [ctypes.c_uint32]
adalib.euler_totient.restype = ctypes.c_uint32

adalib.diophantes.argtypes = [ctypes.c_uint32, ctypes.c_uint32, ctypes.c_uint32]
adalib.diophantes.restype = DiophantineSolution


rustlib.gcd.argtypes = [ctypes.c_uint32, ctypes.c_uint32]
rustlib.gcd.restype = ctypes.c_uint32

rustlib.smallest_prime_factor.argtypes = [ctypes.c_uint32]
rustlib.smallest_prime_factor.restype = ctypes.c_uint32

rustlib.euler_totient.argtypes = [ctypes.c_uint32]
rustlib.euler_totient.restype = ctypes.c_uint32

rustlib.diophantes.argtypes = [ctypes.c_uint32, ctypes.c_uint32, ctypes.c_uint32]
rustlib.diophantes.restype = DiophantineSolution


a = adalib.euler_totient(10)
print(a)
