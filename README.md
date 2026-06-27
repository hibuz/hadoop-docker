# Basic Hibuz Bigdata Stack information
The Hibuz Bigdata Stack (HBS) is a fully containerized, production-ready big data development environment tailored for modern data engineering and analytics. Built on top of Ubuntu 26.04 LTS and Java 21, it delivers a pre-configured, localized ecosystem that allows developers to spin up a comprehensive big data stack instantly using Docker Compose.

Unlike cloud-managed alternatives like Amazon EMR, HBS provides a lightweight, cost-effective, and highly customizable local environment featuring the latest stable open-source releases:

- Orchestration & Notebooks: Apache Zeppelin
- Data Warehousing: Apache Hive
- Processing Engines: Apache Spark and Apache Flink
- Storage & Table Formats: Apache Hadoop (HDFS), Apache HBase, and Apache Iceberg


### Key Features
- Instant Local Setup: Spin up Hadoop, Spark, Hive, Flink, and Zeppelin with a single docker compose up command.
- Modern Component Stack: Actively maintained with cutting-edge versions that often surpass the baselines of standard cloud providers (e.g., Amazon EMR v7.13.0).
- Built-in Python Support: Integrated with Miniconda3 for seamless PySpark, PyFlink, and advanced data science workflows.
---
Feel free to tweak it depending on whether you want to emphasize specific use cases or further developments!

## HBS <code>VS</code> Amazon EMR

| App        | Version  | Date   | Size   |
| ---------- | -------- | ------ | ------ |
| Zeppelin   | [0.12.1](https://zeppelin.apache.org/download.html)         | `2026-06-12` | 6.61GB |
| Iceberg    | [1.11.0](https://iceberg.apache.org/releases)               | `2026-05-19` | -      |
| Flink      | [2.3.0](https://flink.apache.org/downloads/#apache-flink-2) | `2026-06-25` | 5.25GB |
| Hive       | [4.2.0](https://hive.apache.org/general/downloads/)         | `2025-11-23` | 4.37GB |
| Spark      | [4.1.2](https://spark.apache.org/downloads.html)            | `2026-05-21` | 3.79GB |
| Miniconda3 | [py311_26.3.2-2](https://repo.anaconda.com/miniconda/)      | `2026-04-14` | -      |
| Hbase      | [2.6.6](https://hbase.apache.org/downloads.html)            | `2026-06-09` | 2.4GB  |
| Hadoop     | [3.5.0](https://hadoop.apache.org/releases.html)            | `2026-04-02` | 1.94GB |
| Java       | 21.0.11                                                     | `2026-04-21` | -      |
| Ubuntu     | [26.04 LTS](https://ubuntu.com/project/docs/release-team/list-of-releases/)| `2026-04-23` | 323MB |

- Amazon EMR [v7.13.0](https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-release-components.html) | `2026-04-21` 
<details><summary>Version Details</summary>
<ul>
  <li>Zeppelin: 0.11.1</li>
  <li>Iceberg: 1.10.0-amzn-1</li>
  <li>Flink: 1.20.0-amzn-7</li>
  <li>Hive: 3.1.3-amzn-22</li>
  <li>Spark: 3.5.6-amzn-2</li>
  <li>HBase: 2.6.4-amzn-0</li>
  <li>Hadoop: 3.4.2-amzn-0</li>
  <li>Python: 3.9, 3.11</li>
</ul>
</details>


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
hadoop-docker/(hbase|spark|hive|flink|zepplein)$ docker compose up --build
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
Flink 2.2.1 error
 Flink SQL> CREATE CATALOG myhive WITH (
    >     'type' = 'hive',
   [ERROR] Could not execute SQL statement. Reason: org.apache.flink.table.api.ValidationException: Could not find any factory for identifier 'hive' that implements 'org.apache.flink.table.factories.CatalogFactory' in the classpath.
```