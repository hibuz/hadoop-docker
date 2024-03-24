# == Info =======================================
# hibuz/flink-dev(SIZE: 4.43GB) -> hibuz/zeppelin-dev(SIZE: 6.91GB)

# == Build ======================================
# docker build -t hibuz/zeppelin-dev .
# or
# docker build -t hibuz/zeppelin-dev --build-arg ZEPPELIN_VERSION=x.y.z .

# == Run and Attatch ============================
# docker run --rm -it -p 9995:9995 -p 4040:4040 --name zeppelin-tmp hibuz/zeppelin-dev
# 
# docker exec -it zeppelin-tmp bash


# == Init =======================================
ARG FLINK_VERSION=${FLINK_VERSION:-latest}
FROM hibuz/flink-dev:${FLINK_VERSION}

# == Install ============================
ARG ZEPPELIN_VERSION=${ZEPPELIN_VERSION:-0.11.0}
ENV ZEPPELIN_HOME /home/${DEFAULT_USER}/zeppelin-${ZEPPELIN_VERSION}

RUN set -x \
    && DOWNLOAD_URL="https://archive.apache.org/dist/zeppelin/zeppelin-${ZEPPELIN_VERSION}/zeppelin-${ZEPPELIN_VERSION}-bin-all.tgz" \
    && curl -fSL "$DOWNLOAD_URL" -o download.tar.gz \
    && tar -xvf download.tar.gz \
    && mv zeppelin-${ZEPPELIN_VERSION}-bin-all $ZEPPELIN_HOME \
    && rm download.tar.gz

# == Env Setting ============================
ENV PATH $PATH:$ZEPPELIN_HOME/bin
ENV ZEPPELIN_ADDR 0.0.0.0
ENV ZEPPELIN_PORT 9995

RUN cp $ZEPPELIN_HOME/conf/zeppelin-env.sh.template $ZEPPELIN_HOME/conf/zeppelin-env.sh \
    #&& echo "export ZEPPELIN_HOME=$ZEPPELIN_HOME" >> ~/.bash_profile \
    #&& echo "export PATH=\$PATH:\$ZEPPELIN_HOME/bin" >> ~/.bash_profile \
    && echo "export PYSPARK_PYTHON=/usr/bin/python" >> $ZEPPELIN_HOME/conf/zeppelin-env.sh \
    && cp $HIVE_HOME/jdbc/hive-jdbc-*.jar $ZEPPELIN_HOME/interpreter/jdbc

ARG FLINK_VERSION=${FLINK_VERSION:-latest}

RUN pip install jupyter grpcio protobuf==3.19.6 pandas apache-flink==${FLINK_VERSION}

ENV USE_HADOOP false
ENV DISABLE_JEMALLOC true


COPY docker-entrypoint.sh /

WORKDIR ${ZEPPELIN_HOME}

EXPOSE 4040 8083 $ZEPPELIN_PORT

ENTRYPOINT ["/docker-entrypoint.sh"]