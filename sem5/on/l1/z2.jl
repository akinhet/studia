# Piotr Zieniewicz 283961
using Printf

"Find the minimum step in the interval [a, b]"
function check_interval(a::Float64, b::Float64)
    delta = nextfloat(a) - a

    println("Przedział [$a, $b]")
    println("Krok delta = $delta")
    println("Krok jako potęga 2: 2^$(Int(log2(delta)))")

    for k in 0:3
        x = a + k * delta
        @printf("%.17f: %s\n", x, bitstring(x))
    end

    println()
end

check_interval(0.5, 1.0)
check_interval(1.0, 2.0)
check_interval(2.0, 4.0)
