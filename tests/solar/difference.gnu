set term png size 600,600 font '/Library/Fonts/Microsoft/Calibri.ttf,10'
set datafile separator ";";

#set xrange [3.17:3.18]
#set yrange [0.0:0.0000001]
#set xtic auto
#set ytic auto

#set xtics format "%.3f"
#set ytics format "%.3f"

set grid
set pointsize 10

plot 'tests/solar/result_rk4.dat' using 1:3 with lines lt 1 pt 1 ps 0 title 'Рунге-Кутты 4', \
     'tests/solar/result_hermite.dat' using 1:3 with lines lt 2 pt 1 ps 0 title 'Эрмита', \
     'tests/solar/result_yo8.dat' using 1:3 with lines lt 3 pt 1 ps 0 title 'Йошиды 8', \
     'tests/solar/result_ms8.dat' using 1:3 with lines lt 4 pt 1 ps 0 title 'ПК 8'
