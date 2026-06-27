# == Info =======================================
# hibuz/hbase-dev(SIZE: 2.4GB) -> hibuz/spark-dev(SIZE: 3.79GB)

# == Build ======================================
# docker build -t hibuz/spark-dev .
# or
# docker build -t hibuz/spark-dev --build-arg SPARK_VERSION=x.y.z .

# == Run and Attatch ============================
# docker run --rm -it -p 8090:8090 -p 4040:4040 --name spark-tmp hibuz/spark-dev
# 
# docker exec -it spark-tmp bash


# == Init =======================================
FROM hibuz/hbase-dev
LABEL org.opencontainers.image.authors="hibuz@hibuz.com"

# == Install ============================
ARG MINICONDA_VERSION=py311_26.3.2-2
ENV CONDA_HOME /opt/conda

RUN set -x \
    && DOWNLOAD_URL="https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" \
    && curl -fSL "$DOWNLOAD_URL" -o miniconda.sh \
    && sudo bash miniconda.sh -b -p ${CONDA_HOME} \
    && rm miniconda.sh

ARG SPARK_VERSION=4.1.2
ENV SPARK_HOME /home/${DEFAULT_USER}/spark-${SPARK_VERSION}

RUN set -x \
    && DOWNLOAD_URL="https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz" \
    && curl -fSL "$DOWNLOAD_URL" -o download.tar.gz \
    && tar -xvf download.tar.gz \
    && mv spark-${SPARK_VERSION}-bin-* $SPARK_HOME \
    && mkdir /tmp/spark-events \
    && rm download.tar.gz

# == Env Setting ============================
ENV PATH $PATH:$CONDA_HOME/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin

RUN cp $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh \
    && echo "export HADOOP_HOME=$HADOOP_HOME" >> $SPARK_HOME/conf/spark-env.sh \
    && echo "export PYSPARK_PYTHON=$CONDA_HOME/bin/python" >> $SPARK_HOME/conf/spark-env.sh \
    && echo "export SPARK_MASTER_WEBUI_PORT=8090" >> $SPARK_HOME/conf/spark-env.sh \
    && echo "export SPARK_WORKER_WEBUI_PORT=8091" >> $SPARK_HOME/conf/spark-env.sh \
    && echo "export SPARK_DIST_CLASSPATH=\$(\$HADOOP_HOME/bin/hadoop classpath)" >> $SPARK_HOME/conf/spark-env.sh

ARG ICEBERG_VERSION=1.11.0
RUN cd $SPARK_HOME/jars \
    && curl -O "https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-4.1_2.13/$ICEBERG_VERSION/iceberg-spark-runtime-4.1_2.13-$ICEBERG_VERSION.jar"


COPY docker-entrypoint.sh /

WORKDIR ${SPARK_HOME}

EXPOSE 4040 8090 8091

ENTRYPOINT ["/docker-entrypoint.sh"]
