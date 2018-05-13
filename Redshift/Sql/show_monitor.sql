-- show_monitor.sql % 1\ hour


select * from adhoc.monitor_metrics_logs where metric_name ilike :1 
and load_time > sysdate - interval :2
order by 1 desc ,2,4
