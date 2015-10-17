select to_char(trunc(time),'dd/mm/yy') as time,max(sysdate-time) as time_diff,
function_name,substr(message,1,50) as message ,count(*) as count ,count(distinct node_name) as dist_nodes
,case when count(distinct user_name)=1 then max(user_name) else to_char(count(distinct user_name)) end as distinct_user
,to_char(min(time),'dd/mm/yy hh24:mi:ss') as min_time,to_char(max(time),'dd/mm/yy hh24:mi:ss') as max_time
from dc_errors
where time >  trunc(sysdate) - interval :2 DAY
and user_name ilike :1 --in ('LIVEENGAGE','FUNNELREPORT','site_data_etl','vertica')
group by trunc(time),error_level,function_name,substr(message,1,50)
order by trunc(time) desc,count(*) desc ;


