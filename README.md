# Zvika's Vertica Env

This container builds Vertica Env. 

it comed with built in connection to Clusters:
Main
Dash
Stage

Mysql Prod
Mysql Stage

All scripts located under Sql directory.

## Installation

git clone https://convertro.kilnhg.com/Code/Repositories/Zvika/Vertica.git 

## Start contanier

you have to supply passwords for Vertica (prod/dev) and Mysql (prod/dev)
default users for Vertica is dbadmin and for mysql is root

cd Vertica

docker build -t <Your Image Name> .

docker run -it --name <Your Container Name>  <Your Image Name>
or
docker run -it -e v_user_prod=XXX -e v_pass_prod=XXX -e v_user_dev=XXX -e v_pass_dev=XXX -e m_user_prod=XXX -e m_pass_prod=XXX -e m_user_dev=XXX -e m_pass_dev=XXX --rm --name vertica  vertica_env

##Useful shortcuts

cdsql => cd to Sql scripts dir
main / dash / stage => enter Vertica env
q show_nodes.sql => query the status of the node in the clsuter
qq  => enter vsql prompt
ssa => query session active 
sts => query session pool name and resource utilization
srus % => query all nodes resource utilization per minute
srps %001 => query all resource pools utilization on node 001
q show_locks.sql % => query all locks 

mysqprod / mysqlstage => Enter mysql env
my mysql_rebuild_status_all.sql => show clients rebuild status
myy => enter mysql 



