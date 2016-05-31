select  job_run_id as job_run_id,job_run_status,start_date,last_update_date,client,run_type,TIMESTAMPDIFF(MINUTE,start_date ,sysdate()) as minutes 
from insight.dashv2_etl_stats
where job_run_status = ''
order by last_update_date desc ;

