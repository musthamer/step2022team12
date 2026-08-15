#!/bin/bash
search="$(echo $QUERY_STRING | sed "s/^[^*]*=//g" | sed "s/+/ /g")"
echo "content-type: text/html"
echo
echo "<!DOCTYPE html>
<html>
	<head>
		<meta charset='utf-8'>
		<title>Bücherwelt</title>
		<style>
      body {
	      color: #3A3A3A;
      }
      table {
	      margin: auto;
	      border-spacing: 20px;
      }
      td {
	      text-align: center;
	      border: 1px solid;
	      width: 230px;
	      padding: 10px;
      }
      td img {
	      width: 150px;
      }
      .header {
	      background-color: #FFFFFF;
	      font-size:35px;
      }
      .search {
	      background-color: #e9e9e9;
	      text-align: center;
	      width: 220px;
	      padding: 10px;
	      margin: auto;
	      border-radius: 25px;
      }
      .login {
        background-color: #e9e9e9;
        padding: 10px;
        text-align: right;
        position: absolute;
        left: 0px;
        right: 0px;
        top: 0px;
      }
    </style>
	</head>
	<body><div class='login'>
      <form action='login.sh'>
        <input type="text" name=n placeholder=Benutzername>
        <input type="password" name=p placeholder=Passwort>
        <input type=submit value=Login>
      </form>
    </div>
 <br>
    <div class='header'>         
		<h1 align='center'><b><i>Willkommen bei der Bücherwelt</b></i></h1>
	</div>
	<div class='search'>
		<form action='Bücherwelt.sh'>
			<input type=text name=s>
			<input type=submit value=Suche>
		</form>
	</div>
		<table><tr>"
    i=0
    if test -z "$search"; then
      cat /home/docker-marsell/books.csv | while read line; do
        echo $(echo $line | sed "s/^/<td>/g" | sed "s/|/<br>/g" | sed "s/$/<\/td>/g")
        i=$((i+1))
        if test $i -ge 6; then
          echo "</tr><tr>"
          i=0
        fi
      done
    else
      grep "$search" /home/docker-marsell/books.csv | while read line; do
        echo $(echo $line | sed "s/^/<td>/g" | sed "s/|/<br>/g" | sed "s/$/<\/td>/g")
        i=$((i+1))
        if test $i -ge 6; then
          echo "</tr><tr>"
          i=0
        fi
      done
    fi
echo "</tr></table>"
echo "</body></html>"
