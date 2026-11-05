(defun de (a b)
  (if (= b 0)
    (list 1 0 a)
    (let* ((row (de b (mod a b)))
          (x (first row))
          (y (second row))
          (z (third row)))
      (list y (- x (* y (truncate a b))) z))))

(defun prime_factors (n)
  (factor n 2))

(defun factor (n k)
  (if (> (* k k) n)
    (if (> n 1) (list n))
    (if (= 0 (mod n k))
      (cons k (factor (/ n k) k))
      (factor n (+ k 1)))))

(defun totient (n)
  (tot n n))

(defun tot (n k)
  (cond ((< k 2) 1)
        ((= 1 (gcd n k)) (+ 1 (tot n (- k 1))))
        (t (tot n (- k 1)))))

(defun totient2 (n)
  (* n (reduce #'* (mapcar #'(lambda (x) (- 1 (/ 1 x))) (remove-duplicates (prime_factors n))))))

(defun gen_seq (a b)
  (if (<= a b)
    (cons a (gen_seq (+ a 1) b))))

(defun sieve (nums)
  (if (null nums)
    nil
    (let ((p (car nums)))
      (cons p (sieve (remove-if #'(lambda (x) (= 0 (mod x p))) (cdr nums)))))))

(defun primes (n)
  (if (< n 2)
    nil
    (sieve (gen_seq 2 n))))

(print (totient 20260618))
