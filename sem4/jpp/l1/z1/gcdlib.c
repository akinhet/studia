#include "gcdlib.h"

typedef struct {
	int64_t x,y,c;
} egcd_result;


egcd_result egcd(int64_t a, int64_t b)
{
	int64_t prevx = 1,
		prevy = 0,
		x     = 0,
		y     = 1,
		a1    = a,
		b1    = b;

	while (b1 > 0) {
		int64_t q = a1 / b1;

		int64_t tmp = x;
		x = prevx - q*x;
		prevx = tmp;

		tmp = y;
		y = prevy - q*y;
		prevy = tmp;

		tmp = b1;
		b1 = a1 % b1;
		a1 = tmp;
	}

	egcd_result ret;
	ret.x = prevx;
	ret.y = prevy;
	ret.c = a1;

	return ret;
}


uint32_t gcd(uint32_t a, uint32_t b)
{
	egcd_result res = egcd(a, b);

	return res.c;
}


uint32_t smallest_prime_factor(uint32_t n)
{
	if (n % 2 == 0)
		return 2;

	for (uint32_t i = 3; i*i <= n; i += 2) {
		if (n % i == 0)
			return i;
	}

	return n;
}


uint32_t euler_totient(uint32_t n)
{
	uint32_t res = n;
	for (uint32_t i = 2; i*i <= n; i++) {
		if (n % i == 0) {
			while (n % i == 0)
				n /= i;
			res -= res / i;
		}
	}

	if (n > 1)
		res -= res / n;
	return res;
}


diophantes_result diophantes(uint32_t a, uint32_t b, uint32_t c)
{
	egcd_result gcd = egcd(a, b);

	if (c % gcd.c != 0) {
		return (diophantes_result){0,0};
	}

	int64_t mul = c / gcd.c;
	int64_t x = gcd.x * mul;

	int64_t stepx = b / gcd.c;
	int64_t stepy = a / gcd.c;

	x %= stepx;

	int64_t y = (a*x-c)/b;

	if (y<0) {
		y += stepy;
		x = (b*y +c) / a;
	}

	return (diophantes_result){x,y};
}
