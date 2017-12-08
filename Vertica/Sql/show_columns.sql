select table_schema,table_name,is_system_table,column_name,data_type,is_nullable,column_default
 from v_catalog.columns  where upper(table_schema) = upper(:1) and upper(table_name) = upper(:2)
union 
select table_schema,table_name,is_system_table,column_name,data_type,is_nullable,column_default
from v_catalog.system_columns
where upper(table_schema) = upper(:1) and upper(table_name) = upper(:2)
