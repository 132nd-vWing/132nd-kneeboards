#!/usr/bin/env zsh

set -e

mkdir -p output
cd output
cp -f ../TAT.tex TAT_light.tex
cp -f ../TAT.tex TAT_dark.tex
ln -sf ../TAT.dat 

sed -i -e 's/---pagecolor---/\\pagecolor[gray]{1}\n\\color[gray]{0.0}/' -e 's/---rowcolor---/gray!20/g'  TAT_light.tex
sed -i -e 's/---pagecolor---/\\pagecolor[gray]{0}\n\\color[gray]{0.9}/' -e 's/---rowcolor---/black!80/g' TAT_dark.tex
for f in *.tex
do
    lualatex -halt-on-error $f
done
latexmk -c 
gs -sDEVICE=png16m -r400 -o TAT_light.png TAT_light.pdf
gs -sDEVICE=png16m -r400 -o TAT_dark.png  TAT_dark.pdf
latexmk -C 

rm -f TAT.dat TAT*.tex
