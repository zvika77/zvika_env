select partition_key,sizeGB,rows,((sizeGB / sum(sizeGB) over () )*100)::number(10,2)  as percent
from (
      select partition_key,(sum(ros_size_bytes)/2/1024^3)::int sizeGB,(sum(ros_row_count)/2)::int as rows 
      from partitions  p join    (select projection_schema,anchor_table_name,projection_name from projections 
      										where projection_schema = :1 and anchor_table_name ilike  :2  ) p1
      on (p.table_schema = p1.projection_schema and p.projection_name = p1.projection_name)
   group by partition_key order by  2 desc  ) a
   order by 4 desc 
