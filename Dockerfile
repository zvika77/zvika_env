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

# Install python 3.6

RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm && \
    yum -y install python36u 
RUN yum -y install python-pip

#install hadoop, vertica client    
RUN wget http://www.trieuvan.com/apache/hadoop/common/hadoop-2.6.5/hadoop-2.6.5.tar.gz  -O /tmp/hadoop-2.6.5.tar.gz && \
    tar -zxvf /tmp/hadoop-2.6.5.tar.gz -C /usr/local  &&   \
    wget https://my.vertica.com/client_drivers/8.1.x/8.1.1-2/vertica-client-8.1.1-2.x86_64.tar.gz -O /opt/vertica-client-8.1.1-2.x86_64.tar.gz && \
    tar -zxvf /opt/vertica-client-8.1.1-2.x86_64.tar.gz -C / && \
    mkdir -p /home/zvika_env/Vertica && mkdir -p /home/zvika_env/Vertica/{Scripts,Log,Temp} && \
    mkdir -p /home/zvika_env/Mysql && mkdir -p /home/zvika_env/Mysql/{Scripts,Log,Temp} && \
    mkdir -p /home/zvika_env/Redshift && mkdir -p /home/zvika_env/Redshift/{Scripts,Log,Temp} && \
    echo 'Host *' >> /etc/ssh/ssh_config && echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config && echo 'UserKnownHostsFile=/dev/null' >> /etc/ssh/ssh_config 
RUN yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-1.noarch.rpm && \
    yum install -y postgresql10    && yum install -y pwgen && yum install -y autossh

#    wget http://mirror.jax.hugeserver.com/apache/hbase/stable/hbase-1.2.4-bin.tar.gz -O /tmp/hbase-1.2.4-bin.tar.gz && \
#    tar -zxvf /tmp/hbase-1.2.4-bin.tar.gz -C /usr/local  &&   \


#install pip,aws cli, awless, awsfedd, mycli
#RUN curl -O https://bootstrap.pypa.io/get-pip.py 
#RUN    python get-pip.py --user 
RUN     pip install awscli --upgrade --user 
RUN     curl https://raw.githubusercontent.com/wallix/awless/master/getawless.sh | bash 
RUN     ln -s ./awless /usr/local/bin/awless 
RUN     awless completion bash | tee /etc/bash_completion.d/awless > /dev/null
RUN     pip install ptpython
RUN     pip install mycli

#RUN PIP_EXTRA_INDEX_URL=https://pypi.idb2b.aolcloud.net/simple ~/.local/bin/pip install awsfed
#RUN pip install -U aol-sshakr --extra-index-url https://artifactory.us-east-1.aws.aol.com:443/artifactory/pypi-onecloud-us-east-1-local

ADD  ./  /home/zvika_env/
#ADD  ./*site*.xml  /usr/local/hadoop-2.6.5/etc/hadoop/

ENV [v_user_prod=zvika, v_user_dev=zvika, m_user_prod=zvika, m_user_dev=zvika]

RUN echo "export LANG=en_US.UTF-8  ; export JAVA_HOME=/usr/lib/jvm/jre; export HADOOP_HOME=/usr/local/hadoop-2.6.5; export HBASE_HOME=/usr/local/hbase-1.2.4" >> /root/.bashrc 
RUN source /root/.bashrc 
RUN export ZHOME=/home/zvika_env && \
echo "export ZHOME=/home/zvika_env;export RHOME=${ZHOME}/Redshift;export MHOME=${ZHOME}/Mysql;export VHOME=${ZHOME}/Vertica;export SQL=${ZHOME}/Sql ;export PATH=~/.local/bin:$HBASE_HOME/bin:$HADOOP_HOME/sbin:$HADOOP_HOME/bin:/opt/vertica/bin/:$PATH" >> /root/.bashrc && \
    echo "source ${ZHOME}/myaliases"  >> /root/.bashrc
# create tunnels (need ssh config file )
RUN    echo "autossh -M 0 -f -T -N rsprod" >> /root/.bashrc &&  \
       echo "autossh -M 0 -f -T -N rsods" >> /root/.bashrc
