#!/bin/bash 

source ${HOME}/env_main
echo "Cluster Main"
echo "Insert to next_rebuild ..."
${HOME}/Sql/run_sql_noecho.ksh show_dashv2_rebuild_client_main.sql $1

source ${HOME}/env_dash
echo "Cluster Dash"
echo "Copy to next rebuild (the other side of the EXPORT) ..."
${HOME}/Sql/run_sql_noecho.ksh show_dashv2_rebuild_client_dash.sql $1
