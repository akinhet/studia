prime_factors(N, X) :-
    factors(N, 2, X).

factors(1, _, []) :- !.

factors(N, D, [N]) :-
    D * D > N, !.

factors(N, D, [D | Reszta]) :-
    0 is N mod D,
    NoweN is N // D,
    factors(NoweN, D, Reszta), !.

factors(N, D, X) :-
    D1 is D + 1,
    factors(N, D1, X).


totient(N, Wynik) :-
    prime_factors(N, Czynniki),
    list_to_set(Czynniki, Unikalne),
    oblicz_phi(N, Unikalne, Wynik).

oblicz_phi(N, [], N).
oblicz_phi(N, [P|Ps], Wynik) :-
    oblicz_phi(N, Ps, WynikReszta),
    Wynik is WynikReszta // P * (P - 1).


primes(N, X) :-
    N1 is N - 1,
    findall(X, (between(2, N1, X), is_prime(X)), X).

is_prime(X) :-
    X > 1,
    \+ has_divisor(X, 2).

has_divisor(X, D) :-
    D1 is D * D,
    D1 =< X,
    0 is X mod D.

has_divisor(X, D) :-
    D1 is D * D,
    D1 =< X,
    D2 is D + 1,
    has_divisor(X, D2).
