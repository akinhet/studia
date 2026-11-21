module Roots

export mbisekcji, mstycznych, msiecznych

function mbisekcji(f, a::Float64, b::Float64, delta::Float64, epsilon::Float64, maxit::Int)

    fa = f(a)
    fb = f(b)

    if abs(fa) <= epsilon
        return (a, fa, 0, 0)
    end

    if abs(fb) <= epsilon
        return (b, fb, 0, 0)
    end

    if signbit(fa) == signbit(fb)
        return (a, fa, 0, 2)
    end

    r = a
    fr = fa

    for it in 1:maxit
        r = a + (b - a) / 2
        fr = f(r)

        if abs(fr) <= epsilon || abs(b - a) <= delta
            return (r, fr, it, 0)
        end

        if signbit(fa) != signbit(fr)
            b = r
        else
            a = r
            fa = fr
        end
    end

    return (r, fr, maxit, 1)
end


function mstycznych(f, pf, x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)

    fx = f(x0)

    if abs(fx) <= epsilon
        return (x0, fx, 0, 0)
    end

    for it in 1:maxit
        d = pf(x0)

        if abs(d) <= 1e-14
            return (x0, fx, it - 1, 2)
        end

        x1 = x0 - fx / d
        fx1 = f(x1)

        if abs(x1 - x0) <= delta || abs(fx1) <= epsilon
            return (x1, fx1, it, 0)
        end

        x0 = x1
        fx = fx1
    end

    return (x0, fx, maxit, 1)
end


function msiecznych(f, x0::Float64, x1::Float64, delta::Float64, epsilon::Float64, maxit::Int)

    f0 = f(x0)
    f1 = f(x1)

    if abs(f0) <= epsilon
        return (x0, f0, 0, 0)
    end

    if abs(f1) <= epsilon
        return (x1, f1, 0, 0)
    end

    for it in 1:maxit
        d = f1 - f0

        if abs(d) <= 1e-14
            return (x1, f1, it - 1, 2)
        end

        x2 = x1 - f1 * (x1 - x0) / d
        f2 = f(x2)

        if abs(x2 - x1) <= delta || abs(f2) <= epsilon
            return (x2, f2, it, 0)
        end

        x0, x1 = x1, x2
        f0, f1 = f1, f2
    end

    return (x1, f1, maxit, 1)
end

end
