#!/bin/bash

algorithms=("merge" "mysort")

header="n,k,moves,compares"

for alg in "${algorithms[@]}"; do
	echo "$header" > "${alg}.csv"
done

echo "Rozpoczynam testy..."

for n in $(seq 1000 1000 50000); do
	echo "Testowanie n = $n"

	for k in $(seq 1 100); do

		for alg in "${algorithms[@]}"; do
			if [ "$alg" = "insertion" ] ; then
				continue
			fi
			output=$(../z1/rand $n | ./"$alg")

			moves=$(echo "$output" | grep -oP 'moves: \K[0-9]+')
			compares=$(echo "$output" | grep -oP 'compares: \K[0-9]+')

			echo "$n,$k,$moves,$compares" >> "${alg}.csv"
		done
	done
done

echo "Zakończono! Wyniki zapisano w plikach: insertion.csv, quick.csv, hybrid.csv"
