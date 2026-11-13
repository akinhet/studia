set Periods;

param maxProd;

param cost{Periods};
param demand{Periods};
param maxOvertime{Periods};
param overtimeCost{Periods};

param maxStorage;
param storageCost;
param initialStorage;

var production{Periods} >= 0, <= maxProd;
var overtime{j in Periods} >= 0, <= maxOvertime[j];
var storage{Periods} >= 0, <= maxStorage;

minimize objective:
    sum{j in Periods} (
        cost[j] * production[j]
        + overtimeCost[j] * overtime[j]
        + storageCost * storage[j]
    );

s.t. balance{j in Periods}:
    (if j = 1 then initialStorage else storage[j-1])
    + production[j] + overtime[j]
    = demand[j] + storage[j];

s.t. finalStorage:
    storage[4] = 0;

solve;

display production, overtime, storage, objective;

end;
