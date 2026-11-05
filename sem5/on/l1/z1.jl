# Piotr Zieniewicz 283961

"Find machine epsilon of floating point type T using the iterative method."
function findmacheps(T)
	macheps = T(1)
	# divide macheps in half as long as its greater than 0
	while T(0.5) * macheps + T(1.0) > T(1.0)
		macheps *= T(0.5);
	end

	return macheps
end

"Find eta of floating point type T using the iterative method."
function findeta(T)
	eta = T(1)

	# divide eta in half as long as its greater than 0
	while T(0.5) * eta > T(0)
		eta *= T(0.5)
	end

	return eta
end

"Find maximum value of floating point type T using the iterative method."
function findmax(T)
	max = T(1)
	step = T(1)

	# find the biggest power of 2 representable in T
	while !isinf(T(2.0) * step)
		step *= T(2.0)
	end

	# construct max by adding decreasing powers of 2, while making sure not to get out of bounds
	while step > T(0)
		if !isinf(max + step)
			max += step
		end
		step /= T(2)
	end

	return max
end


for T in (Float16, Float32, Float64)
    println("\nTyp: ", T)

    println("macheps: ", findmacheps(T),
            " | eps: ", eps(T))

    println("eta: ", findeta(T),
            " | nextfloat(0): ", nextfloat(T(0)))

    println("MAX: ", findmax(T),
            " | floatmax: ", floatmax(T))

    println("MINnor: ", floatmin(T))
end
