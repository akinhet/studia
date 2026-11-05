#!/bin/bash

set -euo pipefail

tput civis
stty -echo -icanon time 0 min 0

while true
do
	IFS=$'\n' stats=( $(/sbin/ls -1tp /proc | grep "[0-9].*/" | head -n 30 | tr -d / | xargs -I _ sh -c 'cat /proc/_/stat 2>/dev/null || true') )

	output="PID,PPID,GPID,SID,TTY,STATE,RSS,COMM\n,\n"
	for stat in ${stats[@]}
	do
		IFS=$' ' _stat=( $stat )
		pid=${_stat[0]}
		rss=$(awk '{print $2}' /proc/$pid/statm 2>/dev/null || echo 0)
		tty=$(readlink /proc/$pid/fd/0 2>/dev/null || echo ?)
		com=$(echo $stat | sed -n 's/.*(\([^)]*\)).*/\1/p')
		IFS=$' ' stat=( $(echo $stat | sed 's/.*)//g') )
		# tty=$([ "${stat[4]}" -eq 0 ] && echo "?" || find /dev -type c -printf "%t %T %p\n" 2>/dev/null | awk -v n=${stat[4]} 'BEGIN{maj=int(n/256);min=n%256} $1==maj && $2==min {print $3; exit}')

		# if [[ ${stat[4]} == 0 ]]
		# then
		# 	tty=0
		# else
		# 	tty=$(( ${stat[4]} >> 8 ))
		# fi

		output+="$pid,${stat[1]},${stat[2]},${stat[3]},$tty,${stat[0]},$rss,$com\n"
	done

	tput cup 0 0
	tput clear
	echo -e "$output" | column --table -s ,
	echo -e "=============================================================="
	echo -e "| q - quit | k - kill | s - stop | c - continue | r - renice |\n"

	if read -r -t 1 -n 1 opt
	then
		case $opt in
			q)
				# tput clear
				tput cnorm
				stty sane
				exit
				;;
			k)
				stty sane
				tput cnorm
				read -p "PID to kill: " pid
				stty -echo -icanon time 0 min 0
				kill -TERM "$pid"
				;;
			s)
				stty sane
				tput cnorm
				read -p "PID to stop: " pid
				stty -echo -icanon time 0 min 0
				kill -STOP "$pid"
				;;
			c)
				stty echo
				tput cnorm
				read -p "PID to continue: " pid
				stty -echo -icanon time 0 min 0
				kill -CONT "$pid"
				;;
			r)
				stty echo
				tput cnorm
				read -p "PID to renice: " pid
				read -p "New nice value: " nice
				stty -echo -icanon time 0 min 0
				renice --priority $nice --pid $pid
				;;
		esac
	fi
done
