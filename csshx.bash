#!/bin/bash
case "$1" in
main ) V_DB="vertica-main.convertro.com";;
dash ) V_DB="vertica-dash.convertro.com";;
demo ) V_DB="vertica-demo.convertro.com";;
stage ) V_DB="vertica-stage.convertro.com";;
* ) V_DB="vertica-main.convertro.com";;
esac

csshX -l root --ssh_args "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" `vsql -U dbadmin -W  -h ${V_DB} -tA -c"select node_address from nodes order by node_name" | grep -v SET | grep -v Tim`

