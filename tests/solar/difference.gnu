set term png size 600,600 font '/Library/Fonts/Microsoft/Calibri.ttf,15'
set datafile separator ";";

#set xrange [3.17:3.18]
set yrange [0.0:0.0000001]
#set xtic auto
#set ytic auto

#set xtics format "%.3f"
#set ytics format "%.3f"

set grid
set pointsize 10

plot 'tests/solar/result_rk4.dat' using 1:3 with points lt 1 pt 1 ps 1 notitle, \
     'tests/solar/result_hermite.dat' using 1:3 with points lt 2 pt 1 ps 1 notitle, \
     'tests/solar/result_yo8.dat' using 1:3 with points lt 3 pt 1 ps 1 notitle, \
     'tests/solar/result_ms8.dat' using 1:3 with points lt 4 pt 1 ps 1 notitle
