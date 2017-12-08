select table_schema,table_name,owner_name,is_temp_table,is_system_table,partition_expression,create_time
 from v_catalog.tables  where (table_schema ilike :1 or owner_name ilike :1)
 and table_name ilike :2
order by table_schema,table_name

