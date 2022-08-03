#! /bin/bash

cd "$(dirname "${0}")"

declare -a COLORS=(
    'blue'
    'cyan'
    'green'
    'orange'
    'purple'
    'red'
    'white'
    'yellow'
)

for color in ${COLORS[@]}; do
    sed -re "s/\\\$\\{COLOR\\}/${color}/g" useragent_tag_tpl.json > autochrome-tag/useragent_tag_${color}.json
done

exit 0
