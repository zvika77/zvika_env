set timezone to 'Asia/Jerusalem';


select time,cpu.cpu,cpu.node_name,
tm.operation,plan_type,count,b4_sec,proj_name,max_proj,sum_ros,KB,(select count(*)-1 as active_ssssion from sessions where current_statement != ''  or statement_id is not null) as act_sess  from (
select time,node_name,
(nice_usage_in_sec+user_usage_in_sec+system_usage_in_sec) as 'cpu'
from (
select  to_char(time,'dd/mm/yy hh24:mi:ss') as time ,node_name
,((nice_microseconds_end_value - nice_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as nice_usage_in_sec
,((user_microseconds_end_value - user_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as user_usage_in_sec
,((system_microseconds_end_value - system_microseconds_start_value)/(1000000 * number_of_processors)*100)::number(10,2) as system_usage_in_sec
,row_number () over (partition by node_name order by time desc , node_name) as rnum
from dc_cpu_aggregate_by_second  
) a
where rnum =1 ) cpu
left join
(SELECT 
node_name,operation,plan_type,count(*),max(timestampdiff('second',time,sysdate)) as b4_sec 
,case when count (distinct projection_name) > 1 then count (distinct projection_name)::varchar else max(projection_name) end as proj_name,   max(projection_name) as max_proj,sum(container_count) as sum_ros,(sum(total_size_in_bytes)/1024)::int KB
FROM dc_tuple_mover_events a
where transaction_id  not in (select  transaction_id from dc_tuple_mover_events where event in ('Complete','Abort') )
group by node_name,operation,plan_type   ) tm
on (tm.node_name = cpu.node_name)
order by 2
