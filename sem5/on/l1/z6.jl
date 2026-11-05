# Piotr Zieniewicz 283961
using Printf

"Calculate f(x) = sin x + cos 3x"
function f(x::Float64)
	return sin(x) + cos(3*x)
end

"Approximate f'(x) up to parameter h"
function fprimeapprox(x::Float64, h::Float64)
	return (f(x + h) - f(x)) / h
end

"Calculate the exact f'(x)"
function fprime(x::Float64)
	return cos(x) - 3 * sin(3*x)
end

x0::Float64 = 1.0
println(" n |             h              |           h + 1            |           f'(x0)           |          ~f'(x0)           |            diff            ")
println("----------------------------------------------------------------------------------------------------------------------------------------------------")
for i in 0:54
	h::Float64 = 2.0^(-i)
	@printf("%02d | %.24f | %.24f | %.24f | %.24f | %.24f\n", i, h, h + 1, fprime(x0), fprimeapprox(x0, h), abs(fprime(x0) - fprimeapprox(x0, h)))
end


# plot generation section
using Plots

n = 0:54
h = 2.0 .^ (-n)
err = [abs(fprime(1.0) - fprimeapprox(1.0, hi)) for hi in h]

# Określamy dokłanie gdzie mają pojawić się podziałki na osi Y
yticks_val = [10.0^k for k in -10:2:0]  # np. 10^-10, 10^-8, ..., 10^0
yticks_str = ["10^$k" for k in -10:2:0]

plot(
    n, err,
    yscale = :log10,
    yticks = (yticks_val, yticks_str), # nakładamy własne etykiety
    xlabel = "n (h = 2^-n)",
    ylabel = "Błąd bezwzględny",
    label = "Błąd numeryczny",
    legend = :bottomleft
)

savefig("zad6_wykres.svg")
