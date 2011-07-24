set term png size 600,600 font '/Library/Fonts/Microsoft/Calibri.ttf,10'
set datafile separator ";";

#set xtic auto
#set ytic auto

#set xtics format "%.3f"
#set ytics format "%.3f"

set grid
set pointsize 10
plot 'output/solar/rk4.dat' using 2:3 with points lt 3 ps 2 notitle
     