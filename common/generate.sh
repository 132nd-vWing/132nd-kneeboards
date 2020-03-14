#!/usr/bin/env zsh

set -e

autoload -U zmv

for d in frequency-table AET TAT
(
    cd $d 
    ./generate.sh
)
    

process () {
    MOD="OPTIONAL - kneeboard $1 - common"
    MVDIR1="archive/${MOD}/Mods/terrains/PersianGulf/Kneeboard/"
    MVDIR2="archive/${MOD}/Mods/terrains/Caucasus/Kneeboard/"
    mkdir -p ${MVDIR1} ${MVDIR2}
    for MVDIR in ${MVDIR1} ${MVDIR2}
    do
        cp -l {frequency-table,AET,TAT}/output/*${1}*.png ${MVDIR}
        ( 
            cd ${MVDIR}
            noglob zmv -W frequency_table_${1}_?.png 200_frequency_table_${1}_?.png
            mv AET_${1}.png 201_AET_${1}.png
            mv TAT_${1}.png 202_TAT_${1}.png
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

for d in AET TAT frequency-table
    rm -rf $d/output
