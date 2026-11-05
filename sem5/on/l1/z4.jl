# Piotr Zieniewicz 283961
using LinearAlgebra

"Find dot product of a and b front to back"
function f1(a::Array{T}, b::Array{T}, n::Integer) where T
	S = zero(T)
	for i in 1:n
		S += a[i] * b[i]
	end
	return S
end

"Find dot product of a and b back to front"
function f2(a::Array{T}, b::Array{T}, n::Integer) where T
	S = zero(T)
	for i in reverse(1:n)
		S += a[i] * b[i]
	end
	return S
end

"Find dot product of a and b from biggest to smallest"
function f3(a::Array{T}, b::Array{T}, n::Integer) where T
	Sp = zero(T)
	Sn = zero(T)
	c = T[]

	for i in 1:n
		push!(c, a[i] * b[i])
	end

	# separate and sort positive and negative partial results
	positive = sort(filter(x -> x > 0, c), rev=true)
	negative = sort(filter(x -> x < 0, c))

	for x in positive
		Sp += x
	end

	for x in negative
		Sn += x
	end

	return Sp + Sn
end

"Find dot product of a and b from smallest to biggest"
function f4(a::Array{T}, b::Array{T}, n::Integer) where T
	Sp = zero(T)
	Sn = zero(T)
	c = T[]

	for i in 1:n
		push!(c, a[i] * b[i])
	end

	# separate and sort positive and negative partial results
	positive = sort(filter(x -> x > 0, c))
	negative = sort(filter(x -> x < 0, c), rev=true)

	for x in positive
		Sp += x
	end

	for x in negative
		Sn += x
	end

	return Sp + Sn
end


x32 = Float32[2.718281828, -3.141592654, 1.414213562, 0.5772156649, 0.3010299957]
y32 = Float32[1486.2497, 878366.9879, -22.37492, 4773714.647, 0.000185049]

println("1: ", f1(x32, y32, 5))
println("2: ", f2(x32, y32, 5))
println("3: ", f3(x32, y32, 5))
println("4: ", f4(x32, y32, 5))
println("dot: ", dot(x32, y32))

x64 = Float64[2.718281828, -3.141592654, 1.414213562, 0.5772156649, 0.3010299957]
y64 = Float64[1486.2497, 878366.9879, -22.37492, 4773714.647, 0.000185049]

println("1: ", f1(x64, y64, 5))
println("2: ", f2(x64, y64, 5))
println("3: ", f3(x64, y64, 5))
println("4: ", f4(x64, y64, 5))
println("dot: ", dot(x64, y64))
