#!/usr/bin/env zsh

set -e

autoload -U zmv

mkdir -p output
(
    cd output
    cp -f ../CAS-kneeboard.tex CAS-kneeboard_light.tex
    cp -f ../CAS-kneeboard.tex CAS-kneeboard_dark.tex

    sed -i -e 's/---pagecolor---/\\pagecolor[gray]{1}\n\\color[gray]{0.0}/'  -e 's/---fillcolor---/white/g' CAS-kneeboard_light.tex
    sed -i -e 's/---pagecolor---/\\pagecolor[gray]{0}\n\\color[gray]{0.9}/'  -e 's/---fillcolor---/black/g' CAS-kneeboard_dark.tex
    for f in *.tex
        for i in {1..2}
            lualatex -halt-on-error $f
    latexmk -c 
    gs -sDEVICE=png16m -r400 -o CAS_light_%d.png CAS-kneeboard_light.pdf
    gs -sDEVICE=png16m -r400 -o CAS_dark_%d.png CAS-kneeboard_dark.pdf
    latexmk -C 
    rm -f CAS-kneeboard*tex
)


process () {
    MOD="OPTIONAL - kneeboard $1 - CAS"
    MVDIR1="archive/${MOD}/Mods/terrains/PersianGulf/Kneeboard/"
    MVDIR2="archive/${MOD}/Mods/terrains/Caucasus/Kneeboard/"
    mkdir -p ${MVDIR1} ${MVDIR2}
    for MVDIR in ${MVDIR1} ${MVDIR2}
    do
        cp -l output/CAS_${1}_?.png ${MVDIR}
        ( 
            cd ${MVDIR}
            noglob zmv -W *.png 300_*.png
        )
    done
    cp VERSION.txt README.txt archive/
    echo -n "${1} version\r\n" >> archive/README.txt

    (
        cd archive
        7z a "${MOD}.zip" *
    )
    mv archive/"${MOD}.zip" .
    rm -rf archive
}

process dark
process light

rm -rf output
