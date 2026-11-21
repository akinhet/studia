using Plots
using Printf

gr()

default(
    size = (900, 550),
    dpi = 200,
    linewidth = 2,
    framestyle = :box,
    grid = true,
    legend = :best,
    guidefontsize = 12,
    tickfontsize = 10,
    legendfontsize = 9,
    titlefontsize = 13
)

mkpath("wykresy")

# Zwraca historię iteracji Newtona.
function newton_history(f, pf, x0, n)
    xs = [Float64(x0)]
    for _ in 1:n
        x = xs[end]
        d = pf(x)
        if !isfinite(d) || abs(d) < 1e-14
            break
        end

        xn = x - f(x) / d
        if !isfinite(xn)
            break
        end

        push!(xs, xn)
    end
    return xs
end

# Rysuje odcinki stycznych od (x_n, f(x_n)) do (x_(n+1), 0).
function draw_tangents!(p, f, xs; count=3)
    for i in 1:min(count, length(xs)-1)
        x0, x1 = xs[i], xs[i+1]
        plot!(p, [x0, x1], [f(x0), 0.0],
              color=:darkorange, linewidth=1.7,
              linestyle=:dash, label=i == 1 ? "Styczne Newtona" : "")

        scatter!(p, [x0], [f(x0)], color=:darkorange,
                 markersize=4, label="")
    end
end

# ===========================================
# ZADANIE 4a — f1(x) = exp(1-x) - 1
# ===========================================

f1(x) = exp(1-x) - 1
pf1(x) = -exp(1-x)

xs1 = newton_history(f1, pf1, 3.0, 8)

p1 = plot(
    f1, -3.0, 3.5,
    label="f₁(x) = exp(1-x) - 1",
    color=:royalblue,
    xlabel="x", ylabel="f₁(x)",
    title="Zadanie 4a — metoda Newtona, x₀ = 3",
    ylims=(-1.5, 7)
)

hline!(p1, [0], color=:black, linewidth=1, label="")
vline!(p1, [1], color=:gray, linestyle=:dot, label="Pierwiastek x = 1")

draw_tangents!(p1, f1, xs1; count=3)

scatter!(p1, xs1[1:4], zeros(4),
         color=:red, markersize=4,
         label="Kolejne przybliżenia")

for i in 1:4
    annotate!(p1, xs1[i], -0.35, text("x$(i-1)", 9, :red))
end

savefig(p1, "wykresy/zad4a.svg")
savefig(p1, "wykresy/zad4a.png")

# ===========================================
# ZADANIE 4b — f2(x) = x*exp(-x)
# ===========================================

f2(x) = x * exp(-x)
pf2(x) = (1-x) * exp(-x)

xs2 = newton_history(f2, pf2, 2.0, 6)

p2 = plot(
    f2, -0.5, 15.0,
    label="f₂(x) = x exp(-x)",
    color=:royalblue,
    xlabel="x", ylabel="f₂(x)",
    title="Zadanie 4b — metoda Newtona, x₀ = 2",
    ylims=(-0.1, 0.45)
)

hline!(p2, [0], color=:black, linewidth=1, label="")
vline!(p2, [1], color=:gray, linestyle=:dot, label="Maksimum x = 1")

scatter!(p2, [1], [exp(-1)],
         color=:green, markersize=6, label="Maksimum funkcji")

draw_tangents!(p2, f2, xs2; count=4)

scatter!(p2, xs2, zeros(length(xs2)),
         color=:red, markersize=4, label="Kolejne przybliżenia")

for i in 1:min(5, length(xs2))
    annotate!(p2, xs2[i], -0.035, text("x$(i-1)", 9, :red))
end

savefig(p2, "wykresy/zad4b.svg")
savefig(p2, "wykresy/zad4b.png")

# ===========================================
# ZADANIE 3 — przecięcia 3x i exp(x)
# ===========================================

r1 = 0.619061286735945
r2 = 1.51213455165784

p3 = plot(
    x -> 3x, 0.0, 2.0,
    label="y = 3x",
    color=:royalblue,
    xlabel="x", ylabel="y",
    title="Zadanie 3 — punkty przecięcia wykresów"
)

plot!(p3, exp, 0.0, 2.0,
      label="y = exp(x)", color=:darkorange)

scatter!(p3, [r1, r2], [3r1, 3r2],
         color=:red, markersize=6,
         label="Punkty przecięcia")

annotate!(p3, r1 + 0.13, 3r1 - 0.35,
          text("P₁ ≈ (0.6191, 1.8572)", 9, :red))

annotate!(p3, r2 - 0.27, 3r2 + 0.45,
          text("P₂ ≈ (1.5121, 4.5364)", 9, :red))

savefig(p3, "wykresy/zad3.svg")
savefig(p3, "wykresy/zad3.png")

println("Zapisano wykresy w katalogu wykresy/")
println("Historia Newtona f1: ", xs1)
println("Historia Newtona f2: ", xs2)
