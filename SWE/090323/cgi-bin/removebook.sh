#!/bin/bash
echo "Content-type: text/html"
echo
a=$(echo $QUERY_STRING | cut -d "=" -f 2)
sed "$a"d /home/docker-step2022team12/Bücherwelt/books.csv > /home/docker-step2022team12/Bücherwelt/temp.csv
cat /home/docker-step2022team12/Bücherwelt/temp.csv > /home/docker-step2022team12/Bücherwelt/books.csv
echo "<!doctype html><html><head><meta charset='utf-8'><title>removed book</title><link rel='stylesheet' href='https://informatik.hs-bremerhaven.de/docker-step2022team12-web/style.css' /><body>"
echo "<div class='options'>"
echo "<p>book was removed</p>"
echo "</br><a href='./Bücherwelt.sh'>Zurück zur Bücherwelt</a>"
echo "</div>"
echo "</body></html>"
