include("Roots.jl")
using .Roots
using Printf

f = x -> 3x - exp(x)
pf = x -> 3 - exp(x)

delta = epsilon = 1e-4
maxit = 100

results = [
    ("Bisekcja", "1", mbisekcji(f, 0.5, 1.0, delta, epsilon, maxit)),
    ("Bisekcja", "2", mbisekcji(f, 1.0, 2.0, delta, epsilon, maxit)),
    ("Newton", "1", mstycznych(f, pf, 0.5, delta, epsilon, maxit)),
    ("Newton", "2", mstycznych(f, pf, 2.0, delta, epsilon, maxit))
]

@printf("%-12s %-5s %-15s %-15s %-10s %-5s\n",
        "Metoda", "Nr", "r", "f(r)", "Iteracje", "err")

for (method, nr, (r, v, it, err)) in results
    @printf("%-12s %-5s %-15.10f %-15.6e %-10d %-5d\n",
            method, nr, r, v, it, err)
end
