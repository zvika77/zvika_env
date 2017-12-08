select operator_name,counter_name,path_id,count(distinct operator_id) as num_operators,avg(counter_value),sum(counter_value)
from v_monitor.execution_engine_profiles
where transaction_id = :1
and statement_id = :2
and node_name ilike :3
and path_id = :4
group by operator_name,counter_name,path_id
having sum(counter_value) > 0 
order by 1,2;
