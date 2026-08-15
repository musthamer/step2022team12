#!/bin/bash
echo "Content-type: text/html"
echo
a=$(echo $QUERY_STRING | cut -d "&" -f 1 | cut -d "=" -f 2 | sed "s/+/ /g")
b=$(echo $QUERY_STRING | cut -d "&" -f 2 | cut -d "=" -f 2 | sed "s/+/ /g")
c=$(echo $QUERY_STRING | cut -d "&" -f 3 | cut -d "=" -f 2 | sed "s/+/ /g")
d=$(echo $QUERY_STRING | cut -d "&" -f 4 | cut -d "=" -f 2 | sed "s/+/ /g" | sed "s/%2C/,/g" | sed "s/%E2%82%AC/€/g")
if test -z $a; then
  echo $(head -1 /home/docker-step2022team12/Bücherwelt/old.csv) > /home/docker-step2022team12/Bücherwelt/new.csv
else
  echo $a > /home/docker-step2022team12/Bücherwelt/new.csv
fi
if test -z $b; then
  echo $(head -2 /home/docker-step2022team12/Bücherwelt/old.csv | tail -1) >> /home/docker-step2022team12/Bücherwelt/new.csv
else
  echo $b >> /home/docker-step2022team12/Bücherwelt/new.csv
fi
if test -z $c; then
  echo $(head -3 /home/docker-step2022team12/Bücherwelt/old.csv | tail -1) >> /home/docker-step2022team12/Bücherwelt/new.csv
else
  echo $c >> /home/docker-step2022team12/Bücherwelt/new.csv
fi
if test -z $d; then
  echo $(head -4 /home/docker-step2022team12/Bücherwelt/old.csv | tail -1) >> /home/docker-step2022team12/Bücherwelt/new.csv
else
  echo $d >> /home/docker-step2022team12/Bücherwelt/new.csv
fi
cat /home/docker-step2022team12/Bücherwelt/temp.csv > /home/docker-step2022team12/Bücherwelt/books.csv
cat /home/docker-step2022team12/Bücherwelt/new.csv | tr '\n' '|' | sed "s/|$/\n/g" >> /home/docker-step2022team12/Bücherwelt/books.csv
echo "<!doctype html><html><head><meta charset='utf-8'><title>edited book</title></head><body>"
echo "<p>Book was edited</p>"
echo "</br><a href='./Bücherwelt.sh'>Zurück zur Bücherwelt</a>"
echo "</body></html>
