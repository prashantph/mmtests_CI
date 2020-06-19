touch test_time.out

echo "start sysbench-mariadb-oltp-ro-small" |tee -a test_time.out
date |tee -a test_time.out
./run-mmtests.sh --config configs/config-db-sysbench-mariadb-oltp-ro-small       sysbench   
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
echo "End sysbench-mariadb-oltp-ro-small" |tee -a test_time.out
date |tee -a test_time.out

echo "start sqlite" |tee -a test_time.out
date |tee -a test_time.out
./run-mmtests.sh --config configs/config-db-sqlite-insert-small  sqlite 
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
echo "end sqlite" |tee -a test_time.out
date |tee -a test_time.out

echo "start pgbench-timed-rw-small" |tee -a test_time.out
date |tee -a test_time.out
./run-mmtests.sh --config configs/config-db-pgbench-timed-rw-small       pgbench 
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
echo "end pgbench-timed-rw-small" |tee -a test_time.out
date |tee -a test_time.out

echo "start sysbench-postgres-oltp-rw-small" |tee -a test_time.out
date |tee -a test_time.out
./run-mmtests.sh --config  configs/config-db-sysbench-postgres-oltp-rw-small db-sysbench-postgres-oltp-rw-small  
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
echo "End sysbench-postgres-oltp-rw-small" |tee -a test_time.out
date |tee -a test_time.out

