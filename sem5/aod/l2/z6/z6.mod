param m, integer >= 5;
param n, integer >= 5;
param k, integer >= 1;

set Rows := 1..m;
set Cols := 1..n;

set Containers within Rows cross Cols;

var camera{Rows, Cols} binary;

minimize objective:
    sum{i in Rows, j in Cols} camera[i,j];

s.t. noCamera{(i,j) in Containers}:
    camera[i,j] = 0;

s.t. coverage{(i,j) in Containers}:
    sum{r in Rows, c in Cols:
        (r = i and abs(c-j) <= k) or
        (c = j and abs(r-i) <= k)
    } camera[r,c] >= 1;

solve;

printf "Liczba kamer: %g\n", objective;

printf {(i,j) in Rows cross Cols: camera[i,j] > 0.5}
    "Kamera: (%d, %d)\n", i, j;

end;
