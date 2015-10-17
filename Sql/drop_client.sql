   select 'SELECT DROP_PARTITION('''||projection_schema||'.'||anchor_table_name||''','''|| partition_key||''');'
   from (
   select  distinct projection_schema,anchor_table_name,partition_key from projections p1 join
   (select table_schema,projection_name,partition_key from partitions where partition_key = :1 ) p
  on (p.table_schema = p1.projection_schema and p.projection_name = p1.projection_name)
  where projection_schema  ilike :2 ) a

