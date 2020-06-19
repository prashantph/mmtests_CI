#!/bin/bash

Home_dir=`pwd`
echo "checking for required packages"

if [ -e /etc/redhat-release ];
  then 
	yum -y install time*
	yum -y install perl*
	yum -y install patch*
elif [ -e /etc/SuSE-release ];
  then 
	yum  install -y time*
	yum  install -y perl*
	yum  install -y patch*
	
                        elif [ -e /etc/os-release ];
                                then osdetails=`lsb_release -a 2>/dev/null | grep -i 'Description' | awk '{print $2$3;}'`;

                                        else osdetails=`echo "OSdetails unavailable"`


fi


echo "setting up Binary Search module"
cd $Home_dir/List-BinarySearch
 perl Makefile.PL
    make
    make test
    make install

cd $Home_dir
