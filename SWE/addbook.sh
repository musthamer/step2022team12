#!/bin/bash
echo "Content-type: text/plain"
a=$(echo $QUERY_STRING | cut -d "&" -f 1 | cut -d "=" -f 2 | sed "s/+/ /g")
b=$(echo $QUERY_STRING | cut -d "&" -f 2 | cut -d "=" -f 2 | sed "s/+/ /g")
c=$(echo $QUERY_STRING | cut -d "&" -f 3 | cut -d "=" -f 2 | sed "s/+/ /g")
d=$(echo $QUERY_STRING | cut -d "&" -f 4 | cut -d "=" -f 2 | sed "s/+/ /g")
echo "$a|$b|$c|$d" >> /home/docker-marsell/books.csv
echo "book was added"
