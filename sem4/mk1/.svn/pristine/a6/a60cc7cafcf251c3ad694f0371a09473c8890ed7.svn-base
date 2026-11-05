#!/bin/bash

header="s,moves,compares"
echo "$header" > "hybridtest.csv"

echo "Rozpoczynam testy..."

for k in $(seq 1 100); do
	input=$(../z1/rand 10000)

	for s in $(seq 8 13); do
		output=$(echo $input | ../z1/hybrid $s)

		moves=$(echo "$output" | grep -oP 'moves: \K[0-9]+')
		compares=$(echo "$output" | grep -oP 'compares: \K[0-9]+')

		echo "$s,$moves,$compares" >> "hybridtest.csv"
	done
done

echo "Zakończono!"
