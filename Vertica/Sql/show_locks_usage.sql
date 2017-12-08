SELECT 
object_name
,mode
,COUNT( DISTINCT session_id) count_sessions
,SUM(hold_count) sum_hold_count
--,node_name
,avg(avg_hold_time) avg_avg_hold_time
,avg(avg_wait_time) avg_avg_wait_time
,max(max_hold_time) max_hold_time
,max(max_wait_time) max_wait_time
,SUM(wait_count) sum_wait_count
FROM lock_usage
WHERE object_name ilike :1
GROUP BY object_name,MODE
ORDER BY  max_hold_time DESC 