#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BOOKS_FILE="$SCRIPT_DIR/books.csv"

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

search="$(get_param s)"

echo "Content-type: text/html"
echo

cat <<'HTML'
<!DOCTYPE html>
<html lang="de">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Buecherwelt Katalog</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
  </head>
  <body>
    <header class="hero">
      <div class="hero-layout">
      <div class="hero-content">
        <p class="eyebrow">Buecherwelt Katalog</p>
        <h1>Buecher entdecken</h1>
        <p>Filtern funktioniert ohne Login. Login und Registrierung sind rechts fuer Verwaltungsfunktionen.</p>
        <form class="search-form" action="buecherwelt.sh" method="get">
          <input type="text" name="s" placeholder="Suchbegriff eingeben ...">
          <button type="submit">Filtern</button>
        </form>
        <div class="catalog-actions">
          <a class="cta-link" href="buecherwelt.sh">Alle Buecher anzeigen</a>
        </div>
      </div>

      <aside class="auth-panel">
        <section class="auth-card">
          <h2>Login</h2>
          <form class="auth-form" action="login.sh" method="get">
            <input type="text" name="n" placeholder="Benutzername" required>
            <input type="password" name="p" placeholder="Passwort" required>
            <button type="submit">Login</button>
          </form>
        </section>

        <section class="auth-card">
          <h2>Registrierung</h2>
          <form class="auth-form" action="register.sh" method="get">
            <input type="text" name="rn" placeholder="Neuer Benutzername" required>
            <input type="password" name="rp" placeholder="Neues Passwort" required>
            <button type="submit">Registrieren</button>
          </form>
        </section>
      </aside>
      </div>
    </header>
    <main class="catalog-shell">
      <section class="catalog-grid">
HTML

if [ ! -f "$BOOKS_FILE" ]; then
  echo "<p class='msg-error'>books.csv wurde nicht gefunden.</p>"
else
  matched=0
  while IFS='|' read -r title author genre price; do
    [ -z "$title" ] && continue
    row="$title|$author|$genre|$price"
    if [ -n "$search" ] && ! printf '%s' "$row" | grep -qiF -- "$search"; then
      continue
    fi
    matched=1
    echo "<article class='book-card'>"
    echo "  <h3 class='book-title'>$(html_escape "$title")</h3>"
    echo "  <p class='book-meta'>Autor: $(html_escape "$author")</p>"
    echo "  <p class='book-meta'>Genre: $(html_escape "$genre")</p>"
    echo "  <p class='book-meta'>Preis: $(html_escape "$price")</p>"
    echo "</article>"
  done < "$BOOKS_FILE"

  if [ "$matched" -eq 0 ]; then
    echo "<p class='msg-error'>Keine Treffer fuer die Suche gefunden.</p>"
  fi
fi

cat <<'HTML'
      </section>
    </main>
    <footer class="footer">
      <a href="index.html">Startseite</a>
      <span> | </span>
      <a href="impressum.html">Ueber uns</a>
    </footer>
  </body>
</html>
HTML
