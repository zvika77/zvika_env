select * from (
select  row_number () over (order by count(distinct storage_oid) desc ) as rnum
--,to_char(TIMESTAMPADD(HOUR,-1,sysdate),'HH24:mi')||' - '||to_char(sysdate,'HH24:mi') as TIME
,projection_schema,projection_name,count(distinct storage_oid) as count_storage
,count(case when is_dv = false and row_count  <= 10  then 1 end) as "count_less than_10_rows_per_storage"
,(sum(size_in_bytes)/1024)::NUMBER(30,2) KB,sum(row_count) as row_count ,(sum(row_count) / count(distinct storage_oid))::NUMBER(30,2) as "avg rows per storages"
from dc_roses_created
--where node_name like '%001'
--time >= TIMESTAMPADD(HOUR,-1,sysdate)
group  by projection_schema,projection_name 
order by count_storage desc ) a 
--where rnum <= 5;
