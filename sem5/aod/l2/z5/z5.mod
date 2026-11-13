set Districts;
set Shifts;

param minCars{Districts, Shifts};
param maxCars{Districts, Shifts};

param minDistrict{Districts};
param minShift{Shifts};

var x{i in Districts, j in Shifts}
    integer >= minCars[i,j], <= maxCars[i,j];

minimize objective:
    sum{i in Districts, j in Shifts} x[i,j];

s.t. districtLimit{i in Districts}:
    sum{j in Shifts} x[i,j] >= minDistrict[i];

s.t. shiftLimit{j in Shifts}:
    sum{i in Districts} x[i,j] >= minShift[j];

solve;

display x, objective;

end;
