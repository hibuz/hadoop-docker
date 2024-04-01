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
    # Hadoop history server
    mapred --daemon start historyserver
    # Spark history server
    start-history-server.sh
fi

if [[ "$1" == *"hbase"* ]]; then
    mkdir $HBASE_HOME/logs
    nohup hbase master start 2>&1 | tee $HBASE_HOME/logs/hbase-master.log &
fi

if [[ "$1" == *"spark"* ]]; then
    start-master.sh
    start-workers.sh spark://localhost:7077
fi

if [[ "$1" == *"hive"* ]]; then
    cd $HIVE_HOME

    if [ ! -d "$HIVE_HOME/metastore_db" ]; then
        init-hive-dfs.sh
        schematool -dbType derby -initSchema
    fi
    mkdir $HIVE_HOME/logs
    nohup hive --service metastore 2>&1 | tee $HIVE_HOME/logs/metastore.log &
    sleep 2
    nohup hiveserver2 2>&1 | tee $HIVE_HOME/logs/hisveserver2.log &
fi

$FLINK_HOME/bin/start-cluster.sh

hdfs dfsadmin -report

jps

tail -f $FLINK_HOME/log/flink-*-standalonesession-*.log
