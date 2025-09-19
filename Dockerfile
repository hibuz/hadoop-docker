# == Info =======================================
# hibuz/bash==hibuz/hadoop-base(SIZE: 292MB) -> hibuz/hadoop-dev(SIZE: 3.65GB)

# == Build ======================================
# docker build -t hibuz/hadoop-dev .
# or
# docker build -t hibuz/hadoop-dev --build-arg HADOOP_VERSION=x.y.z .

# == Run and Attatch ============================
# docker run --rm -it -p 9870:9870 --name hadoop-tmp hibuz/hadoop-dev [yarn,historyserver]
# 
# docker exec -it hadoop-tmp bash


# == Init =======================================
FROM hibuz/hadoop-base:24.04
LABEL org.opencontainers.image.authors="hibuz@hibuz.com"

# == Package Setting ============================
ARG JDK_VERSION=11
RUN sudo apt update && DEBIAN_FRONTEND=noninteractive sudo apt install -y --no-install-recommends \
    openjdk-${JDK_VERSION}-jdk-headless \
    ssh \
    netcat-openbsd \
    libsnappy-dev \
    && sudo rm -rf /var/lib/apt/lists/* \
    && sudo apt autoclean \
    && sudo apt clean

# == Install ============================
ARG HADOOP_VERSION=3.4.2
RUN set -x \
    && DOWNLOAD_URL="https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}-lean.tar.gz" \
    && curl -fSL "$DOWNLOAD_URL" -o download.tar.gz \
    && tar -xvf download.tar.gz \
    && rm download.tar.gz

# == Env Setting ============================
ENV JAVA_HOME=/usr/lib/jvm/java-${JDK_VERSION}-openjdk-amd64
ENV HADOOP_HOME=/home/${DEFAULT_USER}/hadoop-${HADOOP_VERSION}
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native

RUN echo "export HADOOP_HOME=$HADOOP_HOME" >> ~/.bashrc \
    && echo "export HADOOP_CLASSPATH=\$(\$HADOOP_HOME/bin/hadoop classpath)" >> ~/.bashrc \
    && echo "export HADOOP_HOME=$HADOOP_HOME" >> $HADOOP_CONF_DIR/hadoop-env.sh \
    && echo "export HADOOP_MAPRED_HOME=\$HADOOP_HOME" >> $HADOOP_CONF_DIR/hadoop-env.sh \
    && echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_CONF_DIR/hadoop-env.sh 

RUN if [ -f "$HADOOP_CONF_DIR/mapred-site.xml.template" ]; then \
    cp $HADOOP_CONF_DIR/mapred-site.xml.template $HADOOP_CONF_DIR/mapred-site.xml; fi

RUN core_conf="<property><name>fs.defaultFS</name><value>hdfs://localhost:9000</value></property>" \
    && hdfs_conf="<property><name>dfs.replication</name><value>1</value></property>" \
    && mapred_conf="<property><name>mapreduce.framework.name</name><value>local</value></property>" \
    && yarn_conf="<property><name>yarn.nodemanager.aux-services</name><value>mapreduce_shuffle</value></property> \
                 <property><name>yarn.nodemanager.env-whitelist</name><value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value></property>" \
    && escaped_core_conf=$(echo $core_conf | sed 's/\//\\\//g') \
    && escaped_hdfs_conf=$(echo $hdfs_conf | sed 's/\//\\\//g') \
    && escaped_mapred_conf=$(echo $mapred_conf | sed 's/\//\\\//g') \
    && escaped_yarn_conf=$(echo $yarn_conf | sed 's/\//\\\//g') \
    && sed -i "/<\/configuration>/ s/.*/${escaped_core_conf}&/" $HADOOP_CONF_DIR/core-site.xml \
    && sed -i "/<\/configuration>/ s/.*/${escaped_hdfs_conf}&/" $HADOOP_CONF_DIR/hdfs-site.xml \
    && sed -i "/<\/configuration>/ s/.*/${escaped_mapred_conf}&/" $HADOOP_CONF_DIR/mapred-site.xml \
    && sed -i "/<\/configuration>/ s/.*/${escaped_yarn_conf}&/" $HADOOP_CONF_DIR/yarn-site.xml

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

COPY ssh_config .ssh/config

RUN sudo chmod 0600 ~/.ssh/*

COPY docker-entrypoint.sh /

WORKDIR ${HADOOP_HOME}

EXPOSE 19888 9870 9864 8088 9000 22

ENTRYPOINT ["/docker-entrypoint.sh"]