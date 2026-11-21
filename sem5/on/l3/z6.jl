using Printf

f = x -> (x - 1)^3 * cos(x)
pf = x -> 3(x - 1)^2 * cos(x) - (x - 1)^3 * sin(x)

r = 1.0
x0 = 1.2
m = 3

function newton(f, pf, x0, m, iterations)
    xs = [x0]

    for _ in 1:iterations
        x = xs[end]
        d = pf(x)

        d == 0 && break

        xn = x - m * f(x) / d
        push!(xs, xn)

        xn == x && break
    end

    return xs
end

function print_ratios(name, xs, r, p)
    println("\n", name)

    @printf("%-4s %-18s %-15s %-15s\n",
            "n", "x_n", "|e_n|", "Iloraz")

    for i in eachindex(xs)
        e = abs(xs[i] - r)

        if i == 1
            @printf("%-4d %-18.12f %-15.6e\n",
                    i - 1, xs[i], e)
        else
            prev = abs(xs[i - 1] - r)
            ratio = prev == 0 ? NaN : e / prev^p

            @printf("%-4d %-18.12f %-15.6e %-15.6e\n",
                    i - 1, xs[i], e, ratio)
        end
    end
end

classic = newton(f, pf, x0, 1, 15)
modified = newton(f, pf, x0, m, 5)

print_ratios("Newton klasyczny", classic, r, 1)
print_ratios("Newton zmodyfikowany", modified, r, 2)

C = 1 - 1/m
Cmod = abs(-sin(r) / (m * cos(r)))

@printf("\nC = %.10f\n", C)
@printf("Cmod = %.10f\n", Cmod)
