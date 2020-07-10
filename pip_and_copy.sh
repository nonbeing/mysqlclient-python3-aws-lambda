#!/bin/bash
PKG_DIR=$1
LIB_DIR=$2

pip install -r requirements.txt -t ${PKG_DIR};

for i in `ls /usr/lib64/mysql/libmysqlclient.so*`;
do
    echo "Checking .so file: '$i'"
    if [[ $i =~ libmysqlclient.so.[[:digit:]]+$ ]];
    then
        echo "COPYING '$i' to output dir..."
        cp $i ${LIB_DIR}
    fi
done