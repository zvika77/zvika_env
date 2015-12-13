FROM centos
MAINTAINER Zvika Gutkin <zvika.gutkin@convertro.com>


RUN yum -y update; yum -y install git ; yum -y install wget;yum -y install ksh; yum clean all;

#install vsql
RUN wget http://my.vertica.com/client_drivers/7.1.x/vertica-client-7.1.2-0.x86_64.tar.gz -O /opt/vertica-client-7.1.2-0.x86_64.tar.gz

RUN tar -zxvf /opt/vertica-client-7.1.2-0.x86_64.tar.gz  -C /

# Get scripts from kiln

#RUN git clone https://ZvikaG:Gutkin77\!@convertro.kilnhg.com/Code/Repositories/Zvika/Vertica.git /home/Vertica

RUN mkdir -p /home/Vertica
RUN mkdir -p /home/Vertica/{Sql,Scripts,Log,Temp}
COPY  * /home/Vertica/


RUN echo "export LANG=en_US.UTF-8 ;export HOME=/home/Vertica ">> /root/.bashrc

RUN source /root/.bashrc

RUN echo "export SQL=/home/Vertica/Sql ;export LOG=/home/Vertica/Log ;export DMP=/home/Vertica/Dmp ;export SCRIPT=/home/Vertica/Script ;export TMP=/home/Vertica/Temp ;export TEMP=/home/Vertica/Temp ;export PATH=/opt/vertica/bin/:$PATH" >> /root/.bashrc


RUN echo "source /home/Vertica/myaliases" >> /root/.bashrc

#RUN source /root/.bashrc
