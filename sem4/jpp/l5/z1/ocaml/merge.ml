let rec split l =
  match l with
  | [] -> ([], [])
  | [x] -> ([x], [])
  | x :: y :: tail ->
      let (left, right) = split tail in
      (x :: left, y :: right)

let rec merge l1 l2 =
  match (l1, l2) with
  | ([], _) -> l2
  | (_, []) -> l1
  | (h1 :: t1, h2 :: t2) ->
      if h1 <= h2 then h1 :: merge t1 l2
      else h2 :: merge l1 t2

let rec mergesort l =
  match l with
  | [] | [_] -> l
  | _ ->
      let (left, right) = split l in
      merge (mergesort left) (mergesort right)
