#!/bin/bash
search="$(echo $QUERY_STRING | sed "s/^[^*]*=//g" | sed "s/+/ /g")"
echo "content-type: text/html"
echo
head -n 27 /var/www/html/docker-step2022team12-web/index.html
    i=0
    if test -z "$search"; then
      cat /home/docker-step2022team12/Bücherwelt/books.csv | while read line; do
        echo $(echo $line | sed "s/^/<td>/g" | sed "s/|/<br>/g" | sed "s/$/<\/td>/g")
        i=$((i+1))
        if test $i -ge 6; then
          echo "</tr><tr>"
          i=0
        fi
      done
    else
      grep "$search" /home/docker-step2022team12/Bücherwelt/books.csv | while read line; do
        echo $(echo $line | sed "s/^/<td>/g" | sed "s/|/<br>/g" | sed "s/$/<\/td>/g")
        i=$((i+1))
        if test $i -ge 6; then
          echo "</tr><tr>"
          i=0
        fi
      done
    fi
tail -n 8 /var/www/html/docker-step2022team12-web/index.html
