using Printf
using Plots

function iterate(c, x0, n=40)
    x = zeros(Float64, n + 1)
    x[1] = x0

    for i in 1:n
        x[i+1] = x[i]^2 + c
    end

    return x
end

cases = [
    (-2.0, 1.0),
    (-2.0, 2.0),
    (-2.0, 1.99999999999999),
    (-1.0, 1.0),
    (-1.0, -1.0),
    (-1.0, 0.75),
    (-1.0, 0.25)
]

results = [iterate(c, x0) for (c, x0) in cases]

# Wypisanie wszystkich iteracji
for (i, (c, x0)) in enumerate(cases)
    println("\nc = $c, x0 = $x0")
    for n in 0:40
        @printf("%2d  %.16f\n", n, results[i][n+1])
    end
end

# Wykres dla c = -2
p1 = plot(title="c = -2", xlabel="n", ylabel="xₙ")

for i in 1:3
    plot!(p1, 0:40, results[i], label="x0=$(cases[i][2])")
end

# Wykres dla c = -1
p2 = plot(title="c = -1", xlabel="n", ylabel="xₙ")

for i in 4:7
    plot!(p2, 0:40, results[i], label="x0=$(cases[i][2])")
end

savefig(p1, "c_minus_2.png")
savefig(p2, "c_minus_1.png")

display(plot(p1, p2, layout=(2, 1), size=(900, 700)))
readline()
