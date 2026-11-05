fun de (a, 0) = (1, 0, a)
  | de (a, b) =
    let
        val (x, y, z) = de (b, a mod b)
    in
        (y, x - y * (a div b), z)
    end


fun factor (n, k) =
    if k * k > n then
        if n > 1 then [n] else []
    else
        if n mod k = 0 then
            k :: factor (n div k, k)
        else
            factor (n, k + 1)

fun prime_factors n = factor (n, 2)


fun gcd (a, 0) = a
  | gcd (a, b) = gcd (b, a mod b)

fun unique [] = []
  | unique (x :: xs) = x :: unique (List.filter (fn y => y <> x) xs)

fun tot (n, k) =
    if k < 2 then 1
    else if gcd (n, k) = 1 then 1 + tot (n, k - 1)
    else tot (n, k - 1)

fun totient n = tot (n, n)

fun totient2 n =
    let
        val factors = unique (prime_factors n)
        fun fold_formula (p, acc) = (acc * (p - 1)) div p
    in
        List.foldl fold_formula n factors
    end


fun gen_seq (a, b) =
    if a <= b then
        a :: gen_seq (a + 1, b)
    else
        []

fun sieve [] = []
  | sieve (p :: ps) =
    let
        val filtered_ps = List.filter (fn x => x mod p <> 0) ps
    in
        p :: sieve filtered_ps
    end

fun primes n =
    if n < 2 then
        []
    else
        sieve (gen_seq (2, n));

print (Int.toString (totient2 20260618));
