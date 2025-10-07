#!/bin/bash
# this script is invoked by build.sh
PKG_DIR=$1
LIB_DIR=$2

echo "pip install requirements.txt to '${PKG_DIR}'..."
pip install -r requirements.txt -t ${PKG_DIR};

for i in `ls /usr/lib64/mysql/libmysqlclient.so*`;
do
    echo "Checking .so file: '$i'"
    if [[ $i =~ libmysqlclient.so.[[:digit:]]+$ ]];
    then
        # only copy libmysqlclient.so.21, NOT libmysqlclient.so or libmysqlclient.so.21.1.20
        # because libmysqlclient.so.21 is the necessary and sufficient file for mysqlclient to work
        echo "COPYING '$i' to output dir '${LIB_DIR}'..."
        cp $i ${LIB_DIR}
    fi
done
