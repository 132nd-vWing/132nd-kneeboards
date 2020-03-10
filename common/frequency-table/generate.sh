# frequency-color_table: frequency color table for 132nd vWing as kneeboard 
# Copyright © 2020 132nd.Professor
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
