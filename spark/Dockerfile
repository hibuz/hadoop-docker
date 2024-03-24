# == Info =======================================
# hibuz/hive-dev(SIZE: 3.23GB) -> hibuz/spark-dev(SIZE: 3.89GB)

# == Build ======================================
# docker build -t hibuz/spark-dev .
# or
# docker build -t hibuz/spark-dev --build-arg SPARK_VERSION=x.y.z .

# == Run and Attatch ============================
# docker run --rm -it -p 8080:8080 -p 4040:4040 --name spark-tmp hibuz/spark-dev
# 
# docker exec -it spark-tmp bash


# == Init =======================================
FROM hibuz/hive-dev

# == Package Setting ============================
RUN sudo apt-get update && sudo apt-get install -y \
    python3 python3-pip \
    && sudo rm -rf /var/lib/apt/lists/*

# == Install ============================
ARG SPARK_VERSION=${SPARK_VERSION:-3.5.1}
ENV SPARK_HOME /home/${DEFAULT_USER}/spark-${SPARK_VERSION}

RUN set -x \
    && DOWNLOAD_URL="https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz" \
    && curl -fSL "$DOWNLOAD_URL" -o download.tar.gz \
    && tar -xvf download.tar.gz \
    && mv spark-${SPARK_VERSION}-bin-* $SPARK_HOME \
    && mkdir /tmp/spark-events \
    && rm download.tar.gz

# == Env Setting ============================
ENV PATH $PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

RUN cp $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh \
    && echo "export HADOOP_HOME=$HADOOP_HOME" >> $SPARK_HOME/conf/spark-env.sh \
    && echo "export SPARK_DIST_CLASSPATH=\$(\$HADOOP_HOME/bin/hadoop classpath)" >> $SPARK_HOME/conf/spark-env.sh \
    && sudo ln -s /usr/bin/python3 /usr/bin/python \
    && python -m pip install --upgrade pip


COPY docker-entrypoint.sh /

WORKDIR ${SPARK_HOME}

EXPOSE 4040 8080 8081

ENTRYPOINT ["/docker-entrypoint.sh"]