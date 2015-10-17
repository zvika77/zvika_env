select c.projection_schema,p.anchor_table_name,c.projection_name,max_distribution_perc - min_distribution_perc  as 'skwe_diff_perc (min to max)'
from
(
select projection_schema,projection_name,min(distribution_perc) as  min_distribution_perc, max(distribution_perc) as max_distribution_perc
from
(
select NODE_NAME,projection_schema,projection_name, (sum(s_row_count) / sum(s_row_count) OVER (partition by projection_schema,projection_name) * 100)::number(10,2) as 'distribution_perc'
from (
select NODE_NAME,projection_schema,projection_name
,sum(row_count)  s_row_count
--over (partition by node_name,projection_schema,projection_name)  / sum(sum(row_count)) OVER () * 100)::number(10,2) as 'distribution_perc'
from v_monitor.projection_storage
where anchor_table_schema ilike :1
and anchor_table_name ilike  :2
--AND PROJECTION_NAME ILIKE  '%'
and used_bytes > 500*(1024^2)
group by node_name,projection_schema,projection_name
) a
group by node_name,projection_schema,projection_name,s_row_count
order by projection_schema,projection_name,node_name
) b
group by projection_schema,projection_name
) c
join projections p on (p.projection_schema = c.projection_schema and p.projection_name = c.projection_name)
ORDER BY 4 desc
