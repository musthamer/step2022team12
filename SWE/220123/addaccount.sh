#!/bin/bash
echo "Content-type: text/html"
echo
a=$(echo $QUERY_STRING | cut -d "&" -f 1 | cut -d "=" -f 2 | sed "s/+/ /g")
b=$(echo $QUERY_STRING | cut -d "&" -f 2 | cut -d "=" -f 2 | sed "s/+/ /g")
echo "$a|$b" >> /home/docker-step2022team12/Bücherwelt/accounts.csv
echo "<!doctype html><html><head><meta charset='utf-8'><title>added account</title></head><body>"
echo "<p>account was added</p>"
echo "</br><a href='./Bücherwelt.sh'>Zurück zur Bücherwelt</a>"
echo "</body></html>"
