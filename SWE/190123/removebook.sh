#!/bin/bash
echo "Content-type: text/html"
echo
a=$(wc -l /tmp/books.csv | cut -d " " -f 1)
for i in {1..$a}; do
  if test $(cat $QUERY_STRING | grep -q $i); then
    grep -v "$(head -$i /tmp/books.csv | tail -1)" /tmp/books.csv > /tmp/books.csv
  fi
done
echo "<!doctype html><html><head><meta charset='utf-8'><title>removed book</title><body>"
echo "<p>book was removed</p>"
echo "</br><a href='./Bücherwelt.sh'>Zurück zur Bücherwelt</a>"
echo "</body></html>"
