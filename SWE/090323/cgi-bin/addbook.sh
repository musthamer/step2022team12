#!/bin/bash
echo "Content-type: text/html"
echo
a=$(echo $QUERY_STRING | cut -d "&" -f 1 | cut -d "=" -f 2 | sed "s/+/ /g")
b=$(echo $QUERY_STRING | cut -d "&" -f 2 | cut -d "=" -f 2 | sed "s/+/ /g")
c=$(echo $QUERY_STRING | cut -d "&" -f 3 | cut -d "=" -f 2 | sed "s/+/ /g")
d=$(echo $QUERY_STRING | cut -d "&" -f 4 | cut -d "=" -f 2 | sed "s/+/ /g" | sed "s/%2C/,/g" | sed "s/%E2%82%AC/€/g")
echo "$a|$b|$c|$d" >> /home/docker-step2022team12/Bücherwelt/books.csv
echo "<!doctype html><html><head><meta charset='utf-8'><title>added book</title><link rel='stylesheet' href='https://informatik.hs-bremerhaven.de/docker-step2022team12-web/style.css' /></head><body>"
echo "<div class='options'>"
echo "<p>book was added</p>"
echo "</br><a href='./Bücherwelt.sh'>Zurück zur Bücherwelt</a>"
echo "</div>"
echo "</body></html>"
