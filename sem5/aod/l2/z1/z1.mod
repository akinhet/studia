set Suppliers;
set Airports;

param supply{Suppliers};
param demand{Airports};

param cost{Airports, Suppliers};

var x{Airports, Suppliers} >= 0;

minimize objective: sum{a in Airports, s in Suppliers} cost[a, s] * x[a, s];

s.t. cSupply{s in Suppliers}:
	sum{a in Airports} x[a, s] <= supply[s];

s.t. cDemand{a in Airports}:
	sum{s in Suppliers} x[a, s] = demand[a];

solve;

display x, objective;

end;

