select * from (
select  row_number () over (order by wos_used_bytes desc ) as rnum,
node_name,projection_schema||'.'||anchor_table_name as object,projection_name,wos_row_count,(wos_used_bytes/1024/1024)::NUMBER(10,2) as wos_used_MB 
from v_monitor.projection_storage
 ) a
where rnum <=5;
