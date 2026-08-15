set terminal pngcairo size 4096,1024 font 'Verdana, 32'
set output '/var/www/html/docker-step2022team12-web/schiffswelt/activity.png'

#Daten Zeichen entfernen aus der activity.dat-Datei
set datafile separator "|"

#Name des Diagramms
set title "Aktivität"

#X-Achsen-Titel
set xlabel "Uhrzeit"

#Y-Achsen-Titel
set ylabel "Geschwindigkeit in Knoten"

#Definiere das Format der X-Achse als Stunde
set xdata time
set timefmt "%H:%M:%S"
set xrange ["00:00":"24:00"]
set format x "%H:%M"
set xlabel "Zeit in Stunden"

#Definiert die Y-Achse
set yrange [0:30]

#Ließt die Daten aus der activity.dat-Datei ein
plot "/home/docker-step2022team12/Schiffswelt/activity.dat" using 1:2 with lines title 'Geschwindigkeit'
