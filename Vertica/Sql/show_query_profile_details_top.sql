select node_name,operator_name,path_id,(sum(counter_value)/1000000)::int sum_time,count(distinct operator_id) as num_operators
from v_monitor.execution_engine_profiles
where transaction_id = :1
and statement_id = :2
and node_name ilike :3 
and counter_name like 'execution%'
group by node_name,operator_name,path_id
order by 4 desc
limit 20;
