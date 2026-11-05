mergesort([], []).
mergesort([X], [X]).
mergesort(Lista, Posortowana) :-
    Lista = [_, _ | _], % Sprawdzenie, czy lista ma co najmniej dwa elementy
    podziel(Lista, Lewa, Prawa),
    mergesort(Lewa, LewaPosortowana),
    mergesort(Prawa, PrawaPosortowana),
    scal(LewaPosortowana, PrawaPosortowana, Posortowana).

podziel([], [], []).
podziel([X], [X], []).
podziel([X, Y | Rest], [X | Lewa], [Y | Prawa]) :-
    podziel(Rest, Lewa, Prawa).

scal([], Prawa, Prawa).
scal(Lewa, [], Lewa).
scal([X | Lewa], [Y | Prawa], [X | Reszta]) :-
    X =< Y,
    scal(Lewa, [Y | Prawa], Reszta).
scal([X | Lewa], [Y | Prawa], [Y | Reszta]) :-
    X > Y,
    scal([X | Lewa], Prawa, Reszta).
