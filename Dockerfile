FROM centos
MAINTAINER Zvika Gutkin <zvika.gutkin@convertro.com>


RUN yum -y update; yum -y install git ; yum -y install wget;yum -y install ksh;yum -y install mysql yum clean all;

#install vsql
RUN wget http://my.vertica.com/client_drivers/7.1.x/vertica-client-7.1.2-0.x86_64.tar.gz -O /opt/vertica-client-7.1.2-0.x86_64.tar.gz

RUN tar -zxvf /opt/vertica-client-7.1.2-0.x86_64.tar.gz  -C /


RUN mkdir -p /home/Vertica
RUN mkdir -p /home/Vertica/{Scripts,Log,Temp}
ADD  ./  /home/Vertica/

ENV v_user_prod dbadmin
ENV v_user_dev dbadmin

ENV m_user_prod root
ENV m_user_dev root

RUN echo "export LANG=en_US.UTF-8 ;export HOME=/home/Vertica ">> /root/.bashrc

RUN source /root/.bashrc

RUN echo "export SQL=/home/Vertica/Sql ;export LOG=/home/Vertica/Log ;export DMP=/home/Vertica/Dmp ;export SCRIPT=/home/Vertica/Script ;export TMP=/home/Vertica/Temp ;export TEMP=/home/Vertica/Temp ;export PATH=/opt/vertica/bin/:$PATH" >> /root/.bashrc


RUN echo "source /home/Vertica/myaliases" >> /root/.bashrc

