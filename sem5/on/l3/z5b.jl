using Printf

f = x -> sin(x) - (x / 2)^2
pf = x -> cos(x) - x / 2

exact = 1.9337537628270213
delta = epsilon = 1e-7
maxit = 100

function bisekcja_history(f, a, b, delta, epsilon, maxit)
    xs = Float64[]
    fa = f(a)

    for _ in 1:maxit
        r = a + (b - a) / 2
        fr = f(r)
        push!(xs, r)

        if abs(b - a) <= delta || abs(fr) <= epsilon
            break
        end

        if signbit(fa) != signbit(fr)
            b = r
        else
            a = r
            fa = fr
        end
    end

    return xs
end

function newton_history(f, pf, x, delta, epsilon, maxit)
    xs = [x]

    for _ in 1:maxit
        d = pf(x)
        abs(d) <= 1e-14 && break

        xn = x - f(x) / d
        push!(xs, xn)

        if abs(xn - x) <= delta || abs(f(xn)) <= epsilon
            break
        end

        x = xn
    end

    return xs
end

function sieczne_history(f, x0, x1, delta, epsilon, maxit)
    xs = [x0, x1]

    for _ in 1:maxit
        f0, f1 = f(x0), f(x1)
        d = f1 - f0
        abs(d) <= 1e-14 && break

        x2 = x1 - f1 * (x1 - x0) / d
        push!(xs, x2)

        if abs(x2 - x1) <= delta || abs(f(x2)) <= epsilon
            break
        end

        x0, x1 = x1, x2
    end

    return xs
end

function print_ratios(name, xs, exact, p)
    errors = abs.(xs .- exact)

    println("\n", name)
    @printf("%-5s %-18s %-15s %-15s\n",
            "n", "x_n", "|e_n|", "Iloraz")

    for i in eachindex(xs)
        ratio = i == 1 || errors[i - 1] == 0 ?
                NaN : errors[i] / errors[i - 1]^p

        @printf("%-5d %-18.12f %-15.6e %-15.6e\n",
                i - 1, xs[i], errors[i], ratio)
    end
end

bis = bisekcja_history(f, 1.5, 2.0, delta, epsilon, maxit)
new = newton_history(f, pf, 1.5, delta, epsilon, maxit)
sec = sieczne_history(f, 1.0, 2.0, delta, epsilon, maxit)

print_ratios("Bisekcja", bis, exact, 1.0)
print_ratios("Newton", new, exact, 2.0)
print_ratios("Sieczne", sec, exact, (1 + sqrt(5)) / 2)
