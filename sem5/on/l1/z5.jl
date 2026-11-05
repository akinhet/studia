# Piotr Zieniewicz 283961
using Printf

"Calculate sqrt(x^2 + 1) - 1"
function f(x::Float64)
	a = x*x
	b = sqrt(a + 1)
	return b - 1
end

"Calculate x^2 / (sqrt(x^2 + 1) + 1)"
function g(x::Float64)
	a = x*x
	b = sqrt(a + 1)
	c = b + 1
	return a / c
end

for i in reverse(-13:-1)
	# @printf("8^%d: \n\tf: %.25f\n\tg: %.25f\n", i, f(8.0^i), g(8.0^i))
	@printf("8^%d: \n\tf: %.25e\n\tg: %.25e\n", i, f(8.0^i), g(8.0^i))
end
