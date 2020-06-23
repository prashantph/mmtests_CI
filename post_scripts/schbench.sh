#!/bin/bash

Home_dir=`pwd`
Result_dir=$Home_dir/$1
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/schbench/results.csv
if [ ! -d "$cvs_dir/schbench" ]
then
        mkdir -p $cvs_dir/schbench
fi
#kernel=$(uname -r)
val=$(uname -r)
OLDIFS=$IFS; IFS=$'\n'; for line in $(grep qrtle $Result_dir/schbench.out); do echo $line > qrtle.txt ; LAT=`awk '{print $3}' qrtle.txt`; val="${val}${val:+,}$LAT"; done; IFS=$OLDIFS

echo $val > $csv_file
