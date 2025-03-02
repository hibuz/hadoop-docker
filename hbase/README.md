# Quick usage for hbase-dev docker image
- Docker build and run
``` bash
git clone https://github.com/hibuz/hadoop-docker
cd hadoop-docker/hbase

docker compose up --no-build
```

### Attach to running container
``` bash
docker exec -it hbase bash

~/hbase-x.y.z$ hdfs dfs -ls /hbase
Found 12 items
drwxr-xr-x   - hadoop supergroup          0 2022-04-01 10:25 /hbase/.hbck
drwxr-xr-x   - hadoop supergroup          0 2022-04-01 10:25 /hbase/.tmp
drwxr-xr-x   - hadoop supergroup          0 2022-04-01 10:25 /hbase/MasterData
drwxr-xr-x   - hadoop supergroup          0 2022-04-01 10:25 /hbase/WALs
drwxr-xr-x   - hadoop supergroup          0 2022-04-01 10:25 /hbase/archive
drwxr-xr-x   - hadoop supergroup          0 2022-04-01 10:25 /hbase/corrupt
drwxr-xr-x   - hadoop supergroup          0 2022-04-01 10:25 /hbase/data
-rw-r--r--   3 hadoop supergroup         42 2022-04-01 10:25 /hbase/hbase.id
-rw-r--r--   3 hadoop supergroup          7 2022-04-01 10:25 /hbase/hbase.version
drwxr-xr-x   - hadoop supergroup          0 2022-04-01 10:25 /hbase/mobdir
drwxr-xr-x   - hadoop supergroup          0 2022-04-01 10:25 /hbase/oldWALs
drwx--x--x   - hadoop supergroup          0 2022-04-01 10:25 /hbase/staging
```

### HBase shell example
``` bash

# Connect to HBase.
~/hbase-x.y.z$ hbase shell
HBase Shell
Use "help" to get list of supported commands.
Use "exit" to quit this interactive shell.
For Reference, please visit: http://hbase.apache.org/2.0/book.html#shell
Took 0.0018 seconds

# Display clust status
# or version, whoami
hbase:001:0> status
1 active master, 0 backup masters, 1 servers, 0 dead, 2.0000 average load
Took 0.8972 seconds 

# Create a table.
hbase:002:0> create 'test', 'cf'
Created table test
Took 2.1528 seconds
=> Hbase::Table - test

# List your table.
hbase:003:0> list
TABLE
test
1 row(s)
Took 0.0137 seconds
=> ["test"]

# Put data into your table.
hbase:004:0> put 'test', 'row1', 'cf:a', 'value1'
Took 0.1318 second

# Scan the table for all data at once.
hbase:005:0> scan 'test'
ROW                                       COLUMN+CELL
 row1                                     column=cf:a, timestamp=2022-02-25T10:01:30.405, value=value1
1 row(s)
Took 0.0259 seconds

# Exit HBase Shell
hbase:006:0> exit
```

### HBase, MapReduce
``` bash
# hbase rowcounter test or
~/hbase-x.y.z$ hadoop jar $HBASE_HOME/lib/hbase-mapreduce-2.6.2-hadoop3.jar rowcounter test

...
2022-02-26 11:38:51,306 INFO mapreduce.Job: Job job_local756224404_0001 running in uber mode : false
2022-02-26 11:38:51,310 INFO mapreduce.Job:  map 100% reduce 0%
2022-02-26 11:38:51,317 INFO mapreduce.Job: Job job_local756224404_0001 completed successfully
2022-02-26 11:38:51,343 INFO mapreduce.Job: Counters: 47
...
```

# Visit hbase dashboard
- Master Info: http://localhost:16010

### Stops containers and removes containers, networks, and volumes created by `up`.
``` bash

docker compose down -v

[+] Running 3/3
 ✔ Container hbase         Removed
 ✔ Volume hbase_hbase-vol  Removed
 ✔ Network hbase_default   Removed
```

# Reference
- https://hbase.apache.org/book.html#_get_started_with_hbase