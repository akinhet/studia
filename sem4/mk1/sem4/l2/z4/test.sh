#!/bin/bash

OUTPUT_FILE="results.csv"

echo "n,compares" > search.csv
echo "n,compares" > bin.csv

echo "Rozpoczynam pomiary..."

ns=("100" "50" "20" "10" "5" "2")

for n in "${ns[@]}"
do
	for k in $(seq 1 20)
	do
		RESULT=$( ./generator $n $(echo "10000 / $n" | bc) -1 | ./search )

		COMPARES=$(echo $RESULT | grep -oP 'compares: \K\d+')

		echo "$n,$COMPARES" >> "search.csv"

		RESULT=$( ./generator $n $(echo "10000 / $n" | bc) -1 | ./bin )

		COMPARES=$(echo $RESULT | grep -oP 'compares: \K\d+')

		echo "$n,$COMPARES" >> "bin.csv"
	done

	echo "Rozmiar $n x $(echo "10000 / $n" | bc)"
done

echo "Gotowe! Wyniki zapisano w $OUTPUT_FILE"
