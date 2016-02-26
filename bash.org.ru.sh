#!/bin/sh
curl -X GET -s http://bash.im/random \
  | iconv -f CP1251 -t UTF-8 \
  | grep -m 1 '<div class="text">' \
  | perl -pe  's#<br[ /]*>#\n#g;s/[ ]?<div class="text">//g;s#</div>##g;s/&quot\;/"/g;s/&lt;/</g;s/&gt;/>/g;s/^[ \t]*//g'
