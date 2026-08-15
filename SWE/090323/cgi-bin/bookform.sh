#!/bin/bash
echo "Content-Type: text/html"
echo
option=$(echo $QUERY_STRING | sed "s/^[^=]*=//g")
echo "<!doctype html><html>
<head><meta charset='utf-8'><title>Bücherwelt</title><link rel='stylesheet' href='https://informatik.hs-bremerhaven.de/docker-step2022team12-web/style.css' /></head>
<body>"
echo "<div class='options'>"
  if test $option = 1; then
    echo "<form action='./addbook.sh'>
    <p>Buch</p>
    <input type=text name=b>
    <p>Genre</p>
    <input type=text name=g>
    <p>Autor</p>
    <input type=text name=a>
    <p>Preis</p>
    <input type=text name=p>
    <br>
    <br>
    <input type=submit>
    </form>"
  else
    if test $option = 2; then
      echo "<form action='./removebook.sh'><table>"
      i=1
      cat /home/docker-step2022team12/Bücherwelt/books.csv | while read line; do
        echo "<tr><td><input type='radio' name=option value=$i></td><td>$line</td></tr>"
        i=$((i+1))
      done
      echo "</table><br><input type=submit></form>"
    else
      if test $option = 3; then
        echo "<form action='./bookeditor.sh'><table>"
        i=1
        cat /home/docker-step2022team12/Bücherwelt/books.csv | while read line; do
          echo "<tr><td><input type='radio' name=option value=$i></td><td>$line</td></tr>"
          i=$((i+1))
        done
        echo "</table><br><input type=submit></form>"
      else
        if test $option = 4; then
          echo "<form action='./addaccount.sh'>
          <p>Name</p>
          <input type=text name=n>
          <p>Passwort</p>
          <input type=text name=p>
          <br>
          <br>
          <input type=submit>
          </form>"
        fi
      fi
    fi
  fi
echo "</br><a href='./Bücherwelt.sh'>Zurück zur Bücherwelt</a>"
echo "</div>"
echo "</body>
</html>"
