# == Info =======================================
# hibuz/hbase-dev(SIZE: 2.86GB) -> hibuz/hive-dev(SIZE: 3.23GB)

# == Build ======================================
# docker build -t hibuz/hive-dev .
# or
# docker build -t hibuz/hive-dev --build-arg HIVE_VERSION=x.y.z .

# == Run and Attatch ============================
# docker run --rm -it -p 9870:9870 -p 10002:10002 --name hive-tmp hibuz/hive-dev
# 
# docker exec -it hive-tmp bash


# == Init =======================================
FROM hibuz/hbase-dev

# == Install ============================
ARG HIVE_VERSION=${HIVE_VERSION:-3.1.3}
ENV HIVE_HOME /home/${DEFAULT_USER}/hive-${HIVE_VERSION}

RUN set -x \
    && DOWNLOAD_URL="https://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz" \
    && curl -fSL "$DOWNLOAD_URL" -o download.tar.gz \
    && tar -xvf download.tar.gz \
    && mv apache-hive-${HIVE_VERSION}-bin $HIVE_HOME \
    && rm $HIVE_HOME/lib/guava-19.0.jar \
    && cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava-27.0-jre.jar $HIVE_HOME/lib/ \
    && rm download.tar.gz

# == Env Setting ============================
ENV PATH $PATH:$HIVE_HOME/bin

RUN cp $HIVE_HOME/conf/hive-env.sh.template $HIVE_HOME/conf/hive-env.sh \
    && echo "export HADOOP_HEAPSIZE=512" >> $HIVE_HOME/conf/hive-env.sh \
    && cp $HIVE_HOME/conf/hive-default.xml.template $HIVE_HOME/conf/hive-default.xml
    
RUN core_conf="<property><name>hadoop.proxyuser.${DEFAULT_USER}.hosts</name><value>*</value></property>\
            <property><name>hadoop.proxyuser.${DEFAULT_USER}.groups</name><value>*</value></property>" \
    && escaped_core_conf=$(echo $core_conf | sed 's/\//\\\//g') \
    && sed -i "/<\/configuration>/ s/.*/${escaped_core_conf}&/" $HADOOP_CONF_DIR/core-site.xml


COPY docker-entrypoint.sh /

WORKDIR ${HIVE_HOME}

EXPOSE 10002

ENTRYPOINT ["/docker-entrypoint.sh"]