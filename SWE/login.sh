#!/bin/bash
echo "Content-type: text/html"
echo
name=$(echo $QUERY_STRING | sed "s/^[^*]*n=//g" | sed "s/&.*//g")
pass=$(echo $QUERY_STRING | sed "s/^[^*]*=//g")
echo "<!doctype html><html>
<head><meta charset='utf-8'><title>login</title></head>
<body>"
if grep -q "^$name|$pass$" /home/docker-marsell/accounts.csv; then
echo "<form action=bookform.sh>
  <input type='radio' id='Buch hinzufügen' name='option' value='1'>Buch hinzufügen</br>
  <input type='radio' id='Buch löschen' name='option' value='2'>Buch löschen</br>
  <input type='submit'>
</form>"
else
  echo "<p>invalid login data</p>"
fi
echo "</body></html>"
