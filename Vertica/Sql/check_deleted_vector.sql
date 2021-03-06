\echo "Threshold 1000 ... "


select a.schema_name,b.anchor_table_name,a.projection_name,(sum(a.used_bytes)/1024/1024)::NUMBER(10,2)  sum_used_MB,sum(a.deleted_row_count) sum_del_rows
from v_monitor.delete_vectors a join projections b on (a.schema_name = b.projection_schema and a.projection_name = b.projection_name)
group by a.schema_name,b.anchor_table_name,a.projection_name
having sum(a.deleted_row_count) > 1000
order by sum(a.deleted_row_count) desc ;



select distinct 'select purge_table ('''||a.schema_name||'.'||b.anchor_table_name||''');'
from v_monitor.delete_vectors a join projections b on (a.schema_name = b.projection_schema and a.projection_name = b.projection_name)
group by a.schema_name,b.anchor_table_name,a.projection_name
having sum(a.deleted_row_count) > 1000;
