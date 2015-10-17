select * from (
select 
row_number () over ( partition by plan_type order by  before  ) as rnum
,b.* from (
select max(sysdate) - max(time) as before,plan_type,schema_name,table_name,projection_name,(max(total_size_in_bytes)/1024)::number(10,2) as KB ,max(sysdate) as now,max(time) as started 
from dc_tuple_mover_events a
where schema_name ilike :1
AND table_name ilike :2
group by plan_type,schema_name,table_name,projection_name,transaction_id
order by BEFORE desc
) b ) c
where c.rnum <= 5

