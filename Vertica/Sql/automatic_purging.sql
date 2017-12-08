\a
\t
\o /tmp/automatic_purging.tmp
select distinct 'select purge_table ('''||a.schema_name||'.'||b.anchor_table_name||''');'
from v_monitor.delete_vectors a join projections b on (a.schema_name = b.projection_schema and a.projection_name = b.projection_name)
group by a.schema_name,b.anchor_table_name,a.projection_name
having sum(a.deleted_row_count) > 1000;
\o

\i /tmp/automatic_purging.tmp


