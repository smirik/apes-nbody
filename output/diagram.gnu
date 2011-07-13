set term png size 600,600 font '/Library/Fonts/Microsoft/Calibri.ttf,15'
set datafile separator ";";

#set xrange [3.17:3.18]
#set yrange [0.0:0.30]
#set xtic auto
#set ytic auto

#set xtics format "%.3f"
#set ytics format "%.3f"

set grid
set pointsize 10

#plot 'output/res/A490.res' using 3:4 with points lt 4 pt 5 ps 1 notitle 
#plot 'research/5-2-2/resonances' using 1:2 with points lt 3 pt 5 ps 1 notitle, 'output/res/A490.res' using 3:4 with points lt 4 pt 5 ps 0 notitle 
#plot 'research/5-2-2/resonances' using 1:2 with points lt -1 pt 5 ps 2 notitle
#plot 'result' using 2:3 with points lt 1 pt 1  ps 0 notitle, 'result' using 8:9 with points lt 2 pt 1  ps 0 notitle, 'result' using 14:15 with points lt 3 pt 1  ps 0 notitle, 'result' using 20:21 with points lt 4 pt 1  ps 0 notitle, 'result' using 26:27 with points lt 5 pt 1  ps 0 notitle, 'result' using 32:33 with points lt 6 pt 1  ps 0 notitle, 'result' using 38:39 with points lt 7 pt 1  ps 0 notitle, 'result' using 46:47 with points lt 8 pt 1  ps 0 notitle, 'result' using 52:53 with points lt 9 pt 1  ps 0 notitle
plot 'result' using 2:3 with points lt 1 pt 1  ps 0 notitle, 'result' using 8:9 with points lt 2 pt 1  ps 0 notitle, 'result' using 14:15 with points lt 3 pt 1  ps 0 notitle, 'result' using 20:21 with points lt 4 pt 1  ps 0 notitle, 'result' using 56:57 with points lt -1 pt 1  ps 0 notitle
