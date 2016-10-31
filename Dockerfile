FROM centos
MAINTAINER Zvika Gutkin <zvika.gutkin@convertro.com>

#install vsql
RUN yum -y update && \
    yum -y install git && \
    yum -y install wget && \
    yum -y install ksh && \
    yum -y install mysql yum clean all &&  \
    wget http://my.vertica.com/client_drivers/7.1.x/vertica-client-7.1.2-0.x86_64.tar.gz -O /opt/vertica-client-7.1.2-0.x86_64.tar.gz && \
    tar -zxvf /opt/vertica-client-7.1.2-0.x86_64.tar.gz -C / && \
    mkdir -p /home/Vertica && mkdir -p /home/Vertica/{Scripts,Log,Temp} && \
    echo 'Host *' >> /etc/ssh/ssh_config && echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config && echo 'UserKnownHostsFile=/dev/null' >> /etc/ssh/ssh_config

ADD  ./  /home/Vertica/

ENV [v_user_prod=dbadmin, v_user_dev=dbadmin, m_user_prod=root, m_user_dev=root]

RUN echo "export LANG=en_US.UTF-8 ;export HOME=/home/Vertica ">> /root/.bashrc && \
    source /root/.bashrc && \
    echo "export SQL=/home/Vertica/Sql ;export LOG=/home/Vertica/Log ;export DMP=/home/Vertica/Dmp ;export SCRIPT=/home/Vertica/Script ;export TMP=/home/Vertica/Temp ;export TEMP=/home/Vertica/Temp ;export PATH=/opt/vertica/bin/:$PATH" >> /root/.bashrc && \
    echo "source /home/Vertica/myaliases" >> /root/.bashrc
