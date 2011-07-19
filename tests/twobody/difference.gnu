set term png size 600,600 font '/Library/Fonts/Microsoft/Times New Roman.ttf,10'
set datafile separator ";";

set xrange [2454101.5:2854101.5]
#set yrange [-0.001:0.01]
#set xtic auto
#set ytic auto

#set xtics format "%.3f"
#set ytics format "%.3f"

set grid
set pointsize 10

plot 'tests/twobody/rk4.dat' using 1:2 smooth bezier lt 3 title 'РК 4', \
     'tests/twobody/yo8.dat' using 1:2 smooth bezier lt 5 title 'Йошиды 8', \
     'tests/twobody/ms8.dat' using 1:2 smooth bezier lt 6 title 'ПК 8'