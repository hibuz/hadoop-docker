# Quick usage for flink-dev docker image
- Docker build and run
``` bash
git clone https://github.com/hibuz/ubuntu-docker
cd ubuntu-docker/hadoop/flink

docker compose up --no-build
```

### Attach to running container
``` bash
docker exec -it flink bash
```

### Flink example
``` bash

# To deploy the example word count job to the running cluster, issue the following command:
~/flink-1.x.x$ flink run examples/streaming/WordCount.jar
Executing example with default input data.
Use --input to specify file input.
Printing result to stdout. Use --output to specify output path.
Job has been submitted with JobID 25baa559e2f20096e1595cf15dedd4d8
Program execution finished
Job with JobID 25baa559e2f20096e1595cf15dedd4d8 has finished.
Job Runtime: 1302 ms

# You can verify the output by viewing the logs:
~/flink-1.x.x$ tail log/flink-*-taskexecutor-*.out
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

### Stops containers and removes containers, networks, and volumes created by `up`.
``` bash

docker compose down -v

[+] Running 3/3
 ✔ Container flink         Removed
 ✔ Volume flink_flink-vol  Removed
 ✔ Network flink_default   Removed
```

#  Visit flink dashboard
- http://localhost:8083

# Reference
- https://nightlies.apache.org/flink/flink-docs-stable/docs/try-flink/local_installation