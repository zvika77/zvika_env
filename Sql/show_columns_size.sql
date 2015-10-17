select table_schema,table_name,projection_name,c.column_name,data_type,is_nullable as null
,column_default as default,encodings,compressions,rows,usedGB,totalGB,percent
from 
(select table_schema,table_name,is_system_table,column_name,data_type,is_nullable,column_default
 from v_catalog.columns  where upper(table_schema) = upper(:1) and upper(table_name) = upper(:2)
 ) c
join
(select * from 
(select anchor_table_schema,anchor_table_name,projection_name,column_name,encodings,compressions
,sum(row_count) as rows,sum(used_bytes/1024/1024/1024)::int usedGB 
,(sum(sum(used_bytes)/1024/1024/1024) over (partition by anchor_table_schema,anchor_table_name, projection_name) )::int as totalGB
,((sum(used_bytes/1024/1024/1024) / sum(sum(used_bytes)/1024/1024/1024) over (partition by anchor_table_schema,anchor_table_name, projection_name) ) * 100)::number(10,2) as percent
,row_number () over (partition by anchor_table_schema,anchor_table_name,column_name order by projection_name) as rnum
from column_storage 
where projection_schema = :1
and anchor_table_name = :2
and projection_name ilike :3
group by anchor_table_schema,anchor_table_name,projection_name,column_name,encodings,compressions
) css
where rnum =1
) cs
on (c.table_schema = cs.anchor_table_schema
and c.table_name = cs.anchor_table_name
and c.column_name = cs.column_name)

