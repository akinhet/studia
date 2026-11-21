include("Roots.jl")
using .Roots
using Printf

f1 = x -> exp(1 - x) - 1
pf1 = x -> -exp(1 - x)

f2 = x -> x * exp(-x)
pf2 = x -> (1 - x) * exp(-x)

delta = epsilon = 1e-5
maxit = 100

function printresult(name, result, exact)
    r, v, it, err = result
    @printf("%-22s r=%-15.10f it=%-4d err=%d |r-exact|=%.6e\n",
            name, r, it, err, abs(r - exact))
end

println("Podstawowe obliczenia:")
printresult("f1 Newton",
    mstycznych(f1, pf1, 0.5, delta, epsilon, maxit), 1.0)
printresult("f1 Sieczne",
    msiecznych(f1, 0.0, 2.0, delta, epsilon, maxit), 1.0)

printresult("f2 Newton",
    mstycznych(f2, pf2, 0.5, delta, epsilon, maxit), 0.0)
printresult("f2 Sieczne",
    msiecznych(f2, -0.5, 0.5, delta, epsilon, maxit), 0.0)

println("\na) f1, Newton dla x0 > 1:")
for x0 in [1.1, 1.5, 2.0, 3.0, 4.0, 5.0]
    printresult("x0=$x0",
        mstycznych(f1, pf1, x0, delta, epsilon, maxit), 1.0)
end

println("\nb) f2, Newton dla x0 >= 1:")
for x0 in [1.0, 1.1, 1.5, 2.0, 3.0]
    printresult("x0=$x0",
        mstycznych(f2, pf2, x0, delta, epsilon, maxit), 0.0)
end
