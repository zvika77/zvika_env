select  job_run_id,job_run_status,start_date,last_update_date,client,run_type,
case when job_run_status = '' then TIMESTAMPDIFF(MINUTE,start_date ,sysdate()) 
	else TIMESTAMPDIFF(MINUTE,start_date ,last_update_date ) end as minutes
,loaded_to_datadog,log_file_path
from insight.dashv2_etl_stats
where client like @1
and run_type like @2
order by last_update_date ;

