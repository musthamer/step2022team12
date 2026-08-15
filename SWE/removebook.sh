#!/bin/bash
echo "Content-type: text/plain"
echo
a=$(wc -l /home/docker-marsell/books.csv | cut -d " " -f 1)
for i in {1..$a}; do
   if cat $QUERY_STRING | grep -q $i; then
grep -v "$(head -$i /home/docker-marsell/books.csv | tail -1)" /home/docker-marsell/books.csv > home/docker-marsell/books.csv
   fi
  done
echo "book was removed"
