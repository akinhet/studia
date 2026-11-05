#!/usr/bin/env bash

set -euo pipefail

if [[ ! -z "${1-}" ]]; then
	dir=$(echo "$1" | sed 's/\/*$//g')
	if [[ ! -d $dir ]]; then
		echo "The argument given is not a directory" >&2
		exit 1
	fi
else
	dir=$(pwd | sed 's/\/*$//g')
fi

IFS=$'\n' files=( $(ls -1p "$dir" | grep -v /) )

for file in ${files[@]}
do
	newfile=$(echo "$file" | tr "[:upper:]" "[:lower:]")
	if [[ $file != $newfile ]]; then
		mv -v "$dir/$file" "$dir/$newfile"
	fi
done

