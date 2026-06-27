# == Info =======================================
# hibuz/hive-dev(SIZE: 4.37GB) -> hibuz/flink-dev(SIZE: 5.15GB)

# == Build ======================================
# docker build -t hibuz/flink-dev .
# or
# docker build -t hibuz/flink-dev --build-arg FLINK_VERSION=x.y.z .

# == Run and Attatch ============================
# docker run --rm -it -p 8081:8081 --name flink-tmp hibuz/flink-dev
# 
# docker exec -it flink-tmp bash


# == Init =======================================
FROM hibuz/hive-dev
LABEL org.opencontainers.image.authors="hibuz@hibuz.com"

# == Install ============================
ARG FLINK_VERSION=2.3.0
ENV FLINK_HOME /home/${DEFAULT_USER}/flink-${FLINK_VERSION}

RUN set -x \
    && DOWNLOAD_URL="https://dlcdn.apache.org/flink/flink-${FLINK_VERSION}/flink-${FLINK_VERSION}-bin-scala_2.12.tgz" \
    && curl -fSL "$DOWNLOAD_URL" -o download.tar.gz \
    && tar -xvf download.tar.gz \
    && mv flink-${FLINK_VERSION} $FLINK_HOME \
    && rm download.tar.gz

ENV PATH $PATH:$FLINK_HOME/bin

ARG HADOOP_VERSION=3.5.0
ARG ICEBERG_VERSION=1.11.0
RUN echo "export HADOOP_CLASSPATH=\$(\$HADOOP_HOME/bin/hadoop classpath)" >> $FLINK_HOME/bin/config.sh \
    && cd $FLINK_HOME/lib \
    && curl -O "https://repo1.maven.org/maven2/org/apache/flink/flink-table-api-java-bridge/${FLINK_VERSION}/flink-table-api-java-bridge-${FLINK_VERSION}.jar" \
    && curl -O "https://repo1.maven.org/maven2/org/apache/flink/flink-table-api-scala-bridge_2.12/${FLINK_VERSION}/flink-table-api-scala-bridge_2.12-${FLINK_VERSION}.jar" \
    && curl -O "https://repo1.maven.org/maven2/org/apache/flink/flink-csv/${FLINK_VERSION}/flink-csv-${FLINK_VERSION}.jar" \
    && curl -O "https://repo1.maven.org/maven2/org/apache/flink/flink-json/${FLINK_VERSION}/flink-json-${FLINK_VERSION}.jar" \
    && curl -O "https://repo1.maven.org/maven2/org/apache/flink/flink-orc/${FLINK_VERSION}/flink-orc-${FLINK_VERSION}.jar" \
    && curl -O "https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-client-api/$HADOOP_VERSION/hadoop-client-api-$HADOOP_VERSION.jar" \
    && curl -O "https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-client-runtime/$HADOOP_VERSION/hadoop-client-runtime-$HADOOP_VERSION.jar" \
    && curl -O "https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-flink-runtime-2.1/$ICEBERG_VERSION/iceberg-flink-runtime-2.1-$ICEBERG_VERSION.jar" \
    && curl -O "https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-hbase-2.2/4.0.0-1.19/flink-sql-connector-hbase-2.2-4.0.0-1.19.jar" \
    && cp ../opt/flink-sql-*.jar ./ \
    && sed -i "s/bind-address: localhost/bind-address: 0.0.0.0/" $FLINK_HOME/conf/*.yaml


COPY docker-entrypoint.sh /

WORKDIR ${FLINK_HOME}

EXPOSE 6123 8081

ENTRYPOINT ["/docker-entrypoint.sh"]
