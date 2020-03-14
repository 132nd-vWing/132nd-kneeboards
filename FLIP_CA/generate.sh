#!/usr/bin/env zsh

set -e

autoload -U zmv

process () {
    MOD="OPTIONAL - kneeboard $1 - CA FLIP"
    MVDIR="archive/${MOD}/Mods/terrains/Caucasus/Kneeboard/"
    mkdir -p ${MVDIR}
    cp -l clean.bat output
    cp -l output/*.{png,bat} ${MVDIR}
    cp VERSION.txt README.txt archive/
    echo -n "${1} version\r\n" >> archive/README.txt

    (
        cd archive
        7z a "${MOD}.zip" *
    )
    mv archive/"${MOD}.zip" .
    rm -rf archive
}


nFiles=$(find source -iname '*.png' | wc -l)

if [ $nFiles -le 10 ]
then
    echo "You need to copy the original kneeboard files for Caucasus into the './source/' directory."
    exit 1
fi

mkdir -p output
(
cd output
for f in ../source/*png
    ln $f 4${f:t}
)

process light

rm -rf output/*
(
cd output
for f in ../source/*png
    convert $f -negate -alpha off -normalize 4${f:t}
)

process dark

rm -rf output
