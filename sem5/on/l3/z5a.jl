include("Roots.jl")
using .Roots
using Printf

f = x -> x - 1e8 - pi

r, v, it, err = mbisekcji(
    f, 99999999.0, 100000005.0,
    1e-13, 1e-13, 100
)

setprecision(BigFloat, 256) do
    exact = BigFloat(10)^8 + big(pi)
    error = abs(exact - BigFloat(r))

    println("r = ", r)
    println("f(r) = ", v)
    println("Iteracje = ", it)
    println("err = ", err)
    println("Blad rzeczywisty = ", error)
    println("delta = ", big"1e-13")
    println("Blad <= delta: ", error <= big"1e-13")
    println("Odleglosc Float64 = ", eps(r))
end
