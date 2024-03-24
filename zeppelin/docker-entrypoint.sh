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

if [[ "$1" == *"hive"* ]]; then
    cd $HIVE_HOME

    if [ ! -d "$HIVE_HOME/metastore_db" ]; then
        init-hive-dfs.sh
        schematool -dbType derby -initSchema
    fi
    hiveserver2 &
fi

if [[ "$1" == *"spark"* ]]; then
    start-master.sh
    start-workers.sh spark://localhost:7077
fi

if [[ "$1" == *"flink"* ]]; then
    $FLINK_HOME/bin/start-cluster.sh
fi

zeppelin-daemon.sh start

hdfs dfsadmin -report

jps

tail -f $ZEPPELIN_HOME/logs/zeppelin--*.log
