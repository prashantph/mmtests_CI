

time="/root/timestamp.txt"
if [ -f "$time" ]
then
    echo "$time found."
else
    echo "$time not found."
    echo `date +%Y%m%d%H%M` > /root/timestamp.txt
fi

fs_dir="/hana/data"
timestamp=`cat /root/timestamp.txt`
data_dir="$fs_dir/$timestamp/MMTests"
mkdir -p $data_dir

cp -r Results* $data_dir
cd work 
cp -r log* $data_dir
cd ..

