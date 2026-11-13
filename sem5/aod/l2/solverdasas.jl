using JuMP
import HiGHS

model = Model(HiGHS.Optimizer)

@enum State begin
	variables
	constraints
	objective
	print
	none
end

try
	open(ARGS[1], "r") do f
		state:State = none
	end
catch
	println("ERROR: file does not exist or not given")
end

expr = Meta.parse("x11 >= 0")
eval(:(@variable($model, $expr)))
# @variable(model, x11 >= 0)
@variable(model, x12 >= 0)
@variable(model, x13 >= 0)
@variable(model, x21 >= 0)
@variable(model, x22 >= 0)
@variable(model, x23 >= 0)
@variable(model, x31 >= 0)
@variable(model, x32 >= 0)
@variable(model, x33 >= 0)
@variable(model, x41 >= 0)
@variable(model, x42 >= 0)
@variable(model, x43 >= 0)

expr = Meta.parse("10x11 + 7x12 + 8x13 + 10x21 + 11x22 + 14x23 + 9x31 + 12x32 + 4x33 + 11x41 + 13x42 + 9x43")
eval(:(@objective($model, Min, $expr)))
# @objective(model, Min, 10x11 + 7x12 + 8x13 + 10x21 + 11x22 + 14x23 + 9x31 + 12x32 + 4x33 + 11x41 + 13x42 + 9x43)
expr = Meta.parse("x11 + x21 + x31 + x41 <= 275000")
eval(:(@constraint($model, $expr)))
# @constraint(model, Meta.parse("x11 + x21 + x31 + x41 <= 275000"))
@constraint(model, x12 + x22 + x32 + x42 <= 550000)
@constraint(model, x13 + x23 + x33 + x43 <= 660000)
@constraint(model, x11 + x12 + x13 == 110000)
@constraint(model, x21 + x22 + x23 == 220000)
@constraint(model, x31 + x32 + x33 == 330000)
@constraint(model, x41 + x42 + x43 == 440000)

print(model)
# optimize!(model)
# is_solved_and_feasible(model)
# termination_status(model)
# primal_status(model)
# dual_status(model)
# objective_value(model)
# value(x)
# value(y)

using JuMP
import HiGHS

model = Model(HiGHS.Optimizer)

@enum State begin
    variables
    constraints
    objective
    prints
    none
end

sections = Dict(
    variables => String[],
    constraints => String[],
    objective => String[],
    prints => String[]
)

headers = Dict(
    "VARIABLES" => variables,
    "CONSTRAINTS" => constraints,
    "OBJECTIVE" => objective,
    "PRINTS" => prints
)

try
    open(ARGS[1], "r") do f
        state = none

        for line in eachline(f)
            line = strip(line)

            if isempty(line)
                state = none
            elseif line == "END"
                break
            elseif haskey(headers, line)
                state = headers[line]
            elseif state != none
                push!(sections[state], line)
            end
        end
    end
catch e
    println("ERROR: ", e)
    exit(1)
end

# Zmienne
for line in sections[variables]
    expr = Meta.parse(line)
    name = expr.args[2]

    eval(:(@variable($model, $expr)))
    eval(:($name = model[$(string(name))]))
end

# Funkcja celu
obj = sections[objective]
sense = lowercase(obj[1])
expr = Meta.parse(join(obj[2:end], " "))

if sense == "min"
    eval(:(@objective($model, Min, $expr)))
elseif sense == "max"
    eval(:(@objective($model, Max, $expr)))
else
    error("Unknown objective sense: $sense")
end

# Ograniczenia
for line in sections[constraints]
    expr = Meta.parse(line)
    eval(:(@constraint($model, $expr)))
end

# Rozwiązanie
optimize!(model)

println("Status: ", termination_status(model))

if is_solved_and_feasible(model)
    println("Objective: ", objective_value(model))

    for name in sections[prints]
        println(name, " = ", value(model[name]))
    end
end
