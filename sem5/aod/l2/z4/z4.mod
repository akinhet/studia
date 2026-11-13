set Nodes;
set Arcs within Nodes cross Nodes;

param cost{Arcs};
param time{Arcs};

param source symbolic in Nodes;
param destination symbolic in Nodes;
param maxTime;

var x{Arcs} binary;

minimize objective:
    sum{(i,j) in Arcs} cost[i,j] * x[i,j];

s.t. flow{v in Nodes}:
    sum{(v,j) in Arcs} x[v,j]
    - sum{(i,v) in Arcs} x[i,v]
    = if v = source then 1
      else if v = destination then -1
      else 0;

s.t. timeLimit:
    sum{(i,j) in Arcs} time[i,j] * x[i,j] <= maxTime;

solve;

printf "Cost: %g\n", objective;
printf "Time: %g\n", sum{(i,j) in Arcs} time[i,j] * x[i,j];

printf {(i,j) in Arcs: x[i,j] > 0.5}
    "%d -> %d\n", i, j;

end;
