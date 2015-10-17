/* =========================================
 If no data return :
 Run Audit on the object (Schema) q run_audit.sql <object_name>
 ========================================= 

*/

 select audit_start_timestamp::date,all_projection_sum_GB,one_projection_sum_GB as one_projection_sizeGB,size_GB as raw_sizeGB, (((one_projection_sum_GB/size_GB)-1) *100)::number(10,2) as '%reduction',
(size_GB/one_projection_sum_GB)::int||':1' as ratio
from
-- takes only one super projection for each table not including buddy projections
(select (Sum(used_bytes)/1024/1024/1024)::int as one_projection_sum_GB from projection_storage where  projection_id in (
select projection_id
from (
SELECT  projection_schema,anchor_table_name,projection_name,projection_id,
row_number () over (partition by projection_schema,anchor_table_name order by projection_schema,projection_name) as rnum
FROM projections
 where is_super_projection = true  and is_segmented = true
 group by projection_schema,anchor_table_name,projection_name,projection_id
 ) a
 where rnum =1 
)
  ) compress_data
join
-- all projections include buddy projections
  (select (Sum(used_bytes)/1024/1024/1024)::int as all_projection_sum_GB from projection_storage where  projection_id in (
select projection_id
from (
SELECT  projection_schema,anchor_table_name,projection_name,projection_id
--row_number () over (partition by projection_schema,anchor_table_name order by projection_schema,projection_name) as rnum
FROM projections
-- where is_super_projection = true  and is_segmented = true
 group by projection_schema,anchor_table_name,projection_name,projection_id
 ) a
-- where rnum =1 
)
  ) compress_data1
  on (1=1)
  join
 (SELECT  (audit_start_timestamp::date) audit_start_timestamp,(database_size_bytes/1024/1024/1024)::int size_GB
FROM license_audits order by audit_start_timestamp  desc limit 1 ) raw_data
-- on (raw_data.object_name = compress_data.projection_schema)
 on (1=1)


