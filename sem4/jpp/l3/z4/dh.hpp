#include <random>
#include <stdexcept>

template <typename T, int N>
class DHSetup {
private:
	T generator;


	std::vector<unsigned long> getPrimeFactors(unsigned long m) const {
		std::vector<unsigned long> factors;
		for (unsigned long i = 2; i * i <= m; ++i) {
			if (m % i == 0) {
				factors.push_back(i);
				while (m % i == 0)
					m /= i;
			}
		}
		if (m > 1) factors.push_back(m);
		return factors;
	}


	bool isGenerator(T g, unsigned long phi, const std::vector<unsigned long>& factors) const {
		if (int(g) == 0 || int(g) == 1)
			return false;
		for (unsigned long q : factors) {
			if (power(g, phi / q) == T(1))
				return false;
		}
		return true;
	}

public:
	DHSetup() {
		unsigned long phi = N - 1;
		auto factors = getPrimeFactors(phi);

		std::random_device rd;
		std::mt19937 gen(rd());
		std::uniform_int_distribution<int> dist(2, N - 1);

		T candidate;
		do {
			candidate = T(dist(gen));
		} while (!isGenerator(candidate, phi, factors));
		
		generator = candidate;
	}


	T getGenerator() const { return generator; }


	T power(T a, unsigned long b) const {
		T result(1);
		T base = a;
		while (b > 0) {
			if (b % 2 == 1)
				result *= base;
			base *= base;
			b /= 2;
		}
		return result;
	}
};


template <typename T, int N>
class User {
private:
	const DHSetup<T, N>& setup;
	unsigned long secret;
	T encryptionKey;
	bool keySet;

public:
	User(const DHSetup<T, N>& s) : setup(s), encryptionKey(0), keySet(false) {
		std::random_device rd;
		std::mt19937 gen(rd());
		std::uniform_int_distribution<unsigned long> dist(100, N - 1);
		secret = dist(gen);
	}


	T getPublicKey() const {
		return setup.power(setup.getGenerator(), secret);
	}


	void setKey(T a) {
		encryptionKey = setup.power(a, secret);
		keySet = true;
	}


	T encrypt(T m) const {
		if (!keySet)
			throw std::runtime_error("Brak klucza! Wywolaj setKey().");
		return m * encryptionKey;
	}


	T decrypt(T c) const {
		if (!keySet)
			throw std::runtime_error("Brak klucza! Wywolaj setKey().");
		return c / encryptionKey;
	}
};
