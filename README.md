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

git clone https://convertro.kilnhg.com/Code/Repositories/Zvika/Vertica.git <Target directory>

## Start contanier

./start_container.bash

or

docker build -t <Your Image Name>

docker run -it --name <Your Container Name>  <Your Image Name>

