select table_schema,table_name,projection_name,table_column_name,data_type,statistics_type,statistics_updated_timestamp
from PROJECTION_COLUMNS
where table_schema ilike :1
and table_name ilike :2
and statistics_type = 'NONE'
order by table_schema,table_name,projection_name;
