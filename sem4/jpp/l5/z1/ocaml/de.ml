let rec de a b =
  if b = 0 then 
    (1, 0, a)
  else
    let (x, y, z) = de b (a mod b) in
    (y, x - y * (a / b), z)


let prime_factors n =
  let rec factor n k =
    if k * k > n then
      if n > 1 then [n] else []
    else if n mod k = 0 then
      k :: factor (n / k) k
    else
      factor n (k + 1)
  in
  factor n 2


let rec gcd a b =
  if b = 0 then abs a else gcd b (a mod b)

let totient n =
  let rec tot n k =
    if k < 2 then 1
    else if gcd n k = 1 then 1 + tot n (k - 1)
    else tot n (k - 1)
  in
  tot n n

let rec uniq list =
  match list with
  | x :: y :: tail -> if x = y then uniq (y :: tail) else x :: uniq (y :: tail)
  | other -> other

let totient2 n =
  if n <= 0 then 0
  else
    let factors = uniq (prime_factors n) in
    List.fold_left (fun acc p -> acc * (p - 1) / p) n factors


let rec sieve nums =
  match nums with
  | [] -> []
  | p :: cdr_nums ->
      let filtered = List.filter (fun x -> x mod p <> 0) cdr_nums in
      p :: sieve filtered

let primes n =
  if n < 2 then []
  else
    let rec gen_seq a b =
      if a <= b then a :: gen_seq (a + 1) b
      else []
    in
    sieve (gen_seq 2 n);;

print_int (totient 20260618) ;;
