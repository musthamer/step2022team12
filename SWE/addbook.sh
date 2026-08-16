#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BOOKS_FILE="$SCRIPT_DIR/books.csv"

url_decode() {
	local data="${1//+/ }"
	printf '%b' "${data//%/\\x}"
}

get_param() {
	local key="$1"
	local chunk
	IFS='&' read -ra parts <<< "$QUERY_STRING"
	for chunk in "${parts[@]}"; do
		if [ "${chunk%%=*}" = "$key" ]; then
			url_decode "${chunk#*=}"
			return 0
		fi
	done
	printf ''
}

title="$(get_param b)"
genre="$(get_param g)"
author="$(get_param a)"
price="$(get_param p)"

echo "Content-type: text/html"
echo

if [ -z "$title" ] || [ -z "$genre" ] || [ -z "$author" ] || [ -z "$price" ]; then
	echo "<p class='msg-error'>Fehler: Alle Felder muessen ausgefuellt sein.</p><p><a href='index.html'>Zurueck</a></p>"
	exit 1
fi

printf '%s|%s|%s|%s\n' "$title" "$author" "$genre" "$price" >> "$BOOKS_FILE"
echo "<p class='msg-ok'>Buch wurde hinzugefuegt.</p><p><a href='Bücherwelt.sh'>Katalog ansehen</a></p>"
