set term png size 600,600 font '/Library/Fonts/Microsoft/Times New Roman.ttf,10'
set termoption enhanced
set datafile separator ";";

set xrange [0:26500]
set yrange [0.0000001:0.5]

set key outside left bottom horizontal
set key spacing 0.3

set lmargin 11

#set xtic auto
#set ytic auto

#set xtics format "%.3f"
set ytics format "%.0e"

set grid
set pointsize 10
set logscale y 10

set style line 1 lt 1 lc -1 lw 1
set style line 2 lt 2 lc 1 lw 2
set style line 3 lt 3 lc 2 lw 1
set style line 4 lt 4 lc 3 lw 1

set title "Отклонение в положении от эфемерид DE405 для Меркурия" font '/Library/Fonts/Microsoft/Times New Roman.ttf,13'
set xlabel "Время [дн.]" font '/Library/Fonts/Microsoft/Times New Roman.ttf,12'
set ylabel "|r — r_{DE405}| [а.е.]" font '/Library/Fonts/Microsoft/Times New Roman.ttf,12'

plot 'tests/solar/result_yo8.dat' using 1:2 smooth bezier ls 1 title 'Йошиды', \
     'tests/solar/result_ms8.dat' using 1:2 smooth bezier ls 2 title 'ПК-8', \
     'tests/solar/result_rk4.dat' using 1:2 smooth bezier ls 3 title 'Рунге-Кутты', \
     'tests/solar/result_hermite.dat' using 1:2 smooth bezier ls 4 title 'Эрмита'
     