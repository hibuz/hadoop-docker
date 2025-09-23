# Quick usage for flink-dev docker image
- Docker build and run
```bash
git clone https://github.com/hibuz/hadoop-docker
cd hadoop-docker/flink

docker compose up --no-build
```

### Attach to running container
```bash
docker exec -it flink bash
```

### Run some of the examples provided:
```bash
# To deploy the example word count job to the running cluster, issue the following command:
~/flink-x.y.z$ flink run examples/streaming/WordCount.jar
Executing example with default input data.
Use --input to specify file input.
Printing result to stdout. Use --output to specify output path.
Job has been submitted with JobID 25baa559e2f20096e1595cf15dedd4d8
Program execution finished
Job with JobID 25baa559e2f20096e1595cf15dedd4d8 has finished.
Job Runtime: 1302 ms

# You can verify the output by viewing the logs:
~/flink-x.y.z$ tail log/flink-*-taskexecutor-*.out
(nymph,1)
(in,3)
(thy,1)
(orisons,1)
(be,4)
(all,2)
(my,1)
(sins,1)
(remember,1)
(d,4)
```

### Prepare csv data
```bash
~/flink-x.y.z$ hdfs dfs -mkdir -p /user/hadoop/flink
~/flink-x.y.z$ hdfs dfs -put $SPARK_HOME/examples/src/main/resources/people.csv flink
```

### Interactive Analysis with Flink SQL Client
```bash
~/flink-x.y.z$ sql-client.sh
    ______ _ _       _       _____  ____  _         _____ _ _            _  BETA   
   |  ____| (_)     | |     / ____|/ __ \| |       / ____| (_)          | |  
   | |__  | |_ _ __ | | __ | (___ | |  | | |      | |    | |_  ___ _ __ | |_ 
   |  __| | | | '_ \| |/ /  \___ \| |  | | |      | |    | | |/ _ \ '_ \| __|
   | |    | | | | | |   <   ____) | |__| | |____  | |____| | |  __/ | | | |_ 
   |_|    |_|_|_| |_|_|\_\ |_____/ \___\_\______|  \_____|_|_|\___|_| |_|\__|
          
        Welcome! Enter 'HELP;' to list all available commands. 'QUIT;' to exit.

Command history file path: /home/hadoop/.flink-sql-history

# Create and use hive catalog
Flink SQL> CREATE CATALOG myhive WITH (
    'type' = 'hive',
    'hive-conf-dir' = '/home/hadoop/hive-4.0.1/conf'
);
[INFO] Execute statement succeed.

Flink SQL> SHOW CATALOGS;
+-----------------+
|    catalog name |
+-----------------+
| default_catalog |
|          myhive |
+-----------------+
2 rows in set

Flink SQL> USE CATALOG myhive;
[INFO] Execute statement succeed.

# Connecting To FileSystem(csv)
Flink SQL> CREATE TABLE people (
    name VARCHAR,
    age INT,
    job VARCHAR
) WITH ( 
    'connector' = 'filesystem',
    'path' = 'hdfs://localhost:9000/user/hadoop/flink/people.csv',
    'format' = 'csv',
    'csv.field-delimiter' = ';',
    'csv.ignore-parse-errors' = 'true'
);
[INFO] Execute statement succeed.

Flink SQL> SELECT * from people WHERE age = 30;
                  SQL Query Result (Table)                                                            
 Table program finished.                                        Page: Last of 1
                           name         age                            job
                          Jorge          30                      Developer

Flink SQL> exit;
[INFO] Exiting Flink SQL CLI Client...

Shutting down the session...
done.
```

### Verify the table is also visible to Hive via Beeline CLI:
```bash
# Connect to HiveServer2 with Beeline from shell:
~/flink-x.y.z$ beeline -n hadoop -u jdbc:hive2://localhost:10000

0: jdbc:hive2://localhost:10000> show tables;
+-----------+
| tab_name  |
+-----------+
| people    |
+-----------+
1 rows selected (0.481 seconds)

0: jdbc:hive2://localhost:10000> !q
Closing: 0: jdbc:hive2://localhost:10000
```

#  Visit flink dashboard
- http://localhost:8081

### Stops containers and removes containers, networks, and volumes created by `up`.
```bash

docker compose down -v

[+] Running 3/3
 ✔ Container flink         Removed
 ✔ Volume flink_flink-vol  Removed
 ✔ Network flink_default   Removed
```

# Reference
- https://nightlies.apache.org/flink/flink-docs-stable/docs/try-flink/local_installation
- https://nightlies.apache.org/flink/flink-docs-stable/docs/dev/table/sql/gettingstarted
- https://nightlies.apache.org/flink/flink-docs-stable/docs/connectors/table/hive/overview
