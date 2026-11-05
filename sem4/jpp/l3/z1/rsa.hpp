#include <random>
#include <numeric>
#include "ring.hpp"

template <typename T>
class RSA {
private:
	unsigned n;
	T public_key;
	T private_key;

	unsigned modInverse(unsigned a, unsigned m) {
		int m0 = m, t, q;
		int x0 = 0, x1 = 1;
		if (m == 1)
			return 0;
		while (a > 1) {
			q = a / m;
			t = m;
			m = a % m;
			a = t;
			t = x0;
			x0 = x1 - q * x0;
			x1 = t;
		}
		if (x1 < 0)
			x1 += m0;
		return (unsigned) x1;
	}

	T power(T base, T exp) {
		T result(1);
		int e = (int) exp;
		while (e > 0) {
			if (e % 2 == 1)
				result *= base;
			base *= base;
			e /= 2;
		}
		return result;
	}

public:
	RSA(unsigned p, unsigned q) {
		n = p * q;
		unsigned phi = (p - 1) * (q - 1);

		std::random_device rd;
		std::mt19937 engine(rd());
		std::uniform_int_distribution<unsigned> dist(2, phi - 1);

		unsigned e;
		do {
			e = dist(engine);
		} while (std::gcd(e, phi) != 1);

		public_key = T(e);
		private_key = modInverse(e, phi);
	}

	unsigned getModulo() const {
		return n;
	}

	T getPublicKey() const {
		return public_key;
	}

	T encrypt(T m) {
		return power(m, public_key);
	}

	T decrypt(T s) {
		return power(s, private_key);
	}
};
