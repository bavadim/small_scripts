#!/bin/sh
curl -X GET -s http://wapbash.org.ru/rnd.html \
| sed '/<\/a>]<\/small><\/p><p>/,/<\/p>/!d;s/&quot\;/"/g' \
| sed -e :a -e 's/<[^>]*>/ /g'
