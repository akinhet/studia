let rec binomial n k =
  if n < k || n < 0 || k < 0 then None
  else if n = k || k = 0 then Some 1
  else
    match (binomial (n - 1) k, binomial (n - 1) (k - 1)) with
    | (Some a, Some b) -> Some (a + b)
    | _ -> None


let next_pascal row =
  let shifted_left = row @ [0] in
  let shifted_right = 0 :: row in
  List.map2 (+) shifted_left shifted_right

let rec nth_pascal n =
  if n = 0 then [1]
  else next_pascal (nth_pascal (n - 1))

let binomial2 n k =
  if n < k || n < 0 || k < 0 then None
  else Some (List.nth (nth_pascal n) k)

