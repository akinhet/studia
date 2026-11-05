#include <iostream>
#include <stdexcept>


template <int n>
class Ring {
	static_assert(n > 0, "Modulo n must be positive.");

private:
	int value;


	static int normalize(int v) {
		v %= n;
		if (v < 0) v += n;
		return v;
	}


	static int inverse(int a) {
		int m0 = n, t, q;
		int x0 = 0, x1 = 1;

		if (n == 1) return 0;

		while (a > 1) {
			if (m0 == 0) break; 
			q = a / m0;
			t = m0;
			m0 = a % m0;
			a = t;
			t = x0;
			x0 = x1 - q * x0;
			x1 = t;
		}

		if (a != 1) 
			throw std::runtime_error("Inverse modulo does not exist (elements are not coprime).");

		if (x1 < 0) x1 += n;
		return x1;
	}


public:
	Ring(int v = 0) : value(normalize(v)) {}
	
	explicit operator int() const { return value; }

	Ring& operator+=(const Ring& rhs) { value = (value + rhs.value) % n; return *this; }
	Ring& operator-=(const Ring& rhs) { value = (value - rhs.value + n) % n; return *this; }
	Ring& operator*=(const Ring& rhs) { value = (value * rhs.value) % n; return *this; }
	Ring& operator/=(const Ring& rhs) {
		value = (value * inverse(rhs.value)) % n;
		return *this;
	}

	friend Ring operator+(Ring lhs, const Ring& rhs) { lhs += rhs; return lhs; }
	friend Ring operator-(Ring lhs, const Ring& rhs) { lhs -= rhs; return lhs; }
	friend Ring operator*(Ring lhs, const Ring& rhs) { lhs *= rhs; return lhs; }
	friend Ring operator/(Ring lhs, const Ring& rhs) { lhs /= rhs; return lhs; }

	bool operator==(const Ring& rhs) const { return value == rhs.value; }
	bool operator!=(const Ring& rhs) const { return !(*this == rhs); }
	bool operator<(const Ring& rhs) const { return value < rhs.value; }
	bool operator>(const Ring& rhs) const { return rhs < *this; }
	bool operator<=(const Ring& rhs) const { return !(*this > rhs); }
	bool operator>=(const Ring& rhs) const { return !(*this < rhs); }


	friend std::ostream& operator<<(std::ostream& os, const Ring& r) {
		return os << r.value;
	}


	friend std::istream& operator>>(std::istream& is, Ring& r) {
		int v;
		if (is >> v) r.value = normalize(v);
		return is;
	}
};
