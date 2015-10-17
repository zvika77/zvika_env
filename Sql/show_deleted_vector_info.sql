select sum(used_bytes)/1024/1024  sum_used_MB,sum(deleted_row_count) sum_del_rows
from v_monitor.delete_vectors;

select node_name,sum(used_bytes)/1024/1024  sum_used_MB,sum(deleted_row_count) sum_del_rows
from v_monitor.delete_vectors
group by node_name
order by sum(deleted_row_count) desc;

select schema_name,sum(used_bytes)/1024/1024  sum_used_MB,sum(deleted_row_count) sum_del_rows
from v_monitor.delete_vectors
group by schema_name
order by sum(deleted_row_count) desc ;

select a.schema_name,b.anchor_table_name,a.projection_name,sum(a.used_bytes)/1024/1024  sum_used_MB,sum(a.deleted_row_count) sum_del_rows
from v_monitor.delete_vectors a join projections b on (a.schema_name = b.projection_schema and a.projection_name = b.projection_name)
group by a.schema_name,b.anchor_table_name,a.projection_name
having sum(a.deleted_row_count) > 1000
order by sum(a.deleted_row_count) desc ;

select * from (
select rank() over (partition by schema_name order by deleted_row_count desc ) as rank,
node_name,schema_name,projection_name,used_bytes,deleted_row_count
from v_monitor.delete_vectors ) a
where rank <=5
and schema_name not like '%MASTER'
and deleted_row_count > 100
order by schema_name,rank

;

select * from (
select rank() over (partition by schema_name order by used_bytes desc ) as rank,
node_name,schema_name,projection_name,used_bytes,deleted_row_count
from v_monitor.delete_vectors ) a
where rank <=5
and schema_name not like '%MASTER'
and (used_bytes > 100 or deleted_row_count > 1000)
order by schema_name,rank
;
