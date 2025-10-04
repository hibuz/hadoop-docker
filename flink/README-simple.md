# Quick usage for flink-dev simple docker image
```bash
docker run --rm -it -p 9870:9870 -p 8088:8088 -p 19888:19888 -p 8090:8090 -p 8091:8091 -p 18080:18080 -p 4040:4040 -p 10002:10002 -p 8081:8081 --name flink-tmp hibuz/flink-dev:simple yarn,historyserver,spark,hive

# attach
docker exec -it flink-tmp bash
```

#  Visit dashboard
### Hadoop
- Hadoop Dashboard: http://localhost:9870
- Yarn Dashboard: http://localhost:8088
- Hadoop Job History: http://localhost:19888
### Spark
- Master Web UI: http://localhost:8090
- Worker Web UI: http://localhost:8091
- Spark History Server: http://localhost:18080
- Spark Jobs: http://localhost:4040 (spark-shell only)
### Hive
- http://localhost:10002
### Flink
- Flink: http://localhost:8081


### Run some of the examples provided:
```bash
# prepare input data
hdfs dfs -mkdir -p /user/hadoop
hdfs dfs -put $SPARK_HOME/README.md

# spark
~/spark-4.x.x$ spark-shell
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 4.x.x
      /_/
Using Scala version 2.13.16 (OpenJDK 64-Bit Server VM, Java 21.0.8)
scala> :q
```
```bash
# flink
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

# Connecting To FileSystem
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
| people    | (TODO)
+-----------+
1 rows selected (0.481 seconds)

0: jdbc:hive2://localhost:10000> !q
Closing: 0: jdbc:hive2://localhost:10000
```
