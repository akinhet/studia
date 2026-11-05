(defun mergesort (L)
  (if (small L)
	L
	(mymerge (mergesort (right-half L)) (mergesort (left-half L)))))

(defun small (L)
  (or (null L) (null (cdr L))))

(defun right-half (L)
  (last L (ceiling (/ (length L) 2))))

(defun left-half (L)
  (ldiff L (right-half L)))

(defun mymerge (L1 L2)
  (cond ((null L1) L2)
		((null L2) L1)
		((< (car L1) (car L2)) (cons (car L1) (mymerge (cdr L1) L2)))
		(t (cons (car L2) (mymerge (cdr L2) L1)))))
