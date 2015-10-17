\echo =========================================
\echo If no data return :
\echo Check Parameters : schema 
\echo Run Audit on the object (Schema) q run_audit.sql <object_name>
\echo =========================================
select audit_start_timestamp::date,projection_schema,sum_GB as comp_sizeGB,size_GB as raw_sizeGB, (((sum_GB/size_GB)-1) *100)::number(10,2) as '%reduction',
(size_GB/sum_gb)::int||':1' as ratio 
from 
(select projection_schema,(Sum(used_bytes)/1024/1024/1024)::int as sum_GB from projection_storage where  projection_id in (
select projection_id
from (
SELECT  projection_schema,anchor_table_name,projection_name,projection_id,
row_number () over (partition by projection_schema,anchor_table_name order by projection_schema,projection_name) as rnum
FROM projections where projection_schema = :1  
 and is_super_projection = true  and is_segmented = true
 group by projection_schema,anchor_table_name,projection_name,projection_id
 ) a
 where rnum =1 ) 
 group by projection_schema ) compress_data
 join 
 (select audit_start_timestamp,user_name,object_type,object_schema,object_name,(size_bytes/1024/1024/1024)::int as size_GB 
 from user_audits 
 where object_name = :1
 order by audit_start_timestamp desc limit 1 ) raw_data
-- on (raw_data.object_name = compress_data.projection_schema)
 on (1=1)

