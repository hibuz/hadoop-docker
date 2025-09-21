## Basic Hibuz Bigdata Stack information
<details><summary>Details</summary>

```bash
# run
cd hadoop-docker/zeppelin
docker compose up --no-build

# attach
docker exec -it zeppelin bash

# ls
hadoop@efa0809b5859:~$ ls -al ~/
drwxr-xr-x 1 hadoop hadoop 4096 Sep 21 01:27 zeppelin-0.12.0
drwxr-xr-x 1 hadoop hadoop 4096 Nov 13  2023 flink-1.17.2
drwxr-xr-x 1 hadoop hadoop 4096 Sep 19 06:47 hive-4.0.1
drwxr-xr-x 1 hadoop hadoop 4096 Sep 19 06:47 spark-3.5.6
drwxr-xr-x 1 hadoop hadoop 4096 Sep 19 06:24 hbase-2.6.3
drwxr-xr-x 1 hadoop hadoop 4096 Sep 21 01:27 hadoop-3.4.2
```
</details>

<details>
<summary>HBS <code>VS</code> Amazon EMR</summary>
<strong>릴리스 정보</strong>
<ul>
  <li>Hibuz`s HBS(0.12.0) <code>2025-09-20</code></li>
  <li>Amazon EMR(7.10.0) <code>2025-08-15</code></li>
</ul>

<strong>EMR 버전 정보</strong>
<ul>
  <li>Zeppelin: 0.11.1</li>
  <li>Flink: 1.20.0-amzn-4</li>
  <li>Hive: 3.1.3-amzn-19</li>
  <li>Spark: 3.5.5-amzn-1</li>
  <li>HBase: 2.6.2-amzn-1</li>
  <li>Hadoop: 3.4.1-amzn-2</li>
  <li>Python: 3.9, 3.11</li>
</ul>
</details>

| App        | Version              | Date         | Size   |
| ---------- | -------------------- | ------------ | ------ |
| Zeppelin   | 0.12.0(flink:1.17.2) | `2025-01-31` | 6.61GB |
| Flink      | 1.20.2               | `2025-07-07` | 4.33GB |
| Hive       | 4.0.1                | `2024-10-02` | 3.68GB |
| Spark      | 3.5.6                | `2025-05-23` | 3.22GB |
| Miniconda3 | py310_25.7.0-2       | `2025-08-25` | -      |
| Hbase      | 2.6.3                | `2025-07-15` | 2.25GB |
| Hadoop     | 3.4.2                | `2025-08-28` | 1.8GB  |
| Java       | 11.0.28              | `2025-07-15` | -      |
| Ubuntu     | 24.04.1 LTS          | `2024-08-20` | 117MB  |

### Simple zeppelin stack information
<details><summary>Details</summary>

```bash
# run
docker run --rm -it -p 8083:8083 -p 9995:9995 -p 18080:18080 --name zeppelin-tmp hibuz/zeppelin-dev:simple
# ls
docker exec -it zeppelin ls -al /home/hadoop
drwxr-xr-x  1 hadoop hadoop 4096 Sep 21 01:23 zeppelin-0.12.0
drwxr-xr-x  1 hadoop hadoop 4096 Nov 13  2023 flink-1.17.2
drwxr-xr-x 13 hadoop hadoop 4096 May 23 06:49 spark-3.5.6
```
</details>

| App              | Version | Date         | Size   |
| ---------------- | ------- | ------------ | ------ |
| Zeppelin(python) | 0.12.0  | `2025-06-13` | 4.53GB |
| Flink            | 1.17.2  | `2023-11-28` | -      |
| Spark(java)      | 3.5.6   | `2025-05-23` | -      |

### Simple flink stack information
<details><summary>Details</summary>

```bash
# run
docker run --rm -it -p 8083:8083 --name flink-tmp hibuz/flink-dev:simple

# ls
docker exec -it flink-tmp ls -al /home/hadoop
drwxr-xr-x 1 hadoop hadoop 4096 Jul 21 12:58 flink-2.1.0
drwxr-xr-x 1 hadoop hadoop 4096 Sep 21 00:39 hive-4.1.0
drwxr-xr-x 1 hadoop hadoop 4096 Jul  8 10:57 spark-4.1.0-preview1
drwxr-xr-x 1 hadoop hadoop 4096 Sep 21 00:48 hadoop-3.4.2
```
</details>

| App        | Version        | Date         | Size   |
| ---------- | -------------- | ------------ | ------ |
| Flink      | 2.1.0          | `2025-07-29` | 3.53GB |
| Hive       | 4.1.0          | `2025-07-30` | -      |
| Spark      | 4.1.0-preview1 | `2025-05-23` | -      |
| Hadoop     | 3.4.2          | `2025-08-28` | -      |
| Java       | 21.0.8         | `2025-07-15` | -      |

# Quick usage for hadoop-dev docker image
- Docker build and run
```bash
git clone https://github.com/hibuz/hadoop-docker
cd hadoop-docker

docker compose up hadoop-dev --no-build
```

## Docker build & run for custom hadoop user and version
- see [Dockerfile](Dockerfile)
<details><summary>Hadoop Docker Build & Push Order</summary>

```bash
# hadoop
hadoop-docker$ docker build -t hibuz/hadoop-dev .
# hbase|spark|hive|flink
hadoop-docker/(hbase|spark|hive|flink)$ docker compose up --build
# flink-base for zeppelin
hadoop-docker/zeppelin$ docker compose build flink-base
# zeppelin
hadoop-docker/zeppelin$ docker compose up --build


# docker taagging & push
docker tag hibuz/hadoop-dev hibuz/hadoop-dev:3.x.x
docker push hibuz/hadoop-dev
docker push hibuz/hadoop-dev:3.x.x
```
</details>


### Attach to running container
```bash
docker exec -it hadoop bash
```

### Prepare input files into the distributed filesystem
```bash
# Make the HDFS directories
hdfs dfs -mkdir -p /user/hadoop/input
# Copy the input files
hdfs dfs -put $HADOOP_HOME/etc/hadoop/*.xml input
```

### Run some of the examples provided:
```bash
# Run example wordcount job:
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar wordcount input output
# View the output files on the distributed filesystem:
hdfs dfs -cat output/*

# Run example wordcount grep job:
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar grep input output/count 'dfs[a-z.]+'
# View the output files on the distributed filesystem:
hdfs dfs -cat output/count/*
# Result of the output files 
1	dfsadmin
1	dfs.replication

# Remove the output dir:
hdfs dfs -rm -r output
```

# Visit hadoop dashboard
- Hadoop Dashboard: http://localhost:9870
- Yarn Dashboard: http://localhost:8088 (run start-yarn.sh or uncomment command props in [docker-compose.yml](docker-compose.yml))
- Hadoop Job History: http://localhost:19888

### Stops containers and removes containers, networks, and volumes created by `compose up`.
```bash
docker compose down -v

[+] Running 3/3
 ✔ Container hbase         Removed
 ✔ Volume hbase_hbase-vol  Removed
 ✔ Network hbase_default   Removed
```

# Reference
- [Execute MapReduce jobs](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html#Execution)
- https://github.com/rancavil/hadoop-single-node-cluster
- https://github.com/big-data-europe/docker-hadoop

# TODOs
```
Hive 4.1.0 error

 Exception in thread "main" java.lang.UnsupportedClassVersionError: org/apache/hive/service/server/HiveServer2 has been compiled by a more recent version of the Java Runtime (class file version 61.0), this version of the Java Runtime only recognizes class file versions up to 55.0

Flink 2.1.0 error
 Flink SQL> CREATE CATALOG myhive WITH (
    >     'type' = 'hive',
   [ERROR] Could not execute SQL statement. Reason: org.apache.flink.table.api.ValidationException: Could not find any factory for identifier 'hive' that implements 'org.apache.flink.table.factories.CatalogFactory' in the classpath.

Zeppelin 0.12.0 error
 Caused by: java.lang.Exception: This is not officially supported spark version: 4.0.1 
```