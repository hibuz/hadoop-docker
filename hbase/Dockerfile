# == Info =======================================
# hibuz/hadoop-dev(SIZE: 2.46GB) -> hibuz/hbase-dev(SIZE: 2.86GB)

# == Build ======================================
# docker build -t hibuz/hbase-dev .
# or
# docker build -t hibuz/hbase-dev --build-arg HBASE_VERSION=x.y.z .

# == Run and Attatch ============================
# docker run --rm -it -p 9870:9870 -p 16010:16010 --name hbase-tmp hibuz/hbase-dev
# 
# docker exec -it hbase-tmp bash


# == Init =======================================
FROM hibuz/hadoop-dev

# == Install ============================
ARG HBASE_VERSION=${HBASE_VERSION:-2.5.8}
ENV HBASE_HOME /home/${DEFAULT_USER}/hbase-${HBASE_VERSION}

RUN set -x \
    && DOWNLOAD_URL="https://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-hadoop3-client-bin.tar.gz" \
    && curl -fSL "$DOWNLOAD_URL" -o download.tar.gz \
    && tar -xvf download.tar.gz \
    && mv hbase-${HBASE_VERSION}* $HBASE_HOME \
    && rm download.tar.gz

# == Env Setting ============================
ENV PATH $PATH:$HBASE_HOME/bin
ENV HBASE_CONF_DIR $HBASE_HOME/conf

RUN echo "export HBASE_DISABLE_HADOOP_CLASSPATH_LOOKUP=\"true\"" >> $HBASE_CONF_DIR/hbase-env.sh \
    && echo "export HADOOP_CLASSPATH=\$($HBASE_HOME/bin/hbase mapredcp):\$HADOOP_CLASSPATH" >> $HADOOP_CONF_DIR/hadoop-env.sh
    # Pseudo-Distributed for Local Testing
    # sed to replace hbase.cluster.distributed -> true
    #&& sed -i "0,/>false/ s/>false/>true/" $HBASE_CONF_DIR/hbase-site.xml \
    #&& echo "export JAVA_HOME=$JAVA_HOME" >> $HBASE_CONF_DIR/hbase-env.sh \
    #&& echo "export HBASE_CLASSPATH=$HADOOP_CONF_DIR" >> $HBASE_CONF_DIR/hbase-env.sh \
    #&& echo "export HBASE_MANAGES_ZK=false" >> $HBASE_CONF_DIR/hbase-env.sh \
    #&& ln -s $HADOOP_CONF_DIR/hadoop-site.xml $HBASE_CONF_DIR/hadoop-site.xml
    # <property><name>hbase.wal.provider</name><value>filesystem</value></property>

RUN hbase_conf="<property><name>hbase.rootdir</name><value>hdfs://localhost:9000/hbase</value></property>" \
    && escaped_hbase_conf=$(echo $hbase_conf | sed 's/\//\\\//g') \
    && sed -i "/<\/configuration>/ s/.*/${escaped_hbase_conf}&/" $HBASE_CONF_DIR/hbase-site.xml


COPY docker-entrypoint.sh /

WORKDIR ${HBASE_HOME}

EXPOSE 2181 16000 16010 16020 16030

ENTRYPOINT ["/docker-entrypoint.sh"]