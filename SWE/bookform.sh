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

option="$(get_param option)"

echo "Content-Type: text/html"
echo
cat <<'HTML'
<!doctype html>
<html lang="de">
<head>
  <meta charset='utf-8'>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Aktionen - Buecherwelt</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <main class="admin-panel">
HTML

if [ "$option" = "1" ]; then
  cat <<'HTML'
    <h1>Buch hinzufuegen</h1>
    <form action="addbook.sh" method="get">
      <p><label>Titel</label><input type="text" name="b" required></p>
      <p><label>Genre</label><input type="text" name="g" required></p>
      <p><label>Autor</label><input type="text" name="a" required></p>
      <p><label>Preis</label><input type="text" name="p" required></p>
      <button type="submit">Speichern</button>
    </form>
HTML
elif [ "$option" = "2" ]; then
  echo "<h1>Buch loeschen</h1>"
  echo "<form action='removebook.sh' method='get'>"
  echo "<div class='catalog-grid'>"
  i=1
  while IFS='|' read -r title author genre price; do
    [ -z "$title" ] && continue
    echo "<article class='book-card'><label><input type='checkbox' name='$i'>"
    echo "<strong>$(printf '%s' "$title" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')</strong><br>"
    echo "$(printf '%s' "$author" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')<br>"
    echo "$(printf '%s' "$genre" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')<br>"
    echo "$(printf '%s' "$price" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')"
    echo "</label></article>"
    i=$((i + 1))
  done < "$BOOKS_FILE"
  echo "</div><p><button type='submit'>Ausgewaehlte entfernen</button></p></form>"
else
  echo "<p class='msg-error'>Ungueltige Auswahl.</p>"
fi

cat <<'HTML'
    <p><a href="index.html">Zurueck zur Startseite</a></p>
  </main>
</body>
</html>
HTML
