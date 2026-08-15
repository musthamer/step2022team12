#!/bin/bash
echo "Content-type: text/html"
echo
echo "<!doctype html><html><head><meta charset='utf-8'><title>edited book</title></head><body>"
a=$(echo $QUERY_STRING | cut -d "=" -f 2) 
echo "<form action='./editbook.sh'><table>"
echo "<tr><td>$(head -$a /home/docker-step2022team12/Bücherwelt/books.csv | tail -1 | cut -d "|" -f 1)</td>"
echo "<td><input type='text' name=titel></td></tr>"
echo "<tr><td>$(head -$a /home/docker-step2022team12/Bücherwelt/books.csv | tail -1 | cut -d "|" -f 2)</td>"
echo "<td><input type='text' name=genre></td></tr>"
echo "<tr><td>$(head -$a /home/docker-step2022team12/Bücherwelt/books.csv | tail -1 | cut -d "|" -f 3)</td>"
echo "<td><input type='text' name=autor></td></tr>"
echo "<tr><td>$(head -$a /home/docker-step2022team12/Bücherwelt/books.csv | tail -1 | cut -d "|" -f 4)</td>"
echo "<td><input type='text' name=preis></td></tr>"
echo "</table><input type='submit'>"
echo "</form>"
echo "</br><a href='./Bücherwelt.sh'>Zurück zur Bücherwelt</a>"
echo "</body></html>"
head -$a /home/docker-step2022team12/Bücherwelt/books.csv | tail -1 | sed "s/|/\n/g" > /home/docker-step2022team12/Bücherwelt/old.csv
sed "$a"d /home/docker-step2022team12/Bücherwelt/books.csv > /home/docker-step2022team12/Bücherwelt/temp.csv
