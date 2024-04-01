# == Info =======================================
# hibuz/hive-dev(SIZE: 4.05GB) -> hibuz/flink-dev(SIZE: 4.69GB)

# == Build ======================================
# docker build -t hibuz/flink-dev .
# or
# docker build -t hibuz/flink-dev --build-arg FLINK_VERSION=x.y.z .

# == Run and Attatch ============================
# docker run --rm -it -p 8083:8083 --name flink-tmp hibuz/flink-dev
# 
# docker exec -it flink-tmp bash


# == Init =======================================
FROM hibuz/hive-dev

# == Install ============================
ARG FLINK_VERSION=${FLINK_VERSION:-1.19.0}
ENV FLINK_HOME /home/${DEFAULT_USER}/flink-${FLINK_VERSION}

RUN set -x \
    && DOWNLOAD_URL="https://archive.apache.org/dist/flink/flink-${FLINK_VERSION}/flink-${FLINK_VERSION}-bin-scala_2.12.tgz" \
    && curl -fSL "$DOWNLOAD_URL" -o download.tar.gz \
    && tar -xvf download.tar.gz \
    && mv flink-${FLINK_VERSION} $FLINK_HOME \
    && rm download.tar.gz

# == Env Setting ============================
ENV PATH $PATH:$FLINK_HOME/bin

RUN echo "export HADOOP_CLASSPATH=\$(\$HADOOP_HOME/bin/hadoop classpath)" >> $FLINK_HOME/bin/config.sh \
    && cd $FLINK_HOME/lib \
    && curl -O "https://repo1.maven.org/maven2/org/apache/flink/flink-table-api-java-bridge/${FLINK_VERSION}/flink-table-api-java-bridge-${FLINK_VERSION}.jar" \
    && curl -O "https://repo1.maven.org/maven2/org/apache/flink/flink-table-api-scala-bridge_2.12/${FLINK_VERSION}/flink-table-api-scala-bridge_2.12-${FLINK_VERSION}.jar" \
    && curl -O "https://repo1.maven.org/maven2/org/apache/flink/flink-csv/${FLINK_VERSION}/flink-csv-${FLINK_VERSION}.jar" \
    && curl -O "https://repo1.maven.org/maven2/org/apache/flink/flink-json/${FLINK_VERSION}/flink-json-${FLINK_VERSION}.jar" \
    && curl -O "https://repo1.maven.org/maven2/org/apache/flink/flink-parquet/${FLINK_VERSION}/flink-parquet-${FLINK_VERSION}.jar" \
    && curl -O "https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-hive-3.1.3_2.12/${FLINK_VERSION}/flink-sql-connector-hive-3.1.3_2.12-${FLINK_VERSION}.jar" \
    && curl -O "https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-hbase-2.2/3.0.0-1.17/flink-sql-connector-hbase-2.2-3.0.0-1.17.jar" \
    && cp ../opt/flink-sql-*.jar ../opt/flink-python-*.jar ./ \
    && sed -i "s/#rest.port: 8081/rest.port: 8083/" $FLINK_HOME/conf/*.yaml \
    # 1.19.0
    && sed -i "s/# port: 8081/port: 8083/" $FLINK_HOME/conf/*.yaml \
    && sed -i "s/bind-address: localhost/bind-address: 0.0.0.0/" $FLINK_HOME/conf/*.yaml


COPY docker-entrypoint.sh /

WORKDIR ${FLINK_HOME}

EXPOSE 6123 8083

ENTRYPOINT ["/docker-entrypoint.sh"]