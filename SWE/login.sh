#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ACCOUNTS_FILE="$SCRIPT_DIR/accounts.csv"

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

name="$(get_param n)"
pass="$(get_param p)"

echo "Content-type: text/html"
echo
cat <<'HTML'
<!doctype html>
<html lang="de">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Login - Buecherwelt</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <main class="admin-panel">
    <h1>Login Pruefung</h1>
HTML

if [ -z "$name" ] || [ -z "$pass" ]; then
  echo "<p class='msg-error'>Bitte Benutzername und Passwort angeben.</p>"
elif [ ! -f "$ACCOUNTS_FILE" ]; then
  echo "<p class='msg-error'>accounts.csv fehlt im Projektordner.</p>"
elif grep -q "^$(printf '%s' "$name" | sed 's/[.[\*^$+?(){}|]/\\&/g')|$(printf '%s' "$pass" | sed 's/[.[\*^$+?(){}|]/\\&/g')$" "$ACCOUNTS_FILE"; then
  cat <<'HTML'
    <p class="msg-ok">Login erfolgreich. Waehle eine Aktion:</p>
    <form action="bookform.sh" method="get">
      <p><label><input type="radio" name="option" value="1" required> Buch hinzufuegen</label></p>
      <p><label><input type="radio" name="option" value="2"> Buch loeschen</label></p>
      <button type="submit">Weiter</button>
    </form>
HTML
else
  echo "<p class='msg-error'>Ungueltige Login-Daten.</p>"
fi

cat <<'HTML'
    <p><a href="index.html">Zurueck zur Startseite</a></p>
  </main>
</body>
</html>
HTML
