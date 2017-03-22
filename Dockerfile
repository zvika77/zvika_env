FROM centos:6
MAINTAINER Zvika Gutkin <zvika.gutkin@convertro.com>

#install vsql
RUN yum -y update && \
    yum -y install git && \
    yum -y install which && \
    yum -y install wget && \
    yum -y install ksh && \
    yum -y install java-1.7.0-openjdk.x86_64 && \
    yum -y install mysql yum clean all &&  \
    wget http://www.trieuvan.com/apache/hadoop/common/hadoop-2.6.5/hadoop-2.6.5.tar.gz  -O /tmp/hadoop-2.6.5.tar.gz && \
    tar -zxvf /tmp/hadoop-2.6.5.tar.gz -C /usr/local  &&   \
    wget http://mirror.jax.hugeserver.com/apache/hbase/stable/hbase-1.2.4-bin.tar.gz -O /tmp/hbase-1.2.4-bin.tar.gz && \
    tar -zxvf /tmp/hbase-1.2.4-bin.tar.gz -C /usr/local  &&   \
    wget http://my.vertica.com/client_drivers/7.1.x/vertica-client-7.1.2-0.x86_64.tar.gz -O /opt/vertica-client-7.1.2-0.x86_64.tar.gz && \
    tar -zxvf /opt/vertica-client-7.1.2-0.x86_64.tar.gz -C / && \
    mkdir -p /home/Vertica && mkdir -p /home/Vertica/{Scripts,Log,Temp} && \
    echo 'Host *' >> /etc/ssh/ssh_config && echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config && echo 'UserKnownHostsFile=/dev/null' >> /etc/ssh/ssh_config

ADD  ./  /home/Vertica/
ADD  ./*site*.xml  /usr/local/hadoop-2.6.5/etc/hadoop/

ENV [v_user_prod=dbadmin, v_user_dev=dbadmin, m_user_prod=root, m_user_dev=root]

RUN echo "export LANG=en_US.UTF-8 ;export HOME=/home/Vertica ; export JAVA_HOME=/usr/lib/jvm/jre; && \
          export HADOOP_HOME=/usr/local/hadoop-2.6.5; export HBASE_HOME=/usr/local/hbase-1.2.4" >> /root/.bashrc && \
    source /root/.bashrc && \
    echo "export SQL=/home/Vertica/Sql ;export LOG=/home/Vertica/Log ;export DMP=/home/Vertica/Dmp ;export SCRIPT=/home/Vertica/Script ;export TMP=/home/Vertica/Temp ;export TEMP=/home/Vertica/Temp ;export PATH=$HBASE_HOME/bin:$HADOOP_HOME/sbin:$HADOOP_HOME/bin:/opt/vertica/bin/:$PATH" >> /root/.bashrc && \
    echo "source /home/Vertica/myaliases" >> /root/.bashrc
