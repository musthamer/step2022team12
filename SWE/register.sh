#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ACCOUNTS_FILE="$SCRIPT_DIR/accounts.csv"

url_decode() {
  local data="${1//+/ }"
  printf '%b' "${data//%/\\x}"
}

html_escape() {
  printf '%s' "$1" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' -e 's/"/\&quot;/g'
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

name="$(get_param rn)"
pass="$(get_param rp)"

echo "Content-type: text/html"
echo
cat <<'HTML'
<!doctype html>
<html lang="de">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Registrierung - Buecherwelt</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <main class="admin-panel">
    <h1>Registrierung</h1>
HTML

if [ -z "$name" ] || [ -z "$pass" ]; then
  echo "<p class='msg-error'>Bitte Benutzername und Passwort angeben.</p>"
elif printf '%s' "$name" | grep -q '[|[:space:]]'; then
  echo "<p class='msg-error'>Benutzername darf keine Leerzeichen oder | enthalten.</p>"
elif printf '%s' "$pass" | grep -q '[|]'; then
  echo "<p class='msg-error'>Passwort darf kein | enthalten.</p>"
elif [ ${#pass} -lt 4 ]; then
  echo "<p class='msg-error'>Passwort muss mindestens 4 Zeichen haben.</p>"
else
  touch "$ACCOUNTS_FILE"
  escaped_name="$(printf '%s' "$name" | sed 's/[.[\\*^$+?(){}|]/\\\\&/g')"
  if grep -q "^${escaped_name}|" "$ACCOUNTS_FILE"; then
    echo "<p class='msg-error'>Benutzername bereits vorhanden.</p>"
  else
    printf '%s|%s\n' "$name" "$pass" >> "$ACCOUNTS_FILE"
    echo "<p class='msg-ok'>Konto erstellt fuer <strong>$(html_escape "$name")</strong>.</p>"
  fi
fi

cat <<'HTML'
    <p><a href="index.html">Zurueck zur Startseite</a></p>
    <p><a href="Bücherwelt.sh">Direkt zum Katalog</a></p>
  </main>
</body>
</html>
HTML