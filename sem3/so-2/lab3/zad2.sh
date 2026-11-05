#!/bin/bash

set -euo pipefail

tput civis
stty -echo -icanon time 0 min 0

draw_graph() {
    vals=("$@")
	H=5

	max=$(printf "%s\n" "${vals[@]}" | awk '
		BEGIN { m = 0 }
		{
			gsub(",", ".", $0)
			if ($0 ~ /^[0-9.+-]+$/) v=$0; else v=0
			if (v > m) m = v
		}
		END { print m }
	')

	mapfile -t heights < <(
		printf "%s\n" "${vals[@]}" | awk -v m="$max" -v H="$H" '
			BEGIN { if (m == 0) m = 1 }
			{
				gsub(",", ".", $0)
				if ($0 ~ /^[0-9.+-]+$/) v=$0; else v=0
				h = int((v/m)*H + 0.5)
				if (h < 0) h = 0
				if (h > H) h = H
				print h
			}
		')

	for ((row=H; row>=1; row--)); do
		for h in "${heights[@]}"; do
			if (( h >= row ))
			then
				printf "%s" "█"
			else
				printf " "
			fi
		done
		printf "\n"
	done

}

fmt_net() {
	local v=$1
	if   (( v > 1024*1024 ))
	then
		printf "%.1f MB" $((v/1024/1024))
	elif (( v > 1024 ))
	then
		printf "%.1f KB" $((v/1024))
	else
		printf "%d B" "$v"
	fi
}

mapfile -t oldcpu < <(grep "^cpu[0-9]" /proc/stat)

declare -A rx_hist tx_hist

while true
do
	uptime=$(cat /proc/uptime | sed 's/\..*$//g')
	uptime=$(printf "%d H %d min %d s" $(($uptime / 3600)) $(($uptime % 3600 / 60)) $(($uptime % 60)))

	battery=$(cat /sys/class/power_supply/BAT*/capacity)

	read -r loadavg _ _ _ _ < /proc/loadavg

	mapfile -t newcpu < <(grep "^cpu[0-9]" /proc/stat)
	cpuoutput=""

	for i in "${!newcpu[@]}"
	do
		read c o1 o2 o3 o4 o5 o6 o7 o8 _ <<< "${oldcpu[$i]}"
		read _ n1 n2 n3 n4 n5 n6 n7 n8 _ <<< "${newcpu[$i]}"

		totalold=$(($o1+$o2+$o3+$o4+$o5+$o6+$o7+$o8))
		totalnew=$(($n1+$n2+$n3+$n4+$n5+$n6+$n7+$n8))

		dt=$(($totalnew - $totalold))
		di=$(( (n4+n5) - (o4+o5) ))

		if [[ $dt == 0 ]]; then
			usage=0
		else
			usage=$((100 * (dt - di) / dt))
		fi

		freq=$(awk '{print $1/1000 " MHz"}' /sys/devices/system/cpu/${c}/cpufreq/scaling_cur_freq)
		cpuoutput+="$c: $usage% $freq\n"
	done
	oldcpu=("${newcpu[@]}")

	for iface in /sys/class/net/*; do
		if [[ $iface != "/sys/class/net/wlan0" ]]; then
			continue
		fi
		name=$(basename "$iface")

		rx=$(cat "$iface/statistics/rx_bytes")
		tx=$(cat "$iface/statistics/tx_bytes")

		rx_hist[$name]="${rx_hist[$name]-} $rx"
		tx_hist[$name]="${tx_hist[$name]-} $tx"

		rx_hist[$name]=$(echo ${rx_hist[$name]-} | awk -v n=10 '{for(i=NF-n+1;i<=NF;i++) if(i>0) printf $i" "}')
		tx_hist[$name]=$(echo ${tx_hist[$name]-} | awk -v n=10 '{for(i=NF-n+1;i<=NF;i++) if(i>0) printf $i" "}')

	done

	tput cup 0 0
	tput clear

	echo "--- System Monitor ---"
	echo -e "======================\n"
	echo "uptime: $uptime"
	echo "battery: $battery%"
	echo "loadavg: $loadavg"
	echo -e $cpuoutput
	for iface in /sys/class/net/*; do
		if [[ $iface != "/sys/class/net/wlan0" ]]; then
			continue
		fi
		name=$(basename $iface)
		echo -e "$name\n"
		echo -e "TX: "
		fmt_net $tx
		echo -e "\nRX: "
		fmt_net $rx
		echo
		draw_graph ${rx_hist[$name]}
		echo
		draw_graph ${tx_hist[$name]}
		echo
	done
	echo -e "\npress q to quit\n"

	if read -r -t 1 -n 1 opt
	then
		case $opt in
			q)
				tput cnorm
				stty sane
				exit
				;;
		esac
		sleep 1
	fi
done
