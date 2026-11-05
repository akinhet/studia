#!/bin/bash

DIR="$1"
LOGFILE="monitor.log"

if [[ -z "$DIR" ]]; then
    echo "Użycie: $0 /ścieżka/do/katalogu"
    exit 1
fi

# Kolory
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
NC="\e[0m"  # no color

echo "Monitoruję katalog: $DIR"
echo "Log: $LOGFILE"

inotifywait -m -e create -e delete -e modify -e move "$DIR" --format '%e %w%f' | while read EVENT FILE
do
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

    case "$EVENT" in
        CREATE*)
            echo -e "${GREEN}[DODANO]${NC} $FILE"
            echo "$TIMESTAMP DODANO $FILE" >> "$LOGFILE"
            ;;
        DELETE*)
            echo -e "${RED}[USUNIĘTO]${NC} $FILE"
            echo "$TIMESTAMP USUNIĘTO $FILE" >> "$LOGFILE"
            ;;
        MODIFY*)
            echo -e "${YELLOW}[ZMODYFIKOWANO]${NC} $FILE"
            echo "$TIMESTAMP ZMODYFIKOWANO $FILE" >> "$LOGFILE"
            ;;
        MOVED_FROM*|MOVED_TO*)
            echo -e "${YELLOW}[ZMIANA NAZWY]${NC} $FILE"
            echo "$TIMESTAMP ZMIANA_NAZWY $FILE" >> "$LOGFILE"
            ;;
    esac
done
