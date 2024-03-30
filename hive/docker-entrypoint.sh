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

if [ ! -d "$HIVE_HOME/metastore_db" ]; then
    init-hive-dfs.sh
    schematool -dbType derby -initSchema
    schematool -dbType derby -info
fi

if [[ "$1" == *"hbase"* ]]; then
    mkdir $HBASE_HOME/logs
    nohup hbase master start 2>&1 | tee $HBASE_HOME/logs/hbase-master.log &
fi

hdfs dfsadmin -report

jps


mkdir $HIVE_HOME/logs
nohup hive --service metastore 2>&1 | tee $HIVE_HOME/logs/metastore.log &
sleep 2

nohup hiveserver2 2>&1 | tee $HIVE_HOME/logs/hisveserver2.log &
sleep 1
tail -f $HIVE_HOME/logs/hisveserver2.log
