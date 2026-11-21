include("Roots.jl")
using .Roots
using Printf

f = x -> sin(x) - (x / 2)^2
pf = x -> cos(x) - x / 2

delta = epsilon = 0.5e-5
maxit = 100

exact = 1.9337537628270213

methods = [
    ("Bisekcja", mbisekcji(f, 1.5, 2.0, delta, epsilon, maxit)),
    ("Newton", mstycznych(f, pf, 1.5, delta, epsilon, maxit)),
    ("Sieczne", msiecznych(f, 1.0, 2.0, delta, epsilon, maxit))
]

@printf("%-12s %-20s %-15s %-8s %-15s\n",
        "Metoda", "r", "f(r)", "Iteracje", "|r - exact|")

for (name, (r, v, it, err)) in methods
    @printf("%-12s %-20.15f %-15.6e %-8d %-15.6e\n",
            name, r, v, it, abs(r - exact))
end
