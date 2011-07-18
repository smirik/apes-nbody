set term png size 600,600 font '/Library/Fonts/Microsoft/Calibri.ttf,10'
set datafile separator ";";

#set xrange [3.17:3.18]
set yrange [0.0000001:0.01]
#set xtic auto
#set ytic auto

#set xtics format "%.3f"
#set ytics format "%.3f"

set grid
set pointsize 10
set logscale y 10
plot 'tests/solar/result_yo8.dat' using 1:3 smooth csplines lt 3 title 'Йошиды 8', \
     'tests/solar/result_ms8.dat' using 1:3 smooth csplines lt 4 title 'ПК 8', \
     'tests/solar/result_rk4.dat' using 1:3 smooth csplines lt 5 title 'Рунге-Кутты 4', \
     'tests/solar/result_hermite.dat' using 1:3 smooth csplines lt 6 title 'Эрмита 4'
     