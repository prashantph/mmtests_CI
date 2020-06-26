#!/bin/bash
Home_dir=`pwd`
Result_dir=$Home_dir/$1
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/usemem-swap-ramdisk/result.csv
if [ ! -d "$cvs_dir/usemem-swap-ramdisk" ]
then
        mkdir -p $cvs_dir/usemem-swap-ramdisk
fi

kernel=$(uname -r)
combined=""
for i in syst-1 syst-4 elsp-1 elsp-4; do
  ops=$(grep $i $Result_dir/usemem-swap-ramdisk.out | head -1 | awk '{ print $4 }')
  combined="${combined}${combined:+,}$ops"
done
echo "$kernel,$combined" > $csv_file
cat $csv_file
