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

# vars
for line in sections[variables]
	expr = Meta.parse(line)

	eval(:(@variable($model, $expr)))
end

# objective
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

# constraints
for line in sections[constraints]
	local expr = Meta.parse(line)
	eval(:(@constraint($model, $expr)))
end

optimize!(model)

println("\nStatus: ", termination_status(model))

if is_solved_and_feasible(model)
	println("Objective: ", objective_value(model))

	for name in sections[prints]
		var = eval(Meta.parse(name))
		println(name, " = ", value(var))
	end
end
