#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BOOKS_FILE="$SCRIPT_DIR/books.csv"
TMP_FILE="$SCRIPT_DIR/.books.tmp"

selected="$(printf '%s' "$QUERY_STRING" | tr '&' '\n' | cut -d '=' -f 1 | grep -E '^[0-9]+$' | paste -sd, -)"

echo "Content-type: text/html"
echo

if [ -z "$selected" ]; then
   echo "<p class='msg-error'>Keine Buecher ausgewaehlt.</p><p><a href='Bücherwelt.sh'>Zurueck</a></p>"
   exit 0
fi

awk -F'|' -v sel="$selected" '
BEGIN {
   n = split(sel, arr, ",");
   for (i = 1; i <= n; i++) {
      del[arr[i]] = 1;
   }
}
{
   if (!(FNR in del)) {
      print $0;
   }
}
' "$BOOKS_FILE" > "$TMP_FILE" && mv "$TMP_FILE" "$BOOKS_FILE"

echo "<p class='msg-ok'>Ausgewaehlte Buecher wurden entfernt.</p><p><a href='Bücherwelt.sh'>Katalog ansehen</a></p>"
