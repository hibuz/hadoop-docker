# Quick usage for hive-dev docker image
- Docker build and run
``` bash
git clone https://github.com/hibuz/ubuntu-docker
cd ubuntu-docker/hadoop/hive

docker compose up --no-build

# Wait until 2 Hive sessions are created
hive  | 2021-09-12 03:48:25: Starting HiveServer2
...
hive  | Hive Session ID = 2ffe9e77-c95b-4951-b7b7-080710594503
hive  | Hive Session ID = 405b164b-bf28-4b43-bdc1-3fb9d764efe4
```

### Attach to running container
``` bash
docker exec -it hive bash
```

### Hive DDL Operation example
``` bash

# Connect to HiveServer2 with hive shell:
~/hive-3.1.x$ hive
hive> show databases;

hive> quit;

# Connect to HiveServer2 with Beeline from shell:
~/hive-3.1.x$ beeline -n hadoop -u jdbc:hive2://localhost:10000
...
Connecting to jdbc:hive2://localhost:10000
Connected to: Apache Hive (version 3.1.x)
Driver: Hive JDBC (version 3.1.x)
Transaction isolation: TRANSACTION_REPEATABLE_READ
Beeline version 3.1.x by Apache Hive

# Beeline is started with the JDBC URL of the HiveServer2
# First, create a table with tab-delimited text file format:
0: jdbc:hive2://localhost:10000> CREATE TABLE pokes (foo INT, bar STRING);
...
INFO  : OK
INFO  : Concurrency mode is disabled, not creating a lock manager
No rows affected (0.334 seconds)

# Show table
0: jdbc:hive2://localhost:10000> show tables;
...
+-----------+
| tab_name  |
+-----------+
| pokes     |
+-----------+
1 row selected (0.257 seconds)

# Loading data from flat example file into Hive:
0: jdbc:hive2://localhost:10000> LOAD DATA LOCAL INPATH '/home/hadoop/hive-3.1.3/examples/files/kv1.txt' OVERWRITE INTO TABLE pokes;
...
INFO  : OK
INFO  : Concurrency mode is disabled, not creating a lock manager
No rows affected (1.336 seconds

# Count the number of rows in table pokes:
0: jdbc:hive2://localhost:10000> SELECT COUNT(*) FROM pokes;
...
+------+
| _c0  |
+------+
| 500  |
+------+
1 row selected (5.163 seconds)

# Exit Beeline Shell
0: jdbc:hive2://localhost:10000> !q
Closing: 0: jdbc:hive2://localhost:10000
```

### Stops containers and removes containers, networks, and volumes created by `up`.
``` bash

docker compose down -v

[+] Running 3/3
 ✔ Container hive        Removed
 ✔ Volume hive_hive-vol  Removed
 ✔ Network hive_default  Removed
```

# Visit hive dashboard
- http://localhost:10002

# Reference
- https://cwiki.apache.org/confluence/display/Hive/GettingStarted
- https://github.com/tech4242/docker-hadoop-hive-parquet