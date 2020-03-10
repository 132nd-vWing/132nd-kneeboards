#!/usr/bin/env zsh

set -e

autoload -U zmv

geometry=900x1200
args_pre="-density 300"
args_post="-filter box -resize ${geometry} -gravity center -extent ${geometry} -define png:compression-level=9 -define png:compression-filter=1 -define png:compression-strategy=0 -alpha off -normalize"

mkdir -p output
pdftk FLIP_GULFR2_EC1.pdf burst output output/%02d.pdf

(
    cd output
    rm -f {01..08}.pdf
    parallel convert ${args_pre} {} ${args_post}         PG_FLIP_light_{/.}.png   ::: ??.pdf
    parallel convert ${args_pre} {} ${args_post} -negate PG_FLIP_dark_{/.}.png ::: ??.pdf
    rm -f ??.pdf doc_data.txt
)

process () {
    MOD="OPTIONAL - kneeboard $1 - PG FLIP"
    MVDIR="archive/${MOD}/Mods/terrains/PersianGulf/Kneeboard/"
    mkdir -p ${MVDIR}
    cp -l output/PG_FLIP_${1}_??.png ${MVDIR}
    ( 
        cd ${MVDIR}
        noglob zmv -W *.png 400_*.png
    )
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

