#!/bin/bash

gcc -O3 main.c -o main

echo "n,scenariusz,avg_ins_comp,max_ins_comp,avg_ins_ptr,max_ins_ptr,avg_ins_h,max_ins_h,avg_del_comp,max_del_comp,avg_del_ptr,max_del_ptr,avg_del_h,max_del_h" > wyniki.csv
echo "Uruchamianie eksperymentów..."

for n in 10000 20000 30000 40000 50000 60000 70000 80000 90000 100000
do
    echo "Testowanie n = $n..."
    ./main $n 1 >> wyniki.csv
    ./main $n 0 >> wyniki.csv
done

echo "Gotowe! Wyniki zapisano w pliku wyniki.csv"
