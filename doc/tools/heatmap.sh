#!/bin/bash
value_end=$1
shift
value_start=$1
shift

values=$(gawk -vFPAT='[^,]*|"[^"]*"' "{print \$${value_start},\$${value_end}}" Cook.csv)
titles=`echo "$values"|head -n 1|sed 's/"\(.*\)" "\(.*\)"/\2 su \1/g'`
values=`echo "$values"|tail -n +2`

map=`echo "$values" | sort | uniq -c | sed 's/^\s*//;s/"\([0-9]\+\)"$/\1/'`
while read l; do
	keys+=("$l")
done < <(echo "$map" | gawk -vFPAT='[^ ]*|"[^"]*"' '{print $2}' | sort -u)

if [[ -n $1 ]]; then
	keys=("$@")
fi
echo "using ${keys[@]}"

curr=0;
for k in "${keys[@]}"; do
	echo "analyzing $k"
	map=`echo "$map"|sed "s/$k/$curr/g"`
	curr=$(($curr+1))
done
tmpfile1=`mktemp`
tmpfile2=`mktemp`
echo "$map" | sed 's/\([0-9]\+\) \([0-9]\+\) \([0-9]\+\)/\2 \3 \1/' > $tmpfile1

python2 > $tmpfile2 << __EOF__
maxl = 0;
maxi = 0;
dic={};
normalizer={};

with open('$tmpfile1', "r") as f:
   for line in f.read().split('\n')[:-1]:
        (x,y,z) = [int(i) for i in line.split(" ")];
        # data normalization
        normalizer[x]=normalizer.get(x,0)+z
        if (x > maxl): maxl = x;
        if (y > maxi): maxi = y;
        dic[(x,y)] = z;

for a in range(maxl+1):
    for b in range(maxi + 1):
        print a,b,dic.get((a,b),0)/float(normalizer[a]);
    print
__EOF__


(echo "\
	set title \"$titles\";\
	set xrange [0.5:5.5];\
	set cbrange [0:1];\
	set yrange [-0.5:$((${#keys[@]}-1)).5];"\
	$(curr=0;echo "set ytics (";for k in "${keys[@]}"; do echo "$k $curr,"; curr=$(($curr+1)); done;echo ");")\
	"plot \"$tmpfile2\" using 2:1:3 with image notitle;"
cat )| gnuplot

#\"$tmpfile2\" using 2:1:(\$3 == 0 ? \"\" : sprintf('%g',\$3) ) with labels notitle";\

rm $tmpfile{1,2}
