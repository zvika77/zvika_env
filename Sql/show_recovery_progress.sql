select * from recovery_status where is_running = true;

select node_name, substr(projection_name,1,30) as proj_name ,transaction_id , statement_id as stm ,method , status, progress ,detail ,to_char(start_time,'dd/mm/yy hh24:mi') as start 
, to_char(end_time,'dd/mm/yy hh24:mi') as end , runtime_priority as priority
 from projection_recoveries where status = 'running'
order by node_name,progress
