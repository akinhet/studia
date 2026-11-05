fun binomial (n, k) =
    if n < k orelse n < 0 orelse k < 0 then NONE
    else if n = k orelse k = 0 then SOME 1
    else
        case (binomial (n - 1, k), binomial (n - 1, k - 1)) of
            (SOME a, SOME b) => SOME (a + b)
          | _ => NONE

fun next_pascal row =
    let
        val shifted_left = row @ [0]
        val shifted_right = 0 :: row
    in
        ListPair.map (fn (a, b) => a + b) (shifted_left, shifted_right)
    end

fun nth_pascal 0 = [1]
  | nth_pascal n = next_pascal (nth_pascal (n - 1))

fun binomial2 (n, k) =
    if n < k orelse n < 0 orelse k < 0 then NONE
    else
        let
            val row = nth_pascal n
        in
            SOME (List.nth (row, k))
        end
