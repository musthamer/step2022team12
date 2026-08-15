#!/bin/bash
echo "Content-type: text/html"
echo
name=$(echo $QUERY_STRING | sed "s/^[^*]*n=//g" | sed "s/&.*//g")
pass=$(echo $QUERY_STRING | sed "s/^[^*]*=//g")
echo "<!doctype html><html>
<head><meta charset='utf-8'><title>login</title><link rel='stylesheet' href='https://informatik.hs-bremerhaven.de/docker-step2022team12-web/style.css' /></head>
<body>"
echo "<div class='options'>"
if grep -q "^$name|$pass$" /home/docker-step2022team12/Bücherwelt/accounts.csv; then
echo "<form action=bookform.sh>
  <input type='radio' id='Buch hinzufügen' name='option' value='1'>Buch hinzufügen</br>
  <input type='radio' id='Buch löschen' name='option' value='2'>Buch löschen</br>
  <input type='radio' id='Buch bearbeiten' name='option' value='3'>Buch bearbeiten</br>
  <input type='radio' id='Account hinzufügen' name='option' value='4'>Account hinzufügen</br>
  <input type='submit'>
</form>"
else
  echo "<p>invalid login data</p>"
fi
echo "</br><a href='./Bücherwelt.sh'>Zurück zur Bücherwelt</a>"
echo "</div>"
echo "</body></html>"
