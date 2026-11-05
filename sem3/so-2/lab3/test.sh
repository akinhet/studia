#!/bin/bash

# liczba próbek
N=10

# wykresy przechowujemy w tablicach asocjacyjnych
declare -A rx_hist tx_hist

fmt() {
    local v=$1
    if   (( v > 1024*1024 )); then printf "%.1f MB" $((v/1024/1024))
    elif (( v > 1024 ));      then printf "%.1f KB" $((v/1024))
    else                          printf "%d B" "$v"
    fi
}

while true; do
    # pierwszy odczyt
    mapfile -t S1 < <(grep ':' /proc/net/dev)

    sleep 1

    # drugi odczyt
    mapfile -t S2 < <(grep ':' /proc/net/dev)

    clear
    echo "Ruch sieciowy (ostatnie 10 s):"
    echo

    for i in "${!S1[@]}"; do
        iface=$(awk -F':' '{gsub(/ /,"",$1); print $1}' <<< "${S1[$i]}")

        # pola RX/TX
        rx1=$(awk -F':' '{print $2}' <<< "${S1[$i]}" | awk '{print $1}')
        tx1=$(awk -F':' '{print $2}' <<< "${S1[$i]}" | awk '{print $9}')
        rx2=$(awk -F':' '{print $2}' <<< "${S2[$i]}" | awk '{print $1}')
        tx2=$(awk -F':' '{print $2}' <<< "${S2[$i]}" | awk '{print $9}')

        rx=$((rx2 - rx1))
        tx=$((tx2 - tx1))

        # dodaj próbkę
        rx_hist[$iface]="${rx_hist[$iface]} $rx"
        tx_hist[$iface]="${tx_hist[$iface]} $tx"

        # utnij do N próbek
        rx_hist[$iface]=$(echo ${rx_hist[$iface]} | awk -v n=$N '{for(i=NF-n+1;i<=NF;i++) if(i>0) printf $i" "}')
        tx_hist[$iface]=$(echo ${tx_hist[$iface]} | awk -v n=$N '{for(i=NF-n+1;i<=NF;i++) if(i>0) printf $i" "}')

        echo "=== $iface ==="
        echo "RX: $(fmt $rx)    TX: $(fmt $tx)"

        # autoskalowanie
        max=$(printf "%s %s\n" "${rx_hist[$iface]}" "${tx_hist[$iface]}" | tr ' ' '\n' | sort -n | tail -1)
        ((max==0)) && max=1

        # rysowanie wykresu
        echo -n "RX: "
        for v in ${rx_hist[$iface]}; do
            h=$(( v * 10 / max ))
            printf '%*s' "$h" '' | tr ' ' '#'
            echo -n "|"
        done
        echo

        echo -n "TX: "
        for v in ${tx_hist[$iface]}; do
            h=$(( v * 10 / max ))
            printf '%*s' "$h" '' | tr ' ' '#'
            echo -n "|"
        done
        echo
        echo
    done
done
