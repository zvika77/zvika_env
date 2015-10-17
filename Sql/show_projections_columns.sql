select table_schema,table_name,projection_name,projection_column_name,column_position,sort_position,data_type,encoding_type,statistics_type,statistics_updated_timestamp
from v_catalog.projection_columns
where  upper(table_schema) = upper(:1)
and (upper(projection_name) ilike  upper(:2) or upper(table_name) ilike  upper(:2))
order by table_schema,table_name,projection_name,sort_position;
