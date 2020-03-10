#!/usr/bin/env zsh

set -e
 
mkdir -p output
(
    cd output
    cp -f ../frequency_table.tex frequency_table_light.tex
    cp -f ../frequency_table.tex frequency_table_dark.tex
    ln -sf ../frequencies.dat

    sed -i -e 's/---pagecolor---//' -e 's/---rowcolor---/0.85/' frequency_table_light.tex
    sed -i -e 's/---pagecolor---/\\pagecolor[rgb]{0,0,0}\n\\color[rgb]{0.9,0.9,0.9}/' -e 's/---rowcolor---/0.20/' frequency_table_dark.tex

    latexmk -pdf 
    latexmk -c
    gs -sDEVICE=png16m -r400 -o frequency_table_light_%d.png frequency_table_light.pdf
    gs -sDEVICE=png16m -r400 -o frequency_table_dark_%d.png frequency_table_dark.pdf
    latexmk -C

    rm -f frequency_table_{light,dark}.tex frequencies.dat
)
