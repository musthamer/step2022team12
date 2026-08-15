#!/bin/bash
echo "Content-Type: text/html"
echo
option=$(echo $QUERY_STRING | sed "s/^[^=]*=//g")
echo "<!doctype html><html>
<head><meta charset='utf-8'><title>login</title><style>td{border: 1px solid}</style></head>
<body>"
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
    <input type=submit>
    </form>"
  else
    if test $option = 2; then
      echo "<form action='./removebook.sh'><table>"
      i=1
      cat /home/docker-marsell/books.csv | while read line; do
        echo "<tr><td><input type='checkbox' name=$i></td><td>$line</td></tr>"
        i=$((i+1))
      done
    echo "</table><input type=submit></form>"
    fi
  fi
echo "</body>
</html>"
