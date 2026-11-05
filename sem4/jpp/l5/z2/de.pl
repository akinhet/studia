de(A, 0, 1, 0, A) :- !.

de(A, B, X, Y, Z) :-
    B > 0,
    R is A mod B,
    Q is A // B,
    de(B, R, X1, Y1, Z),
    X is Y1,
    Y is X1 - Q * Y1.
