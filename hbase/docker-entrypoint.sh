#!/bin/bash

sudo service ssh start

if [ ! -d "/tmp/hadoop-`whoami`/dfs/name" ]; then
    hdfs namenode -format
fi

start-dfs.sh

if [[ "$1" == *"yarn"* ]]; then
    sed -i s/local/yarn/ $HADOOP_CONF_DIR/mapred-site.xml
    start-yarn.sh
else
    sed -i s/yarn/local/ $HADOOP_CONF_DIR/mapred-site.xml
fi

if [[ "$1" == *"historyserver"* ]]; then
    mapred --daemon start historyserver
fi

hdfs dfsadmin -report

mkdir $HBASE_HOME/logs
nohup hbase master start 2>&1 | tee $HBASE_HOME/logs/hbase-master.log &
sleep 1

jps

tail -f $HBASE_HOME/logs/hbase-master.log