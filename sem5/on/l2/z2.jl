function hilb(n::Int)
# Function generates the Hilbert matrix  A of size n,
#  A (i, j) = 1 / (i + j - 1)
# Inputs:
#	n: size of matrix A, n>=1
#
#
# Usage: hilb(10)
#
# Pawel Zielinski
        if n < 1
         error("size n should be >= 1")
        end
        return [1 / (i + j - 1) for i in 1:n, j in 1:n]
end

using LinearAlgebra

function matcond(n::Int, c::Float64)
# Function generates a random square matrix A of size n with
# a given condition number c.
# Inputs:
#	n: size of matrix A, n>1
#	c: condition of matrix A, c>= 1.0
#
# Usage: matcond(10, 100.0)
#
# Pawel Zielinski
        if n < 2
         error("size n should be > 1")
        end
        if c< 1.0
         error("condition number  c of a matrix  should be >= 1.0")
        end
        (U,S,V)=svd(rand(n,n))
        return U*diagm(0 =>[LinRange(1.0,c,n);])*V'
end

using LinearAlgebra
using Printf

function test(A)
    n = size(A, 1)

    # Dokładne rozwiązanie
    x = ones(n)

    # Wektor prawych stron
    b = A * x

    # Rozwiązania numeryczne
    x_gauss = A \ b
    x_inv = inv(A) * b

    # Błędy względne
    err_gauss = norm(x_gauss - x) / norm(x)
    err_inv = norm(x_inv - x) / norm(x)

    @printf("%3d  %12.4e  %4d  %12.4e  %12.4e\n",
            n, cond(A), rank(A), err_gauss, err_inv)
end

println("Macierze Hilberta:")
println("  n       cond(A)     rank     Gauss          inv(A)")

for n in 2:20
    test(hilb(n))
end

println("\nMacierze losowe:")
println("  n       cond(A)     rank     Gauss          inv(A)")

for n in [5, 10, 20]
    for c in [1, 10, 1e3, 1e7, 1e12, 1e16]
        test(matcond(n, c))
    end
end
