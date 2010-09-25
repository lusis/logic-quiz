#!/usr/bin/env bash
## Notes at bottom

# baseline count
BASELINE=`awk -F, '{ print $2 }' top-1m.csv | awk -F. '( $2 == "co" ) && ( substr($1,2,1) == "c") && ( $3 !~ /^$/ ) { print $3 }' | wc -l`

# print results
awk -F, '{ print $2 }' top-1m.csv | awk -F. '( $2 == "co" ) && ( substr($1,2,1) == "c") && ( $3 !~ /^$/ ) { print $3 }' | awk '{ count[$1]++}END{for(x in count) print count[x], "-" x}'

# sum aggregate matches
AGGSUM=`awk -F, '{ print $2 }' top-1m.csv | awk -F. '( $2 == "co" ) && ( substr($1,2,1) == "c") && ( $3 !~ /^$/ ) { print $3 }' | \
awk '{ count[$1]++}END{for(x in count) print count[x], "-", x}' | \
awk -F'-' '{ SUM += $1 } END { print SUM }'`

echo "\nRun report"
echo "-------------------------------"
echo "Baseline count was: ${BASELINE}"
echo "Post-aggregation count was: ${AGGSUM}"

if [ "${BASELINE}" -eq "${AGGSUM}" ]; then
        echo "Zug zug"
else
        echo "More work?"
fi

# Logic:
# split at comma | (match co) and (match c in second letter) and (ignore colombian tlds) | set counter for tld and increment each time it matches finally printing results "count - tld"
#
# Gaps:
# I'm duplicating the awk logic in three different places. That's introduces a risk that I type/paste that logic incorrectly.
# I really should use an awk script file for each logic chunk or just do it all in one big script file
#
# Places I had to troubleshoot:
# - Columbian TLD threw me off the first go around. I had 4 matches with no TLD. I must have done at least 30 minutes of manual inspection trying to determine why.
# - I had to look up how to do counts in awk. Usually I've moved to a dynamic language by the point I get to this kind of logic requirement.
# - I'm also making a scary assumption that my base awk logic is giving me all the matches. I'd probably want to write a ruby/python/perl (order of preference) script to validate as well
# - Tried the uniq/sort route at first. I was trying to avoid any intermediate artifacts so I just did as much as I could in awk

# vim: set ts=8 et sw=8 sts=0 sta filetype=sh :
