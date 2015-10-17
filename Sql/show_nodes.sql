select case when critical_nodes.node_name is not null then 'X' else null end  as Critical,node_state,nodes.node_name,node_address,export_address,i_name,is_ephemeral
--,node_type,node_down_since
from v_catalog.nodes left outer join v_monitor.critical_nodes on  (nodes.node_name = critical_nodes.node_name) left outer join (select distinct ip,i_name from sys_history.ec2_ip_to_names)  ec2 on (ip = node_address)
order by node_name

