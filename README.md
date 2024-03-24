# Quick usage for hadoop-dev docker image
- Docker build and run
``` bash
git clone https://github.com/hibuz/ubuntu-docker
cd ubuntu-docker/hadoop

docker compose up hadoop-dev --no-build
```

## Docker build & run for custom hadoop user and version
- see [Dockerfile](Dockerfile)
  <details><summary>Hadoop Build Order</summary>

  ``` bash
  # bash
  ubuntu-docker$ docker compose build bash-base
  # hadoop
  ubuntu-docker/hadoop$ docker compose build hadoop-base
  ubuntu-docker/hadoop$ docker build -t hibuz/hadoop-dev .
  # hbase|hive|spark
  ubuntu-docker/hadoop/(hbase|hive|spark)$ docker compose up --build
  # spark-base for zeppelin
  ubuntu-docker/hadoop/zeppelin$ docker compose build flink-base
  # zeppelin
  ubuntu-docker/hadoop/zeppelin$ docker compose up --build
  ```
  </details>


### Attach to running container
``` bash
docker exec -it hadoop bash
```

### Prepare input files into the distributed filesystem
``` bash
# Make the HDFS directories
hdfs dfs -mkdir -p /user/hadoop/input
# Copy the input files
hdfs dfs -put $HADOOP_HOME/etc/hadoop/*.xml input
```

### Run some of the examples provided:
``` bash
# Run example wordcount job:
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar wordcount input output
# View the output files on the distributed filesystem:
hdfs dfs -cat output/*

# Remove the output dir:
hdfs dfs -rm -r output

# Run example wordcount grep job:
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar grep input output 'dfs[a-z.]+'
# View the output files on the distributed filesystem:
hdfs dfs -cat output/*
# Result of the output files 
1	dfsadmin
1	dfs.replication
```

### Stops containers and removes containers, networks, and volumes created by `up`.
``` bash

docker compose down -v

[+] Running 3/3
 ✔ Container hbase         Removed
 ✔ Volume hbase_hbase-vol  Removed
 ✔ Network hbase_default   Removed
```

# Visit hadoop dashboard
- Hadoop Dashboard: http://localhost:9870
- Yarn Dashboard: http://localhost:8088 (run start-yarn.sh or uncomment command props in [docker-compose.yml](docker-compose.yml))
- Hadoop Job History: http://localhost:19888

# Reference
- [Execute MapReduce jobs](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html#Execution)
- https://github.com/rancavil/hadoop-single-node-cluster
- https://github.com/big-data-europe/docker-hadoop