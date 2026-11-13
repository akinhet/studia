set Products;
set Machines;

param price{Products};
param operatingcost{Machines};
param materialcost{Products};
param demand{Products};

param timeneeded{Products, Machines};

var x{p in Products} >= 0, <= demand[p];

maximize objective: (sum{p in Products} x[p] * (price[p] - materialcost[p])) - (sum{p in Products, m in Machines} x[p] * operatingcost[m] * timeneeded[p, m] / 60);

s.t. cTimeOnMachine{m in Machines}:
	sum{p in Products} x[p] * timeneeded[p, m] / 60 <= 60;

solve;

display x, objective;

end;

