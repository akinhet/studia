using Printf

function logistic(T, truncate=false)
    p = T(0.01)
    r = T(3)

    results = T[p]

    for i in 1:40
        p = p + r * p * (1 - p)

        # Po 10 iteracjach obcinamy do 3 miejsc
        if truncate && i == 10
            p = trunc(p, digits=3)
        end

        push!(results, p)
    end

    return results
end

# Eksperyment 1
a = logistic(Float32)
b = logistic(Float32, true)

println("Eksperyment 1:")
println(" n       Float32       Float32 obcięty")

for i in 0:40
    @printf("%2d  %14.8f  %14.8f\n",
            i, a[i+1], b[i+1])
end

# Eksperyment 2
c = logistic(Float64)

println("\nEksperyment 2:")
println(" n       Float32          Float64")

for i in 0:40
    @printf("%2d  %14.8f  %14.8f\n",
            i, a[i+1], c[i+1])
end

using Plots

plot(0:40, a, label="Float32", lw=2)
plot!(0:40, b, label="Float32 obcięty", lw=2)
plot!(0:40, c, label="Float64", lw=2)

xlabel!("Numer iteracji")
ylabel!("pₙ")

display(current())
readline()
