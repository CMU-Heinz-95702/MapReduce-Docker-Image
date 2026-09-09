FROM ghcr.io/apache/hadoop:3.5.0@sha256:389d4c48dcfdc34815d5ad1c4d2aa6ca85714c9c40e34d01ba5acb55b62f2d72

USER root

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        curl \
        jq \
        nano \
        procps \
        zip \
    && rm -rf /var/lib/apt/lists/* \
    && usermod --login student --home /home/student --move-home hadoop \
    && mkdir -p /data/hadoop /opt/course /var/log/hadoop /var/run/hadoop \
    && chown -R student:users /data/hadoop /home/student /opt/course /var/log/hadoop /var/run/hadoop

COPY --chown=student:users docker/hadoop-conf/ /opt/hadoop/etc/hadoop/
COPY --chown=root:root docker/scripts/ /usr/local/bin/

RUN chmod 0755 \
        /usr/local/bin/course-entrypoint \
        /usr/local/bin/hadoop-healthcheck \
        /usr/local/bin/lab-status \
        /usr/local/bin/lab-submit \
        /usr/local/bin/verify-datasets \
    && ln -s \
        /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.5.0.jar \
        /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples.jar

ENV HADOOP_HOME=/opt/hadoop \
    HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop \
    HADOOP_LOG_DIR=/var/log/hadoop \
    HADOOP_PID_DIR=/var/run/hadoop \
    HADOOP_MAPRED_HOME=/opt/hadoop \
    HADOOP_HDFS_HOME=/opt/hadoop \
    HADOOP_YARN_HOME=/opt/hadoop \
    HADOOP_COMMON_HOME=/opt/hadoop \
    HOME=/home/student \
    USER=student \
    LOGNAME=student \
    LAB_CONTRACT_VERSION=1 \
    PATH=/opt/hadoop/bin:/opt/hadoop/sbin:${PATH} \
    CLASSPATH=/opt/hadoop/share/hadoop/common/*:/opt/hadoop/share/hadoop/common/lib/*:/opt/hadoop/share/hadoop/mapreduce/*:/opt/hadoop/share/hadoop/mapreduce/lib/*:/opt/hadoop/share/hadoop/hdfs/*:/opt/hadoop/share/hadoop/hdfs/lib/*:/opt/hadoop/share/hadoop/yarn/*:/opt/hadoop/share/hadoop/yarn/lib/*

USER student
WORKDIR /home/student/Project5

EXPOSE 9870 8088 19888

ENTRYPOINT ["/usr/local/bin/course-entrypoint"]
