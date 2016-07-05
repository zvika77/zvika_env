# Zvika's Vertica Env

This container builds Vertica Env.

it comes with built in connection to Clusters:
Main
Dash
Stage

Mysql Prod
Mysql Stage

All scripts located under Sql directory.

## Installation

git clone https://convertro.kilnhg.com/Code/Repositories/Zvika/Vertica.git

## Start container

you have to supply passwords for Vertica (prod/dev) and Mysql (prod/dev)
default users for Vertica is dbadmin and for mysql is root

cd Vertica

docker build -t <Your Image Name> .

docker run -it --name <Your Container Name>  <Your Image Name>
or
docker run -it -e v_user_prod=XXX -e v_pass_prod=XXX -e v_user_dev=XXX -e v_pass_dev=XXX -e m_user_prod=XXX -e m_pass_prod=XXX -e m_user_dev=XXX -e m_pass_dev=XXX --rm --name vertica  vertica_env
or
docker run -it -e v_user_prod=XXX -e v_pass_prod=XXX -e v_user_dev=XXX -e v_pass_dev=XXX -e m_user_prod=XXX -e m_pass_prod=XXX -e m_user_dev=XXX -e m_pass_dev=XXX -v <full_ssh_path>.ssh:/root/.ssh -v <full_repository_path>:/home/Vertica/ --name vertica  vertica_env


enter the container env
docker exec -it <container id> /bin/bash

##Useful shortcuts

cdsql => cd to Sql scripts dir
main / dash / stage => enter Vertica env
q show_nodes.sql => query the status of the node in the cluster
qq  => enter vsql prompt
ssa => query session active
sts => query session pool name and resource utilization
srus % => query all nodes resource utilization per minute
srps %001 => query all resource pools utilization on node 001
q show_locks.sql % => query all locks

mysqprod / mysqlstage => Enter mysql env
my mysql_rebuild_status_all.sql => show clients rebuild status
myy => enter mysql
