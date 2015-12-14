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

you have to supply passwords for Vertica (prod/dev) and mysql (prod/dev)
default users for Vertica is dbadmin and for mysql is root

cd Vertica

./start_container.bash

or

docker build -t <Your Image Name> .

docker run -it --name <Your Container Name>  <Your Image Name>
docker run -it -e v_user_prod=XXX -e v_pass_prod=XXX -e v_user_dev=XXX -e v_pass_dev=XXX -e m_user_prod=XXX -e m_pass_prod=XXX -e m_user_dev=XXX -e m_pass_dev=XXX --rm --name vertica  vertica_env

