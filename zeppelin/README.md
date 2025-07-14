# Quick usage for zeppelin-dev docker image
- Docker build and run
``` bash
git clone https://github.com/hibuz/hadoop-docker
cd hadoop-docker/zeppelin

docker compose up --no-build
```

### Attach to running container
``` bash
docker exec -it zeppelin bash
```

### Prepare input data
``` bash
# prepare input data
~/zeppelin-0.xx.x$ hdfs dfs -mkdir -p /user/hadoop
~/zeppelin-0.xx.x$ hdfs dfs -put $SPARK_HOME/README.md
```

### Interactive Analysis with the PySpark
``` bash
~/zeppelin-0.xx.x$ pyspark
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /__ / .__/\_,_/_/ /_/\_\   version 3.x.x
      /_/

Using Python version 3.10.12 (main, Nov 20 2023 15:14:05)
Spark context Web UI available at http://886166433d4e:4040
Spark context available as 'sc' (master = local[*], app id = local-1645887524271).
SparkSession available as 'spark'.

# Read text file in the HDFS
>>> textFile = spark.read.text("README.md")

# Number of rows in this DataFrame
>>> textFile.count()
125

# First row in this DataFrame
>>> textFile.first()
Row(value='# Apache Spark')

# Count words in the text file
>>> from pyspark.sql.functions import explode, split
>>> wordCounts = textFile.select(explode(split(textFile.value, "\s+")).alias("word")).groupBy("word").count()
>>> wordCounts.collect()
[Row(word='[![PySpark', count=1), Row(word='online', count=1), Row(word='graphs', count=1)...

>>> quit()
```

### Interactive Analysis in the Zeppelin Notebook
```python
%spark.pyspark

# Show spark dataframe by reading textfile in the HDFS
textFile = spark.read.text("README.md")
textFile.show()

# Show workd count
from pyspark.sql.functions import explode, split
wordCounts = textFile.select(explode(split(textFile.value, "\s+")).alias("word")).groupBy("word").count()
wordCounts.show()
```

### Collection of useful commands
```bash
# restart daemon
~/zeppelin-0.xx.x$ zeppelin-daemon.sh restart
```

### Tested Tutorials
```python
%sh

## Pre-requisites for Tutorials
sudo apt update && sudo apt install wget unzip

pip install matplotlib seaborn bokeh==2.4.3 pyarrow==11.0.0 plotnine holoviews hvplot altair vega_datasets plotly
```

- Flink Tutorial (known issues)
  1. Flink Basics
  2. Three Essential Steps for Building Flink Job
    - PyFlink Table Api : AttributeError: 'str' object has no attribute '_j_expr'
    - Scala Table Api : error: type mismatch;
    - Flink Sql : TableException: Cannot find table '`default_catalog`...
    - Query mysql : Interpreter mysql not found
  3. Flink Job Control Tutorial
    - Register Data Source : error: type mismatch;
    - Resume flink sql job without savepoint : SQL validation failed. From line 1, column 32 to line 1, column 34: Object 'log' not found
  4. Streaming ETL
    - Transform the data in source table and write it to sink table : findAndCreateTableSource failed.
  5. Streaming Data Analytics
    - error: type mismatch;, Object 'log' not found
  6. Batch ETL
    - Display table via z.show in PyFlink : NameError: name 'bt_env' is not defined
  7. Batch Data Analytics
    - Python UDF : name 'bt_env' is not defined
    - Use python udf in sql : ValidationException: SQL validation failed. From line 1, column 8 to line 1, column 30: No match found for function signature python_upper(<CHARACTER>)
  8. Logistic Regression (Alink)
    - ModuleNotFoundError: No module named 'pyflink.dataset'
    - NameError: name 'OneHotEncoder' is not defined
    - NameError: name 'LogisticRegression' is not defined
    - NameError: name 'metrics' is not defined
    - NameError: name 'predict' is not defined

- Python Tutorial
  1. IPython Basic
  2. IPython Visualization Tutorial
    - Seaborn > remove size : lmplot() got an unexpected keyword argument 'size'
    - HvPlot > !pip install intake intake_parquet intake_xarray s3fs
  3. Keras Binary Classification (IMDB)
    - !pip install keras==2.15.0 tensorflow==2.15.0

- Spark Tutorial
  Set th spark interpreters > zeppelin.spark.enableSupportedVersionCheck > false (spark >= 4.0.0)
  2. Spark Basic Features
  3. Spark SQL (PySpark), Spark SQL (Scala)
  4. Spark MlLib
  8. PySpark Conda Env in Yarn Mode

# Visit zeppelin dashboards
- Zeppelin Tutorials: http://localhost:9995
- Spark Jobs (Optional) : http://localhost:4040
- Flink Dashboard (Optional) : http://localhost:8083
![Zeppelin Tutorials](.assets/zeppelin_dev.jpg)

### Stops containers and removes containers, networks, and volumes created by `up`.
``` bash
docker compose down -v

[+] Running 4/4
 ✔ Container zeppelin-spark-base-1  Removed
 ✔ Container zeppelin               Removed
 ✔ Volume zeppelin_zeppelin-vol     Removed
 ✔ Network zeppelin_default         Removed
```
