#!/usr/bin/env zsh

set -e

source ../../args.sh

mkdir -p output
(
    cd output
    cp -f ../AET.tex AET_light.tex
    cp -f ../AET.tex AET_dark.tex
    ln -sf ../AET.dat

    sed -i -e 's/---pagecolor---/\\pagecolor[gray]{1}\n\\color[gray]{0.0}/'  AET_light.tex
    sed -i -e 's/---pagecolor---/\\pagecolor[gray]{0}\n\\color[gray]{0.9}/'  AET_dark.tex
    for f in *.tex
    do
        lualatex -halt-on-error $f
    done
    latexmk -c 
    eval gs ${GS_ARGS} -o AET_light.png AET_light.pdf
    eval gs ${GS_ARGS} -o AET_dark.png AET_dark.pdf
    latexmk -C 

    rm -f AET.dat AET*.tex
)
