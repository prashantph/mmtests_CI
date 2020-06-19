
MM_OUT_FILE=/root/mmtests/results/mm_out_file.out
LOG=/root/mmtests/results/

date | tee -a $MM_OUT_FILE
#./run-mmtests.sh --config  configs/config-workload-usemem-swap-ramdisk usemem-swap-ramdisk  |tee -a $MM_OUT_FILE  >>    $LOG/usemem-swap-ramdisk.out
#rm -rf /root/mmtests/work/testdisk/data/*
#sleep 5
#date | tee -a $MM_OUT_FILE 

#echo "-------------------------------------------------------------------------------------"
#./run-mmtests.sh --config  configs/config-workload-wp-tlbflush wp-tlbflush |tee -a $MM_OUT_FILE  >>    $LOG/wp-tlbflush.out
#rm -rf /root/mmtests/work/testdisk/data/*
#sleep 5
#date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/ config-workload-usemem-stress-numa-compact  usemem-stress-numa-compact |tee -a $MM_OUT_FILE  >>    $LOG/.-usemem-stress-numa-compact.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/config-workload-thpscale  thpscale  |tee -a $MM_OUT_FILE  >>    $LOG/thpscale.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/config-workload-spinplace-short spinplace-short    |tee -a $MM_OUT_FILE  >>    $LOG/spinplace-short.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/config-workload-stockfish stockfish  |tee -a $MM_OUT_FILE  >>    $LOG/stockfish.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/config-workload-rt-migration  rt-migration  |tee -a $MM_OUT_FILE  >>    $LOG/rt-migration.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/config-numa-autonumabench numa-autonumabench    |tee -a $MM_OUT_FILE  >>    $LOG/numa-autonumabench.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/config-io-paralleldd-read-small paralleldd-read-small    |tee -a $MM_OUT_FILE  >>    $LOG/paralleldd-read-small.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
