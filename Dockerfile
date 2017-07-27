FROM centos:7
MAINTAINER Zvika Gutkin <zvika.gutkin@convertro.com>

#install base
RUN yum -y update && \
    yum -y install git && \
    yum -y install unzip && \
    yum -y install which && \
    yum -y install wget && \
    yum -y install ksh && \
    yum -y install java-1.7.0-openjdk.x86_64 && \
    yum -y install bash-completion && \
    yum -y install mysql yum clean all 

#install hadoop, vertica client    
RUN wget http://www.trieuvan.com/apache/hadoop/common/hadoop-2.6.5/hadoop-2.6.5.tar.gz  -O /tmp/hadoop-2.6.5.tar.gz && \
    tar -zxvf /tmp/hadoop-2.6.5.tar.gz -C /usr/local  &&   \
#    wget http://mirror.jax.hugeserver.com/apache/hbase/stable/hbase-1.2.4-bin.tar.gz -O /tmp/hbase-1.2.4-bin.tar.gz && \
#    tar -zxvf /tmp/hbase-1.2.4-bin.tar.gz -C /usr/local  &&   \
    wget http://my.vertica.com/client_drivers/7.1.x/vertica-client-7.1.2-0.x86_64.tar.gz -O /opt/vertica-client-7.1.2-0.x86_64.tar.gz && \
    tar -zxvf /opt/vertica-client-7.1.2-0.x86_64.tar.gz -C / && \
    mkdir -p /home/Vertica && mkdir -p /home/Vertica/{Scripts,Log,Temp} && \
    echo 'Host *' >> /etc/ssh/ssh_config && echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config && echo 'UserKnownHostsFile=/dev/null' >> /etc/ssh/ssh_config

#install pip,aws cli, awless, awsfedd
RUN curl -O https://bootstrap.pypa.io/get-pip.py 
RUN    python get-pip.py --user 
RUN    ~/.local/bin/pip install awscli --upgrade --user 
RUN    curl https://raw.githubusercontent.com/wallix/awless/master/getawless.sh | bash 
RUN     ln -s /awless /usr/local/bin/awless 
RUN     awless completion bash | tee /etc/bash_completion.d/awless > /dev/null
RUN     pip install ptpython

RUN PIP_EXTRA_INDEX_URL=https://pypi.idb2b.aolcloud.net/simple ~/.local/bin/pip install awsfed
RUN ~/.local/bin/pip install -U aol-sshakr --extra-index-url https://artifactory.us-east-1.aws.aol.com:443/artifactory/pypi-onecloud-us-east-1-local

ADD  ./  /home/Vertica/
ADD  ./*site*.xml  /usr/local/hadoop-2.6.5/etc/hadoop/

ENV [v_user_prod=dbadmin, v_user_dev=dbadmin, m_user_prod=root, m_user_dev=root]

RUN echo "export LANG=en_US.UTF-8  ; export JAVA_HOME=/usr/lib/jvm/jre; export HADOOP_HOME=/usr/local/hadoop-2.6.5; export HBASE_HOME=/usr/local/hbase-1.2.4" >> /root/.bashrc 
RUN source /root/.bashrc 
RUN echo "export SQL=/home/Vertica/Sql ;export LOG=/home/Vertica/Log ;export DMP=/home/Vertica/Dmp ;export SCRIPT=/home/Vertica/Script ;export TMP=/home/Vertica/Temp;export VHOME=/home/Vertica ;export TEMP=/home/Vertica/Temp;export AWS_DEFAULT_PROFILE=federate ;export PATH=~/.local/bin:$HBASE_HOME/bin:$HADOOP_HOME/sbin:$HADOOP_HOME/bin:/opt/vertica/bin/:$PATH" >> /root/.bashrc && \
    echo "source /home/Vertica/myaliases" >> /root/.bashrc
