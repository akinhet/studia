using Polynomials
using Printf

# Dokładne współczynniki wielomianu Wilkinsona
Pbig = fromroots(BigInt.(1:20))

# Postać naturalna w Float64
P = Polynomial(Float64.(coeffs(Pbig)))

# Postać iloczynowa
function p(x)
    prod(x - k for k in 1:20)
end

# Wypisywanie wyników eksperymentu
function test(P)
    z = sort(roots(P), by=real)

    @printf("%2s %24s %14s %14s %14s\n",
            "k", "z_k", "|P(z_k)|", "|p(z_k)|", "|z_k-k|")

    for k in 1:20
        zk = z[k]

        @printf("%2d %11.6f%+11.6fi %14.6e %14.6e %14.6e\n",
                k, real(zk), imag(zk),
                abs(P(zk)), abs(p(zk)), abs(zk - k))
    end
end

println("Wielomian Wilkinsona:")
test(P)

# Zmiana współczynnika przy x^19
a = copy(coeffs(P))
a[20] -= 2.0^(-23)

Q = Polynomial(a)

println("\nPo zmianie współczynnika przy x^19:")
test(Q)
