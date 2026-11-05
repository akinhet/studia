# Piotr Zieniewicz 283961
x::Float64 = nextfloat(1.0)

# look through all floats between 1 and 2 until you find one that satisfies x * 1/x != 1
while x < 2.0
    if x * (1.0 / x) != 1.0
        println("x = ", x)
        println("x * (1/x) = ", x * (1.0 / x))
        break
    end

    global x = nextfloat(x)
end
