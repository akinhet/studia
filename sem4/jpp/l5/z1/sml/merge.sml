fun split [] = ([], [])
  | split [x] = ([x], [])
  | split (x :: y :: ys) =
    let
        val (xs, zs) = split ys
    in
        (x :: xs, y :: zs)
    end

fun mymerge ([], L2) = L2
  | mymerge (L1, []) = L1
  | mymerge (x :: xs, y :: ys) =
    if x < y then
        x :: mymerge (xs, y :: ys)
    else
        y :: mymerge (x :: xs, ys)

fun mergesort [] = []
  | mergesort [x] = [x]
  | mergesort L =
    let
        val (left, right) = split L
    in
        mymerge (mergesort left, mergesort right)
    end
